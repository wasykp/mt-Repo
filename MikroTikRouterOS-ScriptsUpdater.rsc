## Author : Piotr Wasyk
## Email: piotr@mwtc.pl
## version 1.0
## created at: 2016-04-04

##
## MikroTik RouterOS Sctipt to easyly update script content during development. Script watch (in combination with /system scheduler) file directory in RouterOS
## and if content of file change (is different then a script doby) update the script (the same name as file)

## restriction: file cannot be bigger that 4KB

## folderName :: should be change to approriapte value 

##
{
	:foreach plik in=[/file find type="script" size<4000] do={
		:local plikNazwa [/file get $plik name];
		:if ($plikNazwa~"folderName" = true) do={
			:local plikZawartosc [/file get $plikNazwa contents];
			:do {
				:local skryptKod [/system script get $plikNazwa source]
                :if ($plikZawartosc != $skryptKod) do={
                    :put ("Script need to be modified: " . $plikNazwa)
                    /system script remove $plikNazwa
                    /system script add name=$plikNazwa source=$plikZawartosc
                }
			} on-error={
                :put ("New file was found, new scipt was created: " . $plikNazwa)
				/system script add name=$plikNazwa source=$plikZawartosc
			}
    	}
	}
}