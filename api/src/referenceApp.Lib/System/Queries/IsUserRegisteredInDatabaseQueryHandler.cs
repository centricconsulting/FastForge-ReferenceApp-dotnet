
using MediatR;
using System.Threading.Tasks;
using System.Threading;
using System;
using referenceApp.Persistence;

namespace referenceApp.Lib.System.Queries
{
    public class IsUserRegisteredInDatabaseQueryHandler : IRequestHandler<IsUserRegisteredInDatabaseQuery, bool>
    {
        private readonly SystemDataService _dbService;

        public IsUserRegisteredInDatabaseQueryHandler(SystemDataService dbService)
        {
            _dbService = dbService ?? throw new ArgumentNullException(nameof(dbService));
        }

        public async Task<bool> Handle(IsUserRegisteredInDatabaseQuery request, CancellationToken cancellationToken)
        {
            var isRegistered = false;
            if (!string.IsNullOrWhiteSpace(request.UserIdentityId))
            {
                isRegistered = _dbService.IsUserRegisteredInDatabase(request.UserIdentityId);
            }
            return await Task.FromResult(isRegistered);
        }
    }
}
