
using referenceApp.Common.Models;

namespace referenceApp.PowerBi.Models
{
    public class ExportReportResponseModel : BaseResponseModel
    {

        public string ReportName { get; set; } = string.Empty;
        public string ResourceFileExtension { get; set; } = string.Empty;
        public Stream? ReportStream { get; set; }

        /// <summary>
        /// The document mime type also known as the Http Response content type of the
        /// file being downloaded.
        /// </summary>
        public string DownloadMimeType { get; set; } = string.Empty;

    }
}
