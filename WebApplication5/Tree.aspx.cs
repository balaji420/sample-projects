using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using System.Web.Script.Services;
using System.Web.Services;
using System.Runtime.Serialization;
using System.Web.UI.HtmlControls;
namespace WebApplication5
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dts = this.GetData("SELECT * FROM CmpDet where isnull(CmpCmpFk,0)=0");
            //this.PopulateTreeView(dts, 0, null);
            string constring = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            SqlConnection con = new SqlConnection(constring);
            string query = "select * from CmpDet where isnull(CmpCmpFk,0)=0 ";
            string query1 = "select * from CmpDet  ";
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            SqlCommand cmd1 = new SqlCommand(query1, con);
            SqlDataAdapter dp = new SqlDataAdapter(cmd1);
            DataSet dt = new DataSet();
            da.Fill(ds);
            dp.Fill(dt);
            con.Close();
            string TreeNod = "";
            TreeNod += "<div class='tree-node level-1'>Companies</div>";
            TreeNod += "<ul class='tree-branch'>";


            //for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            //{

            //    TreeNod += "<li class='tree-item'> <div class='tree-node level-" + ds.Tables[0].Rows[i]["CmpPk"].ToString() + " node-box'>" + ds.Tables[0].Rows[i]["CmpDispNm"].ToString() + "</div>";

            //    TreeNod += "<ul class='tree-branch level-" + ds.Tables[0].Rows[i]["CmpPk"].ToString() + "'>";

            //    //TreeNod += "</ul class='tree-branch'>";
            //    //TreeNod += "</ul> </li>";
            //    //TreeNod += "</ul>";

            //    if (ds.Tables[0].Rows[i]["CmpPk"].ToString() == dt.Tables[0].Rows[i]["CmpCmpFk"].ToString())
            //    {
            //        TreeNod += treenode(dt);
            //    }

            //    TreeNod += "</ul> </li>";
            //    TreeNod += "</ul>";
            //    //TreeNod += "</ul class='tree-branch'>";

            //}

            //    for (int j = 0; j < dt.Tables[0].Rows.Count; j++)
            //    {
            //        if (dt.Tables[0].Rows[j]["CmpCmpFk"].ToString() == ds.Tables[0].Rows[i]["CmpPk"].ToString())
            //        {

            //            //TreeNod += "<li class='tree-item'> <div class='tree-node'>" + dt.Tables[0].Rows[j]["CmpDispNm"].ToString() + "</div> </li>";
            //            TreeNod += "<li class='tree-item'> <div class='tree-node level-" + dt.Tables[0].Rows[i]["CmpPk"].ToString() + " node-box'>" + dt.Tables[0].Rows[j]["CmpDispNm"].ToString() + "</div>";

            //            TreeNod += "<ul class='tree-branch level-" + dt.Tables[0].Rows[i]["CmpPk"].ToString() + "'>";
            //            for (int k = 0; k < dt.Tables[0].Rows.Count; k++)
            //            {
            //                if (dt.Tables[0].Rows[k]["CmpCmpFk"].ToString() == dt.Tables[0].Rows[j]["CmpPk"].ToString())
            //                {

            //                    TreeNod += "<li class='tree-item'> <div class='tree-node level-" + dt.Tables[0].Rows[j]["CmpPk"].ToString() + " node-box'>" + dt.Tables[0].Rows[k]["CmpDispNm"].ToString() + "</div>";

            //                    TreeNod += "<ul class='tree-branch level-" + dt.Tables[0].Rows[j]["CmpPk"].ToString() + "'>";
            //                    for (int l= 0; l < dt.Tables[0].Rows.Count; l++)
            //                    {
            //                        if (dt.Tables[0].Rows[l]["CmpCmpFk"].ToString() == dt.Tables[0].Rows[k]["CmpPk"].ToString())
            //                        {

            //                            TreeNod += "<li class='tree-item'> <div class='tree-node'>" + dt.Tables[0].Rows[l]["CmpDispNm"].ToString() + "</div> </li>";
            //                        }
            //                    }
            //                    TreeNod += "</ul class='tree-branch'>";
            //                }

            //            }
            //            TreeNod += "</ul class='tree-branch'>";

            //        }

            //    }


            //TreeNod += "</ul class='tree-branch'>";
            ////    }


            //TreeNod += "</ul> </li>";
            //TreeNod += "</ul>";

            TreeNod += treenode(dt);
            divtree.InnerHtml = TreeNod;




        }
        private string treenode(DataSet dt)
        {
            string Nod = "";



            //for (int l = 0; l < ds.Tables[0].Rows.Count; l++)

            //    while (l == 0)
            //   {
            //    if (dt.Tables[0].Rows[k]["CmpCmpFk"].ToString() == ds.Tables[0].Rows[l]["CmpPk"].ToString())
            //    {
            //        Nod += "<li class='tree-item'> <div class='tree-node level-" + dt.Tables[0].Rows[k]["CmpPk"].ToString() + " node-box'>" + dt.Tables[0].Rows[k]["CmpDispNm"].ToString() + "</div>";

            //        Nod += "<ul class='tree-branch level-" + dt.Tables[0].Rows[k]["CmpPk"].ToString() + "'>";
            //        Nod += "</ul class='tree-branch'>";
            //            l--;
            //    }
            //}


            //Nod += "</ul> </li>";
            //Nod += "</ul>";
            //Nod += "</ul class='tree-branch'>";

            //Nod += "</ul class='tree-branch'>";
            //Nod += "</ul>";

           

                for (int j = 1; j < dt.Tables[0].Rows.Count - 1; j++)
                {
                    if (dt.Tables[0].Rows[j]["CmpCmpFk"].Equals(dt.Tables[0].Rows[i]["CmpPk"]))
                    {
                        Nod += "<li class='tree-item'> <div class='tree-node level-" + dt.Tables[0].Rows[j]["CmpPk"].ToString() + " node-box'>" + dt.Tables[0].Rows[j]["CmpDispNm"].ToString() + "</div>";

                        Nod += "<ul class='tree-branch level-" + dt.Tables[0].Rows[j]["CmpPk"].ToString() + "'>";

                        //Nod += "</ul class='tree-branch'>";
                        //Nod += "</ul> </li>";
                        //Nod += "</ul>";
                    }

                    //Nod += "</ul class='tree-branch'>";
                    //Nod += "</ul> </li>";
                    //Nod += "</ul>";

                }

                ////Nod += "<li class='tree-item'> <div class='tree-node'>" + dt.Tables[0].Rows[l]["CmpDispNm"].ToString() + "</div> </li>";




            }
        
            return Nod;
        }

        //private void PopulateTreeView(DataTable dtParent, int parentId, TreeNode treeNode)
        //{
        //    foreach (DataRow row in dtParent.Rows)
        //    {
        //        TreeNode child = new TreeNode
        //        {
        //            Text = row["CmpDispNm"].ToString(),
        //            Value = row["CmpPk"].ToString()
        //        };
        //        if (parentId == 0)
        //        {
        //            TreeView1.Nodes.Add(child);
        //            DataTable dtChild = this.GetData("SELECT CmpDispNm,CmpPk,CmpCmpFk FROM CmpDet WHERE isnull(CmpCmpFk,0)=" + child.Value);

        //            PopulateTreeView(dtChild, int.Parse(child.Value), child);

        //        }

        //        else
        //        {
        //            treeNode.ChildNodes.Add(child);
        //            DataTable dtChild = this.GetData("SELECT CmpDispNm,CmpPk,CmpCmpFk FROM CmpDet WHERE isnull(CmpCmpFk,0)=" + child.Value);

        //            if (dtChild.Rows == dtParent.Rows)
        //            {

        //                TreeView1.Nodes.Add(child);
        //                dtChild = this.GetData("SELECT CmpDispNm,CmpCmpFk  FROM CmpDet WHERE isnull(CmpCmpFk,0)=" + child.Value);

        //                treeNode.ChildNodes.Add(child);
        //            }
        //        }
        //    }


        //}

        private DataTable GetData(string query)
        {
            DataTable dt = new DataTable();
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        sda.SelectCommand.CommandTimeout = 120;
                        sda.Fill(dt);
                    }
                }
                return dt;
            }
        }
    }
}