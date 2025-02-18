
namespace referenceApp.PowerBi.Models
{
    public class EmbedReportModel
    {
        /// <summary>
        /// Id of Power BI report to be embedded 
        /// </summary>
        public Guid ReportId { get; set; } = Guid.Empty;

        /// <summary>
        /// Name of the report 
        /// </summary>
        public string? ReportName { get; set; }

        /// <summary>
        /// Embed URL for the Power BI report 
        /// </summary>
        public string? EmbedUrl { get; set; }
    }
}
