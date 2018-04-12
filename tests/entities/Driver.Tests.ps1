Import-Module '..\app\entities\Driver.psm1' -Force

InModuleScope 'Driver' {
    Describe 'Driver Tests' {
        It 'must create a new driver' {
            # Arrange

            # Act
            $actual = NewDriver 'deviceNameTest' 'driverVersionTest' 'driverDateTest'

            # Assert
            $actual.DeviceName | Should Be 'deviceNameTest'
            $actual.DriverVersion | Should Be 'driverVersionTest'
            $actual.DriverDate | Should Be 'driverDateTest'
        }

    }
}