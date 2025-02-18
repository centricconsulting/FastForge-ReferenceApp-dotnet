using referenceApp.PowerBi.Enums;

namespace referenceApp.PowerBi.Models;

public class ExportReportRequestModel
{
    /// <summary>
    /// Gets or sets the Report Id of the report requested for export.
    /// </summary>
    public string? ReportId { get; set; }

    /// <summary>
    /// Set to the report section id. Applies only for Power BI type reports,
    /// not for Paginated types.
    /// </summary>
    public string? PageName { get; set; }

    /// <summary>
    /// Set to the id of a specific visual within the report section. Applies
    /// only for Power BI type reports.
    /// </summary>
    public string? VisualName { get; set; }

    /// <summary>
    /// Set to 'pdf' to export PDF file, or 'xlsx' to export Excel file.
    /// </summary>
    public string ExportType { get; set; } = string.Empty;

    /// <summary>
    /// ReportFiltersModel containing export filter values passed from
    /// the client-side Web application.
    /// </summary>
    public ReportFiltersModel? ReportFilters { get; set; }

    /// <summary>
    /// Gets or sets if the request report type is Power BI report
    /// or Paginated report.
    /// </summary>
    public ReportTypeEnum ReportType { get; set; }

    /// <summary>
    /// Gets or sets the enum value of the report selected.
    /// </summary>
    public ReportEnum ReportRequested { get; set; }

    /// <summary>
    /// Gets or sets the primary integer id of the report requested for export.
    /// </summary>
    public int ReportEnumId { get; set; } = 0;

}
