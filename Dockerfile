# Use the official .NET runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# Use the official .NET SDK to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG VERSION=0.0.0-dev
WORKDIR /src
COPY Server2/Server2.csproj Server2/
COPY README.md LICENSE ./
RUN dotnet restore Server2/Server2.csproj
COPY Server2/. Server2/
WORKDIR /src/Server2
RUN dotnet publish -c Release -o /app/publish --no-restore -p:Version=$VERSION

# Final image
FROM base AS final
WORKDIR /app
ARG VERSION=0.0.0-dev
ARG SOURCE_REPO="https://github.com/unknown/unknown"
LABEL org.opencontainers.image.version=$VERSION \
	org.opencontainers.image.source=$SOURCE_REPO \
	org.opencontainers.image.title="Server2" \
	org.opencontainers.image.description="Server2 Godot server image" \
	org.opencontainers.image.licenses="MIT"
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Server2.dll"]
