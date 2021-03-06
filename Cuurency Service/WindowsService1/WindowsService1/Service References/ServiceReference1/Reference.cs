﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CurencyService.ServiceReference1 {
    using System.Data;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://www.ibaspro.com.org/", ConfigurationName="ServiceReference1.clsDataInterfaceSoap")]
    public interface clsDataInterfaceSoap {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnExecute", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnExecute(string ProcedureName, string Action, string HeaderXml, string GridXml, string MasterXml, string RowId, string OldRowId, string DocRef, string DocDpdRef);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnExecute_Query", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnExecute_Query(string QueryString);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnExecute_Hlp", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnExecute_Hlp(string ProcedureName, string[] objParam);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnGetFileContent", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnGetFileContent(string FileContent);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnWriteFile", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnWriteFile(string FileContent);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/SSISExecute", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        string SSISExecute();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnWriteFileContent", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnWriteFileContent(string str);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnGetBuildXML", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        System.Data.DataSet fnGetBuildXML(string FileCnt, int Typ);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://www.ibaspro.com.org/fnGetCurrency", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        string fnGetCurrency();
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface clsDataInterfaceSoapChannel : CurencyService.ServiceReference1.clsDataInterfaceSoap, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class clsDataInterfaceSoapClient : System.ServiceModel.ClientBase<CurencyService.ServiceReference1.clsDataInterfaceSoap>, CurencyService.ServiceReference1.clsDataInterfaceSoap {
        
        public clsDataInterfaceSoapClient() {
        }
        
        public clsDataInterfaceSoapClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public clsDataInterfaceSoapClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public clsDataInterfaceSoapClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public clsDataInterfaceSoapClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public System.Data.DataSet fnExecute(string ProcedureName, string Action, string HeaderXml, string GridXml, string MasterXml, string RowId, string OldRowId, string DocRef, string DocDpdRef) {
            return base.Channel.fnExecute(ProcedureName, Action, HeaderXml, GridXml, MasterXml, RowId, OldRowId, DocRef, DocDpdRef);
        }
        
        public System.Data.DataSet fnExecute_Query(string QueryString) {
            return base.Channel.fnExecute_Query(QueryString);
        }
        
        public System.Data.DataSet fnExecute_Hlp(string ProcedureName, string[] objParam) {
            return base.Channel.fnExecute_Hlp(ProcedureName, objParam);
        }
        
        public System.Data.DataSet fnGetFileContent(string FileContent) {
            return base.Channel.fnGetFileContent(FileContent);
        }
        
        public System.Data.DataSet fnWriteFile(string FileContent) {
            return base.Channel.fnWriteFile(FileContent);
        }
        
        public string SSISExecute() {
            return base.Channel.SSISExecute();
        }
        
        public System.Data.DataSet fnWriteFileContent(string str) {
            return base.Channel.fnWriteFileContent(str);
        }
        
        public System.Data.DataSet fnGetBuildXML(string FileCnt, int Typ) {
            return base.Channel.fnGetBuildXML(FileCnt, Typ);
        }
        
        public string fnGetCurrency() {
            return base.Channel.fnGetCurrency();
        }
    }
}
