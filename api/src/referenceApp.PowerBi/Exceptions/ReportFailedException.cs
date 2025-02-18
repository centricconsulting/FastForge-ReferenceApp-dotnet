using System.Text;
using Microsoft.PowerBI.Api.Models;

namespace referenceApp.PowerBi.Exceptions
{
    public class ReportFailedException : Exception
    {

        public ReportFailedException(string? message, ExportReportRequest reportRequest, Exception? innerException = null) : base(AppendRequestDataToMessage(message, reportRequest), innerException)
        {
        }

        public ReportFailedException(string message, Exception? innerException = null) : base(message, innerException)
        {
        }

        public static string? AppendRequestDataToMessage(string? message, ExportReportRequest reportRequest)
        {
            var sbMsg = new StringBuilder();

            if (!string.IsNullOrWhiteSpace(message))
            {
                sbMsg.AppendLine(message);
            }
            else
            {
                sbMsg.Append("Power BI report request failed. ");
            }

            sbMsg.AppendLine("Use Fiddler to capture error returned from Power BI server.");

            if (reportRequest?.PaginatedReportConfiguration?.ParameterValues != null)
            {
                sbMsg.Append(" Paginated Report Parameters: ");
                foreach (var parameter in reportRequest.PaginatedReportConfiguration.ParameterValues)
                {
                    var value = string.IsNullOrEmpty(parameter.Value) ? "null" : $"'{parameter.Value}'";
                    sbMsg.Append($"{parameter.Name}={value}, ");
                }
                sbMsg.Remove(sbMsg.Length - 2, 2);
            }
            else if (reportRequest?.PowerBIReportConfiguration?.ReportLevelFilters != null)
            {
                sbMsg.Append(" Power BI Report Filters: ");
                foreach (var filter in reportRequest.PowerBIReportConfiguration.ReportLevelFilters)
                {
                    sbMsg.Append($"({filter.Filter}), ");
                }
                sbMsg.Remove(sbMsg.Length - 2, 2);
            }
            return sbMsg.ToString();
        }
    }
}
