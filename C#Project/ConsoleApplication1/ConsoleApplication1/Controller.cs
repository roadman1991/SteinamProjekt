using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.IO;
using System.Configuration;

namespace ConsoleApplication1
{
    public class Controller
    {

        public string UserFolderPath { get; set; }
        public string[] werList;
        public Dictionary<String, Wer_Reader> dict;



        public Controller()
        {
            UserFolderPath = ConfigurationManager.AppSettings["UserPath"];
            werList = Directory.GetFiles(UserFolderPath, "*", SearchOption.AllDirectories);
            string Object = "Object";
            int i = 1;
            dict = new Dictionary<String, Wer_Reader>();
            foreach (string s in werList)
            {

                Wer_Reader wer = new Wer_Reader();
                wer.WerPath = s;
                wer.ReadWer(s);
                wer.AppPath = wer.ReadKeys("AppPath");
                wer.AppName = wer.ReadKeys("AppName");
                wer.ReportType = int.Parse(wer.ReadKeys("ReportType"));
                wer.FileDate = wer.GetFileCreationDate(s);
                wer.UserName = wer.ReadUserName(wer.WerPath);
                wer.Mac = wer.ReadMac();
                dict.Add(Object + i, wer);
                i++;
            }
        }

        public string[] CreateWerFileList()
        {
            return Directory.GetFiles(UserFolderPath, "*", SearchOption.AllDirectories);
        }
    }
}
