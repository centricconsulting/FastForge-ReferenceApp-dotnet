using referenceApp.Common.Enum;

namespace referenceApp.Common.Models.System
{
    /// <summary>
    /// Data model of the user profile that contains information from identity claims and the application database.
    /// </summary>
    public class UserProfileModel : BaseResponseModel
    {

        public UserProfileModel()
        {
            IsAuthenticated = false;
            Active = false;
            ReasonNotActive = null;
        }

        /// <summary>
        /// Unique user id from the NTNMath database.
        /// </summary>
        public int? Id { get; set; }

        /// <summary>
        /// Unique user identifier from Azure Active Directory.
        /// </summary>
        public string? ActiveDirectoryIdentityId { get; set; }

        /// <summary>
        /// User full display name.
        /// </summary>
        public string? DisplayName { get; set; }

        /// <summary>
        /// User first given name.
        /// </summary>
        public string? FirstName { get; set; }

        /// <summary>
        /// User family surname.
        /// </summary>
        public string? LastName { get; set; }

        /// <summary>
        /// User email addresss.
        /// </summary>
        public string? Email { get; set; }

        /// <summary>
        /// Identifier of the user type associated with the user. This translates to
        /// the user role. Use with enum comparison in .NET.
        /// </summary>
        public UserTypeEnum UserTypeId { get; set; }

        /// <summary>
        /// String name of the user type also known as the user role.
        /// </summary>
        public string? Role { get; set; }

        /// <summary>
        /// The region culture code that matches the user's preferred language.
        /// </summary>
        public string? RegionCultureCode { get; set; }

        /// <summary>
        /// The time zone name that can be used to create an instance of TimeZoneInfo and
        /// convert date and times to the user's local time zone.
        /// </summary>
        public string? TimeZone { get; set; }

        // ToDo System Security: USER Profile - Customize the properties depending on what data store information related to the current authenticated user is needed by client-side code.
        
        /// <summary>
        /// User's assigned school district id if related to a school or district.
        /// Returns zero if user is NTN admin.
        /// </summary>
        public int DistrictId { get; set; }

        /// <summary>
        /// True if active and false if not.
        /// </summary>
        public bool Active { get; set; }

        /// <summary>
        /// Reason user is not active or failed validation. Set to null if Active is true.
        /// </summary>
        public string? ReasonNotActive { get; set; }

        /// <summary>
        /// True if the user is both authenticated with the identity provider and active in the database.
        /// </summary>
        public bool IsAuthenticated { get; set; }

        /// <summary>
        /// License id that is assigned to the user. Returns zero if license is inactive or no license found.
        /// </summary>
        public int LicenseId { get; set; }

        /// <summary>
        /// List collection of user settings. Each setting is a name and value pair.
        /// Convert string value to the appropriate type as needed.
        /// </summary>
        public List<SettingNameValueModel> Settings { get; set; } = new List<SettingNameValueModel>();
    }
}
