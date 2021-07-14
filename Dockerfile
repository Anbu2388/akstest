FROM mcr.microsoft.com/dotnet/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src
COPY ["TestWebApp.csproj", "./"]
RUN dotnet restore "TestWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TestWebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestWebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestWebApp.dll"]
