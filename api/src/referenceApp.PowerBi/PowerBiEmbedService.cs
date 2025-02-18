using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;
using Microsoft.Rest;
using Newtonsoft.Json;
using referenceApp.Azure;
using referenceApp.Common.Utility;
using referenceApp.PowerBi.Constants;
using referenceApp.PowerBi.Enums;
using referenceApp.PowerBi.Exceptions;
using referenceApp.PowerBi.Models;

namespace referenceApp.PowerBi
{
    public class PowerBiEmbedService : IPowerBiEmbedService
    {
        private readonly IActiveDirectoryService _activeDirectoryService;
        private readonly string _powerBiServiceRootUrl;
        private readonly Guid _powerBiWorkspaceId;
        private readonly string _powerBiPrincipalRole;
        private readonly int _powerBiWorkspaceVersion;
        private readonly int _exportTimeoutSeconds;
        private readonly string _refreshDatasetNames;

        public PowerBiEmbedService(IActiveDirectoryService activeDirectoryService, IOptions<PowerBIConfigModel> powerBiOptions)
        {
            _activeDirectoryService = activeDirectoryService ?? throw new ArgumentNullException(nameof(activeDirectoryService));
            if (PowerBiConfigurationValidatorUtility.ValidatePowerBiConfig(powerBiOptions) == null)
            {
                _powerBiServiceRootUrl = powerBiOptions?.Value?.PowerBiServiceRootUrl ?? string.Empty;
                _powerBiWorkspaceId = new Guid(powerBiOptions?.Value?.WorkspaceId ?? Guid.Empty.ToString());
                _powerBiPrincipalRole = powerBiOptions?.Value?.PowerBiRole ?? string.Empty;
                _powerBiWorkspaceVersion = powerBiOptions?.Value?.WorkspaceVersion ?? 1;  // default classic version
                _exportTimeoutSeconds = powerBiOptions?.Value?.ExportTimeoutSeconds ?? 0; // default to no timeout applied
                _refreshDatasetNames = powerBiOptions?.Value?.RefreshDatasetNames ?? string.Empty;
            }
        }

        #region Implementation

        /// <summary>
        /// Get Power BI client
        /// </summary>
        /// <returns>Power BI client object</returns>
        public PowerBIClient GetPowerBIClient(bool hasPaginatedVisual = false)
        {
            var tokenCredentials = new TokenCredentials(_activeDirectoryService.GetAccessToken(), "Bearer");
            return new PowerBIClient(new Uri(_powerBiServiceRootUrl), tokenCredentials);
        }

        /// <summary>
        /// Get embed params for a report
        /// </summary>
        /// <returns>Wrapper object containing Embed token, Embed URL, Report Id, and Report name for single report</returns>
        public EmbedParametersModel GetEmbedParams(Guid reportId, [Optional] Guid additionalDatasetId)
        {
            PowerBIClient pbiClient = GetPowerBIClient();

            Report pbiReport;
            try
            {
                // Get report info
                pbiReport = pbiClient.Reports.GetReportInGroup(_powerBiWorkspaceId, reportId);
            }
            catch (Exception ex)
            {
                string msg = $"The Power BI service returned the following error during the request for information on report id '{reportId}' and workspace id '{_powerBiWorkspaceId}': {ex.Message}";
                throw new ApplicationException(msg, ex);
            }
            EmbedToken embedToken;

            if (_powerBiWorkspaceVersion == 1)
            {
                // Get Embed token for Report in group on workspace classic version
                embedToken = GetEmbedTokenForSingleReportClassicWorkspace(_powerBiWorkspaceId, reportId);
            }
            else
            {
                //  Check if dataset is present for the corresponding report
                //  If isRDLReport is true then it is a RDL Report 
                var isRDLReport = string.IsNullOrEmpty(pbiReport.DatasetId);

                // Generate embed token for RDL report if dataset is not present
                if (isRDLReport)
                {
                    // Get Embed token for RDL Report
                    embedToken = GetEmbedTokenForSingleReportClassicWorkspace(_powerBiWorkspaceId, reportId);
                }
                else
                {
                    // Create list of datasets
                    var datasetIds = new List<Guid>();

                    // Add dataset associated to the report
                    datasetIds.Add(Guid.Parse(pbiReport.DatasetId));

                    // Append additional dataset to the list to achieve dynamic binding later
                    if (additionalDatasetId != Guid.Empty)
                    {
                        datasetIds.Add(additionalDatasetId);
                    }

                    // Get Embed token multiple resources
                    embedToken = GetEmbedTokenVersion2(reportId, datasetIds, _powerBiWorkspaceId);
                }
            }

            // Add report data for embedding
            var embedReports = new List<EmbedReportModel>() {
                new EmbedReportModel
                {
                    ReportId = pbiReport.Id, ReportName = pbiReport.Name, EmbedUrl = pbiReport.EmbedUrl
                }
            };

            // Capture embed params
            var embedParams = new EmbedParametersModel()
            {
                EmbedReport = embedReports,
                Type = ReportTypeConstants.Report,
                EmbedToken = embedToken
            };

            return embedParams;
        }

