
create table #BM_Depo_Bilgileri(
	stok_kod nvarchar(25)

)

declare 
@depoAdi nvarchar(50),
@depoNo int,
@stokKod nvarchar(25),
@depoAdi_status int,
@stokKod_status int,
@columnDepoAdi nvarchar(50), 
 @addColumn nvarchar(max)

declare cursor_depo cursor
for select 
dep.dep_adi,dep.dep_no
from DEPOLAR dep

declare cursor_stok cursor 
for select 
sto_kod
from STOKLAR
where sto_cins='1'

open cursor_depo
open cursor_stok

fetch next from cursor_depo into @depoAdi,@depoNo
set @depoAdi_status = @@FETCH_STATUS
fetch next from cursor_stok into @stokKod
set @stokKod_status = @@FETCH_STATUS

while @stokKod_status=0
	begin
		insert into  #BM_Depo_Bilgileri(stok_kod)values(@stokKod)
		fetch next from cursor_stok into @stokKod
		set @stokKod_status = @@FETCH_STATUS
	end

fetch first from cursor_stok into @stokKod
set @stokKod_status = @@fetch_status

while @depoAdi_status=0
	begin
	
		set @columnDepoAdi = replace(@depoAdi,' ','_')
		set @addColumn= 'alter table #BM_Depo_Bilgileri ADD '+@columnDepoAdi+' float'
		exec(@addColumn)
		
		while @stokKod_status=0
			begin
				insert into  #BM_Depo_Bilgileri(stok_kod)values(@stokKod)
				update #BM_Depo_Bilgileri set  @columnDepoAdi = dbo.Depodaki_Miktarlar (@stokKod,@depoNo)

				fetch next from cursor_stok into @stokKod
				set @stokKod_status = @@FETCH_STATUS
			end
		--go back to first record of second_cursor to start
		fetch first from cursor_stok into @stokKod
		set @stokKod_status = @@fetch_status

		--index arttýrma
		fetch next from cursor_depo into @depoAdi,@depoNo
		set @depoAdi_status = @@FETCH_STATUS

	end

 close cursor_depo
 deallocate cursor_depo

 close cursor_stok
 deallocate cursor_stok


 select * from #BM_Depo_Bilgileri
drop table #BM_Depo_Bilgileri


select sth_stok_kod from STOK_HAREKETLERI



declare @stokKod nvarchar(25)

 declare cursor_stok cursor for
 select sh.sth_stok_kod 
 from STOK_HAREKETLERI sh

open cursor_stok
fetch next from cursor_stok into @stokKod

while @@FETCH_STATUS=0
begin
	insert into #BM_Depo_Bilgileri() 

end






select * from #BM_Depo_Bilgileri
drop table #BM_Depo_Bilgileri


select * from #BM_Depo_Bilgileri
drop table #BM_Depo_Bilgileri



select dep.dep_adi as dep_adi,
sh.sth_stok_kod,
(select dbo.Depodaki_Miktarlar (sh.sth_stok_kod,dep.dep_no)) as miktar 
from STOK_HAREKETLERI sh
right join DEPOLAR dep 
on (sh.sth_giris_depo_no=dep.dep_no or sh.sth_cikis_depo_no=dep.dep_no) 
where sh.sth_stok_kod is not null 


select * from STOKLAR
