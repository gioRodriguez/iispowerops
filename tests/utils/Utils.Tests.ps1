Import-Module '..\app\utils\Utils.psm1' -Force

Describe 'Utils Tests' {
    It 'must get the formatted date with date' {
        # Arrange
        $date = Get-Date -Date '2016-06-05 00:00:00'

        # Act
        $actual = GetFormatDate $date

        # Assert
        $actual | Should Be '_2016-06-05'
    }

    It 'must get the formatted without date' {
        # Arrange
        $date = Get-Date
        
        # Act
        $actual = GetFormatDate

        # Assert
        $actual | Should Match $date.Year
        $actual | Should Match $date.Month
        $actual | Should Match $date.Day
    }
}