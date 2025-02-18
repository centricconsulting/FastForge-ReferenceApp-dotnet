using System;
using System.Reflection;
using MediatR;
using MediatR.Pipeline;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Azure.Cosmos;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.FeatureManagement;
using referenceApp.Api.Telemetry;
using referenceApp.Azure.Models;
using referenceApp.Azure;
using referenceApp.Lib.Infrastructure;
using referenceApp.Lib.Todos.Queries;
using referenceApp.Persistence;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;
using referenceApp.Api.System;
using referenceApp.Common.Constants;
using referenceApp.Common.Models.System;
using referenceApp.PowerBi;
using referenceApp.PowerBi.Models;

namespace referenceApp.Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            _env = env;
        }

        public IConfiguration Configuration { get; }
        private readonly IWebHostEnvironment _env;

        // This method gets called by the runtime. Use this method to add services to the container.
        public virtual void ConfigureServices(IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddDefaultPolicy(builder =>
                {
                    builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
                });
            });

            services.AddControllers();

            // Add MediatR and load handlers from Lib project
            services.AddTransient(typeof(IPipelineBehavior<,>), typeof(RequestPreProcessorBehavior<,>));
            services.AddTransient(typeof(IPipelineBehavior<,>), typeof(RequestPerformanceBehavior<,>));
            services.AddTransient(typeof(IPipelineBehavior<,>), typeof(RequestValidationBehavior<,>));
            services.AddMediatR(typeof(GetTodosListQueryHandler).GetTypeInfo().Assembly);

            services.AddSwaggerDocument(document =>
            {
                document.DocumentName = "latest";
                document.Title = "ReferenceApp API";
                document.Description = "API routes for interacting with ReferenceApp services.";
            });

            services.AddFeatureManagement();

            var connectionString = Configuration.GetConnectionString("ReferenceAppConnectionString");
            if (!string.IsNullOrEmpty(connectionString))
                // FOR DEMONSTRATION PURPOSES
                services.AddDbContext<ReferenceDbContext>(
                    options => options.UseSqlServer(
                        connectionString,
                        optionsBiuilder => optionsBiuilder.MigrationsAssembly("referenceApp.Api")),
                        ServiceLifetime.Transient);

            var endpoint = Configuration["Cosmos:Endpoint"];
            if (!string.IsNullOrEmpty(endpoint))
                // FOR DEMONSTRATION PURPOSES
                services.AddDbContext<ReferenceDbContext>(
                    options => options.UseCosmos(
                        Configuration["Cosmos:Endpoint"],
                        Configuration["Cosmos:AccountKey"],
                        Configuration["Cosmos:DatabaseName"]
                    )
                );

            // Azure ApplicationInsights logging
            services.AddSingleton<ITelemetryInitializer>(new ApplicationNameTelemetryInitializer("referenceApp.Api"));
            services.Configure<ApplicationInsightsServiceOptions>(Configuration.GetSection("ApplicationInsights"));
            services.AddApplicationInsightsTelemetry();
            services.ConfigureTelemetryModule<DependencyTrackingTelemetryModule>((module, o) => { module.EnableSqlCommandTextInstrumentation = true; });

            // System and Security (user profile)
            ISettingsData settings = new SettingsData();
            settings.ContentRootPath = _env.ContentRootPath;
            services.AddTransient<ISystemDataService>(x => new SystemDataService(x.GetRequiredService<ReferenceDbContext>()));
            services.AddTransient<IUserSecurityService>(x => new UserSecurityService( x.GetRequiredService<IMediator>(), x.GetRequiredService<IHttpContextAccessor>(), settings));

            // ToDo STARTUP Power BI: Remove these lines, PowerBi library, appsettings config sections, and corresponding data service if not embedding Power BI or Paginated reports into the solution.
            services.Configure<PowerBIConfigModel>(Configuration.GetSection(ConfigurationSettingConstants.PowerBiConfigSectionName))
                .Configure<ActiveDirectoryConfigModel>(Configuration.GetSection(ConfigurationSettingConstants.PowerBiActiveDirectoryConfigSectionName));
            services.AddSingleton<IActiveDirectoryService>(x => new ActiveDirectoryService(x.GetRequiredService<IOptions<ActiveDirectoryConfigModel>>()));
            services.AddSingleton<IPowerBiEmbedService>(x => new PowerBiEmbedService(x.GetRequiredService<IActiveDirectoryService>(), x.GetRequiredService<IOptions<PowerBIConfigModel>>()));
            services.AddTransient<IReportDataService>(x => new ReportDataService(x.GetRequiredService<ReferenceDbContext>()));

            // ToDo STARTUP Azure AD Auth: Remove these lines and corresponding appsettings config section if not using Azure Entra ID or Azure B2C for authentication. 
            //services.AddMicrosoftIdentityWebApiAuthentication(Configuration, "AzureAd");
            // The above line is the short form of doing this. Ben: 1st try
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddMicrosoftIdentityWebApi(Configuration, subscribeToJwtBearerMiddlewareDiagnosticsEvents: true);
            services.Configure<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme, options =>
            {
                options.Events = new JwtBearerEvents()
                {
                    OnTokenValidated = async (context) =>
                    {
                        var service = context.HttpContext.RequestServices.GetService<IUserSecurityService>();
                        if (service != null)
                        {
                            if (context.Principal != null)
                            {
                                await service.LoadDatabaseUser(context.Principal);
                            }
                        }
                    }
                };
            });

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public virtual void Configure(IApplicationBuilder app)
        {

            if (_env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            app.UseOpenApi();
            app.UseSwaggerUi();
        }
    }
}
