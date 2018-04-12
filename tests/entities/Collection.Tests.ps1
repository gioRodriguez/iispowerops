Import-Module '..\app\entities\Collection.psm1' -Force

InModuleScope 'Collection' {
    Describe 'Collection Tests' {
        It 'must create a new Collection' {
            # Arrange

            # Act
            $actual = NewCollection

            # Assert
            $actual.Total() | Should Be 0
        }

        It 'must add a new element' {
            # Arrange
            $actual = NewCollection

            # Act
            $actual.Add('element1')
            $actual.Add('element2')
            $actual.Add('element3')

            # Assert
            $actual.Total() | Should Be 3
        }

    }
}