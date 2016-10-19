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

            MySqlCommand command = new MySqlCommand("SELECT COUNT(Appname) FROM appname WHERE Appname ='"+appname+"'", con);
            command.Connection = con;


            try
            {

                object count = command.ExecuteScalar();

                if (count.ToString() == "1")
                {

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
