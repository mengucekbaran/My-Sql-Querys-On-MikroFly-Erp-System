create function BM_fn_Cari_Borc_Bakiye(@cari_kod nvarchar(25),@dcins tinyint)
returns float
as
begin
	DECLARE @borc float
	select  @borc=sum(cha_meblag)
	from CARI_HESAP_HAREKETLERI chh where cha_kod=@cari_kod and @dcins=cha_d_cins and cha_tip=0
	return @borc
end
create function BM_fn_Cari_Alacak_Bakiye(@cari_kod nvarchar(25),@dcins tinyint)
returns float
as
begin
	DECLARE @borc float
	select  @borc=sum(cha_meblag)
	from CARI_HESAP_HAREKETLERI chh where cha_kod=@cari_kod and @dcins=cha_d_cins and cha_tip=1
	return @borc
end
create function BM_fn_Cari_Bakiye(@cari_kod nvarchar(25),@dcins tinyint)
returns float
as
begin
	DECLARE @borc float
	select  @borc=sum(case when cha_tip=0 then cha_meblag 
	when cha_tip=1 then -1*cha_meblag end)
	from CARI_HESAP_HAREKETLERI chh where cha_kod=@cari_kod and @dcins=cha_d_cins 
	return @borc
end
create table #BM_AYLIK_BORC_ODEME_BILGILERI(
	cari_kod nvarchar(25),
	k_hesap_kod nvarchar(25),
	k_hesap_ad nvarchar(50),
	doviz nvarchar(50),
	cek_sonpoz_isim nvarchar(50),
	cari_borc_bakiye float,
	cari_alacak_bakiye float,
	cari_bakiye float
)
--***************DECLARE VARIABLES*******************************
SET language turkish
declare @cari_kod nvarchar(25),
@cek_no nvarchar(25),
@k_hesap_kod nvarchar(25),
@k_hesap_ad nvarchar(50),
@doviz nvarchar(50),
@meblag float,
@ayYil nvarchar(50),
@columnAyYil nvarchar(50),
@addColumn nvarchar(max) ,
@updateStatement nvarchar(max),
@cursor1_status int,
@cursor2_status int,
@cek_sonpoz tinyint,
@cek_sonpoz_isim nvarchar(50),
@cari_borc_bakiye float,
@cari_alacak_bakiye float,
@cari_bakiye float
--*******ALTER TABLE MONTHS**************************
DECLARE @fromDate date= '01-01-2022';
DECLARE @fromDatetime datetime = @Fromdate;
DECLARE @toDate date= '01-01-2024';
DECLARE @toDatetime datetime = @todate;
DECLARE @monthYear nvarchar(50);

while @fromDatetime<@toDatetime
begin
set @monthYear= DATENAME(MONTH, @fromDatetime)
set @monthYear= @monthYear+'_'+DATENAME(YEAR, @fromDatetime)
set @addColumn='ALTER TABLE #BM_AYLIK_BORC_ODEME_BILGILERI ADD '+ @monthYear+' float'
exec(@addColumn)
set @fromDatetime=DATEADD(MONTH, 1, @fromDatetime)
end

--*************CURSOR1****************************************************************
-- declare cursor
declare cursor1_chh scroll cursor for
select  chh.cha_kod,
om.sck_bankano,
om.sck_banka_adres1,
dbo.fn_DovizIsmi(cha_d_cins),
om.sck_sonpoz,
dbo.BM_fn_Cari_Borc_Bakiye(chh.cha_kod,chh.cha_d_cins),
dbo.BM_fn_Cari_Alacak_Bakiye(chh.cha_kod,chh.cha_d_cins),
dbo.BM_fn_Cari_Bakiye(chh.cha_kod,chh.cha_d_cins)
from CARI_HESAP_HAREKETLERI chh
 join ODEME_EMIRLERI as om on om.sck_refno=chh.cha_trefno
 group by cha_kod,
 om.sck_sonpoz,
 chh.cha_d_cins,
 dbo.fn_DovizIsmi(cha_d_cins),
