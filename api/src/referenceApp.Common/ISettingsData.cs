
namespace referenceApp.Common.Models.System
{
    public interface ISettingsData
    {

        /// <summary>
        /// Gets the current user profile information.
        /// </summary>
        UserProfileModel UserProfile { get; set; }

        /// <summary>
        /// Gets or sets the application root path in Azure or local.
        /// </summary>
        string ContentRootPath { get; set; }

        /// <summary>
        /// Gets or sets the string value of the current environment as Development, Test, or Production.
        /// </summary>
        public string? Environment { get; set; }


    }
}
