using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;

namespace referenceApp.Api.Telemetry
{
    public class ApplicationNameTelemetryInitializer : ITelemetryInitializer
    {
        private readonly string roleName;

        public ApplicationNameTelemetryInitializer(string roleName)
        {
            this.roleName = roleName;
        }

        public void Initialize(ITelemetry telemetry)
        {

            telemetry.Context.Cloud.RoleName = roleName;
        }
    }
}
