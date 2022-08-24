DECLARE @colnameList varchar (200)
 SET @colnameList = NULL
 SELECT @colnameList = COALESCE (@colnameList + ',','' ) +'['+ dep.dep_adi+']'
 from DEPOLAR dep



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
sum(miktar) for [dep_adi] in (@colnameList)
) as PivotDepoKalanMiktar

