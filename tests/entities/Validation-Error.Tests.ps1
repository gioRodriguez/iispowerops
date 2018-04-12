Import-Module '..\app\entities\Validation-Error.psm1' -Force

InModuleScope 'Validation-Error' {
    Describe 'Validation errors Tests' {
        It 'must create a new validation error' {
            # Arrange

            # Act
            $actual = NewIISValidationError 'cause' 'Error Message' 

            # Assert
            $actual.Message | Should Be 'Error Message'
            $actual.Category | Should Be 'IIS'            
        }
    }
}