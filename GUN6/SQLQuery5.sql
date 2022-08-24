
create table #BM_depolar(
	id int

)

declare @depoAdi nvarchar(50)
declare @addColumn nvarchar(200)
declare cursor_depo cursor
for select 
dep.dep_adi
from DEPOLAR dep

open cursor_depo

fetch next from cursor_depo into @depoAdi

while @@FETCH_STATUS=0
begin
	set @addColumn= 'alter table #BM_depolar ADD '+@depoAdi+' float'
	select @depoAdi
	exec(@addColumn)
	fetch next from cursor_depo into @depoAdi
end
 
 close cursor_depo
 deallocate cursor_depo

 select @depoAdi

 select * from #BM_depolar
drop table #BM_depolar

 DECLARE @colnameList varchar (200)
 SET @colnameList = NULL
 SELECT @colnameList = COALESCE (@colnameList + ',','' ) +'['+ dep.dep_adi+']'
 from DEPOLAR dep



select *
from (
select dep.dep_no as depNo,
sh.sth_stok_kod,
(select dbo.Depodaki_Miktarlar (sh.sth_stok_kod,dep.dep_no)) as miktar 
from STOK_HAREKETLERI sh
right join DEPOLAR dep
on (sh.sth_giris_depo_no=dep.dep_no or sh.sth_cikis_depo_no=dep.dep_no) 
where sh.sth_stok_kod is not null 
group by dep.dep_no,
dep.dep_no,
sh.sth_stok_kod
) as DepoKalanMiktar
PIVOT
(
sum(miktar) for [depNo] in ([depNo])
) as PivotDepoKalanMiktar


