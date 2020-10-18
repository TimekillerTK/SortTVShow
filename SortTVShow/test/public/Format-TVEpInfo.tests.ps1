BeforeAll {
    . ($PScommandpath.Replace('.tests','')).Replace('\test','')
    #Hardcoded value - to be fixed later 
    $Path = $PSScriptRoot.Substring(0, $psscriptroot.IndexOf("\test")) + "\private\ConvertTo-RomanNumeral.ps1"
    . "$Path"
}


Describe "Format-TVEpInfo" {
    # Need Pester -ForEach in this example, see if it you can find it
    $TestObjects = @(
        @{ShowTitle = "Spaghetti"; Season = 5; Date = 2020; Episode = 55; EpTitle = 'Pas\ta, Pasta (Part 1)'; EpisodeZeroed = "55"}
    )

    Context "Output tests" {

            It "should take object and output a string" -TestCases $TestObjects  {
                
                $object = [pscustomobject]@{
                    ShowTitle = $ShowTitle
                    Season = $Season
                    Date = $Date
                    Episode = $Episode
                    EpTitle = $Eptitle
                    EpisodeZeroed = $EpisodeZeroed
                }

                Format-TVEpInfo -inputobject $object | Should -Be 'Spaghetti - Episode 55 - Pas\ta, Pasta (Part 1)'

            }
            
            It "test object with romannumerals" -TestCases $TestObjects {
                $object = [pscustomobject]@{
                    ShowTitle = $ShowTitle
                    Season = $Season
                    Date = $Date
                    Episode = $Episode
                    EpTitle = $Eptitle
                    EpisodeZeroed = $EpisodeZeroed
                }

                Format-TVEpInfo -inputobject $object -Romannumerals | Should -Be 'Spaghetti - Episode 55 - Pas\ta, Pasta (Part I)'
            }
            It "test object with extension" -TestCases $TestObjects{
                $object = [pscustomobject]@{
                    ShowTitle = $ShowTitle
                    Season = $Season
                    Date = $Date
                    Episode = $Episode
                    EpTitle = $Eptitle
                    EpisodeZeroed = $EpisodeZeroed
                }

                Format-TVEpInfo -inputobject $object -Romannumerals -extension "mkv" | Should -Be 'Spaghetti - Episode 55 - Pas\ta, Pasta (Part I).mkv'
            }
            It "test object with illegal characters" -TestCases $TestObjects {
                    $object = [pscustomobject]@{
                        ShowTitle = $ShowTitle
                        Season = $Season
                        Date = $Date
                        Episode = $Episode
                        EpTitle = $Eptitle
                        EpisodeZeroed = $EpisodeZeroed
                    }
    
                    Format-TVEpInfo -inputobject $object -Romannumerals -extension "mkv" -RemoveIllegalChar | Should -Be 'Spaghetti - Episode 55 - Pasta, Pasta (Part I).mkv'
            }
            It "test object with included season" -TestCases $TestObjects {
                $object = [pscustomobject]@{
                    ShowTitle = $ShowTitle
                    Season = $Season
                    Date = $Date
                    Episode = $Episode
                    EpTitle = $Eptitle
                    EpisodeZeroed = $EpisodeZeroed
                }

                Format-TVEpInfo -inputobject $object -Romannumerals -extension "mkv" -RemoveIllegalChar -Season | Should -Be 'Spaghetti - Season 5 - Episode 55 - Pasta, Pasta (Part I).mkv'
            }
            It "test object with included year" -TestCases $TestObjects {
                $object = [pscustomobject]@{
                    ShowTitle = $ShowTitle
                    Season = $Season
                    Date = $Date
                    Episode = $Episode
                    EpTitle = $Eptitle
                    EpisodeZeroed = $EpisodeZeroed
                }

                Format-TVEpInfo -inputobject $object -Romannumerals -extension "mkv" -RemoveIllegalChar -Season -Year | Should -Be 'Spaghetti - Season 5 - (2020) - Episode 55 - Pasta, Pasta (Part I).mkv'
            }
    }
    # Needs integration test to check what happens when you feed it 1 object vs many objects from Get-TVEpInfo
}