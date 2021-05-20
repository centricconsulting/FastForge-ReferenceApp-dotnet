
## Ensure dotnet format is installed
```
dotnet tool install -g dotnet-format
```

Before you commit, execute ```dotnet format``` to ensure your code meets all standards and formatting conventions. This same command is executed as part of the build process.

## Use Microsoft SQL Server on Linux for Docker Engine
1. install docker
2. install latest sql distro
```
docker pull mcr.microsoft.com/mssql/server:2019-latest
```
3. start sql server instance
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -p 1433:1433 --name mssql -d mcr.microsoft.com/mssql/server:2019-latest
```
4. Update connection string in your favorite way to store development secrets:
   * appsettings.Development.json
   * UserSecrets
   * Environment Variables

## Run Entire Application in Container

The goal here is to run the application and all dependent resources in containers described by a `docker-compose.yml` file.
This file isn't used in real environments, and is provided to provide something of a "canned" development environment.
The current implementation is in two parts: a Microsoft provided SQL Server container and a custom application container.

The application container is designed to use environment variables for configuration, and by default is set to listen for HTTP requests on port 5000.
By default it starts in production mode, but the supplied `docker-compose.yml` file overrides this to start the application in development mode.
The application runs by default as an unprivileged user, and the application's data files are by default read-only.

To use the `docker-compose.yml` file to run the application, `docker-compose build` will build the application, and `docker-compose up` will start it and all prerequisites.
The containers do not require special treatment, and standard `docker`/`docker-compose` commands will work as expected.
The database container is configured to store SQL Server data files in a volume so that data is persisted across containers.
