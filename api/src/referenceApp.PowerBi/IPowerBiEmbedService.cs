using System.Runtime.InteropServices;
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;
using referenceApp.PowerBi.Models;

namespace referenceApp.PowerBi
{
    public interface IPowerBiEmbedService
    {

        /// <summary>
        /// Get Power BI client
        /// </summary>
        /// <returns>Power BI client object</returns>
        PowerBIClient GetPowerBIClient(bool hasPaginatedVisual = false);

        /// <summary>
        /// Get embed params for a report
        /// </summary>
        /// <returns>Wrapper object containing Embed token, Embed URL, Report Id, and Report name for single report</returns>
        EmbedParametersModel GetEmbedParams(Guid reportId, [Optional] Guid additionalDatasetId);

        /// <summary>
        /// Get embed params for multiple reports for a single workspace version 2
        /// </summary>
        /// <returns>Wrapper object containing Embed token, Embed URL, Report Id, and Report name for multiple reports</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        EmbedParametersModel GetEmbedParamsWorkspaceVersion2(IList<Guid> reportIds, [Optional] IList<Guid> additionalDatasetIds);

        EmbedParametersModel GetEmbedTokenHavingPaginatedVisual(IList<Guid> reportIds, [Optional] Guid targetWorkspaceId);

        /// <summary>
        /// Get Embed token for single report, multiple datasets, and an optional target workspace that is version 2.
        /// </summary>
        /// <returns>Embed token</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        EmbedToken GetEmbedTokenVersion2(Guid reportId, IList<Guid> datasetIds, [Optional] Guid targetWorkspaceId);

        /// <summary>
        /// Get Embed token for multiple reports, datasets, and an optional target workspace
        /// </summary>
        /// <returns>Embed token</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        EmbedToken GetEmbedTokenVersion2(IList<Guid> reportIds, IList<Guid> datasetIds, [Optional] Guid targetWorkspaceId);

        /// <summary>
        /// Get Embed token for multiple reports, datasets, and optional target workspaces
        /// </summary>
        /// <returns>Embed token</returns>
        /// <remarks>This function is not supported for RDL Report</remarks>
        EmbedToken GetEmbedTokenVersion2(IList<Guid> reportIds, IList<Guid> datasetIds, [Optional] IList<Guid> targetWorkspaceIds);

        /// <summary>
        /// Get Embed token for RDL Report
        /// </summary>
        /// <returns>Embed token</returns>
        EmbedToken GetEmbedTokenForSingleReportClassicWorkspace(Guid targetWorkspaceId, Guid reportId, string accessLevel = "view");

        /// <summary>
        /// Sends a request to Power BI using the provided request parameter data to return an exported report or visual. The report response
        /// model contains the exported report stream and a Mime type for downloading to the end-user browser.
        /// </summary>
        Task<ExportReportResponseModel> ExportReport(ExportReportRequestModel ExportRequestParams);

        /// <summary>
        /// Sends Http Requests to the Power BI REST API to perform a 'Refresh Dataset' operation on all reporting data models setup in Import Mode.
        /// If the provided refresh type is 'Full' all cached data is cleared and re-imported; if 'automatic' only real-time incremental data is refreshed.
        /// </summary>
        /// <param name="refreshType">Either 'full' to clear all cached data, or 'automatic' to refresh only incremental partitioned data.</param>
        /// <returns>String message indicating the operation completed successfully, or failure having any error details.</returns>
        Task<string> RefreshAllPowerBiDatasets(string refreshType);

    }
}
