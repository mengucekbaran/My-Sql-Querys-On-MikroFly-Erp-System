select sth_stok_kod,
ISNULL([Merkez depo],0)  [Merkez depo],
ISNULL([Hammadde],0)	 [Hammadde],
ISNULL([Yarý Mamul],0)   [Yarý Mamul],
ISNULL([Mamul],0)		 [Mamul],
ISNULL([Sevkiyat],0)	 [Sevkiyat],
ISNULL([Karantina],0)    [Karantina],
ISNULL([Red],0)			 [Red] from
(select 
dep.dep_adi as dep_adi,
sh.sth_stok_kod,
(select dbo.Depodaki_Miktarlar (sh.sth_stok_kod,dep.dep_no)) as miktar from STOK_HAREKETLERI sh
right join DEPOLAR dep 
on (sh.sth_giris_depo_no=dep.dep_no or sh.sth_cikis_depo_no=dep.dep_no) where sh.sth_stok_kod is not null 
group by 
dep.dep_no,dep.dep_adi,sh.sth_stok_kod
) as DepoKalanMiktar
PIVOT
(
sum(miktar) for [dep_adi] in (
[Merkez depo],[Hammadde],[Yarý Mamul],[Mamul],[Sevkiyat],[Karantina],[Red]
)
) as PivotDepoKalanMiktar





DECLARE @colnameList varchar (200)
 SET @colnameList = NULL
 SELECT @colnameList = COALESCE (@colnameList + ',','' ) +'['+ dep.dep_adi+']'
 from DEPOLAR dep


DECLARE @DepoKalanMiktar NVARCHAR(MAX)

SET @DepoKalanMiktar =
'select *
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
sum(miktar) for [dep_adi] in ('+@colnameList+')
) as PivotDepoKalanMiktar'

exec(@DepoKalanMiktar)



