using System;
using MediatR;
using referenceApp.Common.Models.System;

namespace referenceApp.Lib.System.Queries
{
    public class GetUserProfileQuery : IRequest<UserProfileModel>
    {
        public string ActiveDirectoryIdentityId { get; set; }

        public GetUserProfileQuery(string activeDirectoryIdentityId)
        {
            if (string.IsNullOrWhiteSpace(activeDirectoryIdentityId))
                throw new ArgumentException(nameof(activeDirectoryIdentityId));

            ActiveDirectoryIdentityId = activeDirectoryIdentityId;
        }
    }
}