        public EmbedParametersModel GetEmbedTokenHavingPaginatedVisual(IList<Guid> reportIds, [Optional] Guid targetWorkspaceId)
        {
            if (reportIds == null) throw new ArgumentNullException(nameof(reportIds));
            var pbiClient = GetPowerBIClient();

            // Create mapping for reports and Embed URLs
            var embedReports = new List<EmbedReportModel>();

            // create list of Paginated reports only
            var paginatedReportIds = new List<Guid>();

            // Create list of datasets
            var datasetIds = new List<Guid>();

            // Get datasets and Embed URLs for all the reports
            foreach (var reportId in reportIds)
            {
                // Get report info
                var pbiReport = pbiClient.Reports.GetReportInGroup(_powerBiWorkspaceId, reportId);

                // check if report is Paginated; won't have a Power BI DataSet
                var isRDLReport = string.IsNullOrEmpty(pbiReport.DatasetId);
                // This logic is for Power BI Response Error Code=InvalidRequest; Message=Embed token with identity should not specify both reports and datasets
                if (!isRDLReport)
                {
                    // handle BI Report
                    datasetIds.Add(Guid.Parse(pbiReport.DatasetId));
                }
                else
                {
                    // handle Paginated Reports only to include in identities
                    paginatedReportIds.Add(reportId);
                }

                // Add report data for embedding
                embedReports.Add(new EmbedReportModel { ReportId = pbiReport.Id, ReportName = pbiReport.Name, EmbedUrl = pbiReport.EmbedUrl });
            }

            // Get Embed token multiple resources
            // Create a request for getting Embed token 
            // This method works only with new Power BI V2 workspace experience
            // NOTE: Must Exclude Datasets, BI Report IDs, and Roles from the EffectiveIdentity object in 'identities' token request property when BI report has a Paginated Visual.
            var tokenRequest = new GenerateTokenRequestV2(

                reports: ConvertGuidListToTokenRequestReportList(reportIds),

                datasets: ConvertGuidListToTokenRequestDataSetList(datasetIds),

                targetWorkspaces: targetWorkspaceId != Guid.Empty
                    ? ConvertGuidToTokenRequestWorkspaceList(targetWorkspaceId)
                    : ConvertGuidToTokenRequestWorkspaceList(_powerBiWorkspaceId),

                identities: new List<EffectiveIdentity>() {
                    new EffectiveIdentity(_activeDirectoryService.ClientId
                        , reports: ConvertGuidListToStringList(paginatedReportIds)
                    ) }
            );

            // Generate Embed token
            var embedToken = pbiClient.EmbedToken.GenerateToken(tokenRequest);

            // Capture embed params
            var embedParams = new EmbedParametersModel
            {
                EmbedReport = embedReports,
                Type = ReportTypeConstants.Report,
                EmbedToken = embedToken
            };

            return embedParams;
        }

