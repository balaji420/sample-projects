using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PdfFileWriter;
using System.Drawing;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Text;

namespace ReportGeneration
{
    public class pdftcprint
    {
        public PdfDocument pdoc, pdoc1;
        public PdfContents pcon1, pcon2, pcon3, pcon4, pc1, pc2, pc3, pc4;
        public PdfPage page1, page2, page3, page4, p1, p2, p3, p4;
        public PdfFont Times;
        public String FontName1 = "Arial";
        public String FontName2 = "Times New Roman";
        public String FontName3 = "Calibri";
        public double tr, rh, tb, tt;
        public double cgpa = 0;
        public String Result = "PASS";

        string constring = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        public string Tcprint
        (
              Boolean Debug, String ActionParam, String stupk
        )
        {
            SqlConnection con = new SqlConnection(constring);

            String filenm1 = System.Guid.NewGuid() + "Lastpage.pdf";
            String FileName1 = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + filenm1;
            string path = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + "CCE_Logo.jpg";
            string path1 = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + "PSES_Logo.jpg";
            string Dupcpath = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + "PSES_Dup.jpg";

            pdoc = new PdfDocument(PaperType.Legal, false, UnitOfMeasure.cm, FileName1);
            PdfFont ArialNormal = new PdfFont(pdoc, FontName1, FontStyle.Regular, false);
            PdfFont Calibri = new PdfFont(pdoc, FontName3, FontStyle.Regular, false);
            PdfFont Calibribold = new PdfFont(pdoc, FontName3, FontStyle.Bold, false);
            PdfFont ArialBold = new PdfFont(pdoc, FontName1, FontStyle.Bold, false);
            PdfFont ArialItalic = new PdfFont(pdoc, FontName1, FontStyle.Italic, false);
            PdfFont ArialBoldItalic = new PdfFont(pdoc, FontName1, FontStyle.Bold | FontStyle.Italic, true);
            PdfFont TimesNormal = new PdfFont(pdoc, FontName2, FontStyle.Regular, true);
            PdfFont TimesBold = new PdfFont(pdoc, FontName2, FontStyle.Bold, true);
            PdfFont Comic = new PdfFont(pdoc, "Comic Sans MS", FontStyle.Bold, true);

            string s = stupk;
            string[] words = s.Split('*');
            for (int i = 0; (i < words.Length && words[i].Trim() != ""); i++)
            {

                SqlCommand cmd = new SqlCommand("PrcSch_TcListing", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "StudTc");
                cmd.Parameters.AddWithValue("@Param1", words[i]);

                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet dstc = new DataSet();
                da.Fill(dstc);
                con.Close();

                page1 = new PdfPage(pdoc);
                pcon1 = new PdfContents(page1);
                pcon1.SetLineWidth(0.02);
                Double PosX = 1.5;
                Double PosY = 31.5;

                PdfImage Image1 = new PdfImage(pdoc, path1, 96.0);
                pcon1.DrawImage(Image1, PosX, PosY, 2.5, 2);

                //if (dstc.Tables[1].Rows[0]["dupcpy"].ToString() == "1")
                //{
                //    PdfImage Image2 = new PdfImage(pdoc, Dupcpath, 96.0);
                //    pcon1.DrawImage(Image2, 2.5, 3, 5, 2.5);
                //}

                const double left = 1.5;
                const double bottom = 3;
                const double top = 34;      //28;
                const double right = 20;    //19.5;
                double tr, rh, tt;

                PdfTable table2 = new PdfTable(page1, pcon1, ArialNormal, 11);
                table2.TableArea = new PdfRectangle(left, bottom, right, top);
                table2.SetColumnWidth(18);
                table2.BorderLineWidth = 0;
                table2.GridLineControl = 0;
                table2.BorderLineControl = BorderControl.None;
                table2.MinRowHeight = 0.5;
                table2.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                table2.Cell[0].Style.Font = ArialBold;
                table2.Cell[0].Style.FontSize = 14;
                table2.Cell[0].Value = dstc.Tables[0].Rows[0]["locnm"].ToString();   //"P S SENIOR SECONDARY SCHOOL";
                table2.DrawRow();
                table2.Cell[0].Style.Font = ArialNormal;
                table2.Cell[0].Style.FontSize = 11;
                table2.Cell[0].Value = dstc.Tables[0].Rows[0]["hdr1"].ToString();   //"(Affiliated to the Central board of Secondary Education, NewDelhi)";
                table2.DrawRow();
                table2.Cell[0].Value = dstc.Tables[0].Rows[0]["hdr2"].ToString();   //"CBSE Affiliation No 1930032 School Code 06915";
                table2.DrawRow();
                table2.Cell[0].Value = dstc.Tables[0].Rows[0]["hdr3"].ToString();   // "(Management : P.S.Charities/P.S.Educational Society)";
                table2.DrawRow();
                table2.Cell[0].Value = dstc.Tables[0].Rows[0]["locaddress"].ToString();   // "33, Alarmelmangapuram, Mylapore, Chennai-4";
                table2.DrawRow();
                table2.DrawRow();

                table2.Cell[0].Style.Font = ArialBold;
                table2.Cell[0].Style.FontSize = 11;
                table2.Cell[0].Value = "TRANSFER CERTIFICATE";
                table2.DrawRow();
                table2.DrawRow();
                rh = table2.RowHeight;
                tr = table2.RowNumber;
                tb = bottom - (rh * tr);
                tt = top - (rh * tr);
                table2.Close();

                PdfTable table4 = new PdfTable(page1, pcon1, ArialNormal, 10);
                table4.TableArea = new PdfRectangle(left, tb, right, tt);
                table4.SetColumnWidth(9, 6, 4);
                table4.BorderLineControl = BorderControl.None;
                table4.GridLineControl = 0;
                table4.MinRowHeight = 0.8;

                TextBox bt1 = table4.Cell[0].CreateTextBox();
                table4.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                bt1.AddText(ArialNormal, 10, "Sl. No. : " + dstc.Tables[0].Rows[0]["slno"].ToString());
                table4.Cell[1].Value = "";
                TextBox bt2 = table4.Cell[2].CreateTextBox();
                table4.Cell[2].Style.Alignment = ContentAlignment.MiddleRight;
                bt2.AddText(ArialNormal, 10, "Admission No. : " + dstc.Tables[0].Rows[0]["admno"].ToString());

                table4.DrawRow();
                tr = table4.RowNumber;
                rh = table4.RowHeight;
                tb = tb - (tr * rh);
                tt = tt - (tr * rh);
                table4.Close();

                PdfTable table3 = new PdfTable(page1, pcon1, ArialNormal, 10);
                table3.TableArea = new PdfRectangle(left, tb, right, tt);
                table3.SetColumnWidth(10, 8);
                table3.BorderLineWidth = 0;
                table3.BorderLineControl = BorderControl.Both;

                if (dstc.Tables[0].Rows[0]["Class"].ToString() == "PRE KG" || dstc.Tables[0].Rows[0]["Class"].ToString() == "LKG" || dstc.Tables[0].Rows[0]["Class"].ToString() == "UKG")
                    table3.MinRowHeight = 1.2;
                else
                    table3.MinRowHeight = 0.8;

                table3.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                table3.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;

                for (int j = 0; j < dstc.Tables[1].Rows.Count; j++)
                {
                    TextBox tbx1 = table3.Cell[0].CreateTextBox();
                    tbx1.AddText(ArialNormal, 10, dstc.Tables[1].Rows[j]["Stuhdr"].ToString());

                    TextBox tbx2 = table3.Cell[1].CreateTextBox();
                    tbx2.AddText(ArialNormal, 10, dstc.Tables[1].Rows[j]["studet"].ToString());
                    table3.DrawRow();
                }
                if (dstc.Tables[0].Rows[0]["Class"].ToString() == "PRE KG" || dstc.Tables[0].Rows[0]["Class"].ToString() == "LKG" || dstc.Tables[0].Rows[0]["Class"].ToString() == "UKG")
                {
                    tr = table3.RowNumber + 4;
                    rh = table3.RowHeight;
                    tb = tb - (tr * rh);
                    tt = tt - (tr * rh);
                    table3.Close();

                    PdfTable table5 = new PdfTable(page1, pcon1, ArialNormal, 10);
                    table5.TableArea = new PdfRectangle(left, tb, right, tt);
                    table5.SetColumnWidth(6.5, 8.5, 5);
                    table5.BorderLineControl = BorderControl.None;
                    table5.GridLineControl = 0;
                    table5.MinRowHeight = 0.4;
                    table5.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                    table5.Cell[0].Value = "Signature of";
                    table5.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                    table5.Cell[1].Value = "";
                    table5.Cell[2].Style.Alignment = ContentAlignment.MiddleLeft;
                    table5.Cell[2].Value = "Principal";
                    table5.DrawRow();
                    table5.Cell[0].Value = "Class Teacher";
                    table5.Cell[1].Value = "";
                    table5.Cell[2].Value = "SEAL";
                    table5.DrawRow();
                    tr = table5.RowNumber;
                    rh = table5.RowHeight;
                    tb = tb - (tr * rh);
                    tt = tt - (tr * rh);
                    table5.Close();
                }
                else
                {
                    tr = table3.RowNumber;
                    rh = table3.RowHeight;
                    tb = tb - (tr * rh);
                    tt = tt - (tr * rh) - 0.3;
                    table3.Close();

                    double linetop = tt;
                    PdfTable table6 = new PdfTable(page1, pcon1, ArialNormal, 10);
                    table6.TableArea = new PdfRectangle(left, tb, right, tt);
                    table6.SetColumnWidth(10, 8);
                    table6.BorderLineWidth = 0;
                    table6.GridLineControl = 0;
                    table6.BorderLineControl = BorderControl.Vertical;

                    if (dstc.Tables[2].Rows.Count < 2)
                        table6.MinRowHeight = 0.8;
                    else
                        table6.MinRowHeight = 0.4;

                    //table6.MinRowHeight = 0.4;
                    table6.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                    table6.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                    for (int j = 0; j < dstc.Tables[2].Rows.Count; j++)
                    {
                        TextBox tbx1 = table6.Cell[0].CreateTextBox();
                        tbx1.AddText(ArialNormal, 10, dstc.Tables[2].Rows[j]["Stuhdr"].ToString());

                        TextBox tbx2 = table6.Cell[1].CreateTextBox();
                        tbx2.AddText(ArialNormal, 10, dstc.Tables[2].Rows[j]["studet"].ToString());
                        table6.DrawRow();
                    }
                    tr = table6.RowNumber;
                    rh = table6.RowHeight;
                    tb = tb - (tr * rh);
                    tt = tt - (tr * rh);
                    table6.Close();
                    pcon1.DrawLine(left + 10.28, linetop, left + 10.28, tt);

                    PdfTable table7 = new PdfTable(page1, pcon1, ArialNormal, 10);
                    table7.TableArea = new PdfRectangle(left, tb, right, tt);
                    table7.SetColumnWidth(10, 8);
                    table7.BorderLineWidth = 0;
                    table7.BorderLineControl = BorderControl.Both;
                    table7.MinRowHeight = 0.8;
                    table7.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                    table7.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                    for (int j = 0; j < dstc.Tables[3].Rows.Count; j++)
                    {
                        TextBox tbx1 = table7.Cell[0].CreateTextBox();
                        tbx1.AddText(ArialNormal, 10, dstc.Tables[3].Rows[j]["Stuhdr"].ToString());

                        TextBox tbx2 = table7.Cell[1].CreateTextBox();
                        tbx2.AddText(ArialNormal, 10, dstc.Tables[3].Rows[j]["studet"].ToString());
                        table7.DrawRow();
                    }
                    tr = table7.RowNumber + 3;
                    rh = table7.RowHeight;
                    tb = tb - (tr * rh);
                    tt = tt - (tr * rh);
                    table7.Close();

                    PdfTable table8 = new PdfTable(page1, pcon1, ArialNormal, 10);
                    table8.TableArea = new PdfRectangle(left, tb, right, tt);
                    table8.SetColumnWidth(6.5, 8.5, 5);
                    table8.BorderLineControl = BorderControl.None;
                    table8.GridLineControl = 0;
                    table8.MinRowHeight = 0.4;
                    table8.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                    table8.Cell[0].Value = "Signature of";
                    table8.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                    table8.Cell[1].Value = "Checked by";
                    table8.Cell[2].Style.Alignment = ContentAlignment.MiddleLeft;
                    table8.Cell[2].Value = "Principal";
                    table8.DrawRow();
                    table8.Cell[0].Value = "Class Teacher";
                    table8.Cell[1].Value = "(State full name and designation)";
                    table8.Cell[2].Value = "SEAL";
                    table8.DrawRow();
                    tr = table8.RowNumber;
                    rh = table8.RowHeight;
                    tb = tb - (tr * rh);
                    tt = tt - (tr * rh);
                    table8.Close();
                }



                pcon1.SaveGraphicsState();
                pcon1.RestoreGraphicsState();

            }
            pdoc.CreateFile();
            return System.Configuration.ConfigurationManager.AppSettings["PdfUrl"] + filenm1;
        }
    }
}