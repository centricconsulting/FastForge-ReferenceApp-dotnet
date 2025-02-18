using System;
using System.Net;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FeatureManagement;
using referenceApp.Api.System;
using referenceApp.Common.Models;
using referenceApp.Common.Models.System;

namespace referenceApp.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public abstract class ApiControllerBase : ControllerBase
    {
        protected readonly ISettingsData SettingsData;
        private readonly IUserSecurityService _userSecurity;
        protected readonly IFeatureManager _featureManager;
        private IMediator _mediator;

        protected IMediator Mediator => _mediator ?? (_mediator = ControllerContext.HttpContext.RequestServices.GetService<IMediator>());

        public ApiControllerBase(IFeatureManager featureManager, IUserSecurityService userSecurity, ISettingsData settingsData)
        {
            _featureManager = featureManager;
            _userSecurity = userSecurity;
            SettingsData = settingsData;

            if (SettingsData?.UserProfile == null)
            {
                string env = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
                // ToDo TESTING Swagger: Developers change the AAD object id of the user that you want to do Swagger testing with.
                // Uncomment [Authorize] attrbibute in derived controller class when done testing and before pushing changes.
                if (env != null && env.Equals("Development", StringComparison.CurrentCultureIgnoreCase))
                    _userSecurity.LoadTestUser("59c343d1-9306-00aa-a09b-a13fb65867bf");
                //_userSecurity.LoadTestUser(UserTypeEnum.Admin);
            }
        }

        /// <summary>
        /// Returns the appropriate ActionResult type for the provided model object that reflects either 
        /// a 200 success, 400 invalid data, or 500 program error condition.
        /// </summary>
        protected ActionResult ModelResponse(IBaseResponseModel model)
        {
            if (model == null)
                throw new ArgumentNullException(nameof(model), "An instance of IBaseResponseModel is required when using the controller base ModelResponse method.");
            if (model.Success)
            {
                return Ok(model);
            }

            if (string.IsNullOrWhiteSpace(model.ErrorDetail))
            {
                return BadRequest(model);
            }
            // treat any other condition a program error.
            return StatusCode((int)HttpStatusCode.InternalServerError, model);
        }

        /// <summary>
        /// Returns a new instance of the BaseResponseModel in an ActionResult type of 200 success.
        /// </summary>
        protected ActionResult NoDataResponse()
        {
            return Ok(new BaseResponseModel());
        }

    }
}