        /// <summary>
        /// Get embed params for multiple reports for a single workspace
        /// </summary>
        /// <returns>Wrapper object containing Embed token, Embed URL, Report Id, and Report name for multiple reports</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        public EmbedParametersModel GetEmbedParamsWorkspaceVersion2(IList<Guid> reportIds, [Optional] IList<Guid> additionalDatasetIds)
        {
            // Note: This method is an example and is not consumed in this sample app

            PowerBIClient pbiClient = GetPowerBIClient();

            // Create mapping for reports and Embed URLs
            var embedReports = new List<EmbedReportModel>();

            // Create list of datasets
            var datasetIds = new List<Guid>();

            // Get datasets and Embed URLs for all the reports
            foreach (var reportId in reportIds)
            {
                // Get report info
                var pbiReport = pbiClient.Reports.GetReportInGroup(_powerBiWorkspaceId, reportId);

                // check if report is Paginated; won't have a Power BI DataSet
                var isRDLReport = string.IsNullOrEmpty(pbiReport.DatasetId);
                if (!isRDLReport)
                    datasetIds.Add(Guid.Parse(pbiReport.DatasetId));

                // Add report data for embedding
                embedReports.Add(new EmbedReportModel { ReportId = pbiReport.Id, ReportName = pbiReport.Name, EmbedUrl = pbiReport.EmbedUrl });
            }

            // Append to existing list of datasets to achieve dynamic binding later
            if (additionalDatasetIds != null)
            {
                datasetIds.AddRange(additionalDatasetIds);
            }

            // Get Embed token multiple resources
            var embedToken = GetEmbedTokenVersion2(reportIds, datasetIds, _powerBiWorkspaceId);

            // Capture embed params
            var embedParams = new EmbedParametersModel
            {
                EmbedReport = embedReports,
                Type = ReportTypeConstants.Report,
                EmbedToken = embedToken
            };

            return embedParams;
        }

        /// <summary>
        /// Get Embed token for single report, multiple datasets, and an optional target workspace
        /// </summary>
        /// <returns>Embed token</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        public EmbedToken GetEmbedTokenVersion2(Guid reportId, IList<Guid> datasetIds, [Optional] Guid targetWorkspaceId)
        {
            PowerBIClient pbiClient = GetPowerBIClient();

            // Create a request for getting Embed token 
            // This method works only with new Power BI V2 workspace experience
            var tokenRequest = new GenerateTokenRequestV2(

                reports: ConvertGuidToTokenRequestReportList(reportId),

                datasets: ConvertGuidListToTokenRequestDataSetList(datasetIds),

                targetWorkspaces: targetWorkspaceId != Guid.Empty
                    ? ConvertGuidToTokenRequestWorkspaceList(targetWorkspaceId)
                    : ConvertGuidToTokenRequestWorkspaceList(_powerBiWorkspaceId),

                identities: new List<EffectiveIdentity>() {
                    new EffectiveIdentity(_activeDirectoryService.ClientId
                    , datasets: ConvertGuidListToStringList(datasetIds)
                    , roles: new List<string>() { _powerBiPrincipalRole }) }
            );

            try
            {
                // Generate Embed token
                var embedToken = pbiClient.EmbedToken.GenerateToken(tokenRequest);
                return embedToken;
            }
            catch (Exception ex)
            {
                string message = $"The request sent to the Power BI server for generating an Embed Token failed. See inner Exception for Http response details. Request Data: ReportId={reportId}, DataSetId={tokenRequest.Datasets[0].Id}, WorkspaceId={tokenRequest.TargetWorkspaces[0].Id}, ClientId={tokenRequest.Identities[0].Username}, Role={tokenRequest.Identities[0].Roles[0]}";
                throw new Exception(message, ex);
            }
        }

        /// <summary>
        /// Get Embed token for multiple reports, datasets, and an optional target workspace
        /// </summary>
        /// <returns>Embed token</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        public EmbedToken GetEmbedTokenVersion2(IList<Guid> reportIds, IList<Guid> datasetIds, [Optional] Guid targetWorkspaceId)
        {
            // Note: This method is an example and is not consumed in this sample app
            var pbiClient = GetPowerBIClient();

            // Trying the removed datasets and roles from Identities. Also, trying to remove the BI report id from Identities.
            var paginatedReportIds = new List<Guid>() { reportIds[1] };

            // Create a request for getting Embed token 
            // This method works only with new Power BI V2 workspace experience
            var tokenRequest = new GenerateTokenRequestV2(

                reports: ConvertGuidListToTokenRequestReportList(reportIds),

                datasets: ConvertGuidListToTokenRequestDataSetList(datasetIds),

                targetWorkspaces: targetWorkspaceId != Guid.Empty
                    ? ConvertGuidToTokenRequestWorkspaceList(targetWorkspaceId)
                    : ConvertGuidToTokenRequestWorkspaceList(_powerBiWorkspaceId),

                identities: new List<EffectiveIdentity>() {
                    new EffectiveIdentity(_activeDirectoryService.ClientId
                        , reports: ConvertGuidListToStringList(paginatedReportIds)
                        , datasets: ConvertGuidListToStringList(datasetIds)
                        , roles: new List<string>() { _powerBiPrincipalRole }) }
            );

            // Generate Embed token
            var embedToken = pbiClient.EmbedToken.GenerateToken(tokenRequest);
            return embedToken;
        }

