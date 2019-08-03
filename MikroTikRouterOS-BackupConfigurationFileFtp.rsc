## Author : Piotr Wasyk
## Email: piotr@mwtc.pl
## version 1.0
## created at: 2017-10-04

##
## MikroTik RouterOS Sctipt to automate backup and export and store result in FTP folder
##

# imports trReplaceFunc to script (MikroTikRouterOS-ReplaceStringFunc.rsc)
:global strReplaceFunc

# declare variables
:local fileNameExport "";
:local fileNameBackup "";

# FTP1
:local ftpHost ""
:local ftpUser ""
:local ftpPass ""
:local ftpDstPath ""

# FTP2 (optional)
:local ftp2Host ""
:local ftp2User ""
:local ftp2Pass ""
:local ftp2DstPath ""

# collect meta data to put them into files name
:local identity [/system identity get name];
:local date [/system clock get date];
:local time [/system clock get time];
:local version [/system package update get installed-version];
# correct date and time values to be more appropriate as file names
:set date [$strReplaceFunc text=$date];
:set time [$strReplaceFunc text=$time];

# set final file names for backup and export file
:set fileNameExport ("configExport-".$identity."-".$version."-".$date."-".$time);
:set fileNameBackup ("configBackup-".$identity."-".$version."-".$date."-".$time);


# do export and backup of configuration
/export file=$fileNameExport;
/system backup save name=$fileNameBackup

# send file via FTP do FTP1
/tool fetch address=$ftpHost src-path=($fileNameExport.".rsc") dst-path=($ftpDstPath . "Uploaded-export-".$fileNameExport.".rsc") \
upload=yes mode=ftp user=$ftpUser  password=$ftpPass
/tool fetch address=$ftpHost src-path=($fileNameBackup.".backup") dst-path=($ftpDstPath . "Uploaded-backup-".$fileNameBackup.".backup") \
upload=yes mode=ftp user=$ftpUser  password=$ftpPass

# send file via FTP do FTP2 (if FTP2 host was specified)
:if ([:len $ftp2Host] != 0) do={
/tool fetch address=$ftp2Host src-path=($fileNameExport.".rsc") dst-path=($ftp2DstPath . "Uploaded-export-".$fileNameExport.".rsc") \
upload=yes mode=ftp user=$ftp2User  password=$ftp2Pass
/tool fetch address=$ftp2Host src-path=($fileNameBackup.".backup") dst-path=($ftp2DstPath . "Uploaded-backup-".$fileNameBackup.".backup") \
upload=yes mode=ftp user=$ftp2User  password=$ftp2Pass
}

# END
