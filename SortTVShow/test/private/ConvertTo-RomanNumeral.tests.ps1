# Imports public and private functions before running.
BeforeAll {

    . ($PScommandpath.Replace('.tests','')).Replace('\test','')

}
Describe "ConvertTo-RomanNumeral" {
    $testCases = @(
        @{Number = 5; OutPutNumber = "V"; TestName = "Check Roman 5"}
        @{Number = 4; OutPutNumber = "IV"; TestName = "Check Roman 4"}
        @{Number = 1; OutPutNumber = "I"; TestName = "Check Roman 1"}
        @{Number = 9; OutPutNumber = "IX"; TestName = "Check Roman 9"}
        @{Number = 10; OutPutNumber = "X"; TestName = "Check Roman 10"}
        @{Number = 17; OutPutNumber = "XVII"; TestName = "Check Roman 17"}
        @{Number = 40; OutPutNumber = "XL"; TestName = "Check Roman 40"}
        @{Number = 50; OutPutNumber = "L"; TestName = "Check Roman 50"}
        @{Number = 100; OutPutNumber = "C"; TestName = "Check Roman 100"}
        @{Number = 90; OutPutNumber = "XC"; TestName = "Check Roman 90"}
        @{Number = 78; OutPutNumber = "LXXVIII"; TestName = "Check Roman 78"}
        @{Number = 1000; OutPutNumber = "M"; TestName = "Check Roman 1000"}

    )
    
    It "Performs Test: <TestName>" -TestCases $testCases {
        param($Number,$OutPutNumber)

        ConvertTo-RomanNumeral -InputNumber $Number | Should -Be $OutPutNumber
    }

    It "Zero should throw an error" {
        { ConvertTo-RomanNumeral -InputNumber 0 } | Should -Throw -ErrorId "InvalidInput"
    }
    It "String should throw error" {
        { ConvertTo-RomanNumeral -InputNumber "sgfhsrf" } | Should -Throw -ErrorId "ParameterArgumentTransformationError,ConvertTo-RomanNumeral"
    }
    It "Always returns a string" {
        ConvertTo-RomanNumeral -InputNumber 5 | Should -BeOfType [string]
    }
  
}
