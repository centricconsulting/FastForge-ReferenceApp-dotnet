using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.Extensions.Logging;
using referenceApp.Common.Constants;
using referenceApp.Common.Enum;
using referenceApp.Common.Models.Entity;
using referenceApp.Common.Models.System;
using referenceApp.Persistence;
using referenceApp.PowerBi;
using referenceApp.PowerBi.Enums;
using referenceApp.PowerBi.Models;

namespace referenceApp.Lib.Report.Commands
{
    public class ExportReportCommandHandler : IRequestHandler<ExportReportCommand, ExportReportResponseModel>
    {
        private readonly IReportDataService _reportDataService;
        private readonly IPowerBiEmbedService _powerBiService;

        public ExportReportCommandHandler(IReportDataService reportDataService, IPowerBiEmbedService powerBiService)
        {
            _reportDataService = reportDataService ?? throw new ArgumentNullException(nameof(reportDataService));
            _powerBiService = powerBiService ?? throw new ArgumentNullException(nameof(powerBiService));
        }

        public Task<ExportReportResponseModel> Handle(ExportReportCommand request, CancellationToken cancellationToken)
        {
            if (request == null) throw new ArgumentNullException(nameof(request));
            var reportRequest = request.ExportReportRequest ?? throw new ArgumentNullException(nameof(request), "The ExportReportRequest property cannot be null for the Export Report request.");
            if (reportRequest.ReportFilters == null)
                throw new ArgumentNullException(nameof(request), "The ReportFilters property of ExportReportRequest cannot be null for the Export Report request.");

            // clean data noise from swagger testing
            if (!string.IsNullOrWhiteSpace(reportRequest.ReportId) && reportRequest.ReportId.Equals("string"))
                reportRequest.ReportId = null;
            if (!string.IsNullOrWhiteSpace(reportRequest.PageName) && reportRequest.PageName.Equals("string"))
                reportRequest.PageName = null;
            if (!string.IsNullOrWhiteSpace(reportRequest.VisualName) && reportRequest.VisualName.Equals("string"))
                reportRequest.VisualName = null;

            // identify report that client-side is requesting for export/download.
            //var findId = string.IsNullOrWhiteSpace(reportRequest.PageName) ? reportRequest.ReportId : reportRequest.PageName;
            ReportEntityModel reportInfo;
            if (reportRequest.ReportEnumId > 0)
            {
                reportInfo = _reportDataService.GetReportInformationById(reportRequest.ReportEnumId);
                if (reportInfo == null)
                {
                    throw new InvalidOperationException($"No Report information record could be found for the provided report id '{reportRequest.ReportEnumId}'. Make sure the ReportEnumId maps to a record in the [Report] database table.");
                }
            }
            else
            {
                reportInfo = _reportDataService.GetReportInformation(reportRequest.ReportId, reportRequest.PageName);
                if (reportInfo == null)
                {
                    throw new InvalidOperationException($"No Report information record could be mapped from the provided report id '{reportRequest.ReportId}' and section id '{reportRequest.PageName}'. Make sure the id maps to a ReportEnum and it exists in the [Report] database table.");
                }

                reportRequest.ReportEnumId = reportInfo.Id;
            }

            // clean data noise from swagger testing
            if (!string.IsNullOrWhiteSpace(reportRequest.ExportType) && reportRequest.ExportType.Equals("string"))
                reportRequest.ExportType = reportInfo.IsPaginatedReport ? "xlsx" : "pdf";

            // Currently, PDF or PNG is for Power BI report Graph visuals and XLSX is for Excel.
            if (reportRequest.ExportType.Equals("xlsx", StringComparison.InvariantCultureIgnoreCase))
            {
                if (string.IsNullOrWhiteSpace(reportInfo.PaginatedReportId))
                {
                    throw new InvalidOperationException($"No Paginated Report Id could be found for report id {reportRequest.ReportEnumId} and name '{reportInfo.Name}'. Make sure the paginated id exists in the [Report] database table.");
                }

                // set report ids for Paginated report
                reportRequest.ReportId = reportInfo.PaginatedReportId;
                reportRequest.PageName = null;
                reportRequest.ReportType = ReportTypeEnum.PaginatedReport;
            }
            else
            {
                // set report ids for Power BI report
                reportRequest.ReportType = reportInfo.IsPaginatedReport ? ReportTypeEnum.PaginatedReport : ReportTypeEnum.PowerBiReport;
                reportRequest.ReportId = reportInfo.ReportId;
                reportRequest.PageName = reportRequest.ReportType == ReportTypeEnum.PowerBiReport ? reportInfo.ReportSectionId : null;
                // applies only for Power BI reports, not paginated
                reportRequest.ReportFilters.DataModelTableName = reportInfo.DataModelTableName;
            }
            reportRequest.ReportRequested = ReportEnumMapper.IntToReportEnum(reportInfo.Id);

            ExportReportResponseModel model;
            try
            {
                model = _powerBiService.ExportReport(reportRequest).Result;
                model.ReportName = reportInfo.DownloadFileName ?? "Report";
                model.DownloadMimeType = _reportDataService.GetMimeTypeByFileExtension(model.ResourceFileExtension.Substring(1));
            }
            catch (Exception ex)
            {
                model = new ExportReportResponseModel();
                model.Success = false;
                model.DisplayFailMessage = DisplayMessageConstants.ReportExportFailed;
                model.ErrorDetail = ex.ToString();

                // ToDo Logging: Implement logging like Azure AppInsights and use DI to inject the Logger.
                //_logger.LogError(ex, model.DisplayFailMessage);
            }

            return Task.FromResult(model);
        }
    }
}
