Import-Module '..\app\business\IIS-AppPool-ValidationRules.psm1' -Force
Import-Module '..\app\business\ValidationRules-Collection.psm1' -Force


InModuleScope 'ValidationRules-Collection' {
    Describe 'ValidationRules Collection tests' {        

        It 'must add a validation' {
            # Arrange                    
            
            # Act
            AddValidationRule CheckRecyclingTimeIntervalMustNotBeDefault

            # Assert
            (GetValidationRulesTotal) | Should Be 1
        }
    }
}