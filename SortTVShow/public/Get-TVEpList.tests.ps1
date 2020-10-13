#region:Header
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
#endregion

Describe "Get-TVEpList" {
    Context "Check Parameters" {
        It "Checking URI" {

            Get-Command "Get-TVEpList" | Should -HaveParameter URIs -Mandatory -Type [String[]]

        }
        It "Checking Regex" {

            Get-Command "Get-TVEpList" | Should -HaveParameter Regex -Type String

        }
    }
    Context "Checking Output" {
        It "Should return PSCustomObject" {
            Get-TVEpList -URIs "https://www.themoviedb.org/tv/1855-star-trek-voyager/season/1" | Should -BeOfType [pscustomobject]
        }
        
    }
}