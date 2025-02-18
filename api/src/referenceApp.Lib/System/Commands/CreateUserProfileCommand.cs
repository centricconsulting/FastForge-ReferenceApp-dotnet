using System;
using MediatR;
using referenceApp.Common.Models.System;

namespace referenceApp.Lib.System.Commands
{
    public class CreateUserProfileCommand : IRequest<int>
    {
        public CreateUserProfileCommand(NewUserModel newUser)
        {
            NewUser = newUser ?? throw new ArgumentNullException(nameof(newUser));
        }
        public NewUserModel NewUser { get; set; }      

    }
}
