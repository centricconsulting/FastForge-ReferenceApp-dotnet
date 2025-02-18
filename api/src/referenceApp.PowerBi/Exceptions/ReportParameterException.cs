
namespace referenceApp.PowerBi.Exceptions
{
    public class ReportParameterException : Exception
    {

        public ReportParameterException(string message, Exception? innerException = null) : base(message, innerException)
        {
        }

    }
}
