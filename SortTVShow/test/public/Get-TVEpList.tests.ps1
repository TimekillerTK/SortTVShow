#region:Header
BeforeAll {
    . ($PScommandpath.Replace('.tests','')).Replace('\test','')
}
#endregion

Describe "Get-TVEpList" {
    Context "Check Parameters" {
        It "parameter URIs should exist" {

            Get-Command "Get-TVEpList" | Should -HaveParameter URIs -Mandatory -Type [String[]]

        }
        It "parameter Regex should exist" {

            Get-Command "Get-TVEpList" | Should -HaveParameter Regex -Type String -DefaultValue "Season "


        }
    }
    Context "Main tests" {
        $testCases = @(
            @{URI = "https://www.themoviedb.org/tv/1855-star-trek-voyager/season/1"; Output = "116235"; TestName = "Star Trek"}
            @{URI = "https://www.themoviedb.org/tv/35610-inuyasha/season/1"; Output = "598752"; TestName = "InuYasha"}
            @{URI = "https://www.themoviedb.org/tv/27660-legend-of-galactic-heroes/season/2"; Output = "163965"; TestName = "LOGH"}
    
        )
        It "should return the same value when querying website for <TestName> season" -TestCases $testCases {
            param($URI, $output)
            (Invoke-WebRequest -Uri $URI).RawContentLength | Should -Be $Output
        }
    }
    Context "Get-TVWebLinks tests" {

        $testCases = @(
            @{URI = ""; Output = "116235"; TestName = "Star Trek"}
            @{URI = ""; Output = "598752"; TestName = "InuYasha"}
            @{URI = ""; Output = "163965"; TestName = "LOGH"}
    
        )

        # This should be fixed ok? OK! HTTP Response object is needed here... But maybe not, try to isolate it somehow
        It "should return items that match the regex"  {

            $variable = "vars for pscustomobject are here"
            Mock 'Invoke-WebRequest' { 
                # [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]@{
                #     Links = [PSCustomObject]@{
                #         Title = [string]@{ }
                #     }

                # }
                
                @("Season - Result1", "Not - Result2", "Pasta ... Result3") 
            }

            Get-TVWebLinks -URI blabla -regex "Season " | Should -Contain "Season - Result1"

        }

    }
    Context "Output tests" {
        It "should return input split into objects"  {

            Mock 'Get-TVWebLinks' {
                @(
                    "Spaghetti: Season 5 (2020): Episode 55 - Pasta, Pasta"
                )
            }

            $global:object = [pscustomobject]@{
                ShowTitle = "Spaghetti"
                Season = 5
                Date = 2020
                Episode = 55
                EpTitle = 'Pasta, Pasta'
                EpisodeZeroed = "55"
            }

            #$properties = (($object | Get-Member) | Where-Object {$_.membertype -eq "NoteProperty"}).Name
            $properties = $object.PSObject.Properties.Name

            foreach ($name in $properties) {
                (Get-TVEpList -URIs sillywebsite.com).$name | Should -Be $object.$name
            }
            
        }

    }
    Context "Other Websites Check" -Skip {
        #Unfinished work below
        $testCases = @(
            @{URI = "https://www.imdb.com/title/tt0060028/episodes?season=1&ref_=tt_eps_sn_1"; Output = "116235"; TestName = "Star Trek"}
            @{URI = "https://myanimelist.net/anime/41006/Higurashi_no_Naku_Koro_ni_Gou"; Output = "598752"; TestName = "InuYasha"}
            @{URI = "otherwbsite"; Output = "163965"; TestName = "LOGH"}
    
        )
        # It "should throw an error when supplied with a website other than www.themoviedb.org" -TestCases $testCases {
        #     param($URI)
        #     $URIs -notmatch "(https:\/\/www\.themoviedb\.org).*" | Should -Throw
        # }
    }
    Context "Checking Output" {
        It "Should return PSCustomObject" {
            # Should be mock here for something because it honestly doesn't need to look up something to check whether it returns a [pscustomobject]
            #Get-TVEpList -URIs "https://www.themoviedb.org/tv/1855-star-trek-voyager/season/1" | Should -BeOfType [pscustomobject]
        }
        
    }

    # IT also needs to check whether the output from the external API is the same (the website). If not, error.
    # Needs to check whether it's a www.themoviedb.org website, and result in an error if not
    # NEeds to return a mock output:
    <#
    describe 'Get-Employee' {
    mock 'Import-Csv' {
        [pscustomobject]@{
            FirstName = 'Adam'
            LastName  = 'Bertram'
            UserName  = 'abertram'
        }
    }
    it 'returns all expected users' {
        $users = Get-Employee
        $users.FirstName | should -Be 'Adam'
        $users.Lastname | should -Be 'Bertram'
        Mocking Introduction 35
        $users.UserName | should -Be 'abertram'
    }
}

    #>
}