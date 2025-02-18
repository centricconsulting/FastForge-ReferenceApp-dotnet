using Microsoft.Extensions.Options;
using referenceApp.Azure.Constants;
using referenceApp.Azure.Models;
using referenceApp.Common.Constants;

namespace referenceApp.Azure
{
    public class ConfigurationValidatorUtility
    {
        /// <summary>
        /// Validates the provided ActiveDirectoryConfigModel configuration options and throws an Exception if any option
        /// is invalid. Returns null if valid or an optional invalid message if not valid.
        /// </summary>
        public static string? ValidateActiveDirectoryConfig(IOptions<ActiveDirectoryConfigModel> azureAdOptions, bool throwExceptionIfInvalid = true)
        {
            if (azureAdOptions == null || azureAdOptions.Value == null) throw new ArgumentNullException(nameof(azureAdOptions)
                , $"The {ConfigurationSettingConstants.PowerBiActiveDirectoryConfigSectionName} configuration section is required in the {ConfigurationSettingConstants.ConfigurationFileName} file.");

            string? invalidMessage = null;
            var checkMessage = $"Check the {ConfigurationSettingConstants.PowerBiActiveDirectoryConfigSectionName} configuration section in the {ConfigurationSettingConstants.ConfigurationFileName} file.";

            if (string.IsNullOrWhiteSpace(azureAdOptions.Value.AuthenticationMode))
            {
                invalidMessage = "AuthenticationMode setting is not set or missing.";
            }
            else
            {
                var isAuthModeUserAccount = azureAdOptions.Value.AuthenticationMode.Equals(AuthenticationConstants.AuthenticationModeUserAccount, StringComparison.InvariantCultureIgnoreCase);
                var isAuthModeServicePrincipal = azureAdOptions.Value.AuthenticationMode.Equals(AuthenticationConstants.AuthenticationModeServicePrincipal, StringComparison.InvariantCultureIgnoreCase);

                if (!isAuthModeServicePrincipal && !isAuthModeUserAccount)
                {
                    invalidMessage = $"AuthenticationMode setting is not set to a valid value. Correct values are '{AuthenticationConstants.AuthenticationModeServicePrincipal}' or '{AuthenticationConstants.AuthenticationModeUserAccount}'.";
                }
                if (string.IsNullOrWhiteSpace(azureAdOptions.Value.AuthorityUri))
                {
                    invalidMessage = "AuthorityUri setting is not set or missing.";
                }
                else if (string.IsNullOrWhiteSpace(azureAdOptions.Value.ClientId))
                {
                    invalidMessage = "ClientId setting is not set or missing.";
                }
                else if (isAuthModeServicePrincipal && string.IsNullOrWhiteSpace(azureAdOptions.Value.TenantId))
                {
                    invalidMessage = "TenantId setting is not set or missing.";
                }
                else if (azureAdOptions.Value.Scope is null || azureAdOptions.Value.Scope.Length == 0)
                {
                    invalidMessage = "Scope setting is not set or missing.";
                }
                else if (isAuthModeUserAccount && string.IsNullOrWhiteSpace(azureAdOptions.Value.PbiUsername))
                {
                    invalidMessage = "PbiUserName setting is not set or missing.";
                }
                else if (isAuthModeUserAccount && string.IsNullOrWhiteSpace(azureAdOptions.Value.PbiPassword))
                {
                    invalidMessage = "PbiPassword setting is not set or missing.";
                }
                else if (isAuthModeServicePrincipal && string.IsNullOrWhiteSpace(azureAdOptions.Value.ClientSecret))
                {
                    invalidMessage = "ClientSecret setting is not set or missing.";
                }
            }

            if (invalidMessage != null)
            {
                invalidMessage = $"{invalidMessage} {checkMessage}";
                if (throwExceptionIfInvalid)
                {
                    throw new ApplicationException(invalidMessage);
                }
                return invalidMessage;
            }
            return null;
        }

    }
}
