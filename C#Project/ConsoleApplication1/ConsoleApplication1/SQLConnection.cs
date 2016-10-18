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

        private void openConnection()
        {
            try
            {
                using (con = new MySqlConnection("user id=root;server=localhost;password=;database=watson_11fi1_ssg"))
                {
                    /*con.ConnectionString = "Data Source=(local);" +
                                           "Initial Catalog=watson_11fi1_ssg;" +
                                           "User ID=root;" +
                                           "Integrated Security=false";*/
                    con.Open();
                    if (con.State == ConnectionState.Closed)
                    {
                        Console.WriteLine("Closed");
                        con.Close();
                    }
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

        // openConnection();

            

            string appname = w.AppName;

            MySqlCommand command = new MySqlCommand("SELECT COUNT(Appname) FROM appname WHERE Appname ='"+appname+"'", con);
            command.Connection = con;
            object count = command.ExecuteScalar();

            if (count.ToString() == "1")
            {

            }

           // MySqlDataReader readCom = command.ExecuteReader();



            con.Close();

            //bist du schon in tabelle appname

        }




    }
}
