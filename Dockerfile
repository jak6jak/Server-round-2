# Use the official .NET runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# Use the official .NET SDK to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY Server2/Server2.csproj Server2/
RUN dotnet restore Server2/Server2.csproj
COPY Server2/. Server2/
WORKDIR /src/Server2
RUN dotnet publish -c Release -o /app/publish --no-restore

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Server2.dll"]
