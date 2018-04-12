Import-Module '..\app\IIS-OperationsTasks.psm1' -Force

InModuleScope 'IIS-OperationsTasks' {
    Describe 'IIS-OperationsTask tests' {
        It 'must generate the homebroker report' {
            # Arrange
            Mock PerformHomeBrokerReport {}

            # Act
            HomeBrokerPerformanceReport

            # Assert
            Assert-MockCalled PerformHomeBrokerReport -Exactly 1
        }
    }
}