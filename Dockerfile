FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

# Create app directory in container
RUN mkdir -p /app/

WORKDIR /app

# Copy everything
COPY . ./

# Restore as distinct layers
RUN dotnet restore

# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0

WORKDIR /app

COPY --from=build-env /app/out .

ENTRYPOINT ["dotnet", "MyWebApp.dll"]
