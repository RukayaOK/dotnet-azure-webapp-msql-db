using System.Data.SqlClient;

namespace SQLServerTestApp;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly IConfigurationRoot _config;

    public Worker(ILogger<Worker> logger, IConfigurationRoot config)
    {
        _logger = logger;
        _config = config;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var Server = _config["SqlServer:Server"];
        var Database = _config["SqlServer:Database"];
        var User = _config["TF_VAR_administrator_login"];
        var Password = _config["TF_VAR_administrator_login_password"];


        string connString = @"Server=" + Server +
            ";Database=" + Database +
            ";User ID=" + User + "; Password=" +
            Password;

        while (!stoppingToken.IsCancellationRequested)
        {
            _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    //access SQL Server and run your command
                    Console.WriteLine("Connected");

                    Console.WriteLine("Server is: {0}", Server);
                    Console.WriteLine("Database is: {0}", Database);
                    Console.WriteLine("User is: {0}", User);

                    //retrieve the SQL Server instance version
                    string query = @"SELECT @@VERSION";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    //open connection
                    conn.Open();

                    //execute the SQLCommand
                    SqlDataReader dr = cmd.ExecuteReader();

                    //check if there are records
                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            //display retrieved record (first column only/string value)
                            Console.WriteLine(dr.GetString(0));
                        }
                    }
                    else
                    {
                        Console.WriteLine("No data found.");
                    }
                    dr.Close();
                }
            }
            catch (Exception ex)
            {
                //display error message
                Console.WriteLine("Exception: " + ex.Message);
            }
            await Task.Delay(6000, stoppingToken);
        }
    }
}

