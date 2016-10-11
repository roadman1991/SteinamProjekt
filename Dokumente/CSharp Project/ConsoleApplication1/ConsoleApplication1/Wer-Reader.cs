using System;
using System.Collections.Generic;
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
        
        
        
        

        public Wer_Reader() {
        }

        public void ReadWer() { 
        }

        public void ReadUserName() { 
        }

        public void ReadMac() { 
        }
       
    }
}
