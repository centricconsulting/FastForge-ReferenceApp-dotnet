using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
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
using Microsoft.FeatureManagement;
using referenceApp.Api.Telemetry;
using referenceApp.Lib.Infrastructure;
using referenceApp.Lib.Todos.Queries;
using referenceApp.Persistence;

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
                        optionsBiuilder => optionsBiuilder.MigrationsAssembly("referenceApp.Api"))
                );

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

            services.AddSingleton<ITelemetryInitializer>(new ApplicationNameTelemetryInitializer("referenceApp.Api"));
            services.Configure<ApplicationInsightsServiceOptions>(Configuration.GetSection("ApplicationInsights"));
            services.AddApplicationInsightsTelemetry();
            services.ConfigureTelemetryModule<DependencyTrackingTelemetryModule>((module, o) => { module.EnableSqlCommandTextInstrumentation = true; });
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
