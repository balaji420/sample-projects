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

namespace ReportGeneration
{
    public class pdfprintreportcard
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

        public string RptCardPDF(Boolean Debug, String FileName, string stu_id, string acd_year, int acd_class, int acd_sec, int acd_term, string clasname)
        {
            String filenm1 = System.Guid.NewGuid() + "Lastpage.pdf";
            String FileName1 = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + filenm1;
            string path = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + "CCE_Logo.jpg";
            string path1 = System.Configuration.ConfigurationManager.AppSettings["PdfPath"] + "PSES_Logo.jpg";
           
            pdoc = new PdfDocument(PaperType.A4, false, UnitOfMeasure.cm, FileName1);

            PdfFont ArialNormal = new PdfFont(pdoc, FontName1, FontStyle.Regular, false);
            PdfFont Calibri = new PdfFont(pdoc, FontName3, FontStyle.Regular, false);
            PdfFont Calibribold = new PdfFont(pdoc, FontName3, FontStyle.Bold, false);
            PdfFont ArialBold = new PdfFont(pdoc, FontName1, FontStyle.Bold, false);
            PdfFont ArialItalic = new PdfFont(pdoc, FontName1, FontStyle.Italic, false);
            PdfFont ArialBoldItalic = new PdfFont(pdoc, FontName1, FontStyle.Bold | FontStyle.Italic, true);
            PdfFont TimesNormal = new PdfFont(pdoc, FontName2, FontStyle.Regular, true);
            PdfFont TimesBold = new PdfFont(pdoc, FontName2, FontStyle.Bold, true);
            PdfFont Comic = new PdfFont(pdoc, "Comic Sans MS", FontStyle.Bold, true);
            
            ArrayList Stu_ArrayList = new ArrayList();
            
            SqlConnection con = new SqlConnection(constring);
            con.Open();
            if (stu_id == "ALL")
            {
                SqlCommand cmd1 = new SqlCommand("Prcstudmaster_Report", con);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.AddWithValue("@Studid", "");
                cmd1.Parameters.AddWithValue("@Action", "Student_List");
                cmd1.Parameters.AddWithValue("@Acd_year", acd_year);
                cmd1.Parameters.AddWithValue("@Acd_class", acd_class);
                cmd1.Parameters.AddWithValue("@Acd_sec", acd_sec);
                cmd1.Parameters.AddWithValue("@Acd_term", "");
                SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
                DataSet dsData1 = new DataSet();
                da1.Fill(dsData1);

                foreach (DataRow dtRow in dsData1.Tables[0].Rows)
                {
                    Stu_ArrayList.Add(dtRow["stupk"]);
                }
            }
            else
            {
                Stu_ArrayList.Add(stu_id);
            }

            for (int st = 0; st < Stu_ArrayList.Count; st++)
            {
                SqlCommand cmd = new SqlCommand("Prcstudmaster_Report", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Studid", Stu_ArrayList[st].ToString());
                cmd.Parameters.AddWithValue("@Action", "Header");
                cmd.Parameters.AddWithValue("@Acd_year", acd_year);
                cmd.Parameters.AddWithValue("@Acd_class", acd_class);
                cmd.Parameters.AddWithValue("@Acd_sec", acd_sec);
                cmd.Parameters.AddWithValue("@Acd_term", acd_term);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet dsData = new DataSet();
                da.Fill(dsData);
                con.Close();

                DateTime stdob = Convert.ToDateTime(dsData.Tables[0].Rows[0]["tsdob"].ToString());
                if (dsData.Tables[0].Rows[0]["term"].ToString().Trim() == "Term - I")
                {
                    if (dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() == "VI" || dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() == "VII" ||
                            dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() == "VIII")
                    {
                        page1 = new PdfPage(pdoc);
                        pcon1 = new PdfContents(page1);
                        Times = new PdfFont(pdoc, "Times New Roman", FontStyle.Bold, true);
                        double tr, rh, bb, tt;

                        const Double Height = 29;
                        const double topmargin = 3;
                        pcon1.SetLineWidth(0.02);
                        Double PosX = 1.5;
                        Double PosY = Height - topmargin;

                        PdfImage Image1a = new PdfImage(pdoc, path1, 96.0);
                        PdfImage Image2a = new PdfImage(pdoc, path, 96.0);
                        pcon1.SaveGraphicsState();
                        pcon1.DrawImage(Image1a, PosX, PosY, 2, 2);
                        pcon1.DrawImage(Image2a, 17.5, PosY, 2, 2);

                        double l = 1.5, b = 3, r = 19.5, t = 28;
                        PdfTable table = new PdfTable(page1, pcon1, ArialBold, 9);
                        table.TableArea = new PdfRectangle(l + 2.5, b + 1, r - 2.5, t);
                        table.SetColumnWidth(18);
                        table.CellStyle.MultiLineText = true;
                        table.BorderLineWidth = 0;
                        table.GridLineControl = 0;
                        table.MinRowHeight = 0.6;
                        table.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                        table.Cell[0].Style.FontSize = 10;
                        table.Cell[0].Value = dsData.Tables[0].Rows[0]["cmpnm"].ToString().Trim();
                        table.DrawRow();
                        table.Cell[0].Style.FontSize = 9;
                        table.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                        table.Cell[0].Value = dsData.Tables[0].Rows[0]["cmpadd1"].ToString().Trim() + ' ' + dsData.Tables[0].Rows[0]["cmpcity"].ToString().Trim();
                        table.DrawRow();
                        table.Cell[0].Style.FontSize = 9;
                        table.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                        table.Cell[0].Value = "CLASS " + dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() + " (" + dsData.Tables[0].Rows[0]["tssection"].ToString().Trim() + ") - TERM I - " + dsData.Tables[0].Rows[0]["year"].ToString().Trim();
                        table.DrawRow();
                        tr = table.RowNumber + 1;
                        rh = table.RowHeight;
                        bb = b - (tr * rh);
                        tt = t - (tr * rh);
                        table.Close();

                        PdfTable table1 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table1.TableArea = new PdfRectangle(l, bb, r, tt);
                        table1.SetColumnWidth(9, 9);
                        table1.BorderLineWidth = 0;
                        table1.MinRowHeight = 0.6;
                        //table1.Cell[0].Style.FontSize = 8;
                        //table1.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        //table1.Cell[0].Value = "PART 1 - SCHOLASTIC";
                        table1.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox txb5 = table1.Cell[0].CreateTextBox();
                        txb5.AddText(ArialBold, 8, "PART 1 - SCHOLASTIC");
                        table1.Cell[1].Style.FontSize = 8;
                        table1.Cell[1].Style.Alignment = ContentAlignment.MiddleCenter;
                        table1.Cell[1].Value = "TERM 1";
                        table1.DrawRow();
                        tr = table1.RowNumber;
                        rh = table1.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table1.Close();

                        PdfTable table2 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table2.TableArea = new PdfRectangle(l, bb, r, tt);
                        table2.SetColumnWidth(9, 2.2, 2.2, 2.2, 2.4);
                        table2.BorderLineWidth = 0;
                        table2.MinRowHeight = 0.6;
                        table2.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox bt12 = table2.Cell[0].CreateTextBox();
                        bt12.AddText(ArialBold, 8, dsData.Tables[0].Rows[0]["tsrollno"].ToString().Trim() + "  -  " + dsData.Tables[0].Rows[0]["tsname"].ToString());
                        TextBox tgrd1 = table2.Cell[1].CreateTextBox();
                        tgrd1.AddText(ArialBold, 7, "FA1 Grade 10%");
                        TextBox tgrd2 = table2.Cell[2].CreateTextBox();
                        tgrd2.AddText(ArialBold, 7, "FA2 Grade 10%");
                        TextBox tgrd3 = table2.Cell[3].CreateTextBox();
                        tgrd3.AddText(ArialBold, 7, "SA1 Grade 30%");
                        TextBox tgrd4 = table2.Cell[4].CreateTextBox();
                        tgrd4.AddText(ArialBold, 7, "TERM1 Grade 50%");
                        table2.DrawRow();
                        for (int a = 0; a < dsData.Tables[2].Rows.Count; a++)
                        {
                            table2.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                            TextBox b15 = table2.Cell[0].CreateTextBox();
                            b15.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["subnm"].ToString());

                            TextBox txtb1 = table2.Cell[1].CreateTextBox();
                            table2.Cell[1].Style.Alignment = ContentAlignment.MiddleCenter;
                            if (dsData.Tables[2].Rows[a]["fa1"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa1"].ToString().Trim() == "E2")
                            {
                                table2.Cell[1].Value = dsData.Tables[2].Rows[a]["fa1"].ToString();
                                table2.Cell[1].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb1.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa1"].ToString().PadLeft(12));

                            }
                            table2.Cell[2].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb2 = table2.Cell[2].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["fa2"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa2"].ToString().Trim() == "E2")
                            {
                                table2.Cell[2].Value = dsData.Tables[2].Rows[a]["fa2"].ToString();
                                table2.Cell[2].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb2.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa2"].ToString().PadLeft(12));

                            }
                            table2.Cell[3].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb3 = table2.Cell[3].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["sa1"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["sa1"].ToString().Trim() == "E2")
                            {
                                table2.Cell[3].Value = dsData.Tables[2].Rows[a]["sa1"].ToString();
                                table2.Cell[3].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb3.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["sa1"].ToString().PadLeft(12));
                            }
                            table2.Cell[4].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb4 = table2.Cell[4].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["tot1"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["tot1"].ToString().Trim() == "E2")
                            {
                                table2.Cell[4].Value = dsData.Tables[2].Rows[a]["tot1"].ToString();
                                table2.Cell[4].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb4.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["tot1"].ToString().PadLeft(14));
                            }
                            table2.DrawRow();
                        }
                        tr = table2.RowNumber;
                        rh = table2.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh) - 0.05;
                        table2.Close();

                        PdfTable table5 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table5.TableArea = new PdfRectangle(l, bb, r, tt);
                        table5.SetColumnWidth(18);
                        table5.BorderLineWidth = 0;
                        table5.MinRowHeight = 0.55;
                        table5.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        table5.Cell[0].Value = "PART 2 - CO-SCHOLASTIC AREAS";
                        table5.DrawRow();
                        tr = table5.RowNumber;
                        rh = table5.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table5.Close();

                        PdfTable table3 = new PdfTable(page1, pcon1, ArialNormal, 8);
                        table3.TableArea = new PdfRectangle(l, bb, r, tt);
                        table3.SetColumnWidth(9, 9);
                        table3.BorderLineWidth = 0;
                        table3.MinRowHeight = 0.55;
                        for (int cocnt = 0; cocnt < dsData.Tables[1].Rows.Count - 3; cocnt++)
                        {
                            table3.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                            TextBox b15 = table3.Cell[0].CreateTextBox();
                            if (dsData.Tables[1].Rows[cocnt]["tcoscgrd"].ToString().Trim() == "" || dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "Attendance"
                                || dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "PART II 5 VALUE SYSTEM")
                            {
                                b15.AddText(ArialBold, 8, dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim());
                            }
                            else
                            {
                                b15.AddText(ArialNormal, 8, "   " + dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim());
                            }
                            table3.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                            table3.Cell[1].Value = dsData.Tables[1].Rows[cocnt]["tcoscgrd"].ToString().Trim().PadLeft(25);
                            table3.DrawRow();
                            //if (dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "Signature of the Class Teacher" ||
                            //    dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "Signature of the Principal" ||
                            //    dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "Signature of the Parent")
                            //{
                            //    table3.DrawRow();
                            //}
                        }
                        tr = table3.RowNumber;
                        rh = table3.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh) - 0.24;
                        table3.Close();

                        PdfTable table4 = new PdfTable(page1, pcon1, ArialNormal, 8);
                        table4.TableArea = new PdfRectangle(l, bb, r, tt);
                        table4.SetColumnWidth(13, 6);
                        table4.BorderLineWidth = 0;
                        table4.MinRowHeight = 0.6;
                        table4.GridLineControl = 0;
                        table4.DrawRow();
                        table4.DrawRow();
                        table4.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox txb1 = table4.Cell[0].CreateTextBox();
                        txb1.AddText(ArialBold, 8, "Signature of the Class Teacher");
                        table4.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox txb2 = table4.Cell[1].CreateTextBox();
                        txb2.AddText(ArialBold, 8, "Signature of the Principal");
                        table4.DrawRow();
                        table4.DrawRow();
                        table4.DrawRow();
                        table4.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox txb3 = table4.Cell[0].CreateTextBox();
                        txb3.AddText(ArialBold, 8, "Signature of the Parent");
                        table4.DrawRow();

                        tr = table4.RowNumber;
                        rh = table4.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table4.Close();

                    }
                }
                else if (dsData.Tables[0].Rows[0]["term"].ToString().Trim() == "Term - II")
                {
                    if (dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() == "VI" || dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() == "VII" ||
                            dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() == "VIII")
                    {
                        page1 = new PdfPage(pdoc);
                        pcon1 = new PdfContents(page1);
                        Times = new PdfFont(pdoc, "Times New Roman", FontStyle.Bold, true);
                        //Double centerwidth = 21.0 / 2.0;
                        //const Double Width = 19;
                        double tr, rh, bb, tt;

                        const Double Height = 29;
                        const double topmargin = 3;
                        pcon1.SetLineWidth(0.02);
                        Double PosX = 1.5;
                        Double PosY = Height - topmargin;

                        PdfImage Image1a = new PdfImage(pdoc, path1, 96.0);
                        PdfImage Image2a = new PdfImage(pdoc, path, 96.0);
                        pcon1.SaveGraphicsState();
                        pcon1.DrawImage(Image1a, PosX, PosY, 2, 2);
                        pcon1.DrawImage(Image2a, 17.5, PosY, 2, 2);

                        double l = 1.5, b = 3, r = 19.5, t = 28;
                        PdfTable table = new PdfTable(page1, pcon1, ArialBold, 9);
                        table.TableArea = new PdfRectangle(l + 2.5, b + 1, r - 2.5, t);
                        table.SetColumnWidth(18);
                        table.CellStyle.MultiLineText = true;
                        table.BorderLineWidth = 0;
                        table.GridLineControl = 0;
                        table.MinRowHeight = 0.6;
                        table.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                        table.Cell[0].Style.FontSize = 10;
                        table.Cell[0].Value = dsData.Tables[0].Rows[0]["cmpnm"].ToString().Trim();
                        table.DrawRow();
                        table.Cell[0].Style.FontSize = 9;
                        table.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                        table.Cell[0].Value = dsData.Tables[0].Rows[0]["cmpadd1"].ToString().Trim() + ' ' + dsData.Tables[0].Rows[0]["cmpcity"].ToString().Trim();
                        table.DrawRow();
                        table.Cell[0].Style.FontSize = 9;
                        table.Cell[0].Style.Alignment = ContentAlignment.MiddleCenter;
                        table.Cell[0].Value = "GRADE SHEET CUM CERTIFICATE OF PERFORMANCE - " + dsData.Tables[0].Rows[0]["year"].ToString().Trim();
                        //table.Cell[0].Value = "CLASS " + dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim() + " (" + dsData.Tables[0].Rows[0]["tssection"].ToString().Trim() + ") - TERM I - " + dsData.Tables[0].Rows[0]["year"].ToString().Trim();
                        table.DrawRow();
                        tr = table.RowNumber;
                        rh = table.RowHeight;
                        bb = b - (tr * rh);
                        tt = t - (tr * rh);
                        table.Close();

                        PdfTable table0 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table0.TableArea = new PdfRectangle(l, bb, r, tt);
                        table0.SetColumnWidth(14, 2, 3);
                        table0.BorderLineControl = 0;
                        table0.GridLineControl = 0;
                        table0.MinRowHeight = 0.6;
                        table0.Cell[0].Value = "";
                        table0.Cell[1].Style.Alignment = ContentAlignment.BottomCenter;
                        table0.Cell[1].Value = "Class : " + dsData.Tables[0].Rows[0]["tsclass"].ToString().Trim();
                        table0.Cell[2].Style.Alignment = ContentAlignment.BottomCenter;
                        table0.Cell[2].Value = "Section : " + dsData.Tables[0].Rows[0]["tssection"].ToString().Trim();
                        table0.DrawRow();
                        tr = table0.RowNumber;
                        rh = table0.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table0.Close();

                        PdfTable table1 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table1.TableArea = new PdfRectangle(l, bb, r, tt);
                        table1.SetColumnWidth(7, 5, 5, 4);
                        table1.BorderLineWidth = 0;
                        table1.MinRowHeight = 0.6;

                        table1.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox ttb1 = table1.Cell[0].CreateTextBox();
                        ttb1.AddText(ArialBold, 8, "PART 1 - SCHOLASTIC");
                        //table1.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        //table1.Cell[0].Value = "PART 1 - SCHOLASTIC";
                        table1.Cell[1].Style.Alignment = ContentAlignment.MiddleCenter;
                        table1.Cell[1].Value = "TERM 1";
                        table1.Cell[2].Style.Alignment = ContentAlignment.MiddleCenter;
                        table1.Cell[2].Value = "TERM 2";
                        table1.Cell[3].Style.Alignment = ContentAlignment.MiddleCenter;
                        table1.Cell[3].Value = "TERM 1 & 2";
                        table1.DrawRow();
                        tr = table1.RowNumber;
                        rh = table1.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table1.Close();

                        PdfTable table2 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table2.TableArea = new PdfRectangle(l, bb, r, tt);
                        table2.SetColumnWidth(7, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.5);
                        table2.BorderLineWidth = 0;
                        table2.MinRowHeight = 0.7;
                        table2.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        TextBox bt12 = table2.Cell[0].CreateTextBox();
                        bt12.AddText(ArialBold, 8, dsData.Tables[0].Rows[0]["tsrollno"].ToString().Trim() + "  -  " + dsData.Tables[0].Rows[0]["tsname"].ToString());
                        TextBox tgrd1 = table2.Cell[1].CreateTextBox();
                        tgrd1.AddText(ArialBold, 7, "  FA1 10% G");
                        TextBox tgrd2 = table2.Cell[2].CreateTextBox();
                        tgrd2.AddText(ArialBold, 7, "  FA2 10% G");
                        TextBox tgrd3 = table2.Cell[3].CreateTextBox();
                        tgrd3.AddText(ArialBold, 7, "  SA1 30% G");
                        TextBox tgrd4 = table2.Cell[4].CreateTextBox();
                        tgrd4.AddText(ArialBold, 7, "Term1 50% G");
                        TextBox tgrd5 = table2.Cell[5].CreateTextBox();
                        tgrd5.AddText(ArialBold, 7, "  FA3 10% G");
                        TextBox tgrd6 = table2.Cell[6].CreateTextBox();
                        tgrd6.AddText(ArialBold, 7, "  FA4 10% G");
                        TextBox tgrd7 = table2.Cell[7].CreateTextBox();
                        tgrd7.AddText(ArialBold, 7, "  SA2 30% G");
                        TextBox tgrd8 = table2.Cell[8].CreateTextBox();
                        tgrd8.AddText(ArialBold, 7, "Term2 50% G");
                        TextBox tgrd9 = table2.Cell[9].CreateTextBox();
                        tgrd9.AddText(ArialBold, 7, "   FA");
                        TextBox tgrd10 = table2.Cell[10].CreateTextBox();
                        tgrd10.AddText(ArialBold, 7, "   SA");
                        TextBox tgrd11 = table2.Cell[11].CreateTextBox();
                        tgrd11.AddText(ArialBold, 7, "Overall");

                        table2.DrawRow();
                        for (int a = 0; a < dsData.Tables[2].Rows.Count; a++)
                        {
                            table2.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                            TextBox b15 = table2.Cell[0].CreateTextBox();
                            b15.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["subnm"].ToString());

                            TextBox txtb1 = table2.Cell[1].CreateTextBox();
                            table2.Cell[1].Style.Alignment = ContentAlignment.MiddleCenter;
                            if (dsData.Tables[2].Rows[a]["fa1"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa1"].ToString().Trim() == "E2")
                            {
                                table2.Cell[1].Value = dsData.Tables[2].Rows[a]["fa1"].ToString();
                                table2.Cell[1].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb1.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa1"].ToString().PadLeft(5));
                            }
                            table2.Cell[2].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb2 = table2.Cell[2].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["fa2"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa2"].ToString().Trim() == "E2")
                            {
                                table2.Cell[2].Value = dsData.Tables[2].Rows[a]["fa2"].ToString();
                                table2.Cell[2].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb2.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa2"].ToString().PadLeft(5));
                            }
                            table2.Cell[3].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb3 = table2.Cell[3].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["sa1"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["sa1"].ToString().Trim() == "E2")
                            {
                                table2.Cell[3].Value = dsData.Tables[2].Rows[a]["sa1"].ToString();
                                table2.Cell[3].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb3.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["sa1"].ToString().PadLeft(5));
                            }
                            table2.Cell[4].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb4 = table2.Cell[4].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["tot1"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["tot1"].ToString().Trim() == "E2")
                            {
                                table2.Cell[4].Value = dsData.Tables[2].Rows[a]["tot1"].ToString();
                                table2.Cell[4].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb4.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["tot1"].ToString().PadLeft(5));
                            }
                            table2.Cell[5].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb5 = table2.Cell[5].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["fa3"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa3"].ToString().Trim() == "E2")
                            {
                                table2.Cell[5].Value = dsData.Tables[2].Rows[a]["fa3"].ToString();
                                table2.Cell[5].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb5.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa3"].ToString().PadLeft(5));
                            }
                            table2.Cell[6].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb6 = table2.Cell[6].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["fa4"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa4"].ToString().Trim() == "E2")
                            {
                                table2.Cell[6].Value = dsData.Tables[2].Rows[a]["fa4"].ToString();
                                table2.Cell[6].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb6.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa4"].ToString().PadLeft(5));
                            }
                            table2.Cell[7].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb7 = table2.Cell[7].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["sa2"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["sa2"].ToString().Trim() == "E2")
                            {
                                table2.Cell[7].Value = dsData.Tables[2].Rows[a]["sa2"].ToString();
                                table2.Cell[7].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb7.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["sa2"].ToString().PadLeft(5));
                            }
                            table2.Cell[8].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb8 = table2.Cell[8].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["tot2"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["tot2"].ToString().Trim() == "E2")
                            {
                                table2.Cell[8].Value = dsData.Tables[2].Rows[a]["tot2"].ToString();
                                table2.Cell[8].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb8.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["tot2"].ToString().PadLeft(5));
                            }
                            table2.Cell[9].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb9 = table2.Cell[9].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["fa"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fa"].ToString().Trim() == "E2")
                            {
                                table2.Cell[9].Value = dsData.Tables[2].Rows[a]["fa"].ToString();
                                table2.Cell[9].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb9.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fa"].ToString().PadLeft(5));
                            }
                            table2.Cell[10].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb10 = table2.Cell[10].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["sa"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["sa"].ToString().Trim() == "E2")
                            {
                                table2.Cell[10].Value = dsData.Tables[2].Rows[a]["sa"].ToString();
                                table2.Cell[10].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb10.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["sa"].ToString().PadLeft(5));
                            }
                            table2.Cell[11].Style.Alignment = ContentAlignment.MiddleCenter;
                            TextBox txtb11 = table2.Cell[11].CreateTextBox();
                            if (dsData.Tables[2].Rows[a]["fgr"].ToString().Trim() == "E1" || dsData.Tables[2].Rows[a]["fgr"].ToString().Trim() == "E2")
                            {
                                table2.Cell[11].Value = dsData.Tables[2].Rows[a]["fgr"].ToString();
                                table2.Cell[11].Style.TextDrawStyle = DrawStyle.Underline;
                            }
                            else
                            {
                                txtb11.AddText(ArialNormal, 8, dsData.Tables[2].Rows[a]["fgr"].ToString().PadLeft(7));
                            }

                            table2.DrawRow();
                        }
                        tr = table2.RowNumber;
                        rh = table2.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh) - 0.05;
                        table2.Close();

                        PdfTable table5 = new PdfTable(page1, pcon1, ArialBold, 8);
                        table5.TableArea = new PdfRectangle(l, bb, r, tt);
                        table5.SetColumnWidth(18);
                        table5.BorderLineWidth = 0;
                        table5.MinRowHeight = 0.6;
                        table5.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                        table5.Cell[0].Value = "PART 2 - CO-SCHOLASTIC AREAS";
                        table5.DrawRow();
                        tr = table5.RowNumber;
                        rh = table5.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table5.Close();

                        PdfTable table3 = new PdfTable(page1, pcon1, ArialNormal, 8);
                        table3.TableArea = new PdfRectangle(l, bb, r, tt);
                        table3.SetColumnWidth(9, 9);
                        table3.BorderLineWidth = 0;
                        table3.MinRowHeight = .6;
                        for (int cocnt = 0; cocnt < dsData.Tables[1].Rows.Count; cocnt++)
                        {
                            table3.Cell[0].Style.Alignment = ContentAlignment.MiddleLeft;
                            TextBox b15 = table3.Cell[0].CreateTextBox();
                            if (dsData.Tables[1].Rows[cocnt]["tcoscgrd"].ToString().Trim() == "" || dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "Attendance"
                                || dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim() == "PART II 5 VALUE SYSTEM")
                            {
                                b15.AddText(ArialBold, 8, dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim());
                            }
                            else
                            {
                                b15.AddText(ArialNormal, 8, "   " + dsData.Tables[1].Rows[cocnt]["tcoschd"].ToString().Trim());
                            }
                            table3.Cell[1].Style.Alignment = ContentAlignment.MiddleLeft;
                            table3.Cell[1].Value = dsData.Tables[1].Rows[cocnt]["tcoscgrd"].ToString().Trim().PadLeft(25);
                            table3.DrawRow();
                        }
                        tr = table3.RowNumber;
                        rh = table3.RowHeight;
                        bb = bb - (tr * rh);
                        tt = tt - (tr * rh);
                        table3.Close();


                    }
                }
            }

            pdoc.CreateFile();
            return System.Configuration.ConfigurationManager.AppSettings["PdfUrl"] + filenm1;
        }
    }
}