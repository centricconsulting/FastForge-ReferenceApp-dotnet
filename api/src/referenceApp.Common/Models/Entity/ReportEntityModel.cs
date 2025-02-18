
namespace referenceApp.Common.Models.Entity
{
    public class ReportEntityModel
    {

        public int Id { get; set; }

        /// <summary>
        /// Name of the report as defined in Power BI server.
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// Gets or sets the name portion of the export file
        /// when downloaded to the user's browser.
        /// </summary>
        public string? DownloadFileName { get; set; }

        /// <summary>
        /// Report id as defined in Power BI server.
        /// </summary>
        public string? ReportId { get; set; }

        /// <summary>
        /// The Report Section id also known as page name for Power BI reports.
        /// Same as ReportId property for Paginated reports.
        /// </summary>
        public string? ReportSectionId { get; set; }

        /// <summary>
        /// True if the report is a Paginated type report;
        /// False if it is a Power BI Report.
        /// </summary>
        public bool IsPaginatedReport { get; set; }

        /// <summary>
        /// The Report Id of the Paginated report that corresponds with the
        /// Power BI report, but used for export to Excel.
        /// </summary>
        public string? PaginatedReportId { get; set; }

        /// <summary>
        /// The table or view name from the Power BI Data Model 
        /// that is used for applying export filters.
        /// </summary>
        public string? DataModelTableName { get; set; }

        /// <summary>
        /// True if the report requested is a Power BI report that also contains a Paginated Visual
        /// for mixing a Paginated Report within the BI report.
        /// </summary>
        public bool HasPaginatedVisual { get; set; }
    }
}
