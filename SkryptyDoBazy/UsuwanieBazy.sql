--****************Usuwanie bazy
USE [BicycleSharing_Rozproszone]
GO

--*******************usuwanie wszystkich rekordow
delete from Miasto
delete from Stacja
delete from Rodzaj
delete from Stopien_Uszkodzenia
delete from Rowery
delete from Uzytkownik
delete from Historia_wypozyczen

--******************************usuwanie wszystkich kluczy obcych
ALTER TABLE [dbo].Stacja  
DROP CONSTRAINT FK_Stacja_Miasto;
GO
ALTER TABLE [dbo].Rowery  
DROP CONSTRAINT FK_Rowery_Stacja;
GO
ALTER TABLE [dbo].Rowery  
DROP CONSTRAINT FK_Rowery_Rodzaj;
GO
ALTER TABLE [dbo].Rowery  
DROP CONSTRAINT FK_Rowery_Stopien_Uszkodzenia;
GO
ALTER TABLE [dbo].Uzytkownik  
DROP CONSTRAINT FK_Uzytkownik_Rowery;
GO
ALTER TABLE [dbo].Historia_wypozyczen  
DROP CONSTRAINT FK_Historia_wypozyczen_Uzytkownik;
GO
ALTER TABLE [dbo].Historia_wypozyczen  
DROP CONSTRAINT FK_Historia_wypozyczen_Rowery;
GO

--**********************************usuwanie wszystkich tabel
IF OBJECT_ID('dbo.Miasto', 'U') IS NOT NULL
DROP TABLE dbo.Miasto
GO

IF OBJECT_ID('dbo.Stacja', 'U') IS NOT NULL
DROP TABLE dbo.Stacja
GO

IF OBJECT_ID('dbo.Rodzaj', 'U') IS NOT NULL
DROP TABLE dbo.Rodzaj
GO

IF OBJECT_ID('dbo.Rowery', 'U') IS NOT NULL
DROP TABLE dbo.Rowery
GO

IF OBJECT_ID('dbo.Stopien_Uszkodzenia', 'U') IS NOT NULL
DROP TABLE dbo.Stopien_Uszkodzenia
GO

IF OBJECT_ID('dbo.Uzytkownik', 'U') IS NOT NULL
DROP TABLE dbo.Uzytkownik
GO

IF OBJECT_ID('dbo.Historia_wypozyczen', 'U') IS NOT NULL
DROP TABLE dbo.Historia_wypozyczen
GO

