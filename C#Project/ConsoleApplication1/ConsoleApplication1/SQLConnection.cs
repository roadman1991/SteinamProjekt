using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ConsoleApplication1
{
    class SQLConnection
    {
        MySqlConnection con;


        public SQLConnection()
        {
            con = new MySqlConnection("user id=root;server=localhost;password=;database=watson_11fi1_ssg");

        }
        private void openConnection()
        {
            try
            {
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Connection Error. Could not open Connection to Database.");
                Console.WriteLine(e.Message);
            }
        }
        public void insertData(Wer_Reader w)
        {

            // int success = 0; //kein Erfolg


            openConnection();

            string appname = w.AppName;


            //("SELECT AppID FROM appname WHERE Appname ='" + appname + "';", con);


            MySqlCommand command = new MySqlCommand("SELECT COUNT(Appname) FROM appname WHERE Appname ='" + appname + "';", con);
            command.Connection = con;

            try
            {
                object count = command.ExecuteScalar();

                if (count.ToString() == "1")
                {
                    // falls hat schon
                }
                else if (count.ToString() == "0")
                {
                    command = new MySqlCommand("INSERT INTO appname(AppName) VALUES ('" + appname +"');", con);
                    command.ExecuteNonQuery();
                    long appid = command.LastInsertedId;
                   // Console.ReadLine();


                    //change these three lines to use actual database column types, lengths
                    //I'll pretend "e" is a date column just to show an example of how that might look
                    
                    command.CommandText = "Insert into report(ReportType, idAppName, UserName) Values(@repType, @idAppName, @Username)";
                    
                    
                    command.Parameters.Add("@repType", MySqlDbType.Int16).Value = w.ReportType;
                    command.Parameters.Add("@idAppName", MySqlDbType.VarChar).Value = appid;
                    command.Parameters.Add("@Username", MySqlDbType.VarChar).Value = w.UserName;


                    command.ExecuteNonQuery();







                }
                else
                {
                    // hat mehr als ein Eintrag => sollte nicht vorkommen
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                throw (e);
            }

            finally
            {
                con.Close();
            }
        }
    }
}
