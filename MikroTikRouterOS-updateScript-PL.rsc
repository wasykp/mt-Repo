#ver 1.1
# galaz paczek, stable ex current, long term ex bugfix
:global updChannel "current"

#informacje do powiadomienia o aktualizacji
#:local mailTeamtOS "Dokonano aktualizacji RouterOS na:  $[/system identity get name]"
#:local mailWiadomoscOS "Dokonalem aktializacji RouterOS z wersji $[/system package update get installed-version] do $[/system package update get latest-version]"

#:local mailTeamtFW "Dokonano aktualizacji Mikrotik Firmware na:  $[/system identity get name]"
#:local mailWiadomoscFW "Dokonalem aktualizacji Mikrotik Firmware z wersji $[get current-firmware] do $[get upgrade-firmware]"

:local mailAdmin "info@mwtc.pl"

# zmienna okreslajaca czy aktualizaowac takze firmware
:local firmwareUpdate 0

#przejscie do odpowiedniego poziomu drzewa konfiguracji
/system package update 

# sprawdzenie jaka jest aktualna wersja
set channel=$updChannel 
/system package update check-for-updates

#trzeba zaczekac aby RouterOS spradzil na serwerach Mikrotik i mial wynik
:delay 15s;

#jesli wersja zainstalowana rozni sie od obecnej to dokonaj aktualizacji
:if ([get installed-version] != [get latest-version]) do={

    #przed aktualizacja wysle powiadomienie do administratora
    /tool e-mail send to=$mailAdmin subject=$mailTeamtOS body=$mailWiadomoscOS
    #dodatkowo takze dodam wpis w log, przechowywanie logow poza pamiecia RAM
    :log info $mailWiadomoscOS

    # Wait for mail to be send & upgrade
    :delay 10s;

    # instalacja paczki (wykona restart urzadzenia)
    install

} else={

    :if ($firmwareUpdate = 1) do={
        # RouterOS latest, let's check for updated firmware
        :log info ("Nie znaleziono paczek do zainstalowania, sprawdze teraz czy jest firmware do aktualizacji")

        /system routerboard

        :if ([get current-firmware] != [get upgrade-firmware]) do={

            #przed aktualizacja wysle powiadomienie do administratora
            /tool e-mail send to=$mailAdmin subject=$mailTeamtFW body=$mailWiadomoscFW
            #dodatkowo takze dodam wpis w log, przechowywanie logow poza pamiecia RAM
            :log info $mailWiadomoscFW
            # Zaczekam aby wyslal sie mail
            :delay 10s;
            upgrade

            # zaczekam aby wykonala sie aktualizacja i restart urzadzenia
            :delay 180s;
            /system reboot

        } else={
            :log info ("Nie znzlaziono nowszej wersji firmware")
        }
    } else={
        :log info ("Nie znaleziono paczek do zainstalowania, koncze swoje dzialanie")
    }
}