        /// <summary>
        /// Get Embed token for multiple reports, datasets, and optional target workspaces
        /// </summary>
        /// <returns>Embed token</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        public EmbedToken GetEmbedTokenVersion2(IList<Guid> reportIds, IList<Guid> datasetIds, [Optional] IList<Guid> targetWorkspaceIds)
        {
            // Note: This method is an example and is not consumed in this sample app
            PowerBIClient pbiClient = GetPowerBIClient();

            // Create a request for getting Embed token 
            // This method works only with new Power BI V2 workspace experience
            var tokenRequest = new GenerateTokenRequestV2(

                reports: ConvertGuidListToTokenRequestReportList(reportIds),

                datasets: ConvertGuidListToTokenRequestDataSetList(datasetIds),

                targetWorkspaces: targetWorkspaceIds != null && targetWorkspaceIds.Any()
                    ? ConvertGuidListToTokenRequestWorkspaceList(targetWorkspaceIds)
                    : ConvertGuidToTokenRequestWorkspaceList(_powerBiWorkspaceId),

                identities: new List<EffectiveIdentity>() {
                    new EffectiveIdentity(_activeDirectoryService.ClientId
                        , reports: ConvertGuidListToStringList(reportIds)
                        , datasets: ConvertGuidListToStringList(datasetIds)
                        , roles: new List<string>() { _powerBiPrincipalRole }) }
            );

            // Generate Embed token
            var embedToken = pbiClient.EmbedToken.GenerateToken(tokenRequest);
            return embedToken;
        }

        /// <summary>
        /// Get Embed token for RDL Report
        /// </summary>
        /// <returns>Embed token</returns>
        public EmbedToken GetEmbedTokenForSingleReportClassicWorkspace(Guid targetWorkspaceId, Guid reportId, string accessLevel = "view")
        {
            PowerBIClient pbiClient = GetPowerBIClient();

            // Generate token request for RDL Report
            var generateTokenRequestParameters = new GenerateTokenRequest(accessLevel: accessLevel);

            // Generate Embed token
            var embedToken = pbiClient.Reports.GenerateTokenInGroup(targetWorkspaceId, reportId, generateTokenRequestParameters);

            return embedToken;
        }

        #endregion

        #region Private Conversion Methods

        private IList<string> ConvertGuidListToStringList(IList<Guid> guids)
        {
            if (!guids.Any())
                return new List<string>();
            return guids.Select(guid => guid.ToString()).ToList();
        }

        private IList<string> ConvertGuidToStringList(Guid guid)
        {
            var list = new List<string>();
            if (guid == Guid.Empty)
                return list;
            list.Add(guid.ToString());
            return list;
        }

        private List<GenerateTokenRequestV2Report> ConvertGuidToTokenRequestReportList(Guid reportGuid)
        {
            return new List<GenerateTokenRequestV2Report>() { new GenerateTokenRequestV2Report(reportGuid) };
        }

        private List<GenerateTokenRequestV2Report> ConvertGuidListToTokenRequestReportList(IList<Guid> reportGuids)
        {
            return reportGuids.Select(reportId => new GenerateTokenRequestV2Report(reportId)).ToList();
        }

        private List<GenerateTokenRequestV2Dataset> ConvertGuidToTokenRequestDataSetList(Guid datasetGuid)
        {
            return new List<GenerateTokenRequestV2Dataset>() { new GenerateTokenRequestV2Dataset(datasetGuid.ToString()) };
        }

        private List<GenerateTokenRequestV2Dataset> ConvertGuidListToTokenRequestDataSetList(IList<Guid> datasetGuids)
        {
            return datasetGuids.Select(datasetId => new GenerateTokenRequestV2Dataset(datasetId.ToString())).ToList();
        }

