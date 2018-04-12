Import-Module '..\app\entities\BaseLine-Info-Item.psm1' -Force
Import-Module '..\app\entities\BaseLine-Info-Collection.psm1' -Force

InModuleScope 'BaseLine-Info-Collection' {
    Describe 'BaseLine-Info-Collection Tests' {
        It 'must add a base line info item' {
            # Arrange

            # Act
            AddBaseLineInfoItem (NewBaseLineInfoItem 'categoryTest' 'value test' 'details test') 

            # Assert
            (GetTotalBaseLineItems) | Should Be 1
            
        }
    }
}