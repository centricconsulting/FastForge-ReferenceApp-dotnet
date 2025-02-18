
using referenceApp.Common.Models;

namespace referenceApp.PowerBi.Models
{
    public class ReportEmbedResponseModel : BaseResponseModel
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

        /// <summary>
        /// True if the report requested for the UI embed is a Paginated Report. False
        /// if it is a Power BI report.
        /// </summary>
        public bool IsPaginatedReport { get; set; } = false;

        /// <summary>
        /// True if the report requested is a Power BI report that also contains a Paginated Visual
        /// for mixing a Paginated Report within the BI report.
        /// </summary>
        public bool HasPaginatedVisual { get; set; } = false;

        /// <summary>
        /// The name of the fact table in the Power BI report data model to use when applying filters.
        /// This applies only to BI reports, not paginated reports.
        /// </summary>
        public string? FilterTableName { get; set; }

        /// <summary>
        /// The object containing the Power BI request Embed Token used by the UI when sending a
        /// Http Request for report directly from the Power BI server.
        /// </summary>
        public EmbedParametersModel? EmbedParameters { get; set; }

    }
}
