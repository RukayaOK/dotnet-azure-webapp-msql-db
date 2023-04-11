#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
# non-root user details 
ARG APP_USERNAME=appuser
ARG USER_UID=999
ARG USER_GID=$USER_UID

# add dependencies 
RUN groupadd --gid $USER_GID $APP_USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $APP_USERNAME

USER $APP_USERNAME

WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["SQLServerTestApp.csproj", "."]
RUN dotnet restore "./SQLServerTestApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "SQLServerTestApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SQLServerTestApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SQLServerTestApp.dll"]
