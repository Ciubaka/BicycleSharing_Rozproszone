--************************************ Tworzenie bazy

USE master
GO
IF NOT EXISTS (
   SELECT name
   FROM sys.databases
   WHERE name = N'BicycleSharing_Rozproszone'
)
CREATE DATABASE [BicycleSharing_Rozproszone]
GO

USE [BicycleSharing_Rozproszone]
GO

-- ************************************** Tworzenie Tabel
-- Create a new table called 'Miasto' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Miasto', 'U') IS NOT NULL
DROP TABLE dbo.Miasto
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Miasto
(
   MiastoId        INT    NOT NULL , -- primary key column
   Nazwa      [NVARCHAR](50)  NOT NULL,
   
	CONSTRAINT PK_Miasto PRIMARY KEY CLUSTERED (MiastoId)
);
GO


--************************************************
IF OBJECT_ID('dbo.Stacja', 'U') IS NOT NULL
DROP TABLE dbo.Stacja
GO
CREATE TABLE dbo.Stacja
(
 [StacjaId] int NOT NULL ,
 [nazwa]     varchar(50) NOT NULL ,
 [MiastoId] int NOT NULL ,


 CONSTRAINT PK_Stacja PRIMARY KEY CLUSTERED (StacjaId),
 CONSTRAINT FK_Stacja_Miasto FOREIGN KEY (MiastoId) 
	REFERENCES dbo.Miasto(MiastoId)
	ON DELETE CASCADE    
    ON UPDATE CASCADE
);
GO

--*************************************************
IF OBJECT_ID('dbo.Rodzaj', 'U') IS NOT NULL
DROP TABLE dbo.Rodzaj
GO
CREATE TABLE [dbo].[Rodzaj]
(
 [RodzajId] int NOT NULL ,
 [nazwa]      varchar(50) NOT NULL ,


 CONSTRAINT [PK_Rodzaj] PRIMARY KEY CLUSTERED ([RodzajId] ASC)
);
GO

--**********************************************
IF OBJECT_ID('dbo.Stopien_Uszkodzenia', 'U') IS NOT NULL
DROP TABLE dbo.Stopien_Uszkodzenia
GO
CREATE TABLE dbo.Stopien_Uszkodzenia
(
 [Stopien_Uszkodzenia_Id] int NOT NULL ,
 [opis]           varchar(50) NOT NULL ,


 CONSTRAINT [PK_Stopien_Uszkodzenia] PRIMARY KEY CLUSTERED ([Stopien_Uszkodzenia_Id] ASC)
);
GO

--********************************
IF OBJECT_ID('dbo.Rowery', 'U') IS NOT NULL
DROP TABLE dbo.Rowery
GO
CREATE TABLE [dbo].[Rowery]
(
 [RoweryId]      int NOT NULL ,
 [Laczny_czas]    float NOT NULL ,
 [RodzajId]     int NOT NULL ,
 [StacjaId]      int NOT NULL ,
 [Stopien_Uszkodzenia_Id] int NOT NULL ,


 CONSTRAINT [PK_Rowery] PRIMARY KEY CLUSTERED ([RoweryId] ASC),
 CONSTRAINT [FK_Rowery_Rodzaj] FOREIGN KEY ([RodzajId])
	REFERENCES [dbo].[Rodzaj]([RodzajId])
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
 CONSTRAINT [FK_Rowery_Stacja] FOREIGN KEY ([StacjaId])  
	REFERENCES [dbo].[Stacja]([StacjaId])
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
 CONSTRAINT [FK_Rowery_Stopien_Uszkodzenia] FOREIGN KEY (Stopien_Uszkodzenia_Id) 
	REFERENCES [dbo].[Stopien_Uszkodzenia]([Stopien_Uszkodzenia_Id])
		ON DELETE CASCADE    
		ON UPDATE CASCADE
);
GO

--***************************************
IF OBJECT_ID('dbo.Uzytkownik', 'U') IS NOT NULL
DROP TABLE dbo.Uzytkownik
GO
CREATE TABLE dbo.Uzytkownik
(
 [UzytkownikId]           int NOT NULL ,
 [Imie]                     varchar(50) NOT NULL ,
 [Nazwisko]                 varchar(50) NOT NULL ,
 [Nr_telefonu]              varchar(15)NOT NULL ,
 [Nr_karty]                 varchar(20) NOT NULL ,
 [Czas_rozpoczecia_wynajmu] time NOT NULL ,
 [Czas_zakonczenia_wynajmu] time NOT NULL ,
 [Data_urodzenia]           date NOT NULL ,
 [RoweryId]                int NOT NULL ,


 CONSTRAINT [PK_Uzytkownik] PRIMARY KEY CLUSTERED ([UzytkownikId] ASC),
 CONSTRAINT [FK_Uzytkownik_Rowery] FOREIGN KEY ([RoweryId]) 
	REFERENCES [dbo].[Rowery]([RoweryId])
		ON DELETE CASCADE    
		ON UPDATE CASCADE
);
GO



-- ************************************** [Historia_wypozyczen]
IF OBJECT_ID('dbo.Historia_wypozyczen', 'U') IS NOT NULL
DROP TABLE dbo.Historia_wypozyczen
GO
CREATE TABLE dbo.Historia_wypozyczen
(
 [Historia_wypozyczen_Id] int NOT NULL ,
 [UzytkownikId]  int NOT NULL ,
 [RoweryId]       int NOT NULL ,


 CONSTRAINT [PK_Historia_wypozyczen] PRIMARY KEY CLUSTERED ([Historia_wypozyczen_Id] ASC),
 CONSTRAINT [FK_Historia_wypozyczen_Uzytkownik] FOREIGN KEY ([UzytkownikId]) 
	REFERENCES [dbo].[Uzytkownik]([UzytkownikId])
		ON DELETE No Action    
		ON UPDATE No Action,
 CONSTRAINT [FK_Historia_wypozyczen_Rowery] FOREIGN KEY ([RoweryId])  
	REFERENCES [dbo].[Rowery]([RoweryId])
		ON DELETE No Action    
		ON UPDATE No Action
);
GO

--***************************************************male inserty

insert into dbo.Stopien_Uszkodzenia(Stopien_Uszkodzenia_Id,opis) values (1, 'Idealny stan')
insert into dbo.Stopien_Uszkodzenia(Stopien_Uszkodzenia_Id,opis) values (2, 'Drobny defekt')
insert into dbo.Stopien_Uszkodzenia(Stopien_Uszkodzenia_Id,opis) values (3, 'Male uszkodzenie')
insert into dbo.Stopien_Uszkodzenia(Stopien_Uszkodzenia_Id,opis) values (4, 'Powazny defekt')
insert into dbo.Stopien_Uszkodzenia(Stopien_Uszkodzenia_Id,opis) values (5, 'Duze uszkodzenie')
insert into dbo.Stopien_Uszkodzenia(Stopien_Uszkodzenia_Id,opis) values (6, 'Rower zepsuty')

insert into dbo.Rodzaj (RodzajId,nazwa) values (1, 'Rowery dzieciece')
insert into dbo.Rodzaj (RodzajId,nazwa) values (2, 'Rowery zwykle')
insert into dbo.Rodzaj (RodzajId,nazwa) values (3, 'Tandemy')
insert into dbo.Rodzaj (RodzajId,nazwa) values (4, 'Rowery elektryczne')