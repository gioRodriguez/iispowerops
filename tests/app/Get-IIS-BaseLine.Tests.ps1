Import-Module '..\app\Get-IIS-BaseLine.psm1' -Force

InModuleScope 'Get-IIS-BaseLine' {
    Describe 'Get-IIS-BaseLine' {
        It 'must get iis base line info' {
            # Arrange
            Mock PerformIISBaseLine {}

            # Act
            GetIISBaseLine

            # Assert
        }            
    }
}
