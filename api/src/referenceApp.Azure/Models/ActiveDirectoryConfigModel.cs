
namespace referenceApp.Azure.Models
{
    public class ActiveDirectoryConfigModel
    {
        /// <summary>
        /// Can be set to 'MasterUser' or 'ServicePrincipal' 
        /// </summary>
        public string? AuthenticationMode { get; set; }

        /// <summary>
        /// URL used for initiating authorization request 
        /// </summary>
        public string? AuthorityUri { get; set; }

        /// <summary>
        /// Client Id (Application Id) of the AAD app 
        /// </summary>
        public string? ClientId { get; set; }

        /// <summary>
        /// Id of the Azure tenant in which AAD app is hosted. Required only for Service Principal authentication mode.
        /// </summary>
        public string? TenantId { get; set; }

        /// <summary>
        /// Scope of AAD app. Use the below configuration to use all the permissions provided in the AAD app through Azure portal.
        /// </summary>
        public string[]? Scope { get; set; }

        /// <summary>
        /// Master user email address. Required only for MasterUser authentication mode. 
        /// </summary>
        public string? PbiUsername { get; set; }

        /// <summary>
        /// Master user email password. Required only for MasterUser authentication mode. 
        /// </summary>
        public string? PbiPassword { get; set; }

        /// <summary>
        /// Client Secret (App Secret) of the AAD app. Required only for ServicePrincipal authentication mode. 
        /// </summary>
        public string? ClientSecret { get; set; }
    }
}
