
namespace referenceApp.PowerBi.Models
{
    public class ReportEmbedRequestModel
    {

        /// <summary>
        /// The unique integer id of the report requested.
        /// </summary>
        public int ReportEnumId { get; set; }

        /// <summary>
        /// The string Id of the report identified in the Power BI capacity portal. This can be
        /// a Power BI PBIX instance or a Paginated report id. 
        /// </summary>
        public string? ReportId { get; set; }

        /// <summary>
        /// The string Id of the Power BI report section/page identified in the Power BI capacity portal.
        /// This applies only for Power BI reports, not paginated.
        /// </summary>
        public string? ReportSectionId { get; set; } = null;

    }
}
