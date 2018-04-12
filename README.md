# Powerops
Set of PowerShell commands to help in the operation of IIS/ASP.NET applications

Description
-------
Perform several IIS operative validation tasks on the current host in a single step

The CheckIIS command performs the following validations

1. Validations applied over IIS application pools
    1. Recycling time not in default value
    2. Idle timeout not in default value 
    3. Identity set in ApplicationPoolIdentity
    4. At least one application in each application pool
    5. No more than one application in each application pool
    6. No aplications in debug mode

Example
-------
1. Go to [Powerops Releases](https://github.com/gioRodriguez/powerops/releases) and download the lasted Release (Source code zip)
2. Unzip the files locally
3. Open a PowerShell session in Adim mode
4. Go to the unziped folder powerops-version/
5. Build the project `PS > build.ps1`, this will create the `output` folder
6. Copy the `output` folder content to the target server to analyze
7. Tun a full analysis `PS > Run.ps1`
8. After a successful execution your are going to find two files
    * `HostName-Findings.csv` Contains all the action items related to IIS/ASP.NET operation best practices
    * `HostName-BaseLineInfo.csv` Contains general information about the current state of the system
        * System information
        * Hotfixes
        * Drivers
        * IIS information
        * .NETFX information
        * Installed componets information
        * Installed services

Notes
-------
You need to run this commands as an Administrator

Developers
-------
Any design improvement is welcome, any new idea is also welcome :)

Almost all the code in Powerops was designed and written through TDD, so, I encourage you to continue with this good habit

Setup development environment
-------

* Install [Pester](https://github.com/pester/Pester) (Pester is the ubiquitous test and mock framework for PowerShell.)
* To installation details please refer to [Pester Installation and Update](https://github.com/pester/Pester/wiki/Installation-and-Update)

to run the unit tests open a powershell as administrator and run `PS projectPath/test/> Invoke-Pester`