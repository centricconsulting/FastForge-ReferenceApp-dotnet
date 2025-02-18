
namespace referenceApp.Common.Models
{
    /// <summary>
    /// A data model base interface that defines properties containing success and failure information to return to the API client.
    /// </summary>
    public interface IBaseResponseModel
    {

        /// <summary>
        /// True if request was successful with no errors and data passed validation.
        /// </summary>
        bool Success { get; set; }

        /// <summary>
        /// User-friendly display message if a failure occurred such as a program error or invalid data.
        /// </summary>
        string? DisplayFailMessage { get; set; }

        /// <summary>
        /// Technical details of any thrown program exception. Will be null if no error.
        /// </summary>
        string? ErrorDetail { get; set; }

    }
}
