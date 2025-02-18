
namespace referenceApp.Common.Models.Entity
{
    public class IdentityProviderEntityModel
    {
        /// <summary>
        /// Primary key id of the IdentityProvider table. Can correspond with an Enum id.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Short name of the IdentityProvider. Can correspond with an Enum name.
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// Name to display in UI dropdown list options.
        /// </summary>
        public string? DisplayName { get; set; }

        /// <summary>
        /// The claim value part to compare with the current user 'identityprovider' claim
        /// for determining the trusted IdP that authenticated the user.
        /// </summary>
        public string? ClaimIdentityProviderValue { get; set; }

    }
}
