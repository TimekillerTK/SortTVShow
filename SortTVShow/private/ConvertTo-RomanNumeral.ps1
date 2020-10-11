function ConvertTo-RomanNumeral {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int]
        $InputNumber
    )

    $outputX = $null
    $outputIX = $null
    $outputV = $null
    $outputIV = $null
    $outputI = $null

    # Roman "X"
    if (($InputNumber / 10) -ge 1) {

        $numeral = "X"
        $result = [System.Math]::Floor($InputNumber / 10)

        $outputX = $numeral * $result
        
        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 10

    } #if

    # Roman "IX"
    if (($InputNumber / 9) -ge 1) {
    

        $numeral = "IX"
        $result = [System.Math]::Floor($InputNumber / 9)

        $outputIX = $numeral * $result

        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 9
    } #if

    # Roman "V"
    if (($InputNumber / 5) -ge 1) {
    

        $numeral = "V"
        $result = [System.Math]::Floor($InputNumber / 5)

        $outputV = $numeral * $result

        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 5

    } #if

    # Roman "IV"
    if (($InputNumber / 4) -eq 1) {
    
        $numeral = "IV"
        $result = [System.Math]::Floor($InputNumber / 4)

        $outputIV = $numeral * $result
        
        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 4
        
    } #if

    # Roman "I"
    if (($InputNumber / 1) -ge 1) {
    

        $numeral = "I"
        $result = [System.Math]::Floor($InputNumber / 1)

        $outputI = $numeral * $result


    } #if

    $finaloutput = $outputX + $outputIX + $outputV + $outputIV + $outputI
    $finaloutput

} #function