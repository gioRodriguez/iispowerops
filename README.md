# Powerops
Set of PowerShell comands to help in the operation of IIS/ASP.NET application

Description
-------
Perform several IIS operative validation tasks on the current host

The CheckIIS performs the following validations

1. Checks app pools does not have the default value for recycling time
2. Checks app pools does not have the default value for idle time
3. Checks app pools identity
4. Checks app pools does have at least one application
5. Checks app pools does not have more than one application
6. Checks app pools with aplications in debug mode

Example
-------
PowerShell>CheckIIS

Notes
-------
You need to run this function as an Administrator


Developers
-------
Any design improvement is welcome, any new idea is also welcome :)

Almost all the code in Powerops was designed and written trhough TDD, so, I encourage you to contininue with this good pattern

Setup development environment
-------

* Install [Pester](https://github.com/pester/Pester) (Pester is the ubiquitous test and mock framework for PowerShell.)
* To installation details please refer to [Pester Installation and Update](https://github.com/pester/Pester/wiki/Installation-and-Update)

to run the unit tests open a powershell as administrator and run `PS projectPath/test/> Invoke-Pester`