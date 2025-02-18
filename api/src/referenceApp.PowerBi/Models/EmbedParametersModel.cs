using Microsoft.PowerBI.Api.Models;

namespace referenceApp.PowerBi.Models
{
    public class EmbedParametersModel
    {
        /// <summary>
        /// Type of the object to be embedded 
        /// </summary>
        public string? Type { get; set; }

        /// <summary>
        /// Report to be embedded 
        /// </summary>
        public List<EmbedReportModel> EmbedReport { get; set; } = default!;

        /// <summary>
        /// Embed Token for the Power BI report 
        /// </summary>
        public EmbedToken EmbedToken { get; set; } = default!;
    }
}
