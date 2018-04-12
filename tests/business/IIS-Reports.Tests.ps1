Import-Module '..\app\business\IIS-Reports.psm1' -Force

InModuleScope 'IIS-Reports' {
    Describe 'IIS Reports tests' {        

        It 'must generate IIS backup with backup name' {
            # Arrange        
            Mock NewIISBackup {}
            
            # Act
            PerformIISBackup 'backupNameTest'

            # Assert
            Assert-MockCalled NewIISBackup -Exactly 1 -ParameterFilter { $backupName -eq 'backupNameTest' }
        }

        It 'must generate IIS backup with backup name empty or null' {
            # Arrange
            Mock GetFormatDate { return '_2016-06-05' }
            Mock NewIISBackup {}
            
            # Act
            PerformIISBackup ''
            PerformIISBackup

            # Assert
            Assert-MockCalled NewIISBackup -Exactly 2 -ParameterFilter { $backupName -eq 'backup_2016-06-05' }
        }
    }
}