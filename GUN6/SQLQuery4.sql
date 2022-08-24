
create table #BM_depo(
	depoNo int primary key,
	depoAd nvarchar(50)

)

declare @depoNo int, @depoAdi Nvarchar(50)

declare cursor_depo cursor
for select 
dep.dep_no,
dep.dep_adi
from DEPOLAR dep

open cursor_depo

fetch next from cursor_depo into @depoNo,@depoAdi

while @@FETCH_STATUS=0
begin
	insert into #BM_depo(depoNo,depoAd) values(@depoNo,@depoAdi)
	fetch next from cursor_depo into @depoNo,@depoAdi
end
 
 close cursor_depo
 deallocate cursor_depo

 select * from #BM_depo

 delete #BM_depo


 DECLARE @colnameList varchar (200)
 SET @colnameList = NULL
 SELECT @colnameList = COALESCE (@colnameList + ',','' ) +'['+ dep.dep_adi+']'
 from DEPOLAR dep
 select @colnameList



select *
from (
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
) as DepoKalanMiktar
PIVOT
(
sum(miktar) for dep_adi in ([#BM_depo])
) as PivotDepoKalanMiktar


