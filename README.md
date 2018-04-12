# Powerops
Set of PowerShell comands to help in the operation of IIS/ASP.NET application

Description
-------
Perform several IIS operative validation tasks on the current host

The CheckIIS performs the following validations

1. Checks that the appPools does not have the default value for recycling time
2. Checks that the appPools does not have the default value for idle time
3. Checks the appPools identity
4. Checks that the appPools does have at least one application
5. Checks that the appPools does not have at more than one application
6. Checks if some app pool has aplications in debug mode

Example
-------
PowerShell>CheckIIS

Notes
-------
You need to run this function as an Administrator
