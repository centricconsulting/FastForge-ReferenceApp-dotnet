
namespace referenceApp.Common.Models.System
{
    public class SettingsData : ISettingsData
    {

        /// <summary>
        /// Gets the current user profile information.
        /// </summary>
        public UserProfileModel UserProfile { get; set; } = default!;

        public string? ContentRootPath { get; set; }

        public string? Environment { get; set; } = null;
    }
}
