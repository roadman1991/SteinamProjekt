using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class ParseSQLStatement
    {
        private string _sqlStatement;

        public string SqlStatement
        {
            get { return _sqlStatement; }
            set { _sqlStatement = value; }
        }
        
        public ParseSQLStatement()
        {

        }

        public void CreateSqlStatement() { 
        }

    }
}
