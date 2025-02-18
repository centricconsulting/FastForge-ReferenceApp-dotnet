
using System;
using System.Collections.Generic;
using referenceApp.Common.Models.Entity;
using referenceApp.Common.Models.System;

namespace referenceApp.Persistence
{
    public class SystemDataService : ISystemDataService
    {
        private readonly ReferenceDbContext _dbContext;
        public SystemDataService(ReferenceDbContext dbContext)
        {
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
        }

        public TimeZoneInfo UserTimeZone { get; set; }

        public List<IdentityProviderEntityModel> GetTrustedIdentityProviderClaimValues()
        {
            throw new NotImplementedException();
        }

        public bool IsUserRegisteredInDatabase(string activeDirectoryIdentityId)
        {
            throw new NotImplementedException();
        }

        public UserProfileModel GetUserProfile(string activeDirectoryIdentityId)
        {
            throw new NotImplementedException();
        }

    }
}
