Import-Module '..\app\entities\BaseLine-Info-Item.psm1' -Force

InModuleScope 'BaseLine-Info-Item' {
    Describe 'BaseLine-Info-Item Tests' {
        It 'must create a new validation error' {
            # Arrange
            $env:computername = 'serverTest'

            # Act
            $actual = NewBaseLineInfoItem 'categoryTest' 'attribute test' 'value test' 'details test' 

            # Assert
            $actual.Server | Should Be 'serverTest'
            $actual.Category | Should Be 'categoryTest'
            $actual.Attribute | Should Be 'attribute test'
            $actual.Value | Should Be 'value test'
            $actual.Description | Should Be 'details test'            
        }
    }
}