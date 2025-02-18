using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using referenceApp.Persistence;

namespace referenceApp.Lib.System.Commands
{
    public class CreateUserProfileCommandHandler : IRequestHandler<CreateUserProfileCommand, int>
    {
        private readonly SystemDataService _dbService;
        public CreateUserProfileCommandHandler(SystemDataService dbService)
        {
            _dbService = dbService ?? throw new ArgumentNullException(nameof(dbService));
        }

        public async Task<int> Handle(CreateUserProfileCommand request, CancellationToken cancellationToken)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            // ToDo System Security: Write code that auto-registers a new user by creating user profile data in the app's data store.
            int newUserId = 0;

            // Use dbService to insert data in related tables that represent the user profile data.
            throw new NotImplementedException();

            // Return a response data model if logic is more complex and needing to return success/failure details.
            return newUserId;               
        }
    }
}