        private List<GenerateTokenRequestV2TargetWorkspace> ConvertGuidToTokenRequestWorkspaceList(Guid workspaceGuid)
        {
            return new List<GenerateTokenRequestV2TargetWorkspace>() { new GenerateTokenRequestV2TargetWorkspace(workspaceGuid) };
        }
        private List<GenerateTokenRequestV2TargetWorkspace> ConvertGuidListToTokenRequestWorkspaceList(IList<Guid> workspaceGuids)
        {
            return workspaceGuids.Select(workspaceId => new GenerateTokenRequestV2TargetWorkspace(workspaceId)).ToList();
        }

        #endregion

        #region Export Power BI Report

        public async Task<ExportReportResponseModel> ExportReport(ExportReportRequestModel reportExportRequest)
        {
            if (reportExportRequest == null) throw new ArgumentNullException(nameof(reportExportRequest));
            if (string.IsNullOrWhiteSpace(reportExportRequest.ReportId))
                throw new ArgumentNullException(nameof(reportExportRequest), "ReportId property must be provided in argument object.");
            var reportGuid = new Guid(reportExportRequest.ReportId);

            // get Power BI Client object with authentication token
            var pbiClient = GetPowerBIClient();

            // create export request needed by Power BI.
            var exportRequest = reportExportRequest.ReportType == ReportTypeEnum.PowerBiReport
                ? CreateExportReportRequestForPowerBiReport(reportExportRequest)
                : CreateExportReportRequestForPaginatedReport(reportExportRequest);

            // Start Export Job on Power BI server
            var export = await pbiClient.Reports.ExportToFileInGroupAsync(_powerBiWorkspaceId, reportGuid, exportRequest);
            var exportId = export.Id;
            var jobStarted = DateTime.Now;
            bool timedOut;

            // Check Status of Export Job and wait until completion
            do
            {
                System.Threading.Thread.Sleep(4000);  // 4 seconds
                export = pbiClient.Reports.GetExportToFileStatusInGroup(_powerBiWorkspaceId, reportGuid, exportId);
                timedOut = DateTime.Now > jobStarted.AddSeconds(_exportTimeoutSeconds) && _exportTimeoutSeconds > 0;
            } while (export.Status != ExportState.Succeeded && export.Status != ExportState.Failed && !timedOut);

            if (export.Status == ExportState.Succeeded)
            {
                // Get Stream of completed Report file from Power BI
                return new ExportReportResponseModel
                {
                    ReportName = export.ReportName,
                    ResourceFileExtension = export.ResourceFileExtension,
                    ReportStream = pbiClient.Reports.GetFileOfExportToFileInGroup(_powerBiWorkspaceId, reportGuid, exportId)
                };
            }
            else
            {
                // Note: Most common root cause for this failure is when the requested filter parameters do not match with the report design in Power BI.
                // ToDo Power BI: NOTE: The Microsoft.PowerBI.API SDK does not expose the reason for failure from the Http Response. Use the Telerik Fiddler tool to capture the returned Http response for more detail on the failure.
                var sbMsg = new StringBuilder();
                var reason = timedOut ? $"timed out after {_exportTimeoutSeconds} seconds" : "failed";
                if (reportExportRequest.ReportType == ReportTypeEnum.PaginatedReport)
                {
                    sbMsg.Append($"Power BI Export to Excel request {reason} for paginated report id '{reportExportRequest.ReportId}' and these filter values: ");
                }
                else
                {
                    sbMsg.Append($"Power BI Export to PDF request {reason} for report id '{reportExportRequest.ReportId}', section id '{reportExportRequest.PageName}' and these filter values: ");
                }
                sbMsg.Append(JsonConvert.SerializeObject(reportExportRequest.ReportFilters));
                throw new ReportFailedException(sbMsg.ToString(), exportRequest);
            }
        }

        #region Private Export Methods

