using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using referenceApp.Common.Models.System;
using referenceApp.Persistence;

namespace referenceApp.Lib.System.Queries
{
    public class GetUserProfileQueryHandler : IRequestHandler<GetUserProfileQuery, UserProfileModel>
    {
        private readonly SystemDataService _dbService;
        public GetUserProfileQueryHandler(SystemDataService dbService)
        {
            _dbService = dbService ?? throw new ArgumentNullException(nameof(dbService));
        }

        public async Task<UserProfileModel>  Handle(GetUserProfileQuery request, CancellationToken cancellationToken)
        {
            // ToDo System Security: Write code that retrieves the user profile for use by this Web API and the Web App (returned client-side).
            return await Task.FromResult(_dbService.GetUserProfile(request.ActiveDirectoryIdentityId));
        }
    }
}
