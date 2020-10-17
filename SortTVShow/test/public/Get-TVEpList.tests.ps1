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
    Context "Checks for changes on website" {
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
    Context "Test Regex" {

        $testCases = @(
            @{RegexTest = "Season "; TestTitle = "Season - Result1"}
            @{RegexTest = "Season "; TestTitle = "Star Trek - Season 5"}
            @{RegexTest = "Season "; TestTitle = "Youtube - something - Season 3"}
    
        )

        It "should return regex match '<regextest>' for <testtitle>" -TestCases $testCases  {


            mock "Invoke-WebRequest" {
                [PSCustomObject]@{
                    Links = [PSCustomObject]@{
                        Title = $testtitle
                    }
                }
            }
 

            Get-TVWebLinks -URI blabla -Regex $RegexTest | Should -Contain $testtitle

        }

    }
    Context "Output tests" {
        It "should take string and split into objects"  {

            Mock 'Get-TVWebLinks' {
                @(
                    "Spaghetti: Season 5 (2020): Episode 55 - Pasta, Pasta"
                )
            }

            $object = [pscustomobject]@{
                ShowTitle = "Spaghetti"
                Season = 5
                Date = 2020
                Episode = 55
                EpTitle = 'Pasta, Pasta'
                EpisodeZeroed = "55"
            }

            $properties = $object.PSObject.Properties.Name

            foreach ($name in $properties) {
                (Get-TVEpList -URIs www.themoviedb.org).$name | Should -Be $object.$name
            }
            
        }

    }
    Context "Other Websites Check" {
        
        $testCases = @(
            @{URI = "https://www.imdb.com/title/tt0060028/episodes?season=1&ref_=tt_eps_sn_1"}
            @{URI = "https://myanimelist.net/anime/41006/Higurashi_no_Naku_Koro_ni_Gou"}
    
        )

        It "should throw an error with website <URI>" -TestCases $testCases {
            { Get-TVEpList -URIs $uri } | Should -Throw
        }
    }

}