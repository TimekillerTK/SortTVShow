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
                $eptitle = $eptitle -replace "[0-9]" ,{ConvertTo-RomanNumeral -InputNumber $Matches[0]}
                
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
