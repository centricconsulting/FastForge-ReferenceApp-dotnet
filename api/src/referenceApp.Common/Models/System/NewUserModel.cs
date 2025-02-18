
using referenceApp.Common.Enum;

namespace referenceApp.Common.Models.System
{
    public class NewUserModel
    {
        public string? ActiveDirectoryId { get; set; }
        public int AccountTypeId { get; set; }

        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? UserName { get; set; }
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

    }
}
