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
            wer.WerPath = @"C:\Users\f.schwarzer\Desktop\SteinamProjekt-master\SteinamProjekt\Guenther\AppCrash_AD2F1837.HPPrint_5f3be62d972dbae282e3eb41d381fa33e129b39f_9a4a8176_18f7b9a3\Report.wer";
            wer.ReadWer(wer.WerPath); 
            Console.ReadLine();
        }
    }
}
