function ConvertTo-RomanNumeral {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int]
        $InputNumber
    )

    # Roman "Zero"
    if ($InputNumber -eq 0) {

        throw "InvalidInput"

    } #if
    
    # Roman "C"
    if (($InputNumber / 100) -ge 1) {

        $numeral = "C"
        $result = [System.Math]::Floor($InputNumber / 100)

        $outputC = $numeral * $result
        
        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 100

    } #if

    # Roman "XC"
    if (($InputNumber / 90) -ge 1) {

        $numeral = "XC"
        $result = [System.Math]::Floor($InputNumber / 90)

        $outputXC = $numeral * $result
        
        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 90

    } #if

    # Roman "L"
    if (($InputNumber / 50) -ge 1) {

        $numeral = "L"
        $result = [System.Math]::Floor($InputNumber / 50)

        $outputL = $numeral * $result
        
        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 50

    } #if

    # Roman "XL"
    if (($InputNumber / 40) -ge 1) {

        $numeral = "XL"
        $result = [System.Math]::Floor($InputNumber / 40)

        $outputXL = $numeral * $result
        
        # Sets the remainder for the next if statement
        $InputNumber = $InputNumber % 40

    } #if

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



    $finaloutput = $outputC + $outputXC + $outputL + $outputXL + $outputX + $outputIX + $outputV + $outputIV + $outputI
    $finaloutput

} #function