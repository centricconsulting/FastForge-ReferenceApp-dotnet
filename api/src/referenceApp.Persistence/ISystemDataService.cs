using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using referenceApp.Common.Models.Entity;
using referenceApp.Common.Models.System;

namespace referenceApp.Persistence
{
    public interface ISystemDataService
    {

        /// <summary>
        /// Gets or sets the user's local time zone.
        /// Use for converting date and times to the user's time zone.
        /// </summary>
        TimeZoneInfo UserTimeZone { get; set; }

        #region System and Security methods

        /// <summary>
        /// Gets the list of external, trusted IdentityProvider records 
        /// that are coded for automatic user registration.
        /// </summary>
        /// <returns></returns>
        List<IdentityProviderEntityModel> GetTrustedIdentityProviderClaimValues();

        /// <summary>
        /// Verifies the user is registered in the database regardless if active, but not deleted.
        /// </summary>
        bool IsUserRegisteredInDatabase(string activeDirectoryIdentityId);

        /// <summary>
        /// Gets the UserProfileModel object for the provided Active Directory identity id.
        /// Verifies the user is active and has an authorized license.
        /// </summary>
        UserProfileModel GetUserProfile(string activeDirectoryIdentityId);

        #endregion System and Security methods

    }
}
