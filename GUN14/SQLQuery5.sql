create table #BM_AYLIK_BORC_ALACAK(
	cari_kod nvarchar(25),
	doviz nvarchar(50),
)

declare @cari_kod nvarchar(25),
@doviz nvarchar(50),
@ayYil nvarchar(25),
@columnAyYil nvarchar(50),
@addColumn nvarchar(max) ,
@meblag float,
@tip tinyint,
@cursor1_status int,
@cursor2_status int,
@updateStatement nvarchar(max)
-- declare cursor
declare cursor1_chh scroll cursor for
select  chh.cha_kod,
chh.cha_tip,
dbo.fn_DovizIsmi(cha_d_cins),
dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))),
chh.cha_meblag
from CARI_HESAP_HAREKETLERI chh order by cha_vade

-- declare cursor
declare cursor2_chh scroll cursor for
select  chh.cha_kod,
chh.cha_tip,
dbo.fn_DovizIsmi(cha_d_cins),
dbo.fn_AyIsimYil(convert(datetime,cast(cha_vade as char(8)))),
chh.cha_meblag
from CARI_HESAP_HAREKETLERI chh order by cha_vade

--open cursor
open cursor1_chh
open cursor2_chh

fetch next from cursor1_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
fetch next from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
set @cursor1_status=@@FETCH_STATUS
set @cursor2_status=@@FETCH_STATUS
--ÝNSERT ÝNTO WHÝLE
while @cursor1_status=0
	begin
		insert into #BM_AYLIK_BORC_ALACAK(cari_kod,doviz)values(@cari_kod,@doviz)
		fetch next from cursor1_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
		set @cursor1_status=@@FETCH_STATUS
	end

--go back first record
fetch first from cursor1_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
set @cursor1_status=@@FETCH_STATUS
--ALTER TABLE WHÝLE
while @cursor1_status=0
	begin
		select @cari_kod,@doviz
		set @columnAyYil = replace(@ayYil,' ','_' )
		set @addColumn=' alter table #BM_AYLIK_BORC_ALACAK add '+@columnAyYil+' float'
		exec(@addColumn)
		while @cursor2_status=0
		begin
		
			set @updateStatement='update #BM_AYLIK_BORC_ALACAK set'+ @columnAyYil+'='+@meblag+'where cari_kod='+''''+@cari_kod+''''+'and'+'doviz='+''''+@doviz+''''
			exec(@UpdateStatement)
			fetch next from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
			set @cursor2_status=@@FETCH_STATUS
		end
		--go back first record
		fetch first from cursor2_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
		set @cursor2_status=@@FETCH_STATUS
		fetch next from cursor1_chh into @cari_kod,@tip,@doviz,@ayYil,@meblag
		set @cursor1_status=@@FETCH_STATUS
	end
close cursor1_chh
close cursor2_chh
deallocate cursor1_chh
deallocate cursor2_chh




	drop table #BM_AYLIK_BORC_ALACAK
	select * from #BM_AYLIK_BORC_ALACAK  order by cari_kod

	alter table #BM_AYLIK_BORC_ALACAK ADD 15_deneme nvarchar(25)

	select * from sys.objects where name like '%Ay%'

	sp_helptext fn_AyIsimYil



