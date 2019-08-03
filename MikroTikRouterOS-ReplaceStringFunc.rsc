## Author : Piotr Wasyk
## Email: piotr@mwtc.pl
## version 1.0
## created at: 2017-10-04

##
## MikroTik RouterOS Sctipt replace specific characters in string (text)
##

#declaration of function
:global strReplaceFunc do={
    
	:local stringBefore $text
    :local stringAfter
    # definition of inappropriate chars -> char to replace
	:local badChars {" "="-";"/"="-";":"="-";}

    # check every char in stron in loop
	:for i from=0 to=([:len $stringBefore] - 1) do={ 
		:local char [:pick $stringBefore $i]
        # check is need to replace char
		:foreach badChar,goodChar in=$badChars do={
            :if ($char=$badChar) do={
				:set $charChar $goodChar;
			}
		}
        :set stringAfter ($stringAfter . $char)
	}
    
	#result 
	:return $stringAfter
}


# how to execute
:put [$strReplaceFunc text="jul/16/2018 11:33:22"];