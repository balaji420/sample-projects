--screen 173

--screen 175


--screen 655127
--select * from screen_master where sname like'%consol%'

--select * from progemgusrmas with(nolock)



--update progemgusrmas set UsrExpDt ='2018-07-14 15:33:06.633' where UsrName ='admin'
begin tran
exec PrcLevelBased_P_AND_L_Rpt_V5_consol N'',N'30458',N'<DROPDOWN>
	<LIST TEXT="L02-Navitas LLP Chennai -SEZ" VALUE="30458" UmpFk="0" chk="-1" LocPk="30458" lvlno="L0000030458" Chk1="-1"/>
	<LIST TEXT="L29-Navitas LLP-DOMESTIC" VALUE="30518" UmpFk="0" chk="0" LocPk="30518" lvlno="L0000030518" Chk1="0"/>
	<LIST TEXT="L03-TAKE Solutions Global Holdings Pte Ltd" VALUE="30459" UmpFk="0" chk="0" LocPk="30459" lvlno="L0000030459" Chk1="0"/>
	<LIST TEXT="L04-Ecron Acunova Ltd-Bangalore" VALUE="30460" UmpFk="0" chk="0" LocPk="30460" lvlno="L0000030460" Chk1="0"/>
	<LIST TEXT="L05-TAKE Solutions Information Systems Pte Ltd" VALUE="30462" UmpFk="0" chk="0" LocPk="30462" lvlno="L0000030462" Chk1="0"/>
	<LIST TEXT="L06-TAKE Enterprises Services Inc" VALUE="30463" UmpFk="0" chk="0" LocPk="30463" lvlno="L0000030463" Chk1="0"/>
	<LIST TEXT="L07-TAKE Innovations Inc" VALUE="30464" UmpFk="0" chk="0" LocPk="30464" lvlno="L0000030464" Chk1="0"/>
	<LIST TEXT="L08-Navitas Life Sciences Holdings Ltd" VALUE="30465" UmpFk="0" chk="0" LocPk="30465" lvlno="L0000030465" Chk1="0"/>
	<LIST TEXT="L09-Acunova Life Sciences Inc" VALUE="30466" UmpFk="0" chk="0" LocPk="30466" lvlno="L0000030466" Chk1="0"/>
	<LIST TEXT="L10-Navitas Life sciences Company Limited" VALUE="30467" UmpFk="0" chk="0" LocPk="30467" lvlno="L0000030467" Chk1="0"/>
	<LIST TEXT="L11-Ecron Acunova Gmbh" VALUE="30468" UmpFk="0" chk="0" LocPk="30468" lvlno="L0000030468" Chk1="0"/>
	<LIST TEXT="L12-Acunova Life Sciences Ltd" VALUE="30469" UmpFk="0" chk="0" LocPk="30469" lvlno="L0000030469" Chk1="0"/>
	<LIST TEXT="L13-Ecron Acunova Sdn Bhd" VALUE="30470" UmpFk="0" chk="0" LocPk="30470" lvlno="L0000030470" Chk1="0"/>
	<LIST TEXT="L14-Million Star Technologies Ltd" VALUE="30471" UmpFk="0" chk="0" LocPk="30471" lvlno="L0000030471" Chk1="0"/>
	<LIST TEXT="L15-Astus Technologies Inc" VALUE="30472" UmpFk="0" chk="0" LocPk="30472" lvlno="L0000030472" Chk1="0"/>
	<LIST TEXT="L16-Intelent Inc (Slilicon, Apex and Others)" VALUE="30473" UmpFk="0" chk="0" LocPk="30473" lvlno="L0000030473" Chk1="0"/>
	<LIST TEXT="L17-TAKE Synergis Inc" VALUE="30474" UmpFk="0" chk="0" LocPk="30474" lvlno="L0000030474" Chk1="0"/>
	<LIST TEXT="L18-TAKE Dataworks Inc" VALUE="30475" UmpFk="0" chk="0" LocPk="30475" lvlno="L0000030475" Chk1="0"/>
	<LIST TEXT="L19-Navitas Life Sciences Ltd" VALUE="30476" UmpFk="0" chk="0" LocPk="30476" lvlno="L0000030476" Chk1="0"/>
	<LIST TEXT="L20-Navitas Inc (Princeton)" VALUE="30477" UmpFk="0" chk="0" LocPk="30477" lvlno="L0000030477" Chk1="0"/>
	<LIST TEXT="L21-Navitas Life Sciences Inc" VALUE="30478" UmpFk="0" chk="0" LocPk="30478" lvlno="L0000030478" Chk1="0"/>
	<LIST TEXT="L22-Ecron Acunova Sp Z o o" VALUE="30485" UmpFk="0" chk="0" LocPk="30485" lvlno="L0000030485" Chk1="0"/>
	<LIST TEXT="L23-Ecron Acunova LLC" VALUE="30480" UmpFk="0" chk="0" LocPk="30480" lvlno="L0000030480" Chk1="0"/>
	<LIST TEXT="L24-Ecron Acunova AS" VALUE="30481" UmpFk="0" chk="0" LocPk="30481" lvlno="L0000030481" Chk1="0"/>
	<LIST TEXT="L25-Ecron Acunova Ltd" VALUE="30482" UmpFk="0" chk="0" LocPk="30482" lvlno="L0000030482" Chk1="0"/>
	<LIST TEXT="L26-Ecron LLC" VALUE="30483" UmpFk="0" chk="0" LocPk="30483" lvlno="L0000030483" Chk1="0"/>
	<LIST TEXT="L27-Navitas Life Sciences Pte Ltd" VALUE="30484" UmpFk="0" chk="0" LocPk="30484" lvlno="L0000030484" Chk1="0"/>
	<LIST TEXT="L28-TAKE Solutions ESOP Trust" VALUE="30461" UmpFk="0" chk="0" LocPk="30461" lvlno="L0000030461" Chk1="0"/>
	<LIST TEXT="L30-Ecron Acunova Limited-Mangalore" VALUE="30519" UmpFk="0" chk="0" LocPk="30519" lvlno="L0000030519" Chk1="0"/>
	<LIST TEXT="L31-Ecron Acunova Limited-Manipal" VALUE="30520" UmpFk="0" chk="0" LocPk="30520" lvlno="L0000030520" Chk1="0"/>
	<LIST TEXT="L32-Ecron Acunova Limited-Chennai" VALUE="30521" UmpFk="0" chk="0" LocPk="30521" lvlno="L0000030521" Chk1="0"/>
	<LIST TEXT="L33-Navitas Inc - Austin" VALUE="30522" UmpFk="0" chk="0" LocPk="30522" lvlno="L0000030522" Chk1="0"/>
	<LIST TEXT="L34-Navitas Inc - Domain" VALUE="30523" UmpFk="0" chk="0" LocPk="30523" lvlno="L0000030523" Chk1="0"/>
	<LIST TEXT="L35-ABC Limited" VALUE="30975" UmpFk="0" chk="0" LocPk="30975" lvlno="L0000030975" Chk1="0"/>
	<LIST TEXT="XYZ PVT LTD" VALUE="30976" UmpFk="0" chk="0" LocPk="30976" lvlno="X0000030976" Chk1="0"/>
	<LIST TEXT="L01-TAKE Solutions Ltd" VALUE="20459" UmpFk="0" chk="0" LocPk="20459" lvlno="L0000020459" Chk1="0"/>
