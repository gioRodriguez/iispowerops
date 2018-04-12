Import-Module '..\app\repositories\Dynatrace-Reports-Repository.psm1' -Force

InModuleScope 'Dynatrace-Reports-Repository' {
    Describe 'Dynatrace repository Tests' {
        It 'must get the HomeBroker performance dashboard' {
            # Arrange
            Mock Invoke-RestMethod {}

            # Act
            GetHomeBrokerReport

            # Assert
            Assert-MockCalled Invoke-RestMethod -Exactly 1
        }
    }
}