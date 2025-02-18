
namespace referenceApp.PowerBi.Constants
{
    /// <summary>
    /// string constants that represents various Power BI Dataset refresh types.
    /// </summary>
    public class DatasetRefreshTypeConstants
    {

        /// <summary>
        /// Tells Power BI to do a dataset refresh using the default, automatic behavior that
        /// refreshes only what is needed.
        /// </summary>
        public const string Automatic = "automatic";

        /// <summary>
        /// Tells Power BI to do a dataset refresh that clears all imported cached data and reloads
        /// all data from the data source.
        /// </summary>
        public const string Full = "full";

        /// <summary>
        /// Checks whether or not this constants class has the provided string value.
        /// </summary>
        public static bool HasValue(string value)
        {
            return !string.IsNullOrWhiteSpace(value)
                   && (value.Equals(Automatic, StringComparison.InvariantCultureIgnoreCase)
                       || value.Equals(Full, StringComparison.CurrentCultureIgnoreCase));
        }

    }
}
