function Get-TVWebLinks {

    param ($URI,$regex)
    # Web scrape for URI
    $fetch = Invoke-WebRequest -Uri $URI

    # Selects the relevant links, obviously works only with TV shows, not movies
    $rawtitles = (($fetch.links).title | Where-Object { $_ -match $Regex }) | Select-Object -Unique

    return $rawtitles

}


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
        #$arraylist = New-Object -TypeName "System.Collections.ArrayList"
        #$arraylist.Clear()
        
        foreach ($URI in $URIs) {
            
            $rawtitles = Get-TVWebLinks -URI $URI -regex $Regex
    
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
                #$arraylist.Add($temp) | Out-Null
                [pscustomobject]@{
                    ShowTitle = $temp.ShowTitle
                    Season = $temp.Season
                    Date = $temp.Date
                    Episode = $temp.Episode
                    EpTitle = $temp.EpTitle
                    EpisodeZeroed = $temp.EpisodeZeroed
                }
    
            } #foreach
            
        } #foreach

        # Return the result
        #return $arraylist

    } #process
} #function
