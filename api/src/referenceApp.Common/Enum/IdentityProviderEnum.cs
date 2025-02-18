
namespace referenceApp.Common.Enum
{
    public enum IdentityProviderEnum
    {
        /// <summary>
        /// Identity provider is an unknown external entity that is not trusted.
        /// </summary>
        Unknown = 0,

        /// <summary>
        /// Accounts created in the company Azure Entra ID or Active Directory B2C tenant.
        /// </summary>
        LocalMemberAccounts = 1,

        /// <summary>
        /// A trusted Microsoft work or school account.
        /// </summary>
        ClientMicrosoftAccounts = 2,


    }
}
