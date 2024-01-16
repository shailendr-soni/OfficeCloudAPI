FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["OfficeCloudAPI.csproj", "./"]
RUN dotnet restore "OfficeCloudAPI.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "OfficeCloudAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OfficeCloudAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OfficeCloudAPI.dll"]
