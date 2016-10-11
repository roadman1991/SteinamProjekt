using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Wer_Reader
    {
        private DateTime _fileDate;

        public DateTime FileDate
        {
            get { return _fileDate; }
            set { _fileDate = value; }
        }

        private int _reportType;

        public int ReportType
        {
            get { return _reportType; }
            set { _reportType = value; }
        }

        private string _appName;

        public string AppName
        {
            get { return _appName; }
            set { _appName = value; }
        }

        private string _appPath;

        public string AppPath
        {
            get { return _appPath; }
            set { _appPath = value; }
        }

        private string _mac;

        public string Mac
        {
            get { return _mac; }
            set { _mac = value; }
        }

        private string _userName;

        public string UserName
        {
            get { return _userName; }
            set { _userName = value; }
        }

        private int _reportId;

        public int ReportId
        {
            get { return _reportId; }
            set { _reportId = value; }
        }

        private string _werPath;

        public string WerPath
        {
            get { return _werPath; }
            set { _werPath = value; }
        }




        public Wer_Reader()
        {
            try
            {
                // Open the WerFile using stream reader.
                using (StreamReader sr = new StreamReader(WerPath))
                {
                    String line = sr.ReadToEnd();
                    Console.WriteLine(line);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("The file could not be read:");
                Console.WriteLine(e.Message);
            }

        }

        public void ReadWer()
        {
        }

        public void ReadUserName()
        {
        }

        public void ReadMac()
        {
        }

    }
}
