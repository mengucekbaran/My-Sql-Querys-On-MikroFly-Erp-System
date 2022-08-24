
	create table #BM_Cari_Bilgileri(
	cari_kod nvarchar(25),
	cari_ad nvarchar(50),
	cari_alacak float,
	cari_borc float,
	cari_kalan float,
	)
	--DEFINE VARIABLES
	declare @cariKod nvarchar(25),@cariAd nvarchar(50),@alacak float,@borc float
	--DECLARE CURSOR ALACAK
	declare cursor_alacak cursor for 
	select chh.cha_kod,
	(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod),
	sum(cha_meblag)
	from CARI_HESAP_HAREKETLERI chh where cha_tip=1
	group by cha_kod,cha_tip
	order by cha_kod
	--DECLARE CURSOR BORC
	declare cursor_borc cursor for 
	select chh.cha_kod,
	(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod),
	sum(cha_meblag)
	from CARI_HESAP_HAREKETLERI chh where cha_tip=0
	group by cha_kod,cha_tip
	order by cha_kod
	--CURSOR OPEN
	open cursor_alacak
	open cursor_borc
	--FETCH ALACAK
	fetch next from cursor_alacak into @cariKod,@cariAd,@alacak
	--LOOP ALACAK
	while @@FETCH_STATUS=0
		begin
			insert into #BM_Cari_Bilgileri(cari_kod,cari_ad,cari_alacak)values(@cariKod,@cariAd,@alacak)
			fetch next from cursor_alacak into @cariKod,@cariAd,@alacak
		end	
	--FETCH BORC
	fetch next from cursor_borc into @cariKod,@cariAd,@borc
	--LOOP BORC
	while @@FETCH_STATUS=0
	begin
		update #BM_Cari_Bilgileri set cari_borc= @borc,cari_kalan=(cari_alacak-@borc) where cari_kod=@cariKod
		fetch next from cursor_borc into @cariKod,@cariAd,@borc
	end
	--CLOSE AND DEALLOCETE
	close cursor_alacak
	close cursor_borc
	deallocate cursor_alacak
	deallocate cursor_borc

		select * from #BM_Cari_Bilgileri

		drop table #BM_Cari_Bilgileri
		
















