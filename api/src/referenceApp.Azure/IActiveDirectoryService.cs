
namespace referenceApp.Azure
{
    public interface IActiveDirectoryService
    {

        /// <summary>
        /// Authenticates with Active Directory using configuration credentials
        /// and returns a security access token as a string.
        /// </summary>
        /// <returns>AAD token</returns>
        string? GetAccessToken();

        /// <summary>
        /// Gets the registered application client id of the login principal.
        /// </summary>
        string ClientId { get; }

    }
}
