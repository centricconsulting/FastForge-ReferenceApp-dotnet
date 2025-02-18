
namespace referenceApp.Common.Enum
{
    public class EnumMapper
    {
        public static IdentityProviderEnum IntToIdentityProviderEnum(int? value)
        {
            if (value == null || value <= 0)
                return 0;
            return (IdentityProviderEnum)value;
        }
        public static IdentityProviderEnum ToIdentityProviderEnum(string? value)
        {
            System.Enum.TryParse(value, true, out IdentityProviderEnum enumVal);
            return enumVal;
        }


    }
}
