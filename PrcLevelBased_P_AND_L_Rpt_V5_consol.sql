
ALTER PROCEDURE [dbo].[PrcLevelBased_P_AND_L_Rpt_V5_consol]  
(
	@QryId 		CHAR(3)		=	NULL,
	@LocPk 		PKID		=	NULL,
	@xmlLocDoc 	TEXT		=	NULL,
	@LVLNO		INT		=	0,
	@CurDt		VARCHAR(10)	=	Null,
	@CurToDt  	VARCHAR(10)	=	Null,
	@CompDt		VARCHAR(10)	=	Null,
	@CompToDt 	VARCHAR(10)	=	Null,
	@PvnVch		INT 		= 	0,
	@FyrPk		INT		= 	NULL,
	@Scale 		NUMERIC(10)	=	1,
	@ExpPk		BIGINT		=	NULL,
	@ExpXml		TEXT		=	NULL,
	@CustXml 	TEXT		=	NULL,
	@GlobalXml 	TEXT		=	NULL,
	@CurFk		BIGINT		=	NULL,	
	@CmpFk		BIGINT		=	NULL,
	@ShwSubLoc	 TINYINT	  = 0 ,
	@ShwRtTyp    TINYINT      = 0
)

--with encryption
AS
BEGIN
SET NOCOUNT ON	
/*********************
THIS REPORT IS ALTERED SUCH THAT EXPORING OF GROUPS CAN BE ACHIEVED AND TO BE CALLED FROM ANALYSIS
*********************/
 
		/*            
	Author Name 	: <TSENTHIL>
	Created On 		: <Created Date (DD/MM/YYYY) (Leave it blank if unknown)>
	Section 		:  FA
	Purpose 		: Balance Sheet
	Remarks  		: <Remarks if any>
	Reviewed By		: <Reviewed By (Leave it blank)>
	*/
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date		Signature			Description of Changes
	********************************************************************************************************
	TSENTHIL		07/08/2007					To Re-Write the Procedure
	Rajesh			29/08/2007	RJANAINC			To Show PNL in Analysis EAI
	Rajesh			29/08/2007	RJLOC				TO Display all the Location Details when all location is selected in Ana
	Rajesh			04/09/2007	RJTOSHWPDC			To show Pdc only when Combo box is selected as include PDC
	Muthu			29/01/2008	MARI~29012008			For Multiple Location when CalledFor = 'ANA'
	Muthu			02/02/2008	MARI~02022008			Changed Display of Net Profit/Loss 
	Karthi			07/02/2008	RL07022008			To Show Output Based on Frm and To Dt and Place bracket appropriately
	Muthu			31/05/2008	MARI~31052008			Changed the Substring value in Final Select 
	Suresh			08/07/2008	RSRDCIMTFR			Removing Delid Checking In general Masters Tables For Reports
	karthi			15/10/2008	RL15102008			Cost of sale working
	Prakash.N		20/05/2009	Prakash.N~20052009		Include Debit & Credit into the PNL report
	'********************************************************************************************************/


	DECLARE @CURLVL INT
	DECLARE @MAXLVL INT
	DECLARE @MIN_INC_ID VARCHAR(10)
	DECLARE @MIN_EXP_ID VARCHAR(10)		
	DECLARE @GRPNATURE_INC INT
	DECLARE @GRPNATURE_EXP INT
	DECLARE @CrvConvVal NUMERIC(27,7),@BasCurFk BIGINT
	-- For Provisional Entries
	DECLARE @PvnVch1 INT
	DECLARE @PvnVch0 INT
	-- For Financial year 
	DECLARE @CompFyrFk BIGINT
	DECLARE @CurFyrFk  BIGINT
	DECLARE @CurrToDt DATETIME, @ComToDt DATETIME 

	DECLARE @LbhAppSts INT  --this is added to generate based on Application status 

	DECLARE @FYRSTART_DT AS DATETIME
	DECLARE @FYREND_DT AS DATETIME
	DECLARE @OrderTyp INT

	DECLARE @LocTreeId VARCHAR(200)

	SET @LbhAppSts=0  --if AppSts=0 Approved
	IF(ISNULL(@CmpFk,0)=0)
	SELECT @CmpFk=dbo.gefgGetCmpFk(@LocPk)
	SELECT @OrderTyp=dbo.gefgGetCmpCnfgVal('REPORT_DISPLAY_ORDER',@CmpFk,@LocPk)
	SELECT @BasCurFk=CmpCurFk,@CmpFk=CmpPk FROM ProFaMgCmpMas WITH(NOLOCK) WHERE cmpdelid=0
 
	--IF @BasCurFk=@CurFk
	--	SET @CrvConvVal=1
	 IF ISNULL(@CurFk,0)=0
	BEGIN
			--SET @CurFk=@BasCurFk
			--SET @CrvConvVal=1
			SELECT CrvbasCurFk CurFk INTO #temp FROM  ProFaCurConvConfig WITH(NOLOCK)  WHERE   CrvEffTo IS NULL AND CrvDelId = 0 and CrvLocFk =@LocPk
			SELECT @CurFk = gnmpk FROM Profamggeneral WHERE  EXISTS(SELECT NULL FROM #temp WHERE gnmpk =curfk)
	END
	--ELSE
		SELECT @CrvConvVal=ISNULL(CrvConvVal,1)  FROM ProFaCurConvConfig WITH(NOLOCK)  
			where  CrvConCurFk =@CurFk AND CrvEffTo IS NULL AND CrvDelId = 0 AND CrvLocFk =@LocPk

			
		


	CREATE TABLE #CurConv (ConvVal NUMERIC(27,7),CrvBASCurFk BIGINT,CrvEffFrm DATETIME,CrvEffto DATETIME)
	CREATE TABLE #CurConv_OPN (ConvVal NUMERIC(27,7),CrvBASCurFk BIGINT,CrvEffFrm DATETIME,CrvEffto DATETIME)
	CREATE TABLE #BtWnDts(Dates datetime)
	CREATE TABLE #BtWnDts_comp(Dates datetime)
	CREATE TABLE #CurConv_VAL(Val NUMERIC(27,7),BasCurFk BIGINT,Dt DATETIME)
	CREATE TABLE #Calendar(CalendarDate DATETIME)
	CREATE TABLE #Calendar_comp(CalendarDate DATETIME)

	CREATE TABLE #CurConv_comp (ConvVal NUMERIC(27,7),CrvBASCurFk BIGINT,CrvEffFrm DATETIME,CrvEffto DATETIME) 




	/** Create temp table and store the entry type to be showed in reports **/
	Create table #tmpEntryTyp(Type tinyint)
		INSERT INTO #tmpEntryTyp(Type)
		VALUES (0)
	IF ISNULL(@PvnVch,0)=3
	BEGIN
		INSERT INTO #tmpEntryTyp(Type)
		VALUES (1)
		INSERT INTO #tmpEntryTyp(Type)
		VALUES (2)	
	END
	ELSE IF  ISNULL(@PvnVch,0) <> 0
		INSERT INTO #tmpEntryTyp(Type)
		VALUES (@PvnVch)

	CREATE TABLE #TemLoc (loc VARCHAR(50),locpk bigint,chk varchar(3))  

	/* MARI~29012008 Starts */	
/*
	IF @xmlLocDoc is not null  -- TO Create temp table containing selected location pk
	BEGIN
		DECLARE @idoc INT  
	
		EXEC sp_xml_preparedocument @idoc OUTPUT, @xmlLocDoc  
	
		INSERT INTO #TemLoc
		SELECT VALUE,chk
		FROM  OPENXML (@idoc, '/DROPDOWN/LIST',1) WITH   
		( 
		VALUE bigint,chk varchar(3)
		) 
		WHERE chk='-1'

		 EXEC sp_xml_removedocument @idoc  
	END
	ELSE IF @QryId='ANA'
	BEGIN
		INSERT INTO #TemLoc VALUES(@LocPk,'-1')
		IF ISNULL(@LVLNO,0) =0
		SELECT @LVLNO = MAX(grplvlno)+1 FROM ProFaMgLvlDefn WITH(NOLOCK) WHERE GrpTyp = 4 AND GrpDelId = 0
	END	
*/
	IF @xmlLocDoc IS NOT NULL
	BEGIN 	
		DECLARE @idoc INT  
		IF @QryId <> 'ANA'  -- TO Create temp table containing selected location pk
		BEGIN
			
			EXEC sp_xml_preparedocument @idoc OUTPUT, @xmlLocDoc  
		
			INSERT INTO #TemLoc
			SELECT TEXT, VALUE, chk  --B276
			FROM  OPENXML (@idoc, '/DROPDOWN/LIST',1) WITH   
			(   
			TEXT VARCHAR(50), VALUE bigint,chk varchar(3)
			) 
			WHERE chk='-1'
	
		 	EXEC sp_xml_removedocument @idoc
		 
		END
		ELSE IF @QryId='ANA'
		BEGIN
			EXEC sp_xml_preparedocument @idoc OUTPUT, @xmlLocDoc  
		
			INSERT INTO #TemLoc
			SELECT 	VALUE , '-1'
			FROM  OPENXML (@idoc, 'XML/DROPDOWN/LIST',1) WITH   
			(   
			  TEXT VARCHAR(50) ,VALUE BIGINT  
			) 
	
		 	EXEC sp_xml_removedocument @idoc

		END
	END	

	/* MARI~29012008 Ends */	

	
	


	IF @LocPk=0 AND  @xmlLocDoc IS NULL--RJLOC
		INSERT INTO #TemLoc( locpk, chk) 
		SELECT locpk, '-1' FROM profamglocmas WITH (NOLOCK) WHERE --LocDelId=0 AND --RSRDCIMTFR 
			EXISTS(SELECT NULL FROM profamgcmpmas WHERE cmpdelid=0 and cmppk=LocCmpFk AND cmppk=@CmpFk)
	ELSE IF NOT EXISTS(SELECT NULL FROM #TemLoc)
		INSERT INTO #TemLoc(locpk, chk) 
		SELECT locpk, '-1' FROM profamglocmas WITH (NOLOCK) WHERE LocPk = @LocPk --LocDelId=0 AND --RSRDCIMTFR 
	
	/*Sub -loc */
	IF @ShwSubLoc <> 0
	BEGIN
		SELECT @LocTreeId =  LocTreeId FROM profamglocmas WITH (NOLOCK) WHERE LocPk = @LocPk and LocDelId =0 
		SELECT RTRIM(LocDesc) AS LocNm,LocPk locFk INTO #TreeIdWiseLoc FROM profamglocmas  WITH (NOLOCK) WHERE LocTreeId LIKE RTRIM(@LocTreeId) + '%' and  LocDelId =0 --LocPrtFk = @LocPk
		INSERT INTO #TemLoc (Loc, locpk, chk)

		SELECT  LocNm AS 'Loc',locFk,'-1' FROM #TreeIdWiseLoc WITH(NOLOCK) , progemgusrlocmap WITH(NOLOCK) 
		WHERE locFk=ulmlocfk   and UlmDelid = 0  AND NOT EXISTS(SELECT NULL FROM #TemLoc WHERE locpk = locFk)  --and ulmusrfk= @UsrFk
	
	END

	------Start Fetch Group Pks From xml for exploring purpose------------------------------------------------------
	IF @ExpXml IS NOT NULL
	BEGIN
		 EXEC sp_xml_preparedocument @idoc OUTPUT, @ExpXml  
			   	
			     SELECT GrpPk AS GrpFK--Distinct(GrpPk)
			     INTO #TmExpGrpPks
			     FROM  OPENXML (@idoc, '/root/Table1',1) WITH   
			     (   
				GrpPk BIGINT
			     ) GROUP BY GrpPk 
		 EXEC sp_xml_removedocument @idoc  
	END
------End Fetch Group Pks From xml for exploring purpose------------------------------------------------------
	
	IF @LVLNO=0 -- To display Fields and Locations in Filter
	BEGIN
		SELECT  0 AS 'Acccount Head'
		
		SELECT CASE WHEN locpk = @LocPk THEN -1 ELSE 0 END AS 'chk',
		RTRIM(locdesc) AS 'locdesc',locpk 
		FROM ProFaMgLocMas WITH(NOLOCK) --WHERE LocDelId = 0 --RSRDCIMTFR 
	END

	--For Provisional Entries
	IF @PvnVch IS NULL
		SET @PvnVch = 1

	IF @PvnVch = 0 
	BEGIN
		SET @PvnVch0 = 0
		SET @PvnVch1 = 0
	END
	IF @PvnVch = 1 
	BEGIN
		SET @PvnVch0 = 0
		SET @PvnVch1 = 1
	END

	SELECT @MAXLVL = MAX(GrpLvlNo) FROM ProFaMgLvlDefn WITH(NOLOCK) WHERE GrpTyp = 4 AND GrpDelId = 0 
	
	SELECT @FYRSTART_DT = FyrStart FROM ProFaMgFYrDefn WITH(NOLOCK) WHERE FyrPk = @FyrPk AND FyrDelID = 0 




	/* For Getting the financial year start is from and to date falls under different financial years	*/
	SELECT @CompDt = dbo.gefgGetStartDt(@CompDt,@CompToDt,@LocPk)
	SELECT @CurDt = dbo.gefgGetStartDt(@CurDt,@CurToDt,@LocPk)

	SET @CurrToDt  = dbo.gefgChar2Date(@CurToDt,@LocPk)
	SET @ComToDt = dbo.gefgChar2Date(@CompToDt,@LocPk)


	SELECT	@CompFyrFk = FyrPk FROM ProFaMgFyrDefn WITH(NOLOCK) 
			WHERE DATEDIFF( DAY, FyrStart, dbo.gefgChar2Date(@CompDt,@LocPk) ) >= 0 
				AND DATEDIFF( DAY, FyrEnd, dbo.gefgChar2Date(@CompDt,@LocPk) ) <= 0 AND FyrDelId = 0 --RL07022008
	SELECT	@CurFyrFk = FyrPk FROM ProFaMgFyrDefn WITH(NOLOCK) 
			WHERE DATEDIFF( DAY, FyrStart, dbo.gefgChar2Date(@CurDt,@LocPk) ) >= 0
				AND DATEDIFF( DAY, FyrEnd, dbo.gefgChar2Date(@CurDt,@LocPk) ) <= 0 AND FyrDelId = 0 --RL07022008
				
			

	/* code ends */

	SELECT @GRPNATURE_INC = GnmPk FROM ProFaMgGeneral WITH(NOLOCK) WHERE rtrim(gnmcd) = 'INC' AND GnmTyp = 4 AND GnmDelID = 0 --RSRDCIMTFR 
	SELECT @GRPNATURE_EXP = GnmPk FROM ProFaMgGeneral WITH(NOLOCK) WHERE rtrim(gnmcd) = 'EXP' AND GnmTyp = 4 AND GnmDelID = 0 --RSRDCIMTFR 

	SELECT @MIN_INC_ID = MIN(GrpTreeId) FROM ProFaMgLvlDefn WITH (NOLOCK), ProFaMgGeneral WITH (NOLOCK)
		WHERE GnmPk = GrpNature AND rtrim(gnmcd) = 'INC' AND GrpDelId = 0 --AND GnmDelId = 0 --RSRDCIMTFR 

	SELECT @MIN_EXP_ID = MIN(GrpTreeId) FROM ProFaMgLvlDefn WITH (NOLOCK), ProFaMgGeneral WITH (NOLOCK)
		WHERE GnmPk = GrpNature AND rtrim(gnmcd)= 'EXP' AND GrpDelId = 0 --AND GnmDelId = 0 --RSRDCIMTFR 

 	CREATE TABLE #TmpLvlAccDtls(TreeId VARCHAR(500),LvlNo INT, DispNm VARCHAR(700), DispOrder INT, AccDispOrder INT, AccBrkRqd BIGINT, AccTyp INT, 
			AccGrpFK BIGINT, AccPk BIGINT, DrCur NUMERIC(27,7), CrCur NUMERIC(27,7), DrComp NUMERIC(27,7), CrComp NUMERIC(27,7))
 	CREATE TABLE #TmpLvlAcc(GTreeId VARCHAR(500), LvlNo INT, DispNm VARCHAR(700), DispOrder INT, AccDispOrder INT, AccBrkRqd BIGINT, AccTyp INT, 
			AccGrpFK BIGINT, AccPk BIGINT, DrCur NUMERIC(27,7), CrCur NUMERIC(27,7), DrComp NUMERIC(27,7), CrComp NUMERIC(27,7))
 	CREATE TABLE #TmpLvlGrp(TreeId VARCHAR(500), LvlNo INT, DispNm VARCHAR(700), DispOrder INT, GrpNature INT, GrpPk BIGINT, GrpPrtFk BIGINT,
			DrCur NUMERIC(27,7), CrCur NUMERIC(27,7), DrComp NUMERIC(27,7), CrComp NUMERIC(27,7))
 	CREATE TABLE #TmpLvlGrpDtls(TreeId VARCHAR(500), LvlNo INT, DispNm VARCHAR(700), DispOrder INT, GrpNature INT, GrpPk BIGINT, GrpPrtFk BIGINT,
			DrCur NUMERIC(27,7), CrCur NUMERIC(27,7), DrComp NUMERIC(27,7), CrComp NUMERIC(27,7), GenTreeId VARCHAR(500))

 	CREATE TABLE #TmpLvlFinal(GTreeId VARCHAR(500), LvlNo INT, DispNm VARCHAR(700), DispOrder INT, GrpNature INT, AccDispOrder INT,AccBrkRqd BIGINT, 
		AccPk BIGINT, GrpPk BIGINT, GrpPrtFk BIGINT, DrCur NUMERIC(27,7), CrCur NUMERIC(27,7), DrComp NUMERIC(27,7), CrComp NUMERIC(27,7), GenTreeId VARCHAR(500))

