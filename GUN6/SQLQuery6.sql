
create table #BM_Depo_Bilgileri(
	id int

)

declare @depoAdi nvarchar(50),
 @addColumn nvarchar(max)

declare cursor_depo cursor

for select 
dep.dep_adi
from DEPOLAR dep

open cursor_depo

fetch next from cursor_depo into @depoAdi

while @@FETCH_STATUS=0
begin
	set @addColumn= 'alter table #BM_Depo_Bilgileri ADD '+replace(@depoAdi,' ','_')+' float'
	exec(@addColumn)
	fetch next from cursor_depo into @depoAdi
end
 
 close cursor_depo
 deallocate cursor_depo



select * from #BM_Depo_Bilgileri
drop table #BM_Depo_Bilgileri






select dep.dep_adi as dep_adi,
sh.sth_stok_kod,
(select dbo.Depodaki_Miktarlar (sh.sth_stok_kod,dep.dep_no)) as miktar 
from STOK_HAREKETLERI sh
right join DEPOLAR dep 
on (sh.sth_giris_depo_no=dep.dep_no or sh.sth_cikis_depo_no=dep.dep_no) 
where sh.sth_stok_kod is not null 
group by dep.dep_no,
dep.dep_adi,
sh.sth_stok_kod