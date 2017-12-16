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
using Microsoft.SqlServer.Server;
using System.Data.SqlClient;
using System.Data;


namespace WindowsService1
{
    class Library
    {
         public static void WriteErrorLog(Exception ex)
        {
            StreamWriter sw = null;
            try
            {
                sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\Log1.txt", true);
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
                sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\Log1.txt", true);
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
                //string filename = "Cuurency Service";

                System.Timers.Timer ServiceTimer = new System.Timers.Timer();
                ServiceTimer.Stop();
                // string objProc = "INR";
                //string currency_service = "";
                //Cuurency_Service.ProPrc objProcData = new Cuurency_Service.ProPrc { PrcParams = objProc.ToArray() };

                WebClient Proxy1 = new WebClient();

                Proxy1.Headers["Content-type"] = "application/x-www-form-urlencoded";
                 //System.Runtime.Serialization.Json.DataContractJsonSerializer serializerToUplaod = new System.Runtime.Serialization.Json.DataContractJsonSerializer(typeof(ProPrc));
                //MemoryStream ms = new MemoryStream();
                 //serializerToUplaod.WriteObject(ms, objProc) ;
                //var byteArray = System.Text.Encoding.Unicode.GetBytes();
                 //byte[] data = Proxy1.UploadData(currency_service, "POST", ms );
                //Proxy1.OpenWrite(currency_service, "POST");
                //postStream.Write(postArray, 0, postArray.Length);

                //   postStream.Close();
                //byte[] postArray = Encoding.ASCII.GetBytes(objProc);

                //Stream postStream = Proxy1.OpenWrite(currency_service, "POST");
          
                
               //postStream.Write(postArray, 0, postArray.Length);

                // Close the stream and release resources.
                //postStream.Close();


                //ServiceTimer.Start();

              //  WebRequest request = WebRequest.Create("http://www.ibaspro.com.org/fnGetCurrency");
              //request.Method = "POST";
              //  string postData = "INR";
              // byte[] byteArray = Encoding.UTF8.GetBytes(postData);
              // request.ContentType = "application/x-www-form-urlencoded";
              //  request.ContentLength = byteArray.Length;


              //  ////Here is the Business end of the code...
              //  Stream dataStream = request.GetRequestStream();
              //  dataStream.Write(byteArray, 0, byteArray.Length);
              //  dataStream.Close();
                //and here is the response.
                //WebResponse response = request.GetResponse();

                //Console.WriteLine(((HttpWebResponse)response).StatusDescription);
                //dataStream = response.GetResponseStream();
                //StreamReader reader = new StreamReader(dataStream);
                //string responseFromServer = reader.ReadToEnd();
                //Console.WriteLine(responseFromServer);
                //reader.Close();
                //dataStream.Close();
                //response.Close();
                //Library.WriteErrorLog(postData);
                
                       Library.WriteErrorLog("getting data");

                string json, j,dk,sgd,eur,myr,pln,gbp,rub,thb;
              
                using (var web = new WebClient())
                {
                    var url = "http://api.fixer.io/latest?base=INR";
                    var url1 = "http://api.fixer.io/latest?base=USD";
                    var dkk = "http://api.fixer.io/latest?base=DKK";
                    var sgds = "http://api.fixer.io/latest?base=SGD";
                    var eurs = "http://api.fixer.io/latest?base=EUR";
                    var myrs = "http://api.fixer.io/latest?base=MYR";
                    var plns = "http://api.fixer.io/latest?base=PLN";
                    var gbps = "http://api.fixer.io/latest?base=GBP";
                    var rubs = "http://api.fixer.io/latest?base=RUB";
                    var thbs = "http://api.fixer.io/latest?base=THB";
                    //var test = "http://localhost:57096/api/Currency";
                    
                    json = web.DownloadString(url);
                    j = web.DownloadString(url1);
                    dk = web.DownloadString(dkk);
                    sgd = web.DownloadString(sgds);
                    eur = web.DownloadString(eurs);
                    myr = web.DownloadString(myrs);
                    pln = web.DownloadString(plns);
                    gbp = web.DownloadString(gbps);
                    rub = web.DownloadString(rubs);
                    thb = web.DownloadString(thbs);
                    //dk = web.DownloadString(dkk);
                   

                }
                Library.WriteErrorLog("data:"+json);
                try
                {
                    string constring = (ConfigurationManager.AppSettings["constr"]); 
                    SqlConnection con = new SqlConnection(constring);
                    SqlCommand cmd = new SqlCommand("GetCurrency", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@json", json.ToString());
                    cmd.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed"+json);
                    SqlCommand cmd1 = new SqlCommand("GetCurrency", con);
                    cmd1.CommandType = CommandType.StoredProcedure;
                    cmd1.Parameters.AddWithValue("@json", j.ToString());
                    cmd1.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd1.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + j);
                    SqlCommand cmd2 = new SqlCommand("GetCurrency", con);
                    cmd2.CommandType = CommandType.StoredProcedure;
                    cmd2.Parameters.AddWithValue("@json", dk.ToString());
                    cmd2.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd2.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + dk);
                    SqlCommand cmd3 = new SqlCommand("GetCurrency", con);
                    cmd3.CommandType = CommandType.StoredProcedure;
                    cmd3.Parameters.AddWithValue("@json", sgd.ToString());
                    cmd3.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd3.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + sgd);
                    SqlCommand cmd4 = new SqlCommand("GetCurrency", con);
                    cmd4.CommandType = CommandType.StoredProcedure;
                    cmd4.Parameters.AddWithValue("@json", eur.ToString());
                    cmd4.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd4.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + eur);
                    SqlCommand cmd5 = new SqlCommand("GetCurrency", con);
                    cmd5.CommandType = CommandType.StoredProcedure;
                    cmd5.Parameters.AddWithValue("@json", myr.ToString());
                    cmd5.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd5.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + myr);
                    SqlCommand cmd6 = new SqlCommand("GetCurrency", con);
                    cmd6.CommandType = CommandType.StoredProcedure;
                    cmd6.Parameters.AddWithValue("@json", pln.ToString());
                    cmd6.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd6.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + pln);
                    SqlCommand cmd7 = new SqlCommand("GetCurrency", con);
                    cmd7.CommandType = CommandType.StoredProcedure;
                    cmd7.Parameters.AddWithValue("@json", rub.ToString());
                    cmd7.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd7.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + rub);
                    SqlCommand cmd8 = new SqlCommand("GetCurrency", con);
                    cmd8.CommandType = CommandType.StoredProcedure;
                    cmd8.Parameters.AddWithValue("@json", thb.ToString());
                    cmd8.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd8.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + thb);
                    SqlCommand cmd9 = new SqlCommand("GetCurrency", con);
                    cmd9.CommandType = CommandType.StoredProcedure;
                    cmd9.Parameters.AddWithValue("@json", gbp.ToString());
                    cmd9.Parameters.AddWithValue("@date", "");
                    con.Open();
                    cmd9.ExecuteNonQuery();
                    con.Close();
                    Library.WriteErrorLog("parsed" + gbp);
                }
                catch (Exception ex)
                {
                    Library.WriteErrorLog("Error:"+ex.ToString());
                }
                
                
                ServiceTimer.Start();

            }
            catch (Exception e)
            {
                Library.WriteErrorLog("error" + e);
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
