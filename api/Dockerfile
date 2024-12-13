FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

#COPY *.sln ./
COPY src/referenceApp.Api/*.csproj src/referenceApp.Api/
COPY src/referenceApp.Lib/*.csproj src/referenceApp.Lib/
COPY src/referenceApp.Persistence/*.csproj src/referenceApp.Persistence/
#COPY tests/referenceApp.Lib.Tests/*.csproj ./tests/referenceApp.Lib.Tests/

RUN dotnet restore src/referenceApp.Api/referenceApp.Api.csproj

COPY src/referenceApp.Api/ src/referenceApp.Api/
COPY src/referenceApp.Lib/ src/referenceApp.Lib/
COPY src/referenceApp.Persistence/ src/referenceApp.Persistence/

WORKDIR /app/src/referenceApp.Api
RUN dotnet build -c release --no-restore

FROM build as publish
RUN dotnet publish "./referenceApp.Api.csproj" -c Release -o "./out/" --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

RUN useradd -M -s /bin/true -u 1000 dotnet

WORKDIR /app

COPY --from=publish /app/src/referenceApp.Api/out ./

# Make the filesystem read-only to the application.
# Directories that the app needs read-write rights should be added explicitly
# Rationale: (1) It discourages people from storing data in ephemeral containers and
# (2) Limits the damage a compromise to the application can precipitate
USER 1000:1000
ENV ASPNETCORE_URLS="http://*:5000"
ENTRYPOINT ["dotnet", "referenceApp.Api.dll"]
EXPOSE 5000/tcp
