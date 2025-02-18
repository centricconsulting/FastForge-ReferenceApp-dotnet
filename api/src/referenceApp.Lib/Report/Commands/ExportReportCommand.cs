using System;
using MediatR;
using referenceApp.PowerBi.Models;

namespace referenceApp.Lib.Report.Commands
{
    public class ExportReportCommand : IRequest<ExportReportResponseModel>
    {

        public ExportReportCommand(ExportReportRequestModel exportReportRequest)
        {
            ExportReportRequest = exportReportRequest ?? throw new ArgumentNullException(nameof(exportReportRequest));
        }

        public ExportReportRequestModel ExportReportRequest { get; set; }
    }
}
