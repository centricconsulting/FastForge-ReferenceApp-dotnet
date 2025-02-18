
namespace referenceApp.PowerBi.Models
{
    public class PowerBIConfigModel
    {
        /// <summary>
        /// The Power BI service root URL for sending requests.
        /// </summary>
        public string? PowerBiServiceRootUrl { get; set; }

        /// <summary>
        /// The Power BI server Workspace Id for which Embed token needs to be generated 
        /// </summary>
        public string? WorkspaceId { get; set; }

        /// <summary>
        /// Set to 1 if using classic workspace or set to 2 if using the Power BI V2 workspace experience.
        /// </summary>
        /// <remarks><a href="https://docs.microsoft.com/en-us/power-bi/collaborate-share/service-new-workspaces">More Info</a></remarks>
        public int WorkspaceVersion { get; set; }

        /// <summary>
        /// The Power BI role of the user or principal account that is authenticating with Power BI.
        /// </summary>
        public string? PowerBiRole { get; set; }

        /// <summary>
        /// Report Id for which Embed token needs to be generated 
        /// </summary>
        public string? ReportId { get; set; }

        /// <summary>
        /// The number of seconds that a report export request should give up waiting on the Power BI Server
        /// and cancel the export job.
        /// </summary>
        public int ExportTimeoutSeconds { get; set; }

        /// <summary>
        /// Comma delimited list of Power BI Dataset names that are allowed to be refreshed pragmatically.
        /// </summary>
        public string? RefreshDatasetNames { get; set; }
    }
}
