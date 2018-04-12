Import-Module '..\app\entities\Validation-Error.psm1' -Force
Import-Module '..\app\entities\Validation-Error-Collection.psm1' -Force

InModuleScope 'Validation-Error-Collection' {
    Describe 'Validation errors collection Tests' {
        It 'must add a new validation error' {
            # Arrange 

            # Act
            AddError (NewIISValidationError 'cause' 'Error Message') 

            # Assert
            GetTotalErrors | Should Be 1   
        }
    }
}