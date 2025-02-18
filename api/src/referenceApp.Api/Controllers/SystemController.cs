using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using referenceApp.Api.System;
using referenceApp.Common.Models.System;

namespace referenceApp.Api.Controllers
{
    [Authorize]
    [Route("api/[controller]/[action]")]
    public class SystemController : ApiControllerBase
    {
        public SystemController(IFeatureManager featureManager, IUserSecurityService userSecurity, ISettingsData settingsData)
            : base(featureManager, userSecurity, settingsData)
        {
        }

        [HttpGet]
        [Produces("application/json")]
        public async Task<ActionResult<UserProfileModel>> GetUserProfile()
        {
            // ToDo System Security: NOTE: User profile is loaded and validated on every api call from the OnTokenValidated event setup in the Startup class. No input needed; only the header token is needed.
            // to test api using swagger, comment out [Authorize] attributes of the controller/method and change which test user to use in controller base class.
            return ModelResponse(await Task.FromResult(SettingsData.UserProfile));
        }
    }
}
