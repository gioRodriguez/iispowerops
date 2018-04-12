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
1. To run a full analysus try `PS > Run.ps1`
2. After a successful execution your are going to find two 

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