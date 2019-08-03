## Author : Piotr Wasyk
## Email: piotr@mwtc.pl
## version 1.0
## created at: 2016-08-14

##
## MikroTik RouterOS Sctipt to generate passowrd/ random string with specific lenght
##

# declare variables
:local random 0
:local charStrNum 1
:local p1
:local var1
:local var2
:local var3
:local newPassword ""
:local delay 0

# additional verbose info
:local dev 0
:local shres 1

# lenght of passowrd
:local newPassLength 6

# chars to shuffle
:local charStr1 "23456789ABCDEFGHJKLMNPQRSTUVWXYZ23456789abcdefghijkmnopqrstuvwxyz23456789"
:local charStr2 "cN47iKd2bLn8sQz4JAu2PD6Vm5RjTG4UrFY78XewHE3W9gMq62v7a9Z5yf5pC3k6xt9Bh8S3o"
:local charStr3 "uYswW92z6M5fJynQp6hGm5VSr4oR8k7A2bKq5U3FiZvc8gHP2tdL9E4jBT3X7xC6N4D8e7a93"

if ($dev=1) do={ :put ("password lenght was set to: " . $newPassLength) }

# draw a next char
:for char from=1 to=$newPassLength step=1 do={
    if ($dev=1) do={ :put ("iteration number: " . $char) }

:set var1 ([:pick [/system clock get time] 6 8])
    if ($dev=1) do={ :put ("value from time part: " . $var1) }

:set p1 ([:len [/system resource get uptime]])
:set var2 ([:pick [/system resource get uptime] ($p1-2) $p1])
    if ($dev=1) do={ :put ("value from RouterOs uptime: " . $var2) }

# okerslenie, ktory znak bedzie pobierany z talicy
:set var3 (($var1 * $var2) / 48)
    if ($dev=1) do={ :put ("number of char in chars table: " . $var3) }


# pick char from chars table (1,2,3)
:if ($charStrNum=1) do={
    :set newPassword ($newPassword . [:pick $charStr1 $var3]) }

    :if ($charStrNum=2) do={
:set newPassword ($newPassword . [:pick $charStr2 $var3]) }

    :if ($charStrNum=3) do={
:set newPassword ($newPassword . [:pick $charStr3 $var3])}

:set charStrNum ($charStrNum + 1)
    :if ($charStrNum = 6) do={
:set charStrNum 1 }

# delay
:if ( ($var1 + $var2 + $var3) < 60 ) do={
    :delay (($var1 + $var2 + $var3) / 25)
} else={
    :delay (($var1 + $var2 + $var3) / 45)
}
}

# if variable share is set to 1 generated strong will be additionally log to memory and put to console
if ($shres=1) do={
:log info $newPassword
:put $newPassword }