</DROPDOWN>
',1,N'01/04/2018',N'31/7/2018',N'01/04/2018',N'30/6/2018',N'0',N'24',N'1',NULL,NULL,N'<FORMDATA><DATA ATTR="hdnState" VALUE=""/><DATA 
ATTR="hdnFormState" VALUE=""/><DATA ATTR="hdnOldRowID" VALUE=""/><DATA ATTR="hdnNewRowId" VALUE=""/><DATA ATTR="hdnLocalState" 
VALUE=""/><DATA ATTR="hdnKeyValue" VALUE=""/><DATA ATTR="hdnErrString" VALUE=""/><DATA ATTR="hdnCmpFk" VALUE="1"/><DATA ATTR="hdnCmpNm" 
VALUE="TAKE DEVP"/><DATA ATTR="hdnFYrFk" VALUE="24"/><DATA ATTR="hdnSFYr" VALUE="01/04/2018"/><DATA ATTR="hdnEFYr" 
VALUE="31/03/2019"/><DATA ATTR="hdnFYr" VALUE="Apr 2018-Mar 2019"/><DATA ATTR="hdnUsrBgColor" VALUE="#E7E7CF"/><DATA ATTR="hdnUsrBrdColor" 
VALUE="#006666"/><DATA ATTR="hdnUsrFk" VALUE="1"/><DATA ATTR="hdnVchTypFk" VALUE=""/><DATA ATTR="hdnLocFk" VALUE="30458"/><DATA 
ATTR="hdnLoc" VALUE="L02-Navitas LLP Chennai -SEZ,"/><DATA ATTR="hdnDefaultLoc" VALUE="30458"/><DATA ATTR="hdnScrId" VALUE="655166"/><DATA 
ATTR="hdnVerLog" VALUE="TAKE 1.0.0.0"/><DATA ATTR="hdnverPkgNm" VALUE="IBAS"/><DATA ATTR="hdnRowid" VALUE="917CC55F-F9DD-4B91-A960-E04210C86165"/><DATA ATTR="hdnGrnLineNo" VALUE="3"/><DATA ATTR="hdnInvYN" VALUE=""/><DATA ATTR="hdnMUom" VALUE="1"/><DATA ATTR="hdnSessionRowId" VALUE="cfb10d65-d74b-47df-8fc7-6d1ccc87a68a"/><DATA ATTR="hdnCmpCurFk" VALUE="1"/><DATA 
ATTR="hdnCmpCurNm" VALUE="INR"/><DATA ATTR="gHistoryTable" VALUE="Historyadmin107201814763"/><DATA ATTR="gHistoryPk" VALUE="0"/><DATA ATTR="hdnUsr" VALUE="admin"/><DATA ATTR="hdnUsrName" VALUE="admin"/><DATA ATTR="hdnUsrLgd" VALUE="1"/><DATA ATTR="hdnRight" VALUE="1"/><DATA ATTR="hdnCurDt" VALUE="10/07/2018"/><DATA ATTR="hdnRptToDt" VALUE="01/06/2019"/><DATA ATTR="hdnPrevModFk" VALUE=""/><DATA ATTR="hdnProPk" VALUE=""/><DATA ATTR="hdnProCd" VALUE=""/><DATA ATTR="hdnProNm" VALUE=""/><DATA ATTR="gAppValue1" VALUE=""/><DATA ATTR="gAppValue2" VALUE=""/><DATA ATTR="gAppValue3" VALUE=""/><DATA ATTR="gAppValue4" VALUE=""/><DATA ATTR="gAppValue5" VALUE=""/><DATA ATTR="gAppValue6" VALUE=""/><DATA ATTR="gAppValue7" VALUE=""/><DATA ATTR="gAppValue8" VALUE=""/><DATA ATTR="hdnUmpFk" VALUE=""/><DATA ATTR="gCurrSepFmt" VALUE=","/><DATA ATTR="gCurrDecFmt" VALUE="."/><DATA ATTR="gCurrDigit" VALUE="2"/><DATA ATTR="gQtyDigit" VALUE="2"/><DATA ATTR="gPOInspFlg" VALUE="0"/><DATA ATTR="hdnPrcFlg" VALUE="0"/><DATA ATTR="gCTWInspFlg" VALUE="0"/><DATA ATTR="hdnVchDescription" VALUE=""/><DATA ATTR="hdnVchCode" VALUE=""/><DATA ATTR="hdnIsManual" VALUE=""/><DATA ATTR="hdnTrans" VALUE=""/><DATA ATTR="hdnPEmpFk" VALUE="0"/><DATA ATTR="hdnEmp" VALUE=""/><DATA ATTR="hdnIurl" VALUE="/TAKESOLUTIONS"/><DATA ATTR="hdnPurl" VALUE=""/><DATA ATTR="hdnOpnPrd" VALUE=""/><DATA ATTR="hdnChngPwd" VALUE="34"/><DATA ATTR="hdnNxtSId" VALUE=""/><DATA ATTR="hdnRdirMod" VALUE=""/><DATA ATTR="hdnDfltMod" VALUE="0"/><DATA ATTR="hdnDfltModNm" VALUE=""/><DATA ATTR="hdnOpnPrdVal" VALUE=""/><DATA ATTR="hdnRedirSrc" VALUE=""/><DATA ATTR="gAppDefCur" VALUE=""/></FORMDATA>
',NULL,NULL,NULL,2

rollback tran

SELECT CONVERT(VARCHAR(19),'01/01/2018', 120)






	SELECT  CrvConvVal,CrvBASCurFk,CrvEffFrm,CrvEffTo   FROM    ProFaCurConvConfig WITH(NOLOCK)  ,ProFaMgGeneral WITH(NOLOCK) 
			WHERE 	GnmDelid=0 AND GnmTyp=6    AND CrvDelId = 0  AND Gnmpk=CrvBasCurFk   AND CrvEffFrm BETWEEN '2017-04-04 00:00:00.000'  AND '2018-05-04 00:00:00.000'
			AND		CrvConCurFk = 1



	