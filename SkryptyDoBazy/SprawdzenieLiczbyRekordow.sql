--***************Sprawdzenie liczby rekordow we wszystkich tabelach
select (select COUNT(*) from Miasto) as LiczbaRekordow_Miasto, (select COUNT(*) from Stacja) as LiczbaRekordow_Stacja,
	   (select COUNT(*) from Rowery) as LiczbaRekordow_Rowery, (select COUNT(*) from Uzytkownik) as LiczbaRekordow_Uzytkownicy,
       (select COUNT(*) from Historia_wypozyczen) as LiczbaRekordow_HistoriaWypozyczen
	   go
