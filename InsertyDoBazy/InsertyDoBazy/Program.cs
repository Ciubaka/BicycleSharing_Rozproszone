using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using CsvHelper;
using System.Text;

namespace InsertyDoBazy
{
    class Program
    {
        string connectToServer = "Server=DESKTOP-J7HMQKN\\SQLEXPRESS;Database=BicycleSharing_Rozproszone;Trusted_Connection=True;";
        int autoincrement = 10000;
        List<string> citiesList = new List<string>();
        List<string> stationsList;
        List<Users> usersList = new List<Users>();
        public enum NamesOfRecord{ CITY, STATIONS, BICYCLE, USERS, HISTORYOFRENTING}
        public enum NazwyRekordow{ Historia_wypozyczen, Uzytkownik, Rowery, Stacja, Miasto }

        public Program(int numberOfData)
        {

            FromCVStoList();
            DeleteDataFromDatabase();
            InitInsert();


            switch (numberOfData)
            {
                case 100:
                    {
                        for (int i = 0; i < 90000; i++)
                        {
                            foreach (NamesOfRecord names in Enum.GetValues(typeof(NamesOfRecord)))
                                Inserty(names);
                        }
                        break;
                    }
                case 250:
                    {
                        for (int i = 0; i < 240000; i++)
                        {
                            foreach (NamesOfRecord names in Enum.GetValues(typeof(NamesOfRecord)))
                                Inserty(names);

                        }
                        break;
                    }
                case 500:
                    {
                        for (int i = 0; i < 490000; i++)
                        {
                            foreach (NamesOfRecord names in Enum.GetValues(typeof(NamesOfRecord)))
                                Inserty(names);
                        }
                        break;
                    }
                default:
                    Console.WriteLine("Wpisz 100, 250 lub 500");
                    break;
            }


        }


        /**
         * Trzy sposoby wydobycia danych z plikow .CSV i przeniesienia ich do List
         * 
         */
        public void FromCVStoList()
        {
            /**
             * Pierwysz sposob polega na powolaniu StreamReadera, pobieraniu po jednej lini i wrzucaniu do tablicy stringow,
             * gdzie kazdy element odpwiada innej danej, tutaj mielismy tylko nazwe Miast wiec byla 1 kolumna, element[0] nas interesowal
             */
            for (int i = 1; i < 6; i++)
            {
                using (StreamReader sr = new StreamReader(Path.Combine(PathToMainCatalog(1), @"CSV\Miasto" + i + ".csv")))
                {
                    String wiersze;

                    while ((wiersze = sr.ReadLine()) != null)
                    {
                        string[] elementy = wiersze.Split(',');
                        citiesList.Add(elementy[0]);
                    }
                }
            }

            /**
             * Drugi sposob polega od razu na wydostaniu wszystkich danych/linii z pliku i wrzyceniu ich do tablicy, gdzie kazdy element tablicy to
             * kolejny rekord, motoda sprawdzi sie tylko jak mamy jedna dana w rekordzie, tutaj tylko nazwa stacji
             */
            string[] lines = File.ReadAllLines(Path.Combine(Path.GetDirectoryName(PathToMainCatalog(2)), @"CSV\Stacja.csv"));
            stationsList = new List<string>(lines);



            /**
             * Sposob korzystajacy z pakietu NuGet CSVHelper, przy pomocy ktorego mozna kazdy element znajdujacy sie w pliku, bez problemu dopasowac do
             * zmiennej w konkretnej klasie, u nas klasa Users
             */
            for (int i = 1; i < 10; i++)
            {
                using (var reader = new StreamReader(Path.Combine(Path.GetDirectoryName(PathToMainCatalog(2)), @"CSV\Uzytkownik" + i + ".csv")))
                using (var csv = new CsvReader(reader))
                {
                    csv.Configuration.Delimiter = ",";
                    csv.Read();
                    csv.ReadHeader();
                    while (csv.Read())
                    {
                        var record = new Users
                        {

                            Imie = csv.GetField("Imie"),
                            Nazwisko = csv.GetField("Nazwisko"),
                            Nr_telefonu = csv.GetField("Nr_telefonu"),
                            Nr_karty = csv.GetField("Nr_karty"),
                            Data_urodzenia = csv.GetField("Data_urodzenia")
                        };
                        usersList.Add(record);
                    }
                }
            }



        }



        private string PathToMainCatalog(int i)
        {
            var dir = new DirectoryInfo(Directory.GetCurrentDirectory());
            if (i == 1)
            {


                while (dir.Parent.Name != "InsertyDoBazy")
                {
                    dir = dir.Parent;
                }
            }

            else if (i == 2)
            {

                while (dir.Parent.Name != "bin")
                {
                    dir = dir.Parent;
                }

            }

            return dir.Parent.FullName;
        }

