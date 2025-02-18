
using MediatR;

namespace referenceApp.Lib.System.Queries
{
    public class IsUserRegisteredInDatabaseQuery : IRequest<bool>
    {
        public string UserIdentityId { get; set; }

        public IsUserRegisteredInDatabaseQuery(string userIdentityId)
        {
            UserIdentityId = userIdentityId;
        }
    }
}
