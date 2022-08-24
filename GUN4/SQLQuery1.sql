select 
sh.sth_evrakno_seri,
sh.sth_stok_kod,
sh.sth_giris_depo_no,
sum(sh.sth_miktar) as miktar
from STOK_HAREKETLERI sh
group by sh.sth_evrakno_seri,
sh.sth_stok_kod,
sh.sth_giris_depo_no


Select * FROM STOKLAR WITH (NOLOCK)  WHERE sto_Guid='{E8EFCAE7-8D79-4FAC-8144-707C3EF12610}'
Select dbo.fn_DepodakiMiktar(N'HM10',2,'20220731')
Select dbo.fn_DepodanVerilenKonsinyeMiktar(N'HM09',2,'20220731')


Select dbo.fn_DepodakiMiktar(N'HM01',2,'20220731')

declare @depoSayisi int,@i int
set @i=1
select @depoSayisi= count(*) from DEPOLAR
select @depoSayisi

	while(@i<=@depoSayisi)
begin
	if()
	set @i=@i+1
end

declare @tip int
	select @tip=sh.sth_tip from STOK_HAREKETLERI sh where sh.sth_
	select @tip
	

if(@tip=2)
begin

select sh.sth_miktar from STOK_HAREKETLERI sh

end
else if(@tip=0)
begin

select 'deneme'
end




select
sh.sth_tip,
 sh.sth_stok_kod,
 sh.sth_cikis_depo_no,
 sh.sth_giris_depo_no,
 sh.sth_miktar,
 sip.sip_stok_kod,
 sip.sip_teslim_miktar,
 sip.sip_depono
  from SIPARISLER sip
right outer join STOK_HAREKETLERI sh 
on sip.sip_Guid= sh.sth_sip_uid 
group by sh.sth_stok_kod,
 sh.sth_tip,
 sh.sth_stok_kod,
 sh.sth_cikis_depo_no,
 sh.sth_giris_depo_no,
 sh.sth_miktar,
 sip.sip_stok_kod,
 sip.sip_teslim_miktar,
 sip.sip_depono
 order by sh.sth_stok_kod ,sh.sth_tip
















select sho_HareketCins,sho_StokKodu,sho.sho_Depo,
sho_GirisNormal,
sho_CikisNormal,
(sho_GirisNormal-sho_CikisNormal)as kalan 
from STOK_HAREKETLERI_OZET sho 
group by sho_StokKodu,
sho.sho_Depo,
sho_GirisNormal,
sho_CikisNormal ,
sho_HareketCins
order by sho.sho_StokKodu,
sho.sho_Depo



 select 
sh.sth_tip,
 sh.sth_stok_kod,
 sh.sth_cikis_depo_no,
 sh.sth_giris_depo_no,
 sum(sh.sth_miktar) as miktar
  from STOK_HAREKETLERI sh 
left outer join  SIPARISLER sip
on sh.sth_sip_uid = sip.sip_Guid 
where sh.sth_giris_depo_no in (select dep.dep_no from DEPOLAR dep)
group by sh.sth_stok_kod,
 sh.sth_tip,
 sh.sth_cikis_depo_no,
 sh.sth_giris_depo_no
 order by sh.sth_stok_kod ,sh.sth_tip




select 
dep.dep_no,
dep.dep_adi,
coalesce(sho_StokKodu,'BOÞ'), /*coalesce fonksiyonu eðer sho_StokKodu NULL ise NULL yerine BOÞ yazar */
coalesce(sum(sho_GirisNormal-sho_CikisNormal),'0') as miktar 
from STOK_HAREKETLERI_OZET sho 
full outer join 
DEPOLAR dep on sho.sho_Depo= dep.dep_no
group by sho_StokKodu,
dep.dep_no,
dep.dep_adi
order by 
dep.dep_no,
sho.sho_StokKodu


select sho_StokKodu,sho_GirisNormal,sho_CikisNormal from STOK_HAREKETLERI_OZET order by sho_StokKodu