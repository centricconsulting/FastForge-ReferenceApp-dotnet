
using MediatR;
using referenceApp.Common.Models.Entity;
using System.Collections.Generic;

namespace referenceApp.Lib.System.Queries
{
    public class GetTrustedIdentityProvidersQuery : IRequest<List<IdentityProviderEntityModel>>
    {
    }
}
