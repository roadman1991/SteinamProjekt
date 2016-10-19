using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            Controller c = new Controller();

            SQLConnection connect = new SQLConnection();


            foreach (KeyValuePair<string, Wer_Reader> entry in c.dict)
            {
                //// dict durchlaufen, daten rausziehen, mysql-statements erstellen...
                // do something with entry.Value or entry.Key
                connect.insertData(Wer_Reader);
            }
        }
    }
}
