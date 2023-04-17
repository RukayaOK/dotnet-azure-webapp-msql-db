using SQLServerTestApp;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var environmentName = Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT");

var configurationBuilder = new ConfigurationBuilder();

configurationBuilder.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

if (!string.IsNullOrEmpty(environmentName))
{
    configurationBuilder.AddJsonFile($"appsettings.{environmentName.ToLower()}.json", optional: true, reloadOnChange: true);
}

configurationBuilder.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
configurationBuilder.AddUserSecrets<Program>();
configurationBuilder.AddEnvironmentVariables();

IConfigurationRoot configurationRoot = configurationBuilder.Build();

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddHostedService<Worker>();
        services.AddHttpClient();
        services.AddSingleton(configurationRoot);
    })
    .ConfigureWebHostDefaults(webBuilder =>
    {
        webBuilder.UseStartup<Startup>();
    })
    .Build();

await host.RunAsync();
