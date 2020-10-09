#Requires -Version 7.0

# Function
function Get-TVEpList {
    <#
    .SYNOPSIS
    This tool will fetch individual episode titles from https://www.themoviedb.org

    .DESCRIPTION
    Tool for fetching individual episodes from https://www.themoviedb.org. Does not currently work with other websites.

    .PARAMETER URI
    Should be a URI pointing to an individual season of a specific show, like for example: https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1. Can include more than one URI.

    .PARAMETER REGEX
    This regex pattern will be searched for within the URI provided

    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 
    
    This example will simply retrieve the episode titles from the URL and return them as an object
    
    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 -Regex "Spaghetti"
    
    This example uses a custom regex instead of the default "Season "

    .INPUTS
    String

    .OUTPUTS
    PSCustomObject

    .NOTES
    Author:  TimekillerTK
    Website: https://github.com/TimekillerTK
#>

    #CmdletBinding turns the function into an advanced function
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [string[]]$URIs,

        [Parameter()]
        [string]$Regex = "Season "

    )
    PROCESS {

        # Create an empty arraylist object
        # This is suboptimal, optimize it LATER
        $arraylist = New-Object -TypeName "System.Collections.ArrayList"
        $arraylist.Clear()
            
        foreach ($URI in $URIs) {
            
            # Web scrape for URI
            $fetch = Invoke-WebRequest -Uri $URI
    
            # Selects the relevant links, obviously works only with TV shows, not movies
            $rawtitles = (($fetch.links).title | Where-Object { $_ -match $Regex }) | Select-Object -Unique
    
            # Template for ConvertFrom-String, doesn't work perfectly in all cases, needs to be looked at.
            $template = ("{ShowTitle*:Example Title}: Season {[int]Season:1} ({[int]Date:1988}): Episode {[int]Episode:1} - {EpTitle:Spaghetti Code?}`r`n" +
                        "{ShowTitle*:Another Example Title}: Season {[int]Season:17} ({[int]Date:2004}): Episode {[int]Episode:42} - {EpTitle:Wonderful, Spices!!!}`r`n" +
                        "{ShowTitle*:SomeThing}: Season {[int]Season:47} ({[int]Date:1950}): Episode {[int]Episode:142} - {EpTitle:nothing}")
    


            foreach($item in $rawtitles) {
                
                # converts the object 
                $temp = $item | ConvertFrom-String -TemplateContent $template

                # Setting the number of episodes as a string, for the next operation
                $str = [string]($rawtitles.count) 
                
                # Replaced complicated switch with a simple trick with String.PadLeft
                # This first sets the current episode to a string
                # Then once that is done, it pads left with zeroes until the length is equal to $str.length
                $en = ([string]$temp.Episode).PadLeft($str.length,'0')

                # Adds the EpisodeZeroed property to the object
                $temp | Add-Member -MemberType NoteProperty `
                                   -Name 'EpisodeZeroed' `
                                   -Value $en


                # add an object to the arraylist
                $arraylist.Add($temp) | Out-Null
    
            } #foreach

        } #foreach

        # Return the result
        return $arraylist

    } #process
} #function

function ConvertTo-RomanNumeral {

    # Input needs to be tuned/fixed
    $number = 1

    $outputX = $null
    $outputIX = $null
    $outputV = $null
    $outputIV = $null
    $outputI = $null

    # Roman "X"
    if (($number / 10) -ge 1) {

        $numeral = "X"
        $result = [System.Math]::Floor($number / 10)

        $outputX = $numeral * $result
        
        # Sets the remainder for the next if statement
        $number = $number % 10

    } #if

    # Roman "IX"
    if (($number / 9) -ge 1) {
    

        $numeral = "IX"
        $result = [System.Math]::Floor($number / 9)

        $outputIX = $numeral * $result

        # Sets the remainder for the next if statement
        $number = $number % 9
    } #if

    # Roman "V"
    if (($number / 5) -ge 1) {
    

        $numeral = "V"
        $result = [System.Math]::Floor($number / 5)

        $outputV = $numeral * $result

        # Sets the remainder for the next if statement
        $number = $number % 5

    } #if

    # Roman "IV"
    if (($number / 4) -eq 1) {
    
        $numeral = "IV"
        $result = [System.Math]::Floor($number / 4)

        $outputIV = $numeral * $result
        
        # Sets the remainder for the next if statement
        $number = $number % 4
        
    } #if

    # Roman "I"
    if (($number / 1) -ge 1) {
    

        $numeral = "I"
        $result = [System.Math]::Floor($number / 1)

        $outputI = $numeral * $result


    } #if

    $finaloutput = $outputX + $outputIX + $outputV + $outputIV + $outputI
    $finaloutput

} #function

function Format-TVEpInfo {
    <#
    .SYNOPSIS
    Some Synopsis

    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [PSCustomObject[]]
        $InputObject,

        # Must be up to 3 characters in length
        [ValidateLength(1,3)]
        [string]
        $Extension,

        # Will remove numbers from the Season and replace them with roman numerals
        [switch]
        $RomanNumerals,

        # Will remove NTFS illegal characters / ? < > \ : * | " from the Episode Title 
        [switch]
        $RemoveIllegalChar,

        # Will include season info
        [switch]
        $Season,

        # Will include year info
        [switch]
        $Year
    )
    PROCESS {

        # Loop is accepting values one by one, which is why object count will always be 1
        # This foreach is probably useless, get rid of it later      
        foreach ($object in $InputObject) {

            $eptitle = $object.EpTitle

            if ($PSBoundParameters.ContainsKey('RemoveIllegalChar')) {
                    
                # NTFS illegal characters for filenames, regex format
                $illegalchar = "\'", "\""", "\/", "\?", "\<", "\>", "\\", "\:", "\*", "\|" 
    
                # Loop that goes over each illegal character
                foreach ($item in $illegalchar) {
                    $eptitle = $eptitle -replace $item,""            
                } #foreach
            } #if

            # This block deals with the RomanNumerals parameter
            if ($PSBoundParameters.ContainsKey('RomanNumerals')) {

                # This is what will swap the number itself
                # The $Matches var returns the matches that were matched by -match
                $eptitle -match "[0-9]" | Out-Null
                $eptitle = $eptitle -replace "[0-9]" ,{ConvertTo-RomanNumeral $Matches[0]}
                
            } #if
            
            # setting variables for the output string (formatted text)
            $showtitle = $object.ShowTitle
            $episode = " - Episode " + $object.EpisodeZeroed
            $eptitle = " - " + $eptitle

            if ($PSBoundParameters.ContainsKey('Season')) {

                $seasonvar = " - Season " + $object.Season

            } #if

            if ($PSBoundParameters.ContainsKey('Year')) {
                    
                $datevar = " - ($($object.Date))"

            } #if

            # Combines all the variables to a final string
            $output = $showtitle + $seasonvar + $datevar + $episode + $eptitle

            # This block deals with the Extension parameter
            if ($PSBoundParameters.ContainsKey('Extension')) {
                
                $output = $output + ".$($Extension)"
            
            } #if 
        
        } #foreach

        return $output

    } #PROCESS
} #function