        private void InitInsert()
        {
            autoincrement = 1;
            for (int i = 0; i < 10000; i++)
            {
                Inserty(NamesOfRecord.CITY);
            }

            autoincrement = 1;
            for (int i = 0; i < 10000; i++)
            {
                Inserty(NamesOfRecord.STATIONS);
            }


            autoincrement = 1;
            for (int i = 0; i < 10000; i++)
            {
                Inserty(NamesOfRecord.BICYCLE);
            }


            autoincrement = 1;
            for (int i = 0; i < 10000; i++)
            {
                Inserty(NamesOfRecord.USERS);
            }


            autoincrement = 1;
            for (int i = 0; i < 10000; i++)
            {
                Inserty(NamesOfRecord.HISTORYOFRENTING);
            }
        }


        private bool DeleteDataFromDatabase()
        {
            using (var connection = new SqlConnection(connectToServer))
            {
                connection.Open();
                foreach (NazwyRekordow nazwy in Enum.GetValues(typeof(NazwyRekordow)))
                { 
                var cmnd = new SqlCommand("DELETE FROM dbo." + nazwy, connection);
                cmnd.ExecuteNonQuery();
                }
                connection.Close();
            }

            return true;
        }


        private void Inserty(NamesOfRecord names)
        {
            Random r = new Random();
            String insertLine = null;
            switch (names)
            {
                case NamesOfRecord.CITY:
                    insertLine = "INSERT INTO dbo.Miasto " +
                        "(MiastoId, Nazwa) VALUES" +
                        "( " + autoincrement++ + ", '" + citiesList[r.Next(2, 1000)] + "')";
                    break;

                case NamesOfRecord.STATIONS:
                    insertLine = "INSERT INTO dbo.Stacja " +
                                   "(StacjaId, nazwa, MiastoId) VALUES" +
                                   "( " + autoincrement++ + ", '" + stationsList[r.Next(2, 1000)] + "', " + r.Next(2, 1000) + ")";
                    break;

                case NamesOfRecord.BICYCLE:
                    insertLine = "INSERT INTO dbo.Rowery " +
                        "(RoweryId, Laczny_czas, RodzajId, StacjaId, Stopien_Uszkodzenia_Id) VALUES" +
                        "(" + autoincrement++ + "," + r.Next(1,500) + ", " + r.Next(1, 5) + ", " + r.Next(1, 1000) + ", " + r.Next(1, 7) + ")";
                    break;
                case NamesOfRecord.USERS:
                        int randomStartHour = r.Next(0, 16);
                        int randomStartMinute = r.Next(0, 39);
                        int randomStartSecond = r.Next(0, 59);
                        int randomStopHour = (randomStartHour + r.Next(0, 7)%24);
                        int randomStopMinute = (randomStartMinute + r.Next(0, 20)%60);
                        int randomStopSecond = (randomStartSecond + r.Next(0, 20))%60;
                        
                        string startTime = randomStartHour + ":" + randomStartMinute + ":" + randomStartSecond;
                        string stopTime = randomStopHour + ":" + randomStopMinute + ":" + randomStopSecond;


                    insertLine = "INSERT INTO dbo.Uzytkownik " +
                                 "(UzytkownikId, Imie, Nazwisko, Nr_telefonu, Nr_karty, " +
                                 "Czas_rozpoczecia_wynajmu, Czas_zakonczenia_wynajmu, Data_urodzenia, RoweryId ) VALUES" +
                                    "( " + autoincrement++ + ", '" + usersList[r.Next(1, 8999)].Imie + "', '" + usersList[r.Next(1, 8999)].Nazwisko +
                                    "', '" + usersList[r.Next(1, 8999)].Nr_telefonu + "', '" + usersList[r.Next(1, 8999)].Nr_karty +
                                    "', '" + startTime +"', '" + stopTime +"', '" + usersList[r.Next(1, 8999)].Data_urodzenia + "', " + r.Next(1, 5000) + ")";
                    break;
                case NamesOfRecord.HISTORYOFRENTING:
                    insertLine = "INSERT INTO dbo.Historia_wypozyczen " +
                                   "(Historia_wypozyczen_Id, UzytkownikId, RoweryId) VALUES" +
                                   "( " + autoincrement++ + ", " + r.Next(1,1000) + ", "+ r.Next(1,1000) + ")";
                    break;
                default:
                    insertLine = "SELECT * FROM dbo.Rowery";
                    break;
            }

            addToDatabase(insertLine);
        }



        private bool addToDatabase(string insert)
        {
            using (var connection = new SqlConnection(connectToServer))
            {
                string line = insert;
                connection.Open();
                var cmnd = new SqlCommand(line, connection);
                cmnd.ExecuteNonQuery();
                connection.Close();
            }

            return true;
        }


        static void Main(string[] args)
        {

            Console.WriteLine("Ile danych chcesz wprowadzic? 100k, 250k, 500k?");
            Console.WriteLine("Wpisz liczbe: ");
            string liczbaDanych  = Console.ReadLine();
            Program program = new Program(int.Parse(liczbaDanych));
            
        }
    }
}
