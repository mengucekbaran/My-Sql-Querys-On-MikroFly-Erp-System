
create table BM_AYLIK_ALACAK_ODEME_BILGILERI(
	cari_kod nvarchar(25),
	doviz nvarchar(50),
)
declare @cari_kod nvarchar(25),
@doviz nvarchar(50),
@meblag float,
@ayYil nvarchar(50),
@columnAyYil nvarchar(50),
@addColumn nvarchar(max) ,
@updateStatement nvarchar(max),
@cursor1_status int,
@cursor2_status int
--*******ALTER TABLE MONTHS**************************
DECLARE @fromDate date= '20220101';
DECLARE @fromDatetime datetime = @Fromdate;
DECLARE @toDate date= '20240101';
DECLARE @toDatetime datetime = @todate;
DECLARE @monthYear nvarchar(50);
while @fromDatetime<@toDatetime
begin
set @monthYear= FORMAT(@fromDatetime,'MMMM','TR')
set @monthYear= @monthYear+'_'+DATENAME(YEAR, @fromDatetime)
set @addColumn='ALTER TABLE BM_AYLIK_ALACAK_ODEME_BILGILERI ADD '+ @monthYear+' float'
exec(@addColumn)
set @fromDatetime=DATEADD(MONTH, 1, @fromDatetime)
end
--*******************************************************
--*************CURSOR1****************************************************************
-- declare cursor
declare cursor1_chh scroll cursor for
select  chh.cha_kod,
dbo.fn_DovizIsmi(cha_d_cins)
from CARI_HESAP_HAREKETLERI chh where cha_tip=1 group by cha_kod,dbo.fn_DovizIsmi(cha_d_cins) order by cha_kod
--open cursor
open cursor1_chh
fetch next from cursor1_chh into @cari_kod,@doviz
set @cursor1_status=@@FETCH_STATUS
--ÝNSERT ÝNTO WHÝLE
while @cursor1_status=0
	begin
		insert into BM_AYLIK_ALACAK_ODEME_BILGILERI(cari_kod,doviz)values(@cari_kod,@doviz) 
		fetch next from cursor1_chh into @cari_kod,@doviz
		set @cursor1_status=@@FETCH_STATUS
	end
close cursor1_chh
--***********************************************************************************************
--*************CURSOR2*********************************************************
-- declare cursor
declare cursor2_chh scroll cursor for
select  chh.cha_kod,
dbo.fn_DovizIsmi(cha_d_cins),
dbo.fn_AyIsimYil(convert(datetime,convert(char(8),cha_vade))),
sum(cha_meblag) as bakiye
from CARI_HESAP_HAREKETLERI chh where cha_tip=1 group by cha_kod,cha_d_cins,dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))) order by cha_kod
--OPEN CURSOR
open cursor2_chh
--FETCH NEXT
fetch next from cursor2_chh into @cari_kod,@doviz,@ayYil,@meblag
set @cursor2_status=@@FETCH_STATUS
while @cursor2_status=0
begin
	set @columnAyYil = replace(@ayYil,' ','_' )
	set @updateStatement='update BM_AYLIK_ALACAK_ODEME_BILGILERI set '+ @columnAyYil+' = '+convert(nvarchar,@meblag)+
	' where cari_kod = '+''''+@cari_kod+''''+' and '+'doviz = '+''''+@doviz+''''
	exec(@UpdateStatement)
	fetch next from cursor2_chh into @cari_kod,@doviz,@ayYil,@meblag
	set @cursor2_status=@@FETCH_STATUS
end
close cursor2_chh
deallocate cursor1_chh
deallocate cursor2_chh

select * from BM_AYLIK_ALACAK_ODEME_BILGILERI
--drop table BM_AYLIK_ALACAK_ODEME_BILGILERI