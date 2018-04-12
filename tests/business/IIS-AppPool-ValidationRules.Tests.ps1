Import-Module '..\app\business\IIS-AppPool-ValidationRules.psm1' -Force
Import-Module '..\app\repositories\IIS-Repository.psm1' -Force
Import-Module '..\app\entities\AppPool.psm1' -Force

InModuleScope 'IIS-AppPool-ValidationRules' {
    Describe "IIS app pool validation Tests" {
        it 'must return hasError true if the app pool has the default recycling time enabled' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                Recycling = @{
                    periodicRestart = @{
                        time = @{
                            TotalMinutes = 1740
                        }
                    }
                }
            }
            $appPoolObject = NewAppPool $appPool

            # Act
            $actual = CheckRecyclingTimeIntervalMustNotBeDefault $appPoolObject 

            # Assert
            $actual.hasError | Should Be $true
            $actual.cause | Should Be 'CheckRecyclingTimeIntervalMustNotBeDefault'
        }

        it 'must return hasError false if the app pool has not the default recycling time enabled' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                Recycling = @{
                    periodicRestart = @{
                        time = @{
                            TotalMinutes = 0
                        }
                    }
                }
            }
            $appPoolObject = NewAppPool $appPool

            # Act
            $actual = CheckRecyclingTimeIntervalMustNotBeDefault $appPoolObject
            
            # Assert
            $actual.hasError | Should Be $false
        }

        it 'must return hasError false if the app pool has the default idle time enabled' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    idleTimeout = @{
                        TotalMinutes = 20
                    }
                }
            }
            $appPoolObject = NewAppPool $appPool

            # Act
            $actual = CheckIdleTimeoutMustNotBeDefault $appPoolObject 

            # Assert
            $actual.hasError | Should Be $true
            $actual.cause | Should Be 'CheckIdleTimeoutMustNotBeDefault'
        }

        it 'must return hasError false if the app pool has the ApplicationPoolIdentity' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'ApplicationPoolIdentity'
                }
            }
            $appPoolObject = NewAppPool $appPool

            # Act
            $actual = CheckAppPoolIdentity $appPoolObject 

            # Assert
            $actual.hasError | Should Be $false
        }

        it 'must return hasError true if the app pool has a different identity' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'LocalSystem'
                }
            }
            $appPoolObject = NewAppPool $appPool

            # Act
            $actual = CheckAppPoolIdentity $appPoolObject 

            # Assert
            $actual.hasError | Should Be $true
            $actual.cause | Should Be 'CheckAppPoolIdentity'
        }

        it 'must return hasError true if the app pool has more that one application' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'LocalSystem'
                }
            }
            Mock Get-WebSite {} -ModuleName 'IIS-Repository'
            Mock Get-Webapplication {} -ModuleName 'IIS-Repository'
            $aplications = @(@{
                'Value' = '/app';
            }, @{
                'Value' = '/';
            })

            $appPoolObject = NewAppPool $appPool $aplications
            #Write-Host $appPoolObject
            # Act
            $actual = CheckAppPoolOnlyOneApplicationPerPool $appPoolObject 

            # Assert
            $actual.hasError | Should Be $true
            $actual.cause | Should Be 'CheckAppPoolOnlyOneApplicationPerPool'
        }

        it 'must return hasError false if the app pool has only one application' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'LocalSystem'
                }
            }
            Mock Get-WebSite {} -ModuleName 'IIS-Repository'
            Mock Get-Webapplication {} -ModuleName 'IIS-Repository'
            Mock Get-WebConfigurationProperty {return @(
                @{
                    'Value' = '/app';
                }
            )} -ModuleName 'IIS-Repository'

            $appPoolObject = NewAppPool $appPool
            #Write-Host $appPoolObject
            # Act
            $actual = CheckAppPoolOnlyOneApplicationPerPool $appPoolObject 

            # Assert
            $actual.hasError | Should Be $false
        }

        it 'must return hasError true if the app pool has not applications' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'LocalSystem'
                }
            }
            Mock Get-WebSite {} -ModuleName 'IIS-Repository'
            Mock Get-Webapplication {} -ModuleName 'IIS-Repository'
            Mock Get-WebConfigurationProperty {return @()} -ModuleName 'IIS-Repository'

            $appPoolObject = NewAppPool $appPool
            #Write-Host $appPoolObject
            # Act
            $actual = CheckAppPoolAtLeastOneApplicationPerPool $appPoolObject 

            # Assert
            $actual.hasError | Should Be $true
            $actual.cause | Should Be 'CheckAppPoolAtLeastOneApplicationPerPool'
        }

        it 'must return hasError false if the app pool has at least one applications' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'LocalSystem'
                }
            }
            Mock Get-WebSite {} -ModuleName 'IIS-Repository'
            Mock Get-Webapplication {} -ModuleName 'IIS-Repository'
            $applications = @(@{
                'Value' = '/app';
            })

            $appPoolObject = NewAppPool $appPool $applications
            #Write-Host $appPoolObject
            # Act
            $actual = CheckAppPoolAtLeastOneApplicationPerPool $appPoolObject 

            # Assert
            $actual.hasError | Should Be $false
        }

        it 'must return hasError true if the app pool has applications in debug' {
            # Arrange
            $appPool = @{
                Name = 'AppPoolNameTest';
                ProcessModel = @{
                    identityType = 'LocalSystem'
                }
            }
            Mock Get-WebSite {} -ModuleName 'IIS-Repository'
            $applications= @(@{
                'Name' = 'testName';
                'PhysicalPath' = 'PhysicalPath';
                'IsDebug' = $true
            })

            $appPoolObject = NewAppPool $appPool $applications

            # Act     
            #Write-Host $appPoolObject.AppsInDebug   
            $actual = CheckAppPoolHasApplicationsInDebug $appPoolObject 

            # Assert
            $actual.hasError | Should Be $true
            $actual.cause | Should Be 'CheckAppPoolHasApplicationsInDebug'
        }
    }
}