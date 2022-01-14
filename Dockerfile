FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["Net6WeatherApi.csproj", "./"]
RUN dotnet restore "Net6WeatherApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Net6WeatherApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Net6WeatherApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Net6WeatherApi.dll"]