        private ExportReportRequest CreateExportReportRequestForPowerBiReport(ExportReportRequestModel reportExportRequest)
        {
            if (reportExportRequest == null)
                throw new ArgumentNullException(nameof(reportExportRequest));
            if (string.IsNullOrWhiteSpace(reportExportRequest.ReportId))
                throw new ArgumentNullException(nameof(reportExportRequest), "ReportId property must be provided in argument object.");
            if (reportExportRequest.ReportFilters == null)
                throw new ArgumentNullException(nameof(reportExportRequest), "ReportFilters property must be set to an instance and contain proper filter properties.");
            if (reportExportRequest.ReportType == ReportTypeEnum.PaginatedReport)
                throw new ArgumentNullException(nameof(reportExportRequest), "Caller has called the wrong method. Call CreateExportReportRequestForPaginatedReport instead.");
            if (string.IsNullOrWhiteSpace(reportExportRequest.PageName))
                throw new ArgumentNullException(nameof(reportExportRequest), "PageName property must be set to the report section id for Power BI Report type export request.");

            // ToDo Power BI: EXPORT TO PDF - Use the GetRequestedFileFormat method in future to give user format options for Power BI export like PDF, PPT.  Currently, only export of Graph visual to PNG is offered.
            var exportRequest = new ExportReportRequest
            {
                //Format = GetRequestedFileFormat(reportExportRequest),
                Format = FileFormat.PNG,
                PowerBIReportConfiguration = new PowerBIReportExportConfiguration()
            };

            exportRequest.PowerBIReportConfiguration.Pages = new List<ExportReportPage>(){
                new ExportReportPage{PageName = reportExportRequest.PageName}
            };
            if (!string.IsNullOrEmpty(reportExportRequest.VisualName))
            {
                exportRequest.PowerBIReportConfiguration.Pages[0].VisualName = reportExportRequest.VisualName;
            }

            exportRequest.PowerBIReportConfiguration.ReportLevelFilters = new List<ExportFilter>()
            {
                new ExportFilter()
                {
                    Filter = GetExportFilterForPowerBiReport(reportExportRequest.ReportFilters, reportExportRequest.ReportRequested)
                }
            };
            return exportRequest;
        }

        private string GetExportFilterForPowerBiReport(ReportFiltersModel filters, ReportEnum reportRequested)
        {
            if (filters == null) throw new ArgumentNullException(nameof(filters));
            var filterList = new List<string>();

            // ToDo Power BI: EXPORT - Customize this code that returns the complex report filters string to append to the Power BI report request. Consider making filter syntax dynamic by storing filter field names in a db table.

            // user authorization filters
            if (filters.DistrictId > 0)
            {
                filterList.Add($"{filters.DataModelTableName}/DistrictId eq {filters.DistrictId}");
            }

            if (filters.StartDate != null && filters.EndDate != null)
            {
                filterList.Add($"{filters.DataModelTableName}/AssignedDate ge datetime'{((DateTime)filters.StartDate).ToString("s")}'");
                filterList.Add($"{filters.DataModelTableName}/AssignedDate lt datetime'{((DateTime)filters.EndDate).ToString("s")}'");
            }

            return ConversionUtility.StringListToString(filterList, " and ");
        }

        private ExportReportRequest CreateExportReportRequestForPaginatedReport(ExportReportRequestModel reportExportRequest)
        {
            if (reportExportRequest == null)
                throw new ArgumentNullException(nameof(reportExportRequest));
            if (string.IsNullOrWhiteSpace(reportExportRequest.ReportId))
                throw new ArgumentNullException(nameof(reportExportRequest), "ReportId property must be provided in argument object.");
            if (reportExportRequest.ReportFilters == null)
                throw new ArgumentNullException(nameof(reportExportRequest), "ReportFilters property must be set to an instance and contain proper filter properties.");
            if (reportExportRequest.ReportType == ReportTypeEnum.PowerBiReport)
                throw new ArgumentNullException(nameof(reportExportRequest), "Caller has called the wrong method. Call CreateExportReportRequestForPowerBiReport instead.");

            var exportRequest = new ExportReportRequest
            {
                Format = GetRequestedFileFormat(reportExportRequest),
                PaginatedReportConfiguration = new PaginatedReportExportConfiguration
                {
                    ParameterValues = GetExportParametersForPaginatedReport(reportExportRequest.ReportFilters, reportExportRequest.ReportRequested)
                }
            };
            return exportRequest;
        }

