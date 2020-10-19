function ConvertTo-RomanNumeral {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int]
        $InputNumber
    )

    function PrivateFunc ($Integer,$RomanInteger) {

        if (($InputNumber / $Integer) -ge 1) {
    
            # How many times this roman numeral should be printed
            $TimesRoman = [System.Math]::Floor($InputNumber / $Integer)

            # Return the roman numeral
            $RomanInteger * $TimesRoman

        } #if
    
    }

    # Roman "Zero"
    if ($InputNumber -eq 0) {

        throw "InvalidInput"

    } #if

    # Roman Numerals list
    $iterations = [PSCustomObject]@{
        RomanM = @{ a = 1000; b = "M"}
        RomanD = @{ a = 500; b = "D"}
        RomanC = @{ a = 100; b = "C"}
        RomanXC = @{ a = 90; b = "XC"}
        RomanL = @{ a = 50; b = "L"}
        RomanXL = @{ a = 40; b = "XL"}
        RomanX = @{ a = 10; b = "X"}
        RomanIX = @{ a = 9; b = "IX"}
        RomanV = @{ a = 5; b = "V"}
        RomanIV = @{ a = 4; b = "IV"}
        RomanI = @{ a = 1; b = "I"}
    } # iterations var

    # All other roman numerals
    $iterations.PSObject.Properties.Name | ForEach-Object {
    
        #Write-Output $iterations.$_['b']
        #Write-Output $iterations.$_['a']
    
        $value = PrivateFunc -Integer $iterations.$_['a'] -RomanInteger $iterations.$_['b']

        # Set the remainder for the next if statement
        $InputNumber = $InputNumber % $iterations.$_['a']

        $finaloutput = $finaloutput + $value
    
    } #Foreach-Object
    
    return $finaloutput
  
} #function