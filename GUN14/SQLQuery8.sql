create table #BM_AYLIK_BORC_ALACAK(
	cari_kod nvarchar(25),
	doviz nvarchar(50),
	tip tinyint
)

declare @cari_kod nvarchar(25),
@doviz nvarchar(50),
@ayYil nvarchar(25),
@meblag float,
@tip tinyint,
@columnAyYil nvarchar(50),
@addColumn nvarchar(max) ,
@updateStatement nvarchar(max),
@cursor1_status int,
@cursor2_status int

--*************CURSOR1****************************************************************
-- declare cursor
declare cursor1_chh scroll cursor for
select  chh.cha_kod,
chh.cha_tip,
dbo.fn_DovizIsmi(cha_d_cins)
from CARI_HESAP_HAREKETLERI chh group by cha_kod,dbo.fn_DovizIsmi(cha_d_cins),cha_tip order by cha_kod
--open cursor
open cursor1_chh
fetch next from cursor1_chh into @cari_kod,@tip,@doviz
set @cursor1_status=@@FETCH_STATUS

--ÝNSERT ÝNTO WHÝLE
while @cursor1_status=0
	begin
		insert into #BM_AYLIK_BORC_ALACAK(cari_kod,tip,doviz)values(@cari_kod,@tip,@doviz) 
		fetch next from cursor1_chh into @cari_kod,@tip,@doviz
		set @cursor1_status=@@FETCH_STATUS
	end

--***********************************************************************************************
--*************CURSOR2*********************************************************
-- declare cursor
declare cursor2_chh scroll cursor for
select  chh.cha_kod,
chh.cha_tip,
dbo.fn_DovizIsmi(cha_d_cins),
dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))) as ayYil,
sum(cha_meblag)
/*sum(case when cha_tip=1 then chh.cha_meblag end) as borc,
sum(case when cha_tip=0 then chh.cha_meblag end) as alacak
*/
from CARI_HESAP_HAREKETLERI chh group by cha_kod,cha_tip,cha_d_cins,dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))) order by ayYil

--OPEN CURSOR
open cursor2_chh
--FETCH NEXT
fetch next from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
set @cursor2_status=@@FETCH_STATUS
--ALTER TABLE WHÝLE
while @cursor2_status=0
	begin
		
		set @columnAyYil = replace(@ayYil,' ','_' )
		set @addColumn=' alter table #BM_AYLIK_BORC_ALACAK add '+@columnAyYil+' float' 
		exec(@addColumn)
		fetch next from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
		set @cursor2_status=@@FETCH_STATUS
	end
--go back first record
fetch first from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
set @cursor2_status=@@FETCH_STATUS
--go back first record
fetch first from cursor1_chh into @cari_kod,@tip,@doviz
set @cursor1_status=@@FETCH_STATUS
while @cursor1_status=0
	begin
		while @cursor2_status=0
		begin
			set @columnAyYil = replace(@ayYil,' ','_' )
			set @updateStatement='update #BM_AYLIK_BORC_ALACAK set '+ @columnAyYil+' = '+convert(nvarchar,@meblag)+' where cari_kod = '+''''+@cari_kod+''''+' and '+'doviz = '+''''+@doviz+''''+' and tip= '+convert(nvarchar,@tip)+''
			exec(@UpdateStatement)
		
		
			fetch next from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
			set @cursor2_status=@@FETCH_STATUS
		end
		--go back first record
		fetch first from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
		set @cursor2_status=@@FETCH_STATUS
		fetch next from cursor1_chh into @cari_kod,@tip,@doviz
		set @cursor1_status=@@FETCH_STATUS
	end



close cursor1_chh
deallocate cursor1_chh
close cursor2_chh
deallocate cursor2_chh


	drop table #BM_AYLIK_BORC_ALACAK
	select * from #BM_AYLIK_BORC_ALACAK  order by cari_kod



