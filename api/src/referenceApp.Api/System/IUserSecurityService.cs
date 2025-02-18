using System.Security.Claims;
using System.Threading.Tasks;
using referenceApp.Common.Enum;

namespace referenceApp.Api.System
{
    public interface IUserSecurityService
    {
        
        /// <summary>
        /// Loads a user profile from the database using the user's unique identity Guid provided in the IdP claims.
        /// First time users can be automatically registered into the database if coming form an external, trusted IdP.
        /// </summary>
        Task LoadDatabaseUser(ClaimsPrincipal user);

        /// <summary>
        /// Creates a test user profile and an impersonated ClaimsPrincipal for developer testing in debug mode.
        /// </summary>
        Task LoadTestUser(UserTypeEnum userType);

        /// <summary>
        /// Creates a test user profile and an impersonated ClaimsPrincipal for developer testing in debug mode.
        /// </summary>
        Task LoadTestUser(string activeDirectoryIdentityId);
    }
}
