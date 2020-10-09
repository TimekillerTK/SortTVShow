# SortTVShow
A module to help manage show titles in a directory with proper formatting.
* `Get-TVEpList` - Retrieve info about episodes for a show, used with https://www.themoviedb.org/ specifically.
* `Format-TVEpInfo` - Intended to format input objects into a string suitable for file names.

Example output: `Show Title - Season 2 - Episode 034 - Episode Title.txt`



## How to use
* Run `Get-TVEpList -URI https://www.themoviedb.org/tv/####/season/##` to get episodes returned as objects.
* `Import-CSV c:\file.csv | Format-TVEpInfo -Extension txt`
* `Get-TVEpList https://url.com/show/season/1 | Format-TVEpInfo -Extension txt`
* Check `Get-Help Format-TVEpInfo`

## Todo
- Current way of passing parameters to the cmdlet is a bit strange - should accept a custom format akin to `Get-Date -Format "dddd MM/dd/yyyy HH:mm K"` for displaying Season/Episode/etc
- `ConvertTo-RomanNumeral` function has too many if statements, need to check if it can be turned into a switch or programmed more efficiently.
- ~~Help is currently broken~~
  - _Fixed_
- ~~Instead of using `'Season '` as a match, should prompt the user for what to match for, this will make it useful for scraping other websites as well~~
  - _Instead of prompting, it can be specified with the `-Regex` parameter_
- ~~Add a parameter `-RemoveIllegalChar` to optionally remove illegal NTFS characters `"/ ? < > \ : * | "`~~
  - _Done_
- Add support for searching by title instead of only URI
- Uses regex pattern to find relevant info, as a result is fragile and can break easily. Find different solution?
- Currently only works on TV shows, should work on movies as well