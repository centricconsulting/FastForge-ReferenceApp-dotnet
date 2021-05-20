using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FeatureManagement;

namespace referenceApp.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public abstract class ApiControllerBase : ControllerBase
    {
        protected readonly IFeatureManager FeatureManager;
        private IMediator _mediator;

        protected IMediator Mediator => _mediator ?? (_mediator = ControllerContext.HttpContext.RequestServices.GetService<IMediator>());

        public ApiControllerBase(IFeatureManager featureManager)
        {
            FeatureManager = featureManager;
        }
    }
}
