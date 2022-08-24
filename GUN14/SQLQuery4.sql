

create view BM_aylýkOdeme as 

select chh.cha_kod,
dbo.fn_YilAy(convert(datetime,cast(cha_vade as char(8)))) as yilAy,
dbo.fn_DovizIsmi(cha_d_cins) AS doviz,
case when cha_tip=0 then
sum( cha_meblag) as Borc
from CARI_HESAP_HAREKETLERI chh WHERE cha_tip=1 group by cha_kod,cha_d_cins,dbo.fn_YilAy(convert(datetime,cast(cha_vade as char(8)))) 
UNION ALL
select chh.cha_kod,
dbo.fn_YilAy(convert(datetime,cast(cha_vade as char(8)))) as yilAy,
dbo.fn_DovizIsmi(cha_d_cins) AS doviz,
sum(cha_meblag) as Alacak
from CARI_HESAP_HAREKETLERI chh WHERE cha_tip=0 group by cha_kod,cha_d_cins,dbo.fn_YilAy(convert(datetime,cast(cha_vade as char(8)))) 

Select * from BM_aylýkOdeme order by cha_kod,yilAy