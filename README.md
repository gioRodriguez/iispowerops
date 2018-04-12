# powerops
set of PowerShell comands to help in the operation of IIS/ASP.NET application

Perform several operative validation tasks on the current host

The CheckIIS performs the following validations
    - Checks that the appPools does not have the default value for recycling time
    - Checks that the appPools does not have the default value for idle time
    - Checks the appPools identity
    - Checks that the appPools does have at least one application
    - Checks that the appPools does not have at more than one application
    - Checks if some app pool has aplications in debug mode

EXAMPLE
PowerShell>CheckIIS

NOTES
You need to run this function as an Administrator
