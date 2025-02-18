using System.Security;
using referenceApp.Azure.Models;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using referenceApp.Azure.Constants;

namespace referenceApp.Azure
{
    public class ActiveDirectoryService : IActiveDirectoryService
    {
        private readonly IOptions<ActiveDirectoryConfigModel>? _adOptions;

        public ActiveDirectoryService(IOptions<ActiveDirectoryConfigModel> adOptions)
        {
            if (ConfigurationValidatorUtility.ValidateActiveDirectoryConfig(adOptions) == null)
                _adOptions = adOptions ?? throw new ArgumentNullException(nameof(adOptions));
        }

        #region Properties


        public string ClientId { get { return _adOptions?.Value?.ClientId ?? string.Empty; } }


        #endregion

        #region Implementation Methods

        public string? GetAccessToken()
        {
            string? accessToken = null;
            if (_adOptions?.Value?.AuthenticationMode == null) return accessToken;

            AuthenticationResult authenticationResult;
            if (_adOptions.Value.AuthenticationMode.Equals(AuthenticationConstants.AuthenticationModeUserAccount, StringComparison.InvariantCultureIgnoreCase))
            {
                // Create a public client to authorize the app with the AAD app
                var clientApp = PublicClientApplicationBuilder.Create(_adOptions.Value.ClientId).WithAuthority(_adOptions.Value.AuthorityUri).Build();
                var userAccounts = clientApp.GetAccountsAsync().Result;
                try
                {
                    // Retrieve Access token from cache if available
                    authenticationResult = clientApp.AcquireTokenSilent(_adOptions.Value.Scope, userAccounts.FirstOrDefault()).ExecuteAsync().Result;
                }
                catch (MsalUiRequiredException)
                {
                    var password = new SecureString();
                    foreach (var key in _adOptions.Value.PbiPassword ?? string.Empty)
                    {
                        password.AppendChar(key);
                    }
                    authenticationResult = clientApp.AcquireTokenByUsernamePassword(_adOptions.Value.Scope, _adOptions.Value.PbiUsername, password).ExecuteAsync().Result;
                    accessToken = authenticationResult.AccessToken;
                }
            }

            // Service Principal auth is the recommended by Microsoft to achieve App Owns Data Power BI embedding
            else if (_adOptions.Value.AuthenticationMode.Equals(AuthenticationConstants.AuthenticationModeServicePrincipal, StringComparison.InvariantCultureIgnoreCase))
            {
                // For app only authentication, we need the specific tenant id in the authority url
                var tenantSpecificUrl = _adOptions.Value.AuthorityUri ?? string.Empty;
                if (!tenantSpecificUrl.Contains(_adOptions.Value.TenantId ?? string.Empty, StringComparison.InvariantCultureIgnoreCase))
                {
                    if (tenantSpecificUrl.EndsWith("/"))
                    {
                        tenantSpecificUrl = $"{tenantSpecificUrl}{_adOptions.Value.TenantId}/";
                    }
                    else
                    {
                        tenantSpecificUrl = $"{tenantSpecificUrl}/{_adOptions.Value.TenantId}/";
                    }
                }

                // Create a confidential client to authorize the app with the AAD app
                var clientApp = ConfidentialClientApplicationBuilder
                                    .Create(_adOptions.Value.ClientId)
                                    .WithClientSecret(_adOptions.Value.ClientSecret)
                                    .WithAuthority(tenantSpecificUrl)
                                    .Build();
                // Make a client call if Access token is not available in cache
                authenticationResult = clientApp.AcquireTokenForClient(_adOptions.Value.Scope).ExecuteAsync().Result;
                accessToken = authenticationResult.AccessToken;
            }

            return accessToken;
        }

        #endregion

    }
}
