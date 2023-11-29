# Use the official Microsoft .NET Core runtime image for Alpine Linux as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 8080

# Use the official Microsoft .NET Core SDK image for Alpine Linux for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build-env
WORKDIR /app
COPY WeatherAPI/*.csproj ./
## Install dependencies
RUN dotnet restore
## Copy the remaining source files to the working directory and build the application
COPY WeatherAPI/. ./
RUN dotnet build "WeatherAPI.csproj" -c Release -o /app/build
## Publish the application
FROM build-env AS publish
RUN dotnet publish "WeatherAPI.csproj" -c Release -o /app/publish


# Build the final runtime image
FROM base AS final
WORKDIR /app
# Copy the published application to the final image
COPY --from=publish /app/publish .
# Set the entry point for the application
ENTRYPOINT ["dotnet", "WeatherAPI.dll"]