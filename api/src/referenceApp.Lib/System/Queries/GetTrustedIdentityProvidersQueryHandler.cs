
using MediatR;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Threading;
using System;
using referenceApp.Common.Models.Entity;
using referenceApp.Persistence;

namespace referenceApp.Lib.System.Queries
{
    public class GetTrustedIdentityProvidersQueryHandler : IRequestHandler<GetTrustedIdentityProvidersQuery, List<IdentityProviderEntityModel>>
    {
        private readonly SystemDataService _dbService;

        public GetTrustedIdentityProvidersQueryHandler(SystemDataService dbService)
        {
            _dbService = dbService ?? throw new ArgumentNullException(nameof(dbService));
        }

        public async Task<List<IdentityProviderEntityModel>> Handle(GetTrustedIdentityProvidersQuery request, CancellationToken cancellationToken)
        {
            return await Task.FromResult(_dbService.GetTrustedIdentityProviderClaimValues());
        }
    }
}
