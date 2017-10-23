using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using System.Configuration;
using System.Diagnostics;
using System.Reflection;

namespace Cuurency_Service
{
    class Library
    {
         public static void WriteErrorLog(Exception ex)
        {
            StreamWriter sw = null;
            try
            {
                sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\Log.txt", true);
                sw.WriteLine(DateTime.Now.ToString() + ":" + ex.Source.ToString().Trim() + ":" + ex.Message.ToString().Trim());
                sw.Flush();
                sw.Close();
                System.Threading.Thread thread = new System.Threading.Thread(new System.Threading.ThreadStart(service));
                thread.Start();
            
            }
            catch
            {

            }
        }

        public static void WriteErrorLog(String p)
        {
            StreamWriter sw = null;
            try
            {
                sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\Log.txt", true);
                sw.WriteLine(DateTime.Now.ToString() + ":" + p);
                sw.Flush();
                sw.Close();
            }
            catch
            {

            }
        }

        public Uri Cuurency_Service { get; set; }

        public static void service()
        {
            try   
	      {
            string codeBase = Assembly.GetExecutingAssembly().CodeBase;
            UriBuilder uri = new UriBuilder(codeBase);
            string path = Uri.UnescapeDataString(uri.Path);
            

            StackFrame stackFrame = new StackFrame();
            MethodBase Curmethod = stackFrame.GetMethod();
            string filename = "Cuurency Service";

            System.Timers.Timer ServiceTimer = new System.Timers.Timer();
            ServiceTimer.Stop();
             string[] objProc = new string[1];
            objProc[0] = "INR";
             //objProc[1]= "GetCurrency";
             //objProc[2] = "1";
             //objProc[3] = "1";

            string currency_service = (ConfigurationManager.AppSettings["currency_service"]);
            //Cuurency_Service.ProPrc objProcData = new Cuurency_Service.ProPrc { PrcParams = objProc.ToArray() };
         
            WebClient Proxy1 = new WebClient();

            Proxy1.Headers["Content-type"] = "application/x-www-form-urlencoded";
           // System.Runtime.Serialization.Json.DataContractJsonSerializer serializerToUplaod = new System.Runtime.Serialization.Json.DataContractJsonSerializer(typeof(ProPrc));
           //MemoryStream ms = new MemoryStream();
           // serializerToUplaod.WriteObject(ms, objProcData);
            string ar = ConvertStringArrayToString(objProc);
            var byteArray = System.Text.Encoding.Unicode.GetBytes(ar);
            byte[] data = Proxy1.UploadData(currency_service,"POST",byteArray);
            ServiceTimer.Start();
          }
            catch (Exception e)
            {
                Library.WriteErrorLog("error"+e);        
            }
        }
        static string ConvertStringArrayToString(string[] array)
        {
            // Concatenate all the elements into a StringBuilder.
            StringBuilder builder = new StringBuilder();
            foreach (string value in array)
            {
                builder.Append(value);
                builder.Append('.');
            }
            return builder.ToString();
        }

    }
}
