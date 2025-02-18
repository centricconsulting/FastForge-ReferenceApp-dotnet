
namespace referenceApp.Common.Models
{
    /// <summary>
    /// A data model base class that defines properties containing success and failure information to return to the API client.
    /// Return an instance of this base class if no data to return.
    /// </summary>
    public class BaseResponseModel : IBaseResponseModel
    {
        /// <summary>
        /// Base constructor that sets its properties to a default success state.
        /// Set the base properties directly if returning a failure condition.
        /// </summary>
        public BaseResponseModel()
        {
            Success = true;
            DisplayFailMessage = null;
            ErrorDetail = null;
        }

        /// <summary>
        /// True if request was successful with no errors and data passed validation.
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// User-friendly display message if a failure occurred such as a program error or invalid data.
        /// </summary>
        public string? DisplayFailMessage { get; set; }

        /// <summary>
        /// Technical details of any thrown program exception. Will be null if no error.
        /// </summary>
        public string? ErrorDetail { get; set; }


    }
}
