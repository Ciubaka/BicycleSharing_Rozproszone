--****************************Zapytanie
set statistics time on
go
with WybraneRowery(LacznyCzasPrzejechany, Stopien_UszkodzeniaID, RodzajRoweru, NazwaStacji, StacjaID, RoweryID)
as
(select Laczny_czas, Rowery.Stopien_Uszkodzenia_Id, Rodzaj.nazwa, Stacja.nazwa, Rowery.StacjaId, Rowery.RoweryId
from Rowery
INNER JOIN Rodzaj ON Rowery.RodzajId = Rodzaj.RodzajId
INNER JOIN Stacja ON Rowery.StacjaId = Stacja.StacjaId
INNER JOIN Stopien_Uszkodzenia On Rowery.Stopien_Uszkodzenia_Id = Stopien_Uszkodzenia.Stopien_Uszkodzenia_Id
where Rodzaj.nazwa not in('Rowery dzieciece', 'Tandemy') AND
	  Stacja.nazwa not in ('Red', 'Blue', 'Turquoise', 'Violet', 'Purple','Orange') AND
	  Rowery.Laczny_czas > 50 AND 
	  Rowery.Stopien_Uszkodzenia_Id between 1 AND 3
)
select distinct Uzytkownik.UzytkownikId, Uzytkownik.Imie, Uzytkownik.Nazwisko, Uzytkownik.Nr_telefonu, Uzytkownik.Data_urodzenia, LacznyCzasPrzejechany, Stopien_UszkodzeniaID, RodzajRoweru, NazwaStacji, WybraneRowery.RoweryID

from Uzytkownik
Inner JOIN WybraneRowery on Uzytkownik.RoweryId = WybraneRowery.RoweryID
Inner JOIn Historia_wypozyczen on Uzytkownik.UzytkownikId = Historia_wypozyczen.UzytkownikId
order by LacznyCzasPrzejechany, Stopien_UszkodzeniaID
go

set statistics time off
go
