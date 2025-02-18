using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.FeatureManagement;
using referenceApp.Api.System;
using referenceApp.Common.Models.System;
using referenceApp.PowerBi.Models;
using referenceApp.PowerBi;
using System;
using System.Threading.Tasks;
using referenceApp.Lib.Report.Commands;
using referenceApp.Lib.Report.Queries;
using Microsoft.AspNetCore.Authorization;

namespace referenceApp.Api.Controllers
{
    [Authorize]
    [Route("api/[controller]/[action]")]
    public class ReportController : ApiControllerBase
    {
        private readonly IPowerBiEmbedService _powerBiService;
        private readonly IOptions<PowerBIConfigModel> _powerBiOptions;

        public ReportController(IFeatureManager featureManager, IUserSecurityService userSecurity, ISettingsData settingsData, IPowerBiEmbedService powerBiService, IOptions<PowerBIConfigModel> powerBiOptions)
            : base(featureManager, userSecurity, settingsData)
        {
            _powerBiService = powerBiService ?? throw new ArgumentNullException(nameof(powerBiService));
            _powerBiOptions = powerBiOptions ?? throw new ArgumentNullException(nameof(powerBiOptions));
        }

        [HttpGet]
        [Produces("application/json")]
        public async Task<ActionResult<ReportEmbedResponseModel>> GetReportIdEmbedToken(int reportEnumId)
        {
            // get new Embed Token and report info
            var reportEmbedResponse = await Mediator.Send(new GetReportEmbedQuery(new ReportEmbedRequestModel() { ReportEnumId = reportEnumId }));

            // return report info with EmbedParameters needed for UI Http Request to Power BI server
            return ModelResponse(reportEmbedResponse);
        }

        [HttpPost]
        public async Task<IActionResult> ExportReport(ExportReportRequestModel request)
        {

            var response = await Mediator.Send(new ExportReportCommand(request));
            if (response.Success && response.ReportStream != null)
            {
                //response.ReportStream.Flush();

                var file = new FileStreamResult(response.ReportStream, response.DownloadMimeType);
                file.FileDownloadName = response.ReportName + response.ResourceFileExtension;
                return file;
            }
            else
            {
                return ModelResponse(response);
            }
        }

    }
}