om.sck_bankano,
om.sck_banka_adres1
order by cha_kod

--open cursor
open cursor1_chh
fetch next from cursor1_chh into @cari_kod,@k_hesap_kod,@k_hesap_ad,@doviz,@cek_sonpoz,@cari_borc_bakiye,@cari_alacak_bakiye,@cari_bakiye
set @cursor1_status=@@FETCH_STATUS

--***************************ÝNSERT ÝNTO WHÝLE*******************************
while @cursor1_status=0
	begin
		select @cek_sonpoz_isim=OMPozIsim from vw_Odeme_Emri_Pozisyon_Isimleri where @cek_sonpoz=OMPozNo
		insert into #BM_AYLIK_BORC_ODEME_BILGILERI(cari_kod,k_hesap_kod,k_hesap_ad,doviz,cek_sonpoz_isim,cari_borc_bakiye,cari_alacak_bakiye,cari_bakiye)
										values(@cari_kod,@k_hesap_kod,@k_hesap_ad,@doviz,@cek_sonpoz_isim,@cari_borc_bakiye,@cari_alacak_bakiye,@cari_bakiye) 
		fetch next from cursor1_chh into @cari_kod,@k_hesap_kod,@k_hesap_ad,@doviz,@cek_sonpoz,@cari_borc_bakiye,@cari_alacak_bakiye,@cari_bakiye
		set @cursor1_status=@@FETCH_STATUS
	end
close cursor1_chh
--deallocate cursor1_chh

--******************************CURSOR2*********************************************************
-- declare cursor
declare cursor2_chh scroll cursor for
select  chh.cha_kod,
dbo.fn_DovizIsmi(cha_d_cins),
dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))) as ayYil,
sum(cha_meblag) as bakiye
from CARI_HESAP_HAREKETLERI chh
join ODEME_EMIRLERI as om on om.sck_refno=chh.cha_trefno
 group by cha_kod,cha_d_cins,dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))),om.sck_refno order by cha_kod
--***********************************************************************************************************
open cursor1_chh
fetch next from cursor1_chh into @cari_kod,@k_hesap_kod,@k_hesap_ad,@doviz,@cek_sonpoz,@cari_borc_bakiye,@cari_alacak_bakiye,@cari_bakiye
set @cursor1_status=@@FETCH_STATUS
--***********************************UPDATE NESTED WHILE*******************************************************
while @cursor1_status=0
		begin
		--OPEN CURSOR
		open cursor2_chh
		--FETCH NEXT
		fetch next from cursor2_chh into @cari_kod,@doviz,@ayYil,@meblag
		set @cursor2_status=@@FETCH_STATUS
		while @cursor2_status=0
		begin
			set @columnAyYil = replace(@ayYil,' ','_' )
			set @updateStatement='update #BM_AYLIK_BORC_ODEME_BILGILERI set '+ @columnAyYil+' = '+convert(nvarchar,@meblag)+
			' where cari_kod = '+''''+@cari_kod+''''+' and '+'doviz = '+''''+@doviz+''''
			exec(@UpdateStatement)
		
		
			fetch next from cursor2_chh into @cari_kod,@doviz,@ayYil,@meblag
			set @cursor2_status=@@FETCH_STATUS
		end
		close cursor2_chh
	
		fetch next from cursor1_chh into @cari_kod,@k_hesap_kod,@k_hesap_ad,@doviz,@cek_sonpoz,@cari_borc_bakiye,@cari_alacak_bakiye,@cari_bakiye
		set @cursor1_status=@@FETCH_STATUS
	end
--*******************************************************************************************************************
close cursor1_chh
deallocate cursor1_chh
deallocate cursor2_chh


select * from #BM_AYLIK_BORC_ODEME_BILGILERI
--drop table #BM_AYLIK_BORC_ODEME_BILGILERI