        private List<ParameterValue> GetExportParametersForPaginatedReport(ReportFiltersModel filters, ReportEnum reportRequested)
        {
            if (filters == null)
                throw new ArgumentNullException(nameof(filters));

            var parameters = new List<ParameterValue>();

            // ToDo Power BI: EXPORT - Customize this code that returns the complex report filter parameters for the Power BI paginated report request. Consider making filter syntax dynamic by storing filter field names in a db table.

            // District filter
            if (IsParameterRequired(ReportParameterEnum.DistrictId, reportRequested))
            {
                if (filters.DistrictId > 0)
                {
                    parameters.Add(new ParameterValue() { Name = "DistrictId", Value = filters.DistrictId.ToString() });
                }
                else if (IsParameterRequired(ReportParameterEnum.DistrictId, reportRequested, true))
                {
                    parameters.Add(new ParameterValue() { Name = "DistrictId", Value = null });
                }
            }

            // Some Entity Filter.
            var isRequiredSomeEntityId = IsParameterRequired(ReportParameterEnum.SomeEntityId, reportRequested);
            if (isRequiredSomeEntityId && !string.IsNullOrWhiteSpace(filters.SelectedEntityIds) && !filters.SelectedEntityIds.Equals("string"))
            {
                parameters.Add(new ParameterValue() { Name = "SomeEntityId", Value = filters.SelectedEntityIds });
            }
            else if (isRequiredSomeEntityId && filters.SomeEntityIds != null && filters.SomeEntityIds.Any() && filters.SomeEntityIds[0] > 0)
            {
                foreach (var id in filters.SomeEntityIds)
                {
                    parameters.Add(new ParameterValue() { Name = "SomeEntityId", Value = id.ToString() });
                }
            }

            if (filters.StartDate != null && filters.EndDate != null)
            {
                parameters.Add(new ParameterValue() { Name = "StartDate", Value = ((DateTime)filters.StartDate).ToString("s") });
                parameters.Add(new ParameterValue() { Name = "EndDate", Value = ((DateTime)filters.EndDate).ToString("s") });
            }
            else
            {
                if (IsParameterRequired(ReportParameterEnum.StartDate, reportRequested, filters.StartDate == null) && filters.StartDate != null)
                {
                    parameters.Add(new ParameterValue() { Name = "StartDate", Value = ((DateTime)filters.StartDate).ToString("s") });
                }
                if (IsParameterRequired(ReportParameterEnum.EndDate, reportRequested, filters.EndDate == null) && filters.EndDate != null)
                {
                    parameters.Add(new ParameterValue() { Name = "EndDate", Value = ((DateTime)filters.EndDate).ToString("s") });
                }
            }

            return parameters;
        }

        private bool IsParameterRequired(ReportParameterEnum parameter, ReportEnum report, bool throwErrorIfNotNullable = false)
        {
            bool isRequired = false;
            bool isNullable = false;

            // ToDo Power BI: EXPORT - Customize this code that validates which Paginated report parameters are required and nullable based on the requested report. Consider making this logic dynamic by storing in related database table(s).

            if (parameter == ReportParameterEnum.StartDate
                || parameter == ReportParameterEnum.EndDate)
            {
                isRequired = true;
            }
            else
            {
                switch (report)
                {
                    // Report# 1
                    case ReportEnum.FirstReportNameHere:
                        isRequired = (parameter == ReportParameterEnum.DistrictId
                                      || parameter == ReportParameterEnum.SomeEntityId);

                        isNullable = (parameter == ReportParameterEnum.SomeEntityId);
                        break;

                }
            }

            if (isRequired && !isNullable && throwErrorIfNotNullable)
            {
                var errMsg = $"Null value is not allowed for parameter '{parameter}' on paginated report '{report}'. The parameter is required.";
                throw new ReportParameterException(errMsg);
            }

            return isRequired;
        }

        private FileFormat GetRequestedFileFormat(ExportReportRequestModel reportExportRequest)
        {
            FileFormat fileFormat;
            switch (reportExportRequest.ExportType.ToLower())
            {
                case "pdf":
                    fileFormat = FileFormat.PDF;
                    break;
                case "pptx":
                    fileFormat = FileFormat.PPTX;
                    break;
                case "png":
                    fileFormat = FileFormat.PNG;
                    break;
                case "xlsx":
                case "xls":
                    if (reportExportRequest.ReportType == ReportTypeEnum.PowerBiReport)
                    {
                        throw new InvalidOperationException("Power BI type reports do not support exporting to Excel file format. Report type must be a Paginated report.");
                    }
                    fileFormat = FileFormat.XLSX;
                    break;
                default:
                    throw new InvalidOperationException($"Power BI reports do not support the requested format of 'reportExportRequest.ExportType'.");
            }

            return fileFormat;
        }


