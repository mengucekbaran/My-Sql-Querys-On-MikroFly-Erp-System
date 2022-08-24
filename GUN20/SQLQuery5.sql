select sto_kod as [STOK KODU],sto_isim as [STOK ISMI],dbo.fn_MarkaIsmi(sto_marka_kodu)as[MARKA ISMI]
FROM STOKLAR