<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tree.aspx.cs" Inherits="WebApplication5.WebForm3" %>


<!DOCTYPE html>
<style>

   .row-hidden {
                    display: none;
                }

.tree { padding:10px; color: #212121; text-align: center; background: #fff;
    border: 1px #D0CDCD solid;	min-height: 200px; margin-bottom: 30px;}
.tree h4{margin-top: 5px; margin-bottom: 0px;}
  .tree-widget {position: relative; padding: 20px 0px; overflow-x: auto;}
.tree-structure { font-size: 0; white-space: nowrap;}
.tree-node { display: inline-block; margin: 0 4px;padding: 7px 15px; border-radius:5px;  background: #0b79c4;
font-size: 12px; line-height: 24px; color: #fff; transition: all 0.2s ease-in-out 0s;  cursor: pointer;}
.tree-node:hover{background:#E5A00A; color:#000;}
.tree-node:focus{background:#E5A00A; color:#000;}
.tree-branch { position: relative; margin: 0;padding: 0;list-style: none;}
.tree-branch:before {content: ''; position: absolute;top: 0; left: 50%;
display: block; height: 0px; margin-left: -1px; border-left: 2px solid #000;}
.tree-item { position: relative; display: inline-block;padding: 40px 0px 0px; vertical-align: top;}
.tree-item:before { content: ''; position: absolute;top: 15px;left: 50%;display: block; height: 0px;
margin-left: -1px; border-left: 2px solid #212121;}
.tree-item:after {content: '';position: absolute; top: 15px; display: block; border-top: 2px solid #212121;}
.tree-item:first-child:after {left: 50%; width: 50%;}
.tree-item:not(:first-child):not(:last-child):after { left: 0; width: 100%;}
.tree-item:last-child:after {right: 50%;width: 50%;}
.tree-item:first-child:last-child:after { display: none;}
.tree-description {margin: 30px 0 0;font-size: 14px; text-align: center;}
.tree-mark {position: absolute; border: 2px dashed #212121; transition: all 0.2s ease-in-out 0s;}
</style>

<html>
 <head runat="server">  
        <title> TreeView</title>  
        <script src="jquery-2.1.4.js"></script>  
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>  
            <script type="text/javascript">
             
                $(function () {
                    $("[id*=TreeView1] input[type=checkbox]").bind("click", function () {
                        var table = $(this).closest("table");
                        if (table.next().length > 0 && table.next()[0].tagName == "DIV") {
                            var childDiv = table.next();
                            var isChecked = $(this).is(":checked");
                            $("input[type=checkbox]", childDiv).each(function () {
                                if (isChecked) {
                                    $(this).attr("checked", "checked");
                                } else {
                                    $(this).removeAttr("checked");
                                }
                            });
                        } else {
                            var parentDIV = $(this).closest("DIV");
                            if ($("input[type=checkbox]", parentDIV).length == $("input[type=checkbox]:checked", parentDIV).length) {
                                $("input[type=checkbox]", parentDIV.prev()).attr("checked", "checked");
                            } else {
                                $("input[type=checkbox]", parentDIV.prev()).removeAttr("checked");
                            }
                        }
                    });
                })
            </script> 
    </head>  

  <script src="Scripts/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/app.js"></script>
    <script src="Scripts/d3.min.js" charset="utf-8"></script>
      <script src="Scripts/c3.js"></script>
        <script>
        $(document).ready(function () {
            $("[id *= divtree]").click(function () {
               
                $("[class *= tree-node").toggle();
                $("[class *= tree-node").toggle();
               $('head').append("<style>.tree-branch:before { height:16px; }</style>");
                $('head').append("<style>.tree-item:before { height:25px; }</style>");
            });
            $("[class *=tree-node ]").click(function () {
                $("[class *= tree-branch").toggle();
                $("[class *= tree-branch").toggle();
               
            });
        });
        $(document).ready(function () {
            $('ul li a').click(function () {
                $('li a').removeClass("active");
                $(this).addClass("active");
            });
        });
    </script>

<body>
    <form id="form1" runat="server">

 <div id="tree" class="tree">
                 <h4>Tree View Of Companies</h4>
                 <div class="tree-widget">
             <div class="tree-structure" id="divtree" runat="server" >
                   
        <span class="toggle-child">
        </span>
           </div>
       </div>                            
    </div>
<%--       <asp:TreeView ID="TreeView1" runat="server" ImageSet="Simple" >
      <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
    <NodeStyle Font-Names="Tahoma" Font-Size="10pt" ForeColor="Black" HorizontalPadding="0px"
        NodeSpacing="0px" VerticalPadding="0px"></NodeStyle>
    <ParentNodeStyle Font-Bold="False" />
    <SelectedNodeStyle Font-Underline="True" HorizontalPadding="0px"
        VerticalPadding="0px" ForeColor="#5555DD" />
          
           </asp:TreeView>   --%>      
           </form>
    </body>
</html>
                
          
   
  
 