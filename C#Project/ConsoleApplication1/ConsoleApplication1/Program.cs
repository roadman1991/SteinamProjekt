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
            Wer_Reader wer = new Wer_Reader();
            wer.WerPath = @"H:\11\SteinamProjectERRFiles\Guenther\AppCrash_AD2F1837.HPPrint_7abab9a238d31ce95943fa32488e7ff1e0ef441f_8eaf7b11_0efc9e31\Report.wer";
            wer.ReadWer(wer.WerPath);
            wer.AppPath = wer.ReadKeys("AppPath");
            wer.AppName = wer.ReadKeys("AppName");
            wer.ReportType = int.Parse(wer.ReadKeys("ReportType"));
            wer.UserName = wer.ReadUserName(wer.WerPath);
            wer.Mac = wer.ReadMac();
            wer.FileDate = wer.GetFileCreationDate(wer.WerPath);
            Console.ReadLine();

            SQLConnection connect = new SQLConnection();
            connect.insertData(wer);
        }
    }
}
