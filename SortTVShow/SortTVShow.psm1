$private = @(
    'ConvertTo-RomanNumeral'
)

foreach ($file in $private) {
    . ("{0}\private\{1}.ps1" -f $psscriptroot, $file)
}

$public = @(
    'Format-TVEpInfo'
    'Get-TVEpList'

)

foreach ($file in $public) {
    . ("{0}\public\{1}.ps1" -f $psscriptroot, $file)
}

$functionsToExport = @(
    'Format-TVEpInfo'
    'Get-TVEpList'
)
Export-ModuleMember -Function $functionsToExport