--  	CREATE TABLE #TmFinalRpt(DispOrder INT,LvlNo Varchar(5),g INT, DispNm VARCHAR(700), CompBal VARCHAR(100), CompTot VARCHAR(100), CurBal VARCHAR(100), CurTot VARCHAR(100), -- Prakash.N~20052009
-- 		GrpNature INT, AccDispOrder INT, AccPk BIGINT, TreeId VARCHAR(500), GrpPk BIGINT, GrpPrtFk BIGINT, Img CHAR(1), AccBrkRqd BIGINT, GenTreeId VARCHAR(500))

 	CREATE TABLE #TmFinalRpt(DispOrder INT,LvlNo Varchar(5),g INT, DispNm VARCHAR(700), CompBal VARCHAR(100), CompTot VARCHAR(100), CurBal VARCHAR(100), CurTot VARCHAR(100), -- Prakash.N~20052009
		DrComp VARCHAR(100), CrComp VARCHAR(100), DrCur VARCHAR(100), CrCur VARCHAR(100),
		GrpNature INT, AccDispOrder INT, AccPk BIGINT, TreeId VARCHAR(500), GrpPk BIGINT, GrpPrtFk BIGINT, Img CHAR(1), AccBrkRqd BIGINT, GenTreeId VARCHAR(500))

	CREATE TABLE #TmLvl(GenTid VARCHAR(8000), GenGrpPk BIGINT)


	Declare @todt datetime ,@fromdt datetime 



	INSERT	INTO #CurConv
	SELECT * FROM  dbo.gefgConVal(@CurDt,@CurToDt,@LocPk,@CurFk,@ShwRtTyp,@FyrPk)

	
	INSERT	INTO #CurConv_comp
	SELECT * FROM  dbo.gefgConVal(@Compdt,@CompToDt,@LocPk,@CurFk,@ShwRtTyp,@FyrPk)
	
	SELECT * FROM  dbo.gefgConVal(@CurDt,@CurToDt,@LocPk,@CurFk,@ShwRtTyp,@FyrPk)


   --     select CrvConvVal,CrvBasCurFk,CrvEffFrm,CrvEffTo FROM  ProFaCurConvConfig WITH(NOLOCK)  WHERE   CrvEffTo IS NULL AND CrvDelId = 0 and CrvLocFk =@LocPk
			--SELECT @CurFk = gnmpk FROM Profamggeneral WHERE  EXISTS(SELECT NULL FROM #temp WHERE gnmpk =curfk)

	--Here to Select the All Accounts with in the Expanse and Income Groups

	SELECT GrpNature,GrpDesc, GrpLvlNo, GrpPrtFk, GrpTreeId, GrpPk, RTRIM(AccDispNm) AS 'AccDispNm', AccDispOrd as 'AccDispOrder', AccBrkRqd, AccTyp, AccGrpFk, AccLocFk, AccPk, 
		CASE WHEN rtrim(gnmcd) = 'EXP' THEN 2 WHEN rtrim(gnmcd) = 'INC' THEN 1 END AS 'DispOrder'
		INTO #TmpGrpAccDtls
		FROM ProFaMgLvlDefn WITH(NOLOCK), ProFaMgAccDefn WITH(NOLOCK), ProFaMgGeneral WITH(NOLOCK) 
		WHERE AccGrpFk=GrpPk AND GrpTyp = 4 AND AccDelID = 0 AND GrpDelID = 0 AND GrpNature IN (@GRPNATURE_INC,@GRPNATURE_EXP) AND GnmPK = GrpNature


	

		IF @ShwRtTyp = 2
BEGIN

select @ShwRtTyp

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

DECLARE @StartDate_comp DATETIME
DECLARE @EndDate_comp DATETIME


SELECT  @StartDate = FyrStart FROM ProFaMgFyrDefn WITH(NOLOCK) WHERE FyrDelId = 0 AND FyrPK = @CurFyrFk
SELECT @EndDate = FyrEnd FROM ProFaMgFyrDefn WITH(NOLOCK) WHERE FyrDelId = 0 AND FyrPK = @CurFyrFk

SELECT  @StartDate_comp = FyrStart FROM ProFaMgFyrDefn WITH(NOLOCK) WHERE FyrDelId = 0 AND FyrPK = @CompFyrFk
SELECT @EndDate_comp = FyrEnd FROM ProFaMgFyrDefn WITH(NOLOCK) WHERE FyrDelId = 0 AND FyrPK = @CompFyrFk


WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO #Calendar
             (
                   CalendarDate
             )
             SELECT
                   @StartDate

             SET @StartDate = DATEADD(dd, 1, @StartDate)
      END

	

SELECT a.ConvVal,a.CrvBASCurFk,b.CalendarDate AS Start, b.CalendarDate+1 AS [End] INTO #CurConv_TRAN
FROM #CurConv a
JOIN #Calendar b
  ON b.CalendarDate BETWEEN a.CrvEffFrm AND a.CrvEffto
  where  ISNULL(CrvEffto,'') <> '' AND B.CalendarDate <> A.CrvEffto 
order by Start

DELETE FROM #CurConv WHERE ISNULL(CrvEffto,'') <> ''

INSERT INTO #CurConv
SELECT * FROM #CurConv_TRAN


WHILE @StartDate_comp <= @EndDate_comp
      BEGIN
             INSERT INTO #Calendar_comp
             (
                   CalendarDate
             )
             SELECT
                   @StartDate_comp

             SET @StartDate_comp = DATEADD(dd, 1, @StartDate_comp)
      END

	

SELECT a.ConvVal,a.CrvBASCurFk,b.CalendarDate AS Start, b.CalendarDate+1 AS [End] INTO #CurConv_TRAN_comp
FROM #CurConv_comp a
JOIN #Calendar_comp b
  ON b.CalendarDate BETWEEN a.CrvEffFrm AND a.CrvEffto
  where  ISNULL(CrvEffto,'') <> '' AND B.CalendarDate <> A.CrvEffto 
order by Start

DELETE FROM #CurConv_comp WHERE ISNULL(CrvEffto,'') <> ''

INSERT INTO #CurConv_comp
SELECT * FROM #CurConv_TRAN_comp



END

--SELECT * FROM #CurConv
--return

	IF @ShwRtTyp = 2
	BEGIN
		DECLARE @i INT,@j INT,@date DATETIME,@MAXDt DATETIME
		SELECT @MAXDt = crvefffrm FROM #CurConv WHERE CrvEffTo IS NULL

		
		SELECT @j =( select DATEDIFF(DAY,@maxdt,@CurrToDt ) )
		
		SET @date = @CurrToDt 

		--select @date 
		SET @i =0
		
		WHILE @i < @j
		BEGIN
			INSERT INTO #BtWnDts
			SELECT @date -@i   


			SET @i = @i + 1	
		END

		UPDATE #CurConv SET CrvEffto = @CurrToDt  WHERE CrvEffto IS NULL
		

		IF EXISTS(SELECT NULL FROM #CurConv)
		BEGIN
		
			INSERT INTO #CurConv_VAL
			SELECT ConvVal,CrvBASCurFk,Dates 
			FROM #CurConv
			JOIN #BtWnDts ON  Dates BETWEEN CrvEffFrm  AND CrvEffto --AND Dates <> CrvEffto

			INSERT INTO #CurConv(ConvVal,CrvBASCurFk,CRVEFFFRM)
			SELECT  Val,BASCurFk,Dt FROM #CurConv_VAL
		END

			

		---SELECT * FROM #CurConv


		delete from #CurConv_VAL

			SELECT @MAXDt = crvefffrm FROM #CurConv_comp WHERE CrvEffTo IS NULL

		
		SELECT @j =( select DATEDIFF(DAY,@maxdt,@ComToDt) )
		
		SET @date = @ComToDt 

		--select @date 
		SET @i =0
		
		WHILE @i < @j
		BEGIN
			INSERT INTO #BtWnDts_comp
			SELECT @date -@i   


			SET @i = @i + 1	
		END

		UPDATE #CurConv_comp SET CrvEffto = @ComToDt   WHERE CrvEffto IS NULL
		

		IF EXISTS(SELECT NULL FROM #CurConv_comp)
		BEGIN
		
			INSERT INTO #CurConv_VAL
			SELECT ConvVal,CrvBASCurFk,Dates 
			FROM #CurConv_comp
			JOIN #BtWnDts_comp ON  Dates BETWEEN CrvEffFrm  AND CrvEffto --AND Dates <> CrvEffto

			INSERT INTO #CurConv_comp(ConvVal,CrvBASCurFk,CRVEFFFRM)
			SELECT  Val,BASCurFk,Dt FROM #CurConv_VAL
		END

		--select * from #curconv_comp


	END


		DECLARE @CurrRt  NUMERIC(27,7)
	SET @CurrRt = 1.0000000

	--To Select All Current Dates  Transactions Accounts

	INSERT INTO #TmpLvlAccDtls
	SELECT RTRIM(GrpTreeID) + 'A' as GTreeID, GrpLvlNo, AccDispNm, DispOrder, AccDispOrder, AccBrkRqd, AccTyp, AccGrpFK, AccPk, 
			CASE
 WHEN SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END ) > 0 THEN
				SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END )
			ELSE
				0
			END AS 'DrCur',
			CASE WHEN SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
                WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END ) < 0 THEN
				ABS(SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END ))
			ELSE
				0
			END AS 'CrCur',0 as 'DrComp',0 as 'CrComp'
	FROM ProFaGLbkHdr WITH (NOLOCK), ProFaGlBkDtls WITH (NOLOCK), #TmpGrpAccDtls, #TemLoc, #tmpEntryTyp,#CurConv
	WHERE LbhPk = LbdLbhFk AND LbdAccFk = AccPk AND LbhLocFk = LocPk AND LbhPvnVch = Type AND 
	LbhCurrFk=CrvBasCurFk AND LbhVchDt = CASE WHEN @ShwRtTyp = 2 THEN CrvEffFrm ELSE LbhVchDt END
		AND LbhFyrFk = @CurFyrFk AND LbhAppSts = @LbhAppSts 
		AND LbhDelId = 0 AND LbdDelId = 0 AND ((DATEDIFF(DAY,LbhVchDt,dbo.gefgChar2Date(@CurDt,@LocPk)) <= 0 ) ) --RL07022008
		AND ((DATEDIFF(DAY,LbhVchDt,@CurrToDt) >= 0 ) ) 
	GROUP BY  GrpTreeId, GrpLvlNo, AccDispNm, DispOrder, AccDispOrder, AccBrkRqd, AccTyp, AccGrpFK, AccPk

 
 --select * from #TmpLvlAccDtls

	--To Select All Comparitive Dates  Transactions Accounts

	INSERT INTO #TmpLvlAccDtls
	SELECT RTRIM(GrpTreeID) + 'A' as GTreeID, GrpLvlNo, AccDispNm, DispOrder, AccDispOrder, AccBrkRqd, AccTyp, AccGrpFK, AccPk,0 as 'DrCur',0 as 'CrCur', 
			CASE WHEN SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END ) > 0 THEN
				SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END )
			ELSE
				0
			END AS 'DrComp',
			CASE WHEN SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END ) < 0 THEN
				ABS(SUM(CASE WHEN LbhCurrFk = @CurFk THEN
					LbdDrAmt - LbdCrAmt
					WHEN LbhCurrFk <> @CurFk AND LbhCurrRt <> @CurrRt AND ConvVal <> @CurrRt THEN ((LbdDrAmt - LbdCrAmt) / ConvVal)
				ELSE
					(((LbdDrAmt - LbdCrAmt) * LbhCurrRt) / ConvVal)
				END ))
			ELSE
				0
			END AS 'CrComp'
	FROM ProFaGLbkHdr WITH (NOLOCK), ProFaGlBkDtls WITH (NOLOCK), #TmpGrpAccDtls, #TemLoc, #tmpEntryTyp,#CurConv_comp
	WHERE LbhPk = LbdLbhFk AND LbdAccFk = AccPk AND LbhLocFk = LocPk AND LbhPvnVch = Type AND
	LbhCurrFk=CrvBasCurFk AND LbhVchDt = CASE WHEN @ShwRtTyp = 2 THEN CrvEffFrm ELSE LbhVchDt END
		AND LbhFyrFk = @CompFyrFk AND LbhAppSts = @LbhAppSts 
		AND LbhDelId = 0 AND LbdDelId = 0 AND ((DATEDIFF(DAY,LbhVchDt,dbo.gefgChar2Date(@CompDt,@LocPk)) <= 0 ) ) --RL07022008
		AND ((DATEDIFF(DAY,LbhVchDt,@ComToDt) >= 0 ) ) 
	GROUP BY  GrpTreeId, GrpLvlNo, AccDispNm, DispOrder, AccDispOrder, AccBrkRqd, AccTyp, AccGrpFK, AccPk

	--select * from #TmpLvlAccDtls


	--To Merge All Current and Comparitive Dates  Transactions Accounts

	INSERT INTO #TmpLvlAcc
	SELECT TreeId as GTreeID, LvlNo, DispNm, DispOrder, AccDispOrder, AccBrkRqd, AccTyp, AccGrpFK, AccPk, SUM(DrCur), SUM(CrCur), SUM(DrComp), SUM(CrComp)
			FROM #TmpLvlAccDtls GROUP BY TreeId, LvlNo, DispNm, DispOrder, AccDispOrder, AccBrkRqd, AccTyp, AccGrpFK, AccPk


			--select * from #TmpLvlAcc

	--To Calculate the Group Wise Total

	SET @CURLVL = 1

	WHILE @CURLVL <= @MAXLVL
	BEGIN
		-- For Generating Tree ID
		INSERT INTO #TmLvl
			SELECT ISNULL(AC.GenTid,'') + dbo.gefgGetPadZero(5,ISNULL(GrpDispOrd,0)) ,GrpPk
			FROM ProFaMgLvlDefn  WITH(NOLOCK) 
			LEFT OUTER JOIN #TmLvl AC ON AC.GenGrpPk=GrpPrtFk
			WHERE GrpTyp =4 AND GrpLvlNo=@CURLVL AND GrpDelId=0

		INSERT INTO #TmpLvlGrp
		SELECT RTRIM(LEFT(GTreeID,5*@CURLVL)) as GTid, @CURLVL, RTRIM(GrpDispNm) as 'GrpDispNm',  
		CASE WHEN rtrim(gnmcd) = 'EXP' THEN 2 WHEN rtrim(gnmcd) = 'INC' THEN 1 END AS 'DispOrder', GrpNature,
		GrpPk, GrpPrtFk, SUM(DrCur), SUM(CrCur), SUM(DrComp), SUM(CrComp)
			FROM #TmpLvlAcc, ProFaMgLvlDefn WITH (NOLOCK), ProFaMgGeneral WITH(NOLOCK)
			WHERE NOT EXISTS(SELECT TreeID FROM #TmpLvlGrpDtls WHERE TreeId = GTreeID) 
			AND GrpTreeId = RTRIM(LEFT(GTreeID,5*@CURLVL)) AND GrpDelId = 0 AND GrpNature = GnmPk
				GROUP BY RTRIM(LEFT(GTreeID,5*@CURLVL)),GrpDispNm, GrpNature, gnmcd, GrpPk, GrpPrtFk

		SET @CURLVL = @CURLVL + 1	
	END

	INSERT INTO #TmpLvlGrpDtls
	SELECT RTRIM(LEFT(TreeID,5*@CURLVL)) as GTid, LvlNo, RTRIM(DispNm) as 'GrpDispNm', DispOrder, GrpNature,
	GrpPk, GrpPrtFk, DrCur, CrCur, DrComp, CrComp, GenTid FROM #TmpLvlGrp LEFT OUTER JOIN #TmLvl ON GrpPk=GenGrpPk				

	--RL15102008 Starts
	DECLARE @CurCOS NUMERIC(27, 7), @CompCOS NUMERIC(27, 7), @OPNCurCOS NUMERIC(27, 7), @OPNCompCOS NUMERIC(27, 7)

	SET @CurCOS = 0
	SET @CompCOS = 0

	IF dbo.gefgGetCmpCnfgVal('CmpBusiTyp', @CmpFk,@LocPk) = 1
	BEGIN
		SELECT @OPNCurCOS = SUM(ISNULL(SbdRvdQty, 0) * ISNULL(SbdQtySgn, 0) * ISNULL(SbdValnRt, 0) )
			FROM ProInvStkBkHdr WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), ProFaMgGeneral WITH(NOLOCK), #TemLoc
			WHERE SbhLocFk = LocPk AND GnmPk = SbhVchTypFk AND SbhPk = SbdSbhFk AND SbhDelId = 0 AND SbdDelId = 0 --AND GnmCd = 'OPNSTK' 
				AND ( DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CurDt,@LocPk) ) >= 0 OR 
					( GnmCd = 'OPNSTK' AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CurToDt,@LocPk) ) >= 0 ))
				AND SbhAppSts = 0

		SELECT @OPNCurCOS = ISNULL(@OPNCurCOS, 0) + ISNULL( SUM(ISNULL(IpdPrmQty, 0) * ISNULL(IpdPrmAmt, 0) * ISNULL(SbdQtySgn, 0) ), 0)
			FROM ProInvIsuValParmDtls WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), ProInvStkBkHdr WITH(NOLOCK), #TemLoc
		WHERE SbhPk = SbdSbhFk And IpdSldFk = SbdPk AND ISNULL(SbdValnRt, 0) = 0
				AND SbhLocFk = locpk AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CurDt,@LocPk) ) >= 0
				AND Ipddelid = 0 AND SbdDelId = 0 AND SbhDelId = 0
				AND SbhAppSts = 0

		SELECT @OPNCompCOS = SUM(ISNULL(SbdRvdQty, 0) * ISNULL(SbdQtySgn, 0) * ISNULL(SbdValnRt, 0) )
			FROM ProInvStkBkHdr WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), ProFaMgGeneral WITH(NOLOCK), #TemLoc
			WHERE SbhLocFk = LocPk AND GnmPk = SbhVchTypFk AND SbhPk = SbdSbhFk AND SbhDelId = 0 AND SbdDelId = 0 --AND GnmCd = 'OPNSTK' 
				--AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompDt) ) >= 0
				AND ( DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompDt,@LocPk) ) >= 0 OR 
					( GnmCd = 'OPNSTK' AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompToDt,@LocPk) ) >= 0 ))
				AND SbhAppSts = 0

		SELECT @OPNCompCOS = ISNULL(@OPNCompCOS, 0) + ISNULL( SUM(ISNULL(IpdPrmQty, 0) * ISNULL(IpdPrmAmt, 0) * ISNULL(SbdQtySgn, 0) ), 0)
			FROM ProInvIsuValParmDtls WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), ProInvStkBkHdr WITH(NOLOCK), #TemLoc
		WHERE SbhPk = SbdSbhFk And IpdSldFk = SbdPk AND ISNULL(SbdValnRt, 0) = 0
				AND SbhLocFk = locpk AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompDt,@LocPk) ) >= 0
				AND Ipddelid = 0 AND SbdDelId = 0 AND SbhDelId = 0
				AND SbhAppSts = 0

		SELECT @CurCOS = SUM(ISNULL(SbdRvdQty, 0) * ISNULL(SbdQtySgn, 0) * ISNULL(SbdValnRt, 0) )
			FROM ProInvStkBkHdr WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), #TemLoc
			WHERE SbhLocFk = LocPk AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CurDt,@LocPk) ) <= 0 
				AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CurToDt,@LocPk) ) >= 0
				AND SbhPk = SbdSbhFk AND SbhDelId = 0 AND SbdDelId = 0
				AND SbhAppSts = 0

		SELECT @CurCOS = ISNULL( @CurCOS, 0 ) + ISNULL( SUM(ISNULL(IpdPrmQty, 0) * ISNULL(IpdPrmAmt, 0) * ISNULL(SbdQtySgn, 0) ), 0)
			FROM ProInvIsuValParmDtls WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), ProInvStkBkHdr WITH(NOLOCK), #TemLoc
		WHERE SbhPk = SbdSbhFk And IpdSldFk = SbdPk AND ISNULL(SbdValnRt, 0) = 0
				AND SbhLocFk = LocPk AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CurToDt,@LocPk) ) >= 0
				AND Ipddelid = 0 AND SbdDelId = 0 AND SbhDelId = 0
				AND SbhAppSts = 0

		SELECT @CompCOS = SUM(ISNULL(SbdRvdQty, 0) * ISNULL(SbdQtySgn, 0) * ISNULL(SbdValnRt, 0) )
			FROM ProInvStkBkHdr WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), #TemLoc
			WHERE SbhLocFk = LocPk AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompDt,@LocPk) ) <= 0 
				AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompToDt,@LocPk) ) >= 0
				AND SbhPk = SbdSbhFk AND SbhDelId = 0 AND SbdDelId = 0
				AND SbhAppSts = 0

		SELECT @CompCOS = ISNULL( @CompCOS, 0 ) + ISNULL( SUM(ISNULL(IpdPrmQty, 0) * ISNULL(IpdPrmAmt, 0) * ISNULL(SbdQtySgn, 0) ), 0)
			FROM ProInvIsuValParmDtls WITH(NOLOCK), ProInvStkBkDtls WITH(NOLOCK), ProInvStkBkHdr WITH(NOLOCK), #TemLoc
		WHERE SbhPk = SbdSbhFk And IpdSldFk = SbdPk AND ISNULL(SbdValnRt, 0) = 0
				AND SbhLocFk = LocPk AND DATEDIFF( DAY, SbhVchDt, dbo.gefgChar2Date(@CompToDt,@LocPk) ) >= 0
				AND Ipddelid = 0 AND SbdDelId = 0 AND SbhDelId = 0
				AND SbhAppSts = 0

 		SELECT @CurCOS = ISNULL(@OPNCurCOS, 0) - ISNULL(@CurCOS, 0)
 		SELECT @CompCOS = ISNULL(@OPNCompCOS, 0) - ISNULL(@CompCOS, 0)

		IF @CurCOS <> 0
			SET @CurCOS = @CurCOS / @CrvConvVal

		IF @CompCOS <> 0
			SET @CompCOS = @CompCOS / @CrvConvVal

		INSERT INTO #TmFinalRpt(TreeId,LvlNo, g, DispNm, CompBal, CompTot, CurBal, CurTot,GrpNature, DispOrder,GenTreeId)
		SELECT 'ABCDE','0', NULL, '(Increase) / Decrease in Stock',
			CASE WHEN @CompCOS > 0 THEN dbo.GefgCurFormat( ( @CompCOS / @Scale ), @CmpFk,@LocPk ) 
				ELSE '(' + dbo.GefgCurFormat( ( ABS(@CompCOS) / @Scale ), @CmpFk,@LocPk ) + ')' END AS 'CompBal','',
			CASE WHEN @CurCOS > 0 THEN dbo.GefgCurFormat( ( @CurCOS / @Scale ), @CmpFk,@LocPk ) 
				ELSE '(' + dbo.GefgCurFormat( ( ABS(@CurCOS) / @Scale ), @CmpFk,@LocPk ) + ')' END AS 'CurBal',
			--dbo.GefgCurFormat( ( @CurCOS / @Scale ), @CmpFk ) AS 'CurBal',
			'', @GRPNATURE_EXP, 1,'999'

	END

	--To Calculate the Final Total for Net Profit/Loss
	INSERT INTO #TmFinalRpt(TreeId,LvlNo, g, DispNm, CompBal, CompTot, CurBal, CurTot,GrpNature, DispOrder,GenTreeId)
	SELECT 'ABCDE','0', @GRPNATURE_EXP, 'Net (Profit)/Loss',   -- MARI~02022008
		CASE 	WHEN (SUM(ISNULL(DrComp,0))-SUM(ISNULL(CrComp,0)) + @CompCOS ) > 0 	THEN 
				dbo.GefgCurFormat(((SUM(ISNULL(DrComp,0))-SUM(ISNULL(CrComp,0)) + @CompCOS)/@Scale),@CmpFk,@LocPk)
			WHEN (SUM(ISNULL(DrComp,0))-SUM(ISNULL(CrComp,0)) + @CompCOS ) < 0 	THEN 
				'(' + dbo.GefgCurFormat(ABS(((SUM(ISNULL(DrComp,0))-SUM(ISNULL(CrComp,0)) + @CompCOS)/@Scale)),@CmpFk,@LocPk) + ')'
			WHEN ISNULL((SUM(ISNULL(DrComp,0))-SUM(ISNULL(CrComp,0)) + @CompCOS),0) = 0 THEN			
			'' 
		END AS 'CompBal','',
		CASE 	WHEN (SUM(ISNULL(DrCUR,0))-SUM(ISNULL(CrCUR,0)) + @CurCOS) > 0 	THEN 
				dbo.GefgCurFormat(((SUM(ISNULL(DrCUR,0))-SUM(ISNULL(CrCUR,0)) + @CurCOS)/@Scale),@CmpFk,@LocPk)
			WHEN (SUM(ISNULL(DrCUR,0))-SUM(ISNULL(CrCUR,0)) + @CurCOS) < 0 	THEN 
				'(' + dbo.GefgCurFormat(ABS(((SUM(ISNULL(DrCUR,0))-SUM(ISNULL(CrCUR,0)) + @CurCOS)/@Scale)),@CmpFk,@LocPk) + ')'
			WHEN ISNULL((SUM(ISNULL(DrCUR,0)) - SUM(ISNULL(CrCUR,0)) + @CurCOS),0) = 0 THEN 			
			'' 
		END AS 'CurBal','', @GRPNATURE_EXP, 1,'999' 
		FROM #TmpLvlAccDtls
	--RL15102008 Ends
	
	--To Sperate the records by level wise

	IF(@LVLNO >= @MAXLVL+1)
	BEGIN
		--Taking Group Total Values
		INSERT INTO #TmpLvlFinal
		SELECT RTRIM(TreeID) + 'ABC', LvlNo, 'Total '+ RTRIM(DispNm), DispOrder, GrpNature, NULL, NULL, NULL, GrpPk, GrpPrtFk, DrCur, CrCur, DrComp, CrComp, GenTreeId+ 'ABC' 
			FROM #TmpLvlGrpDtls ONE 
				WHERE LvlNo < @LVLNO

		--Taking Account Information
		INSERT INTO #TmpLvlFinal
		SELECT GTreeID, LvlNo+1, DispNm, DispOrder, AccTyp, AccDispOrder, AccBrkRqd, AccPk, NULL, NULL, DrCur, CrCur, DrComp, CrComp, GenTid + 'A' 
		FROM #TmpLvlAcc  LEFT OUTER JOIN #TmLvl ON AccGrpFK=GenGrpPk
		
		--Taking Group Wise Values
		INSERT INTO #TmpLvlFinal
		SELECT TreeID, LvlNo, DispNm, DispOrder,  GrpNature, NULL, NULL, NULL, GrpPk, GrpPrtFk,
			CASE WHEN LvlNo = @LVLNO THEN DrCur ELSE 0 END, CASE WHEN LvlNo = @LVLNO THEN CrCur ELSE 0 END,
			CASE WHEN LvlNo = @LVLNO THEN DrComp ELSE 0 END, CASE WHEN LvlNo = @LVLNO THEN CrComp ELSE 0 END, GenTreeId
			FROM #TmpLvlGrpDtls
	END
	ELSE		
	BEGIN
		--Taking Group Wise Total Values
		INSERT INTO #TmpLvlFinal
		SELECT RTRIM(
TreeID) + 'ABC', LvlNo, 'Total '+ RTRIM(DispNm), DispOrder, GrpNature, NULL, NULL, NULL, GrpPk, GrpPrtFk, DrCur, CrCur, DrComp, CrComp, GenTreeId+ 'ABC' 
			FROM #TmpLvlGrpDtls ONE 
				WHERE LvlNo < @LVLNO
					AND EXISTS ( SELECT NULL FROM #TmpLvlGrpDtls TWO WHERE ONE.GrpPk = TWO.GrpPrtFk )
		
		IF @ExpPk IS NOT NULL
		BEGIN
			--This is to get the Account Details
			INSERT INTO #TmpLvlFinal
			SELECT GTreeID, LvlNo+1, DispNm, DispOrder, AccTyp, AccDispOrder, AccBrkRqd, AccPk, NULL, NULL, DrCur, CrCur,
					DrComp, CrComp, GenTid + 'A'
				FROM #TmpLvlAcc Acc JOIN #TmExpGrpPks ON GrpFk = AccGrpFK
				LEFT OUTER JOIN #TmLvl ON AccGrpFK=GenGrpPk

			--Taking Drilldowned Group's Total
			INSERT INTO #TmpLvlFinal
			SELECT RTRIM(TreeID) + 'ABC', LvlNo, 'Total ' + RTRIM(DispNm), DispOrder, GrpNature, NULL, NULL, NULL, GrpPk, GrpPrtFk,
				CASE WHEN GrpPk = GrpFk THEN DrCur ELSE 0 END, CASE WHEN GrpPk = GrpFk THEN CrCur ELSE 0 END,
				CASE WHEN GrpPk = GrpFk THEN DrComp ELSE 0 END, CASE WHEN GrpPk = GrpFk THEN CrComp ELSE 0 END, GenTreeId+ 'ABC'
				FROM #TmpLvlGrpDtls Grp, #TmExpGrpPks
				WHERE GrpPk = GrpFk AND NOT EXISTS (SELECT NULL FROM #TmpLvlFinal Lvl WHERE Lvl.GrpPk = Grp.GrpPk AND GTreeId = RTRIM(TreeId) + 'ABC')

			/*--Taking Drilldowned Group's wise list
			INSERT INTO #TmpLvlFinal
			SELECT Grp.TreeID, Grp.LvlNo, Grp.DispNm, Grp.DispOrder, Grp.GrpNature, NULL, NULL, NULL, Grp.GrpPk, Grp.GrpPrtFk,
				CASE WHEN Grp.GrpPrtFk <> Grp.GrpPk AND RTRIM(Lvl1.GTreeId) IS NOT NULL THEN 0 ELSE Grp.DrCur END, CASE WHEN Grp.GrpPrtFk <> Grp.GrpPk AND RTRIM(Lvl1.GTreeId) IS NOT NULL THEN 0 ELSE Grp.CrCur END,
				CASE WHEN Grp.GrpPrtFk <> Grp.GrpPk AND RTRIM(Lvl1.GTreeId) IS NOT NULL THEN 0 ELSE Grp.DrComp END, CASE WHEN Grp.GrpPrtFk <> Grp.GrpPk AND RTRIM(Lvl1.GTreeId) IS NOT NULL THEN 0 ELSE Grp.CrComp END, Grp.GenTreeId
				FROM #TmpLvlGrpDtls Grp JOIN #TmExpGrpPks
					ON GrpPrtFk = GrpFk AND NOT EXISTS (SELECT NULL FROM #TmpLvlFinal Lvl WHERE Lvl.GrpPk = Grp.GrpPk AND GTreeId = TreeId)
						LEFT OUTER JOIN #TmpLvlFinal Lvl1 ON RTRIM(Grp.TreeID) + 'A' = RTRIM(Lvl1.GTreeId)
			*/
			--Taking Drilldowned Group's wise list
			INSERT INTO #TmpLvlFinal
			SELECT Grp.TreeID, Grp.LvlNo, Grp.DispNm, Grp.DispOrder, GrpNature , NULL, NULL, NULL, Grp.GrpPk, Grp.GrpPrtFk,
				NULL, NULL, NULL, NULL, Grp.GenTreeId
				FROM #TmpLvlGrpDtls Grp, #TmExpGrpPks
					WHERE GrpPrtFk = GrpFk AND NOT EXISTS (SELECT NULL FROM #TmpLvlFinal Lvl WHERE Lvl.GrpPk = Grp.GrpPk AND GTreeId = TreeId)
						AND EXISTS ( SELECT NULL FROM #TmpLvlFinal Lvl1 WHERE ( RTRIM(Grp.TreeID) + 'A' = RTRIM(Lvl1.GTreeId) OR RTRIM(Grp.TreeID) + 'ABC' = RTRIM(Lvl1.GTreeId) ) )

			--Taking Drilldowned Group's wise list
			INSERT INTO #TmpLvlFinal
			SELECT Grp.TreeID, Grp.LvlNo, Grp.DispNm, Grp.DispOrder, GrpNature , NULL, NULL, NULL, Grp.GrpPk, Grp.GrpPrtFk,
				Grp.DrCur , Grp.CrCur, Grp.DrComp, Grp.CrComp ,Grp.GenTreeId
				FROM #TmpLvlGrpDtls Grp, #TmExpGrpPks
					WHERE GrpPrtFk = GrpFk AND NOT EXISTS (SELECT NULL FROM #TmpLvlFinal Lvl WHERE Lvl.GrpPk = Grp.GrpPk AND GTreeId = TreeId)
						AND NOT EXISTS ( SELECT NULL FROM #TmpLvlFinal Lvl1 WHERE ( RTRIM(Grp.TreeID) + 'A' = RTRIM(Lvl1.GTreeId) OR RTRIM(Grp.TreeID) + 'ABC' = RTRIM(Lvl1.GTreeId) ) )

		END

		--To take the Level selected group wise values
		INSERT INTO #TmpLvlFinal
		SELECT Grp.TreeID, Grp.LvlNo, Grp.DispNm, Grp.DispOrder, Grp.GrpNature, NULL, NULL, NULL, Grp.GrpPk, Grp.GrpPrtFk,
			CASE WHEN ISNULL(Lvl.GTreeId, '') = '' THEN Grp.DrCur ELSE 0 END, CASE WHEN ISNULL(Lvl.GTreeId, '') = '' THEN Grp.CrCur ELSE 0 END,
			CASE WHEN ISNULL(Lvl.GTreeId, '') = '' THEN Grp.DrComp ELSE 0 END, CASE WHEN ISNULL(Lvl.GTreeId, '') = '' THEN Grp.CrComp ELSE 0 END, Grp.GenTreeId
			FROM #TmpLvlGrpDtls Grp LEFT OUTER JOIN #TmpLvlFinal Lvl ON RTRIM(TreeId) + 'ABC' = RTRIM(GTreeId)
			WHERE Grp.LvlNo <= @LVLNO
				AND NOT EXISTS (SELECT NULL FROM #TmpLvlFinal Lvl1 WHERE Lvl1.GrpPk = Grp.GrpPk AND GTreeId = RTRIM(TreeId))
	END

	--To insert the records for final display

 	INSERT INTO #TmFinalRpt
	SELECT DispOrder,LvlNo,GrpNature as 'g' ,
		ISNULL(Space(5*(ISNULL(LvlNo,0)-1)+1),'')+RTRIM(DispNm) AS'DispNm',
		--ISNULL(REPLICATE('.',5*(ISNULL(LvlNo,0)-1)+1),'')+RTRIM(DispNm) AS'DispNm',		
		CASE WHEN RIGHT(GTreeID,3) <> 'ABC' THEN 
			CASE WHEN (DrComp-CrComp) > 0 THEN
				dbo.GefgCurFormat(((DrComp-CrComp)/@Scale),@CmpFk,@LocPk)
			WHEN (DrComp-CrComp) < 0 THEN '(' + dbo.GefgCurFormat(ABS((DrComp-CrComp)/@Scale),@CmpFk,@LocPk) + ')' 
			WHEN ISNULL((DrComp-CrComp),0)=0 THEN '' END 
		END AS 'CompBal',		
		CASE WHEN RIGHT(GTreeID,3) = 'ABC' THEN 
			CASE WHEN (DrComp-CrComp) > 0 THEN
				dbo.GefgCurFormat(((DrComp-CrComp)/@Scale),@CmpFk,@LocPk)
			WHEN (DrComp-CrComp) < 0 THEN '(' + dbo.GefgCurFormat(ABS((DrComp-CrComp)/@Scale),@CmpFk,@LocPk) + ')' 
			WHEN ISNULL((DrComp-CrComp),0)=0 THEN '' END 
		END AS 'CompTot',		
		CASE WHEN RIGHT(GTreeID,3) <> 'ABC' THEN 
			CASE WHEN (DrCur-CrCur) > 0 THEN
				dbo.GefgCurFormat(((DrCur-CrCur)/@Scale),@CmpFk,@LocPk)
			WHEN (DrCur-CrCur) < 0 THEN '(' + dbo.GefgCurFormat(ABS((DrCur-CrCur)/@Scale),@CmpFk,@LocPk) + ')' 
			WHEN ISNULL((DrCur-CrCur),0)=0 THEN '' END 
		END AS 'CurBal',		
		CASE WHEN RIGHT(GTreeID,3) = 'ABC' THEN 
			CASE WHEN (DrCur-CrCur) > 0 THEN
				dbo.GefgCurFormat(((DrCur-CrCur)/@Scale),@CmpFk,@LocPk)
			WHEN (DrCur-CrCur) < 0 THEN '(' + dbo.GefgCurFormat(ABS((DrCur-CrCur)/@Scale),@CmpFk,@LocPk) + ')' 
			WHEN ISNULL((DrCur-CrCur),0)=0 THEN '' END 
		END AS 'CurTot',
-- Prakash.N~20052009
			CASE WHEN (DrComp) > 0 THEN
			dbo.GefgCurFormat(((DrComp)/@Scale), @CmpFk,@LocPk)
			WHEN (DrComp) < 0 THEN '(' + dbo.GefgCurFormat(ABS((DrComp)/@Scale), @CmpFk,@LocPk) + ')'
			WHEN ISNULL((DrComp),0)=0 THEN '' END,
			CASE WHEN (CrComp) > 0 THEN
			dbo.GefgCurFormat(((CrComp)/@Scale), @CmpFk,@LocPk)
			WHEN (CrComp) < 0 THEN '(' + dbo.GefgCurFormat(ABS((CrComp)/@Scale), @CmpFk,@LocPk) + ')'
			WHEN ISNULL((CrComp),0)=0 THEN '' END,
			CASE WHEN (DrCur) > 0 THEN
			dbo.GefgCurFormat(((DrCur)/@Scale), @CmpFk,@LocPk)
			WHEN (DrCur) < 0 THEN '(' + dbo.GefgCurFormat(ABS((DrCur)/@Scale), @CmpFk,@LocPk) + ')'
			WHEN ISNULL((DrCur),0)=0 THEN '' END,
			CASE WHEN (CrCur) > 0 THEN
			dbo.GefgCurFormat(((CrCur)/@Scale), @CmpFk,@LocPk)
			WHEN (CrCur) < 0 THEN '(' + dbo.GefgCurFormat(ABS((CrCur)/@Scale), @CmpFk,@LocPk) + ')'
			WHEN ISNULL((CrCur),0)=0 THEN '' END,
-- Prakash.N~20052009
		GrpNature, AccDispOrder, ISNULL(AccPk, 0) AS 'AccPk', RTRIM(GTreeId) AS 'TreeId',ISNULL(GrpPk,0) as GrpPk,
		ISNULL(GrpPrtFk,0) as GrpPrtFk,	CASE ISNULL(GrpPk,0) WHEN 0 THEN '' ELSE '+'END  AS Img,
		ISNULL(AccBrkRqd,0) as AccBrkRqd,GenTreeId
		FROM
		#TmpLvlFinal
		WHERE DispNm IS NOT NULL

	IF @QryId='ANA'--RJANAINC
		SELECT SUBSTRING(RTRIM(DispNm),1,200) AS 'Account Head', -- /* MARI~31052008 */ 
		 ISNULL(CurBal,'') AS 'Comp Date Balance', ISNULL(CurTot,'') AS 'Comp Date Total',
		 ISNULL(CompBal,'') AS 'Cur Date Balance', ISNULL(CompTot,'') AS 'Cur Date Total'
				
				--, GrpNature, AccPk, TreeId, GrpPk, GrpPrtFk, Img, AccBrkRqd, GenTreeId 
			FROM #TmFinalRpt ORDER BY GrpNature DESC, GentreeId ASC, DispOrder, AccDispOrder ASC 
	ELSE
		SELECT DispOrder,LvlNo,g, SUBSTRING(RTRIM(DispNm),1,200) AS 'DispNm',
		ISNULL(DrComp, '') AS 'DrComp', ISNULL(CrComp, '') AS 'CrComp', -- Prakash.N~20052009
		ISNULL(CompBal,'') AS CompBal, ISNULL(CompTot,'') AS CompTot, -- /* MARI~31052008 */ 
		ISNULL(DrCur, '') AS 'DrCur', ISNULL(CrCur, '') AS 'CrCur', -- Prakash.N~20052009
		ISNULL(CurBal,'') AS CurBal, ISNULL(CurTot,'') AS CurTot, GrpNature, 
		AccPk, TreeId, GrpPk, GrpPrtFk, Img, AccBrkRqd, GenTreeId 
			FROM #TmFinalRpt ORDER BY GrpNature DESC, GentreeId ASC, DispOrder, AccDispOrder ASC 

	SELECT dbo.gefgdmy(dbo.gefgchar2date(@CurDt,@LocPk),@LocPk) AS  CurFrmDt, 
		dbo.gefgdmy(dbo.gefgchar2date(@CurToDt,@LocPk),@LocPk) AS CurToDt, 
		dbo.gefgdmy(dbo.gefgchar2date(@CompDt,@LocPk),@LocPk) AS CompFrmDt, 
		dbo.gefgdmy(dbo.gefgchar2date(@CompToDt,@LocPk),@LocPk) AS CompToDt,@CurFk as hdn_txtRptCur,rtrim(GnmDesc) as txtRptCur
		From Profamggeneral with(nolock) where gnmpk=@CurFk --and gnmdelid=0 --RSRDCIMTFR

END



