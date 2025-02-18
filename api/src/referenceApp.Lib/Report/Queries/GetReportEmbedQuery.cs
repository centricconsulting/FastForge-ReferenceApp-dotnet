using System;
using MediatR;
using referenceApp.PowerBi.Models;

namespace referenceApp.Lib.Report.Queries
{
    public class GetReportEmbedQuery : IRequest<ReportEmbedResponseModel>
    {

        public GetReportEmbedQuery(ReportEmbedRequestModel reportEmbedRequest)
        {
            ReportEmbedRequest = reportEmbedRequest ?? throw new ArgumentNullException(nameof(reportEmbedRequest));
        }

        public ReportEmbedRequestModel ReportEmbedRequest { get; set; }
    }
}
