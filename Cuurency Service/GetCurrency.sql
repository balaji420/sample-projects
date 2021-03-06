
	Use [Take_Sol]
	Go
	/****** Object:  Storedprocedure [Dbo].[Getcurrency]    Script Date: 1/3/2018 10:08:35 Am ******/
	Set Ansi_Nulls On
	Go
	Set Quoted_Identifier On
	Go
	Alter Proc [Dbo].[Getcurrency]
	(
	@Json Varchar(Max),
	@Date Datetime =Null
	)
	As
	Begin
	
	Set Nocount On

	Declare @Locfk Bigint;
	Declare @Bascur Int ;
	Declare @Cnt Int = 1;
	
	Create Table #Tmp (Names Varchar(Max),Stringvalues Varchar(Max),Gnmpk Bigint,Locfk Bigint);

	Create Table #Location(Locpk Bigint,Sno Bigint)


	Insert Into #Tmp(Names,Stringvalues)
	Select Name,Stringvalue From Parsejson(@Json) Where Valuetype<>'Object' And  Name In ('Base','Date','Inr','Usd','Sgd','Eur','Dkk','Myr','Pln','Gbp','Rub','Thb')

                                                                                           
	Update #Tmp Set Gnmpk = (Select Gnmpk From Profamggeneral With(Nolock) Where Gnmtyp=6 And Gnmdelid=0 And Rtrim(Names)=Rtrim(Gnmdesc))
	
	Set @Date=(Select Dateadd(Day,0, Convert(Date,(Select Stringvalues From #Tmp Where Names='Date'))));


	Set @Bascur = (Select Gnmpk From Profamggeneral With(Nolock) Where Gnmtyp=6 And Gnmdelid=0 And Rtrim(Gnmdesc)= (Select Stringvalues From #Tmp Where Names='Base' )) 

	--If(Isnull(@Bascur,0)=0)
	-- Set @Bascur= 1 

	If Exists(Select * From Profacurconvconfiglog Where Logcreateddt = @Date And Logbascurfk = @Bascur And Isnull(Logmodifieddt,0)=0)
     Return
	Else
	Begin
	
	 Update Profacurconvconfiglog Set Logmodifieddt = @Date Where Isnull(Logmodifieddt,0)=0  And logCreatedDt <> @Date
	
	 Insert Into  Profacurconvconfiglog( Logbascurfk,Logconcurfk,Logconvval,Logrowid,Logcreatedby,Logcreateddt,Logmodifiedby,Logdelid)
	 Select @Bascur,@Bascur,'1.00',Newid(),'Admin',Getdate(),'Admin',0; 

	 Insert Into  Profacurconvconfiglog( Logbascurfk,Logconcurfk,Logconvval,Logrowid,Logcreatedby,Logcreateddt,Logmodifiedby,Logdelid)
	 Select @Bascur,Gnmpk,Stringvalues,Newid(),'Admin',Getdate(),'Admin',0  From #Tmp Where Gnmpk In(Select Gnmpk From Profamggeneral With(Nolock) Where Gnmtyp=6 And Gnmdelid=0); 

	 Insert Into #Location(Locpk,Sno) 
	 Select Locpk,Dense_Rank()Over(Order By Locpk) From Profamglocmas With(Nolock)Where Locdelid=0 And Locentity=0 And Loccurrfk In (Select Logconcurfk From Profacurconvconfiglog Where Logbascurfk= @Bascur)
	
	End
	
	If Exists(Select * From Profacurconvconfig Where crvdelid=0 and Crvefffrm = @Date And Crvbascurfk=@Bascur And Isnull(Crveffto,0)=0 )
	
	 Return

	Else
	 If(Select distinct Logbascurfk From Profacurconvconfiglog Where Isnull(Logmodifieddt,0)=0 ) = (Select count(Gnmdesc) From Profamggeneral With(Nolock) Where Gnmdelid=0 And Gnmtyp=6 And Gnmdesc Not In('Uah','Mur'))
	
	Begin
	
	 Update Profacurconvconfig Set Crveffto= @Date Where Isnull(Crveffto,0)=0 And Crvefffrm <> @Date
	

		While @Cnt <= (Select Count(Sno) From #Location)
			
			Begin

				Set @Locfk = (Select  Locpk From #Location Where Sno = @Cnt )
	
				Set @Bascur = (Select Loccurrfk From  Profamglocmas With(Nolock)Where Locdelid=0 And Locentity=0 And Locpk = @Locfk)

				Insert Into  Profacurconvconfig( Crvlocfk,Crvbascurfk,Crvconcurfk,Crvconvval,Crvefffrm,Crvrowid,Crvcreatedby,Crvcreateddt,Crvmodifiedby,Crvmodifieddt,Crvbyrt,Crvselrt,Crvcutofftm,Crvdelid)
				Select @Locfk ,@Bascur,@Bascur,'1.00',@Date,Newid(),'Admin',Getdate(),'Admin',Getdate(),0.00,0.00,'',0; 

				Insert Into  Profacurconvconfig( Crvlocfk,Crvbascurfk,Crvconcurfk,Crvconvval,Crvefffrm,Crvrowid,Crvcreatedby,Crvcreateddt,Crvmodifiedby,Crvmodifieddt,Crvbyrt,Crvselrt,Crvcutofftm,Crvdelid)
				Select @Locfk,@Bascur,Logbascurfk,Logconvval,@Date,Newid(),'Admin',Getdate(),'Admin',Getdate(),0.00,0.00,'',0  
				From Profacurconvconfiglog Where Logconcurfk = @Bascur And Logbascurfk <> @Bascur and isnull(logModifiedDt,0)=0

				Set @Cnt = @Cnt + 1;
			
			End

	End
	
	Drop Table #Tmp
End




