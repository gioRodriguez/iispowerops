Import-Module '..\app\entities\AppPool.psm1' -Force

InModuleScope 'AppPool' {
    Describe 'AppPool Tests' {
        It 'must create a new AppPool' {
            # Arrange
            $appPoolRaw = @{
                    Name = 'AppPoolName';
                    State = 'Started';
                    Recycling = @{
                        periodicRestart = @{
                            time = @{
                                TotalMinutes = 1720
                            }
                        }
                    };
                    ProcessModel = @{
                        identityType = 'ApplicationPoolIdentity';
                        idleTimeout = @{
                            TotalMinutes = 20
                        }
                    };
                    PSChildName = 'SiteNameTest'
                };
            
            $applications =  @(
                @{
                    'IsDebug' = $true;
                }
            )

            $site = @{
                'name' = 'Name'
            }

            # Act
            $actual = NewAppPool $appPoolRaw $applications $site

            # Assert
            $actual.Name | Should Not BeNullOrEmpty
            $actual.State | Should Not BeNullOrEmpty
            $actual.Recycling | Should Not BeNullOrEmpty
            $actual.IdleTimeoutInminutes | Should Not BeNullOrEmpty
            $actual.Identity | Should Not BeNullOrEmpty
            $actual.Applications | Should Not BeNullOrEmpty
            $actual.AppsInDebug | Should Not BeNullOrEmpty
            $actual.Site | Should Not BeNullOrEmpty
        }

        It 'must get AppPool as string' {
            # Arrange
            $appPoolRaw = @{
                    Name = 'AppPoolName';
                    Enable32BitAppOnWin64 = $false;
                    State = 'Started';
                    Recycling = @{
                        periodicRestart = @{
                            time = @{
                                TotalMinutes = 1720
                            }
                        }
                    };
                    ProcessModel = @{
                        identityType = 'ApplicationPoolIdentity';
                        idleTimeout = @{
                            TotalMinutes = 20
                        }
                    };
                    PSChildName = 'SiteNameTest'
                };
            
            $applications =  @(
                @{
                    'IsDebug' = $true;
                }
            )

            $site = @{
                'name' = 'Name'
            }

            # Act
            $actual = NewAppPool $appPoolRaw $applications $site

            # Assert
            $actual.ToString() | Should Be '{ "name": "AppPoolName", "enable32BitAppOnWin64": "False", "state": "Started", "recycling": { "periodicRestartTimeInminutes": 1720 }, "idleTimeoutInminutes": 20, "identity": "ApplicationPoolIdentity", "site" : System.Collections.Hashtable, "applications": [System.Collections.Hashtable] }'
        }

    }
}