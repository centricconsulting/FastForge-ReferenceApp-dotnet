using Microsoft.Extensions.Options;
using referenceApp.Azure.Constants;
using referenceApp.Azure.Models;
using referenceApp.Common.Constants;
using referenceApp.PowerBi.Models;

namespace referenceApp.PowerBi
{
    public class PowerBiConfigurationValidatorUtility
    {
        /// <summary>
        /// Validates the provided PowerBIConfigModel configuration options and throws an Exception if any option
        /// is invalid. Returns null if valid or an optional invalid message if not valid.
        /// </summary>
        public static string? ValidatePowerBiConfig(IOptions<PowerBIConfigModel> powerBIOptions, bool throwExceptionIfInvalid = true)
        {
            if (powerBIOptions == null || powerBIOptions.Value == null)
                throw new ArgumentNullException(nameof(powerBIOptions)
                    , $"The {ConfigurationSettingConstants.PowerBiConfigSectionName} configuration section is required in the {ConfigurationSettingConstants.ConfigurationFileName} file.");

            string? invalidMessage = null;
            var checkMessage = $"Check the {ConfigurationSettingConstants.PowerBiConfigSectionName} configuration section in the {ConfigurationSettingConstants.ConfigurationFileName} file.";

            if (string.IsNullOrWhiteSpace(powerBIOptions.Value.PowerBiServiceRootUrl))
            {
                invalidMessage = "PowerBiServiceRootUrl setting is not set or missing.";
            }
            else if (string.IsNullOrWhiteSpace(powerBIOptions.Value.WorkspaceId))
            {
                invalidMessage = "WorkspaceId setting is not set or missing.";
            }
            else if (!IsValidGuid(powerBIOptions.Value.WorkspaceId))
            {
                invalidMessage = "WorkspaceId is not a valid Guid value.";
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

        /// <summary>
        /// Checks whether a string is a valid guid
        /// </summary>
        /// <param name="configParam">String value</param>
        /// <returns>Boolean value indicating validity of the guid</returns>
        private static bool IsValidGuid(string configParam)
        {
            return Guid.TryParse(configParam, out var result);
        }

    }
}
