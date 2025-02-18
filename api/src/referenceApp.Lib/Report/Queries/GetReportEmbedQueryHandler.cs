using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.Extensions.Options;
using referenceApp.Common.Models.Entity;
using referenceApp.Persistence;
using referenceApp.PowerBi;
using referenceApp.PowerBi.Enums;
using referenceApp.PowerBi.Models;

namespace referenceApp.Lib.Report.Queries
{
    public class GetReportEmbedQueryHandler : IRequestHandler<GetReportEmbedQuery, ReportEmbedResponseModel>
    {
        private readonly IReportDataService _reportDataService;
        private readonly IPowerBiEmbedService _powerBiService;
        private readonly IOptions<PowerBIConfigModel> _powerBiOptions;

        public GetReportEmbedQueryHandler(IReportDataService reportDataService, IPowerBiEmbedService powerBiService, IOptions<PowerBIConfigModel> powerBiOptions) 
        {
            _reportDataService = reportDataService ?? throw new ArgumentNullException(nameof(reportDataService));
            _powerBiService = powerBiService ?? throw new ArgumentNullException(nameof(powerBiService));
            _powerBiOptions = powerBiOptions ?? throw new ArgumentNullException(nameof(powerBiOptions));
        }

        public Task<ReportEmbedResponseModel> Handle(GetReportEmbedQuery request, CancellationToken cancellationToken)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            var reportRequest = request.ReportEmbedRequest;
            var model = new ReportEmbedResponseModel();

            // get report info from db Report table
            ReportEntityModel report;
            if (reportRequest.ReportEnumId > 0)
            {
                report = _reportDataService.GetReportInformationById(reportRequest.ReportEnumId);
            }
            else
            {
                report = _reportDataService.GetReportInformation(reportRequest.ReportId, reportRequest.ReportSectionId);
            }
            model.ReportEnumId = report.Id;
            model.ReportId = report.ReportId;
            model.ReportSectionId = report.IsPaginatedReport ? null : report.ReportSectionId;
            model.IsPaginatedReport = report.IsPaginatedReport;
            model.HasPaginatedVisual = report.HasPaginatedVisual;
            model.FilterTableName = report.DataModelTableName;
            var reportName = ReportEnumMapper.IntToReportEnum(report.Id);

            // get authorization Embed Token for report Http request
            var stringGuid = string.IsNullOrEmpty(model.ReportId) ? _powerBiOptions?.Value?.ReportId : model.ReportId;
            if (string.IsNullOrWhiteSpace(stringGuid))
                throw new InvalidOperationException("The required ReportId is missing from the Report table in the data store.");
            var reportGuid = new Guid(stringGuid);
            if (model.IsPaginatedReport)
            {
                // get Embed Token for a Paginated Report, not BI report
                model.EmbedParameters = Task.FromResult(_powerBiService.GetEmbedParams(reportGuid)).Result;
            }
            else if (model.HasPaginatedVisual && !string.IsNullOrWhiteSpace(report.PaginatedReportId))
            {
                // special Embed Token Request must be used when BI report has Paginated Visual (2 reports in 1)
                var reportIds = new List<Guid>() { reportGuid };
                reportIds.Add(new Guid(report.PaginatedReportId));
                model.EmbedParameters = Task.FromResult(_powerBiService.GetEmbedTokenHavingPaginatedVisual(reportIds)).Result;
            }
            else
            {
                // all other BI Reports use this simple Embed Token request
                model.EmbedParameters = Task.FromResult(_powerBiService.GetEmbedParams(reportGuid)).Result;
            }

            return Task.FromResult(model);
        }
    }
}
