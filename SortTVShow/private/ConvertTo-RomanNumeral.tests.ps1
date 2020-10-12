#region:Header
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
#endregion

Describe "ConvertTo-RomanNumeral" {
    It "Zero should throw an error" {
        { ConvertTo-RomanNumeral -InputNumber 0 } | Should -Throw -ErrorId "InvalidInput"
    }
    It "String should throw error" {
        { ConvertTo-RomanNumeral -InputNumber sgfhsrf } | Should -Throw -ErrorId "ParameterArgumentTransformationError"
    }
    It "Always returns a string" {
        ConvertTo-RomanNumeral -InputNumber 5 | Should -BeOfType [string]
    }
    It "Checks roman 5" {
        ConvertTo-RomanNumeral -InputNumber 5 | Should -Be "V"
    }
    It "Checks roman 4" {
        ConvertTo-RomanNumeral -InputNumber 4 | Should -Be "IV"
    }
    It "Checks roman 1" {
        ConvertTo-RomanNumeral -InputNumber 1 | Should -Be "I"
    }
    It "Checks roman 9" {
        ConvertTo-RomanNumeral -InputNumber 9 | Should -Be "IX"
    }
    It "Checks roman 10" {
        ConvertTo-RomanNumeral -InputNumber 10 | Should -Be "X"
    }
    It "Checks roman 17" {
        ConvertTo-RomanNumeral -InputNumber 17 | Should -Be "XVII"
    }
    It "Checks roman 40" {
        ConvertTo-RomanNumeral -InputNumber 40 | Should -Be "XL"
    }
    It "Checks roman 50" {
        ConvertTo-RomanNumeral -InputNumber 50 | Should -Be "L"
    }
    It "Checks roman 90" {
        ConvertTo-RomanNumeral -InputNumber 90 | Should -Be "XC"
    }
    It "Checks roman 100" {
        ConvertTo-RomanNumeral -InputNumber 100 | Should -Be "C"
    }
    It "Checks roman 78" {
        ConvertTo-RomanNumeral -InputNumber 78 | Should -Be "LXXVIII"
    }
}
