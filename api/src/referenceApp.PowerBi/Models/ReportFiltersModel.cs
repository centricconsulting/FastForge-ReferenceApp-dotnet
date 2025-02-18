namespace referenceApp.PowerBi.Models;

public class ReportFiltersModel
{
    /// <summary>
    /// Assigned Date report filter for applying the start date
    /// on a date range filter.
    /// </summary>
    public DateTime? StartDate { get; set; }

    /// <summary>
    /// Assigned Date report filter for applying the end date
    /// on a date range filter.
    /// </summary>
    public DateTime? EndDate { get; set; }

    /// <summary>
    /// DistrictId report filter applies authorization filter for district user role only.
    /// </summary>
    public int DistrictId { get; set; } = 0;

    /// <summary>
    /// List of {some entity} Ids to apply filter of multiple selections.
    /// </summary>
    public List<int>? SomeEntityIds { get; set; } = null;

    /// <summary>
    /// A comma-delimited list of selected {some entity} Ids for applying filter on one or more selections.
    /// Use for the new UI multi-select component type filter field.
    /// </summary>
    public string? SelectedEntityIds { get; set; }

    /// <summary>
    /// Gets or sets the table or view name from the Power BI Data Model
    /// that is used for applying export filters.
    /// </summary>
    public string? DataModelTableName { get; set; }

}
