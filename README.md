# Powerops
Set of PowerShell commands to help in the operation of IIS/ASP.NET applications

## Description
In any improvement effort, the first recommended step is to explore and to answer where are we standing on (to explore and to analyze our current state) in addition to where would us like to be, although each best practice could be confirmed and applied manually, this project has been started at first scope to help during the discovery. As first output, we are going to have two CSV files, in which we are going to have the recommended action items to cover and general information about the current system. 

These commands perform system read only operations, there are not modifications action involved, the only exceptions are of two csv files created only to contain the final results.

- [x] means implemented
- [ ] means coming soon

## IIS checklist
- [x] [AppPool recycling regular time set to "00:00:00"](#recycling-regular-time-should-not-be-the-default-value)
- [x] [AppPool recycling idle time-out set to "00:00:00"](#recycling-idle-time-out-should-not-be-the-default-value)
- [x] [AppPool identity set to ApplicationPoolIdentity](#identity-should-be-the-default-value)
- [x] [Only one application per application pool](#at-least-one-application-in-each-application-pool-and-no-more-than-one-application-in-each-application-pool)
- [x] [No applications leave with `<compilation debug="true"/>`](#no-applications-leave-with-compilation-debugtrue)
- [ ] AppPool queue length set to 5000
- [ ] AppPool auto start set to true
- [ ] AppPool start mode set to AlwaysRunning
- [ ] IIS HTTP static compression enabled
- [ ] IIS HTTP dynamic compression enabled
- [ ] IIS operational log enabled

## ASP.NET checklist
- [ ] ASP.NET maxConcurrentRequestsPerCPU option set to 5000
- [ ] MaxConcurrentRequestsPerCPU registry key set to 5000
- [ ] MaxConcurrentRequestsPerCPU registry key set to 5000
- [ ] ASP.NET deployment/retail attribute set to true
- [ ] Custom errors set to RemoteOnly

## Windows Server checklist
- [ ] User account control enabled
- [ ] Windows logs (Application/System/Security) archived and retained
- [ ] System processor scheduling set to 24 (24 Decimal or 18 hexa)

## Documentation
### Recycling regular time set to "00:00:00"
The default recycling time is 1740 minutes, then, an app pool recycling will happen during business hours at some moment, this could cause performance degradation and user sessions finished, (the user session finished problem could be mitigated whether ASP.NET keeps its session state out-proc, for example in SqlServer), the recommended value for recycling regular time is 0 (set to zero, this means that the recycling will not occur due to elapsed time), in addition to specifying a Specific Time, for example at 3:00am

### Recycling idle time-out set to "00:00:00" 
The default recycling idle time-out is 20 minutes, this means that IIS will automatically shut down a worker process after 20 minutes of inactivity, then when a new request arrives to the application, the full activation process starts again (creation of a new worker process, ASP.NET pages and Dlls compilation, etc.), this could cause performance degradation and user sessions finished, if the server memory usage allows us, then, the recommended value for idle time-out is 0 (set to zero, in other words, IIS will never shutdown an already running worker process due to inactivity time, it will be recycled only when other recycling conditions were meet)

### Identity set to ApplicationPoolIdentity
The default identity used by the worker process is ApplicationPoolIdentity, and it has the required privileges to run almost any web application, in case that this account needs to be changed, we need to ensure that the selected account does not have more privileges that minimum needed, never, under any circumstance, is recommended to leave LocalService or Administrator accounts to run worker process in production, this could over expose not only the application security our operative system security too

### Only one application per application pool
As each the application pool starts a different worker process, this is the ultimate isolation layer in IIS, so, if for some reason an application is having performance issues, unhandled exceptions, thread contention and/or resource management problems, then other applications should not be affected by this bad behavior, and that is true, but only when each application is isolated in its own application pool.

### No applications leave with `<compilation debug="true"/>`
Never leave accidentally (or deliberately) the `<compilation debug="true"/>` switch on the application's web.config file, doing so causes a number of non-optimal this to happen including:
* ASP.NET page compilation slower. This translates into performance degradation
* ASP.NET timeouts without timeouts. This translates into possible resource leaking
* Code optimizations missing. Not all the available code optimizations are applied, then the code execution could be slower by 30%
* For more good reasons to do not leave debug="true" please refer to [ASP.NET Memory: If your application is in production… then why is debug=true](https://blogs.msdn.microsoft.com/tess/2006/04/12/asp-net-memory-if-your-application-is-in-production-then-why-is-debugtrue/) and [Don't run production ASP.ENT Application with debug="true" enabled](https://weblogs.asp.net/scottgu/442448)

## Example
-------
1. Go to [Powerops Releases](https://github.com/gioRodriguez/powerops/releases) and download the lasted Release (Source code zip)
2. Unzip the files locally
3. Open a PowerShell session in Adim mode
4. Go to the unziped folder powerops-version/
5. Build the project `PS > build.ps1`, this will create the `output` folder
6. Copy the `output` folder content to the target server to analyze
7. Run a full analysis `PS > Run.ps1`
8. After a successful execution you are going to find two files
    * `HostName-Findings.csv` Contains all the action items related to IIS/ASP.NET operation best practices
    * `HostName-BaseLineInfo.csv` Contains general information about the current state of the system
        * System information
        * Hotfixes
        * Drivers
        * IIS information
        * .NETFX information
        * Installed componets information
        * Installed services

## Notes
-------
You need to run these commands as an Administrator

## Developers
-------
Any design improvement is welcome, any new idea is also welcome :)

Almost all the code in Powerops was designed and written through TDD, so, I encourage you to continue with this good habit

## Setup development environment
-------

* Install [Pester](https://github.com/pester/Pester) (Pester is the ubiquitous test and mock framework for PowerShell.)
* To installation details please refer to [Pester Installation and Update](https://github.com/pester/Pester/wiki/Installation-and-Update)

to run the unit tests, open a powershell as administrator and run `PS projectPath/test/> Invoke-Pester`