        private string GetPropertyValues(ReportFiltersModel filter)
        {
            Type type = filter.GetType();
            PropertyInfo[] props = type.GetProperties();
            string str = "{";
            foreach (var prop in props)
            {
                str += (prop.Name + ":" + prop.GetValue(filter)) + ";";
            }
            return str.Remove(str.Length - 1) + "}";
        }

        #endregion

        #endregion

        #region Power BI REST API Methods

        public async Task<string> RefreshAllPowerBiDatasets(string refreshType)
        {
            if (string.IsNullOrWhiteSpace(refreshType)) throw new ArgumentNullException(nameof(refreshType));
            if (!DatasetRefreshTypeConstants.HasValue(refreshType)) throw new InvalidOperationException($"The provided value of '' for argument refreshType is not one of the valid values in DatasetRefreshTypeConstants.");
            if (string.IsNullOrWhiteSpace(_refreshDatasetNames)) throw new InvalidOperationException("The RefreshDatasetNames setting value is required in the PowerBI application configuration section.");
            var resultMessage = new StringBuilder();
            var allowedDatasetNames = ConversionUtility.StringToStringCollection(_refreshDatasetNames);


            PowerBIClient pbiClient = GetPowerBIClient();

            var response = await pbiClient.Datasets.GetDatasetsInGroupAsync(_powerBiWorkspaceId);

            if (response != null)
            {
                var datasets = response.Value;
                var datasetCount = allowedDatasetNames.Count;
                var foundCount = datasets.Count > datasetCount ? datasetCount : datasets.Count;
                resultMessage.AppendLine($"GetDatasetsInGroup found '{foundCount}' datasets to clear and refresh. ");

                if (datasets.Any())
                {
                    foreach (var dataset in datasets)
                    {
                        if (allowedDatasetNames.Contains(dataset.Name))
                        {
                            var result = await pbiClient.Datasets.RefreshDatasetAsync(_powerBiWorkspaceId, dataset.Id);
                            System.Threading.Thread.Sleep(10000);  // 10 seconds

                            // get status to confirm it started and not failed.
                            var historyResult = await pbiClient.Datasets.GetRefreshHistoryInGroupAsync(_powerBiWorkspaceId, dataset.Id);
                            if (historyResult != null)
                            {
                                var lastRefresh = historyResult.Value.OrderByDescending(r => r.StartTime).FirstOrDefault();
                                if (lastRefresh != null)
                                {
                                    resultMessage.AppendLine($"RefreshDataset '{dataset.Name}(Id:{dataset.Id})' submitted (status:{lastRefresh.Status}, started:{lastRefresh.StartTime}, ended:{lastRefresh.EndTime}). ");
                                }
                                else
                                {
                                    resultMessage.AppendLine($"RefreshDataset '{dataset.Name}(Id:{dataset.Id})' request not found. Manually check for status via the Power BI Workspace portal. ");
                                }
                            }
                            else
                            {
                                resultMessage.AppendLine($"GetRefreshHistory on Dataset '{dataset.Name}(Id:{dataset.Id})' returned no history. Manually check for status via the Power BI Workspace portal. ");
                            }
                        }
                    }
                    resultMessage.AppendLine("Manually verify reports show no data. Also, you may need to verify the completion status of Dataset refreshes via the Power BI Workspace Portal.");
                }
                else
                {
                    resultMessage.Append("No request was sent to perform a Refresh Dataset. Manually check Datasets via the Power BI Workspace portal and perform Full Refresh manually.");
                }

            }
            else
            {
                resultMessage.Append($"GetDatasetsInGroup for workspace id '{_powerBiWorkspaceId}' returned no datasets. No request was sent to perform a Refresh Dataset. Manually check Datasets via the Power BI Workspace portal and perform Full Refresh manually.");
            }

            return resultMessage.ToString();
        }

        #endregion  

    }
}
