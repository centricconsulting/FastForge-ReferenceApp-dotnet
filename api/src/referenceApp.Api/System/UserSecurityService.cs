using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Identity.Web;
using referenceApp.Common.Constants;
using referenceApp.Common.Enum;
using referenceApp.Common.Models.System;
using referenceApp.Lib.System.Commands;
using referenceApp.Lib.System.Queries;
using referenceApp.Persistence;

namespace referenceApp.Api.System
{
    public class UserSecurityService : IUserSecurityService
    {
        //private UserProfileModel _userProfile = null;
        private readonly IMediator _mediator;
        private readonly IHttpContextAccessor _httpContext;

        private readonly ISettingsData _settingsData;
        //private IMediator Mediator => _mediator ?? (_mediator = HttpContext.RequestServices.GetService<IMediator>());

        public UserSecurityService(IMediator mediator, IHttpContextAccessor httpContext, ISettingsData settingsData)
        {
            _mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
            _httpContext = httpContext ?? throw new ArgumentNullException(nameof(httpContext));
            _settingsData = settingsData ?? throw new ArgumentNullException(nameof(settingsData));
        }

        public Task LoadDatabaseUser(ClaimsPrincipal user)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));

            _settingsData.Environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            if (user.Identity != null)
            {
                if (user.Identity.IsAuthenticated)
                {
                    // ToDo System Security: Customize this code for your client specific requirements. The code below auto-registers and verifies user access via database stored profile data.

                    // attempt to get user profile
                    var activeDirectoryIdentityId = user.GetObjectId(); //?? "0f570bfb-1ed8-465f-ae88-03adc7ff4cfa"; // Mike Card
                    _settingsData.UserProfile = _mediator.Send(new GetUserProfileQuery(activeDirectoryIdentityId)).GetAwaiter().GetResult();
                    if (!_settingsData.UserProfile.Success)
                    {
                        if (_settingsData.UserProfile.ReasonNotActive == DisplayMessageConstants.SecurityUserNotFound)
                        {
                            // check if user is from a trusted IdP and already registered in DB
                            if (IsNewUserRegistration(activeDirectoryIdentityId))
                            {
                                var idp = DetermineTrustedIdentityProviderIfExternal(user);
                                if (idp != IdentityProviderEnum.Unknown && idp != IdentityProviderEnum.LocalMemberAccounts)
                                {
                                    RegisterExternalUserIntoDatabase(user, activeDirectoryIdentityId, idp);

                                    // try again to load profile after auto-registration attempt
                                    _settingsData.UserProfile = _mediator.Send(new GetUserProfileQuery(activeDirectoryIdentityId)).GetAwaiter().GetResult();
                                }
                            }
                        }
                    }

                    if (!_settingsData.UserProfile.Success)
                    {
                        // user profile not active or user not trusted, so exit now
                        return Task.CompletedTask;
                    }

                    // set custom user profile 
                    if (_settingsData.UserProfile.Active)
                        _settingsData.UserProfile.IsAuthenticated = true;

                    string adDisplayName = user.GetDisplayName();
                    if (!string.IsNullOrWhiteSpace(adDisplayName))
                    {
                        if (adDisplayName.Contains("@") && string.IsNullOrWhiteSpace(_settingsData.UserProfile.Email))
                            _settingsData.UserProfile.Email = adDisplayName;
                        if (!adDisplayName.Contains("@") && string.IsNullOrWhiteSpace(_settingsData.UserProfile.DisplayName))
                            _settingsData.UserProfile.DisplayName = adDisplayName;
                    }
                    if (string.IsNullOrWhiteSpace(_settingsData.UserProfile.DisplayName))
                        _settingsData.UserProfile.DisplayName = _settingsData.UserProfile.FirstName + " " + _settingsData.UserProfile.LastName;

                    // add role to the claims
                    ((ClaimsIdentity)user.Identity).AddClaim(new Claim(ClaimTypes.Role, _settingsData.UserProfile.Role ?? string.Empty)); 

                    // ToDo System Security: Consider caching the _settingsData in memory using the user identity guid as the key. Then, reload from cache on every Web request for better performance.
                }
            }
            return Task.CompletedTask;
        }

        private void RegisterExternalUserIntoDatabase(ClaimsPrincipal user, string _activeDirectoryIdentityId, IdentityProviderEnum identityProvider)
        {
            var claims = DeserializeIdToken(user.Identities.First().Claims.First(x => x.Type == "idp_access_token").Value);

            // ToDo System Security: Different identity providers will have a varying list of claim types. Consider using constants or store in the database with the IdP table.
            NewUserModel? newUser = null;
            switch (identityProvider)
            {
                case IdentityProviderEnum.ClientMicrosoftAccounts:
                    newUser = new NewUserModel
                    {
                        ActiveDirectoryId = _activeDirectoryIdentityId,
                        UserName = claims.First(x => x.Type == "preferred_username").Value,
                        Email = user.Identities.First().Claims.First(x => x.Type == "emails").Value,
                        FirstName = user.Identities.First().Claims.First(x => x.Type.Contains("givenname")).Value,
                        LastName = user.Identities.First().Claims.First(x => x.Type.Contains("surname")).Value,
                        AccountTypeId = Convert.ToInt32(identityProvider),
                        Role = "user role?", // modify code as needed to support single role or support for multiple roles.
                        UserTypeId = UserTypeEnum.OtherUserRole // write code to transform this from role or delete and modify code accordingly.
                    };
                    break;
            }
            if (newUser != null)
                _mediator.Send(new CreateUserProfileCommand(newUser)).GetAwaiter().GetResult();            
        }

        private IEnumerable<Claim> DeserializeIdToken(string value)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var jwtToken = tokenHandler.ReadJwtToken(value);
            return jwtToken.Claims;
        }

        private bool IsNewUserRegistration(string? activeDirectoryId)
        {
            if (string.IsNullOrWhiteSpace(activeDirectoryId))
                return false;
            return !_mediator.Send(new IsUserRegisteredInDatabaseQuery(activeDirectoryId)).GetAwaiter().GetResult();
        }

        private IdentityProviderEnum DetermineTrustedIdentityProviderIfExternal(ClaimsPrincipal user)
        {
            var identityProvider = IdentityProviderEnum.Unknown;
            var claimIdpValue = user.Identities.First().Claims.FirstOrDefault(x => x.Type.ToLower().Contains("identityprovider"))?.Value;
            if (string.IsNullOrEmpty(claimIdpValue))
            {
                // local accounts do not have claim 'identityprovider'
                identityProvider = IdentityProviderEnum.LocalMemberAccounts;
                return identityProvider;
            }

            // check list of trusted identity providers
            // ToDo System Security: Store the compare claim value in appsettings or enum or database. Use database approach below if app will support many different B2B/B2C Identity Providers.
            if (claimIdpValue.Contains("clientDomain.com/oauth2", StringComparison.CurrentCultureIgnoreCase))
            {
                identityProvider = IdentityProviderEnum.ClientMicrosoftAccounts;
            }
            // using the database approach
            var trustedIdps = _mediator.Send(new GetTrustedIdentityProvidersQuery()).GetAwaiter().GetResult();
            foreach (var idp in trustedIdps)
            {
                if (idp.ClaimIdentityProviderValue != null
                    && claimIdpValue.Contains(idp.ClaimIdentityProviderValue, StringComparison.CurrentCultureIgnoreCase))
                {
                    identityProvider = EnumMapper.IntToIdentityProviderEnum(idp.Id);
                    break;
                }
            }

            return identityProvider;
        }

        /// <summary>
        /// Use only for Development purpose only.
        /// </summary>
        public Task LoadTestUser(UserTypeEnum userType)
        {
            //if (context == null) throw new ArgumentNullException(nameof(context));
            _settingsData.Environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            string activeDirectoryIdentityId;
            switch (userType)
            {
                case UserTypeEnum.AdminRole:
                    activeDirectoryIdentityId = "0f570bfb-1ed8-0000-ae88-03adc7ff4cfa";  // Test Name?
                    break;

                case UserTypeEnum.OtherUserRole:
                    activeDirectoryIdentityId = "547b574e-a9e0-0000-9d80-2c2feb1d92ee";  // Test Name
                    break;

                default:
                    activeDirectoryIdentityId = "0f570bfb-1ed8-0000-ae88-03adc7ff4cfa";  // Default Test User?
                    break;
            }
            return LoadTestUser(activeDirectoryIdentityId);
        }

        public Task LoadTestUser(string activeDirectoryIdentityId)
        {
            if (string.IsNullOrWhiteSpace(activeDirectoryIdentityId)) throw new ArgumentNullException(nameof(activeDirectoryIdentityId));
            //var envVars = System.Environment.GetEnvironmentVariables();
            _settingsData.Environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            // create impersonation principal for dev debug only
            var claims = new List<Claim>();
            claims.Add(new Claim("oid", activeDirectoryIdentityId)); // Mike Card
            //claims.Add(new Claim("Name", "Mike Card"));
            //var identity = new ClaimsIdentity(claims, "Developer", "Name", "Role");
            var identity = new ClaimsIdentity(claims, "Basic");
            if (_httpContext.HttpContext != null)
            {
                _httpContext.HttpContext.User = new ClaimsPrincipal(identity);

                // load test user
                LoadDatabaseUser(_httpContext.HttpContext.User);
            }
            return Task.CompletedTask;
        }

    }
    }
