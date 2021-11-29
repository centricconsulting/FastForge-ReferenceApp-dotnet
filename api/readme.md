
## Ensure dotnet format is installed
```
dotnet tool install -g dotnet-format
```

Before you commit, execute ```dotnet format``` to ensure your code meets all standards and formatting conventions. This same command is executed as part of the build process.

## Support for both Microsoft SQL Server and Cosmos DB
The reference application includes support for SQL Server and Cosmos DB Entity Framework Providers.  Instructions provide instructions for running the application under both configurations.  Running locally using Cosmos DB requires the Azure Cosmos Emulator.  The emulator currently supports both Windows and MacOS (Intel only) environments.  

## To Use Microsoft SQL Server on Linux for Docker Engine
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

## Run Entire Application in Containers (SQL Server Only)

The goal here is to run the application and all dependent resources in containers described by a `docker-compose.yml` file.
This file isn't used in real environments, and is provided to provide something of a "canned" development environment.
The current implementation is in two parts: a Microsoft provided SQL Server container and a custom application container.

The application container is designed to use environment variables for configuration, and by default is set to listen for HTTP requests on port 5000.
By default it starts in production mode, but the supplied `docker-compose.yml` file overrides this to start the application in development mode.
The application runs by default as an unprivileged user, and the application's data files are by default read-only.

To use the `docker-compose.yml` file to run the application, `docker-compose build` will build the application, and `docker-compose up` will start it and all prerequisites.
The containers do not require special treatment, and standard `docker`/`docker-compose` commands will work as expected.
The database container is configured to store SQL Server data files in a volume so that data is persisted across containers.

## To Use Cosmos DB on Windows
1. Download and install the [Azure Cosmos DB Emulator](https://aka.ms/cosmosdb-emulator)
2. Run the emulator for Windows or from a CMD prompt as below
```
Microsoft.Azure.Cosmos.Emulator.exe /AllowNetworkAccess /Key=C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==
```
3. The emulator defaults the URl (Endpoint) to https://localhost:8081 and the Key (AccountKey) is provided in the command line.  Update the Cosmos configuration ("Endpoint","AccountKey", & "DatabaseName") in your favorite way to store development secrets:
   * appsettings.Development.json
   * UserSecrets
   * Environment Variables

## To Use Cosmos DB on Windows for Docker Engine
1. install docker
2. install latest latest Azure Cosmsos DB Emulator for Windows
```
docker pull mcr.microsoft.com/cosmosdb/windows/azure-cosmos-emulator
```
3. start the emulator
```
md %LOCALAPPDATA%\CosmosDBEmulator\bind-mount

docker run --name azure-cosmosdb-emulator --memory 2GB --mount "type=bind,source=%LOCALAPPDATA%\CosmosDBEmulator\bind-mount,destination=C:\CosmosDB.Emulator\bind-mount" --interactive --tty -p 8081:8081 -p 8900:8900 -p 8901:8901 -p 8902:8902 -p 10250:10250 -p 10251:10251 -p 10252:10252 -p 10253:10253 -p 10254:10254 -p 10255:10255 -p 10256:10256 -p 10350:10350 mcr.microsoft.com/cosmosdb/windows/azure-cosmos-emulator
```
4. Import the TLS/SSL Certificate.  NOTE:  you will need to execute step 4 each time you start the stop the emulator
```
cd  %LOCALAPPDATA%\CosmosDBEmulator\bind-mount
powershell .\importcert.ps1
```
5. The emulator defaults the URl (Endpoint) to "https://localhost:8081" and the Key (AccountKey) to "C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==".  The Application will create a Container and Database automatically from the Database name (DatabaseName) provided from configuration. Update the Cosmos configuration ("Endpoint","AccountKey", & "DatabaseName") in your favorite way to store development secrets:
   * appsettings.Development.json
   * UserSecrets
   * Environment Variables

## To Use Cosmos DB on MacOS for Docker Engine
1. install docker
2. install latest latest Azure Cosmsos DB Emulator for linux
```
docker pull mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator
```
3. start the emulator
```
ipaddr="`ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n 1`"
docker run -p 8081:8081 -p 10251:10251 -p 10252:10252 -p 10253:10253 -p 10254:10254  -m 3g --cpus=2.0 --name=test-linux-emulator -e AZURE_COSMOS_EMULATOR_PARTITION_COUNT=10 -e AZURE_COSMOS_EMULATOR_ENABLE_DATA_PERSISTENCE=true -e AZURE_COSMOS_EMULATOR_IP_ADDRESS_OVERRIDE=$ipaddr -it mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator
```
4. import the TLS/SSL certificate
```
ipaddr="`ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n 1`"
curl -k https://$ipaddr:8081/_explorer/emulator.pem > emulatorcert.crt
```
5. Using Finder, locate the emulatorcert.crt file and double click to import and trust the certificate via Keychain Access.  NOTE:  you will need to execute steps 4 & 5 each time you start the stop the emulator

6. The emulator defaults the URl (Endpoint) to "https://localhost:8081" and the Key (AccountKey) to "C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==".  The Application will create a Container and Database automatically from the Database name (DatabaseName) provided from configuration. Update the Cosmos configuration ("Endpoint","AccountKey", & "DatabaseName") in your favorite way to store development secrets:
   * appsettings.Development.json
   * UserSecrets
   * Environment Variables