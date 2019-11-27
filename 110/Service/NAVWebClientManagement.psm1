#Requires -RunAsAdministrator

<#
.SYNOPSIS
Gets the information about the Dynamics NAV web server instances that are registered on a computer.
.DESCRIPTION
You can use Get-NAVWebServerInstance cmdlet to get the following information about Dynamics NAV web server instances that are registered in IIS on the computer. 

WebServerInstance: The name of the Dynamics NAV web server instance
Uri: Unified Resource Locator of web server instance.
SiteDeploymentType: The deployment type of the web server instance. Possible values are: RootSite or SubSite
Server: The computer that is running the Dynamics NAV Server that the Dynamics NAV web server instance connects to.
ServerInstance: The Dynamics NAV Server instance that the Dynamics NAV web server instance connects to.
ClientServicesPort: Specifies the listening TCP port for the Dynamics NAV Server instance that the Dynamics NAV web server instance connects to.
DNSIdenity: Specifies the subject name or common name of the service certificate for Dynamics NAV Server instance. This parameter is only relevant when the ClientServicesCredentialType in the Dynamics NAV Server instance configuration is set to UserName, NavUserPassword, or AccessControlService. These credential types requires that security certificates are used on the Dynamics NAV web server and Dynamics NAV Server instances to protect communication.
Configuration File: The location of the navsettings.json file that is used by the Dynamics NAV web server instance.
Version: The platform version of the Dynamics NAV web server instance.
.PARAMETER WebServerInstance
Specifies the name of the Dynamics NAV web server instance that you want information about. If you omit this parameter, then the cmdlet returns information about all Dynamics NAV web server instances.
.EXAMPLE
Get-NAVWebServerInstance -WebServerInstance DynamicsNAV
This example gets information about the Dynamics NAV web server instance that is named 'DynamicsNAV'.
#>
function Get-NAVWebServerInstance
(
    [string] $WebServerInstance
) {
    $instances = @()

    Import-Module WebAdministration
    
    foreach ($site in Get-Website) {
        $exePath = Join-Path $site.PhysicalPath "Prod.Client.WebCoreApp.exe"
        if (Test-Path $exePath) {
            $settingFilePath = Join-Path $site.PhysicalPath "navsettings.json"
            $settings = Get-Content $settingFilePath -Raw | ConvertFrom-Json
            
            $instance = [PSCustomObject]@{
                WebServerInstance            = $site.Name
                Website                      = $site.Name
                Uri                          = Get-NavWebSiteUrl -WebSite $site
                SiteDeploymentType           = "RootSite"
                "Configuration File"         = $settingFilePath
                ClientServicesPort           = $settings.NAVWebSettings.ClientServicesPort
                ClientServicesCredentialType = $settings.NAVWebSettings.ClientServicesCredentialType
                DnsIdentity                  = $settings.NAVWebSettings.DnsIdentity
                Server                       = $settings.NAVWebSettings.Server
                ServerInstance               = $settings.NAVWebSettings.ServerInstance
                Version                      = Get-ChildItem -Path $exePath | % versioninfo | % fileversion
            }

            $instances += $instance
        }

        foreach ($application in  Get-WebApplication -Site $site.Name) {
            $exePath = Join-Path $application.PhysicalPath "Prod.Client.WebCoreApp.exe"
            if (Test-Path $exePath) {
                $settingFilePath = Join-Path $application.PhysicalPath "navsettings.json"
                $settings = Get-Content $settingFilePath -Raw | ConvertFrom-Json
                
                $instance = [PSCustomObject]@{
                    WebServerInstance            = $application.Path.Trim('/')
                    Website                      = $site.Name
                    Uri                          = Get-NavWebSiteUrl -WebSite $site -Application $application
                    SiteDeploymentType           = "SubSite"
                    "Configuration File"         = $settingFilePath
                    ClientServicesPort           = $settings.NAVWebSettings.ClientServicesPort
                    ClientServicesCredentialType = $settings.NAVWebSettings.ClientServicesCredentialType
                    DnsIdentity                  = $settings.NAVWebSettings.DnsIdentity
                    Server                       = $settings.NAVWebSettings.Server
                    ServerInstance               = $settings.NAVWebSettings.ServerInstance
                    Version                      = Get-ChildItem -Path $exePath | % versioninfo | % fileversion
                }

                $instances += $instance
            }
        }
    }
    if ($WebServerInstance){
        $instances | where {$_.WebServerInstance -eq $WebServerInstance} | Write-Output
    }
    else {
        Write-Output $instances      
    }
}

<#
.SYNOPSIS
Changes a configuration value for a Dynamics NAV web server instance. 
.DESCRIPTION
Each web server instance has a configuration file called the navsettings.json file, which is stored in the physical path of the web server instance. This file contains several key-value pairs that configure various settings. The key-value pairs have the format "KeyName":  "KeyValue", such as "ClientServicesCredentialType":  "Windows". You can use this cmdlet to change the value of any key in the configuration file.  The changes will be applied to the web server instance automatically because the application pool is recycled. When the application pool is recycled by the IIS, static state such as client sessions in the Dynamics NAV Web client will be lost.
.PARAMETER WebServerInstance
Specifies the name of the web server instance in IIS. 
.PARAMETER KeyName
Specifies the configuration key name as it appears in the web server instance’s configuration file (navsettings.json).
.PARAMETER KeyValue
Specifies configuration key value.
.PARAMETER SiteDeploymentType
Specifies the deployment type of web server instance. There are two possible values: SubSite and RootSite.
-   Use SubSite if the web server instance was created as a subsite (web application) to a container website. If you specify SubSite, you will have to set the -ContainerSiteName parameter. If the subsite is under the default container website 'Microsoft Dynamics NAV [Version] Web Client' then you can omit this parameter. 
-   RootSite if the web server instance was created as a root-level website. 
.PARAMETER ContainerSiteName
Specifies the name of the container website that the SubSite-type web server instance belongs to. This setting is only used if SiteDeploymentType has been set to "SubSite". If the subsite is under the default container website 'Microsoft Dynamics NAV [Version] Web Client' then you can omit this parameter.
.EXAMPLE
Set-NAVWebServerInstanceConfiguration -WebServerInstance DynamicsNAV -KeyName ClientServicesCredentialType -KeyValue NavUserPassword
This example sets the 'ClientServicesCredentialType' configuration setting to 'NavUserNamePassword'.
#>
function Set-NAVWebServerInstanceConfiguration
(
    [Parameter(Mandatory = $true)]
    [string] $WebServerInstance,
    [Parameter(Mandatory = $true)]
    [string] $KeyName,
    [Parameter(Mandatory = $true)]
    [string] $KeyValue,
    [ValidateSet('SubSite', 'RootSite')]
    [string] $SiteDeploymentType = "SubSite",
    [string] $ContainerSiteName
) {
    Import-Module WebAdministration

    $ContainerSiteName = Validate-NavWebContainerSiteName -ContainerSiteName $ContainerSiteName -SiteDeploymentType $SiteDeploymentType

    $iisEntity = Get-NavWebsiteOrApplication -WebServerInstance $WebServerInstance -SiteDeploymentType $SiteDeploymentType -ContainerSiteName $ContainerSiteName
    $physicalPath = $iisEntity.PhysicalPath
    $applicationPool =  $iisEntity.ApplicationPool

    $navSettingFile = Join-Path $physicalPath "navsettings.json"
       
    if (!(Test-Path -Path $navSettingFile -ErrorAction Stop)) {
        throw "$navSettingFile does not exist"
    }

    $config = Get-Content $navSettingFile -Raw | ConvertFrom-Json

    if ($config.'NAVWebSettings'| get-member -Name $KeyName -MemberType NoteProperty){
        $config.'NAVWebSettings'.$KeyName = $KeyValue
    }
    else {
        $config.'NAVWebSettings'| add-member -Name $KeyName -value $KeyValue -MemberType NoteProperty -Force
    }

    $config | ConvertTo-Json | Set-Content $navSettingFile

    # Manually recycle IIS App pool
    Restart-WebAppPool -Name $applicationPool -ErrorAction Ignore
}

<#
.SYNOPSIS
Gets a specific configuration value for a Dynamics NAV web server instance. 
.DESCRIPTION
Use this cmdlet to get the value of a setting in the configuration file (navsettings.json) for a web server instance. The settings in the navsettings.json are defined by a key-value pair.
.PARAMETER WebServerInstance
Specifies the name of the web server instance in IIS. 
.PARAMETER KeyName
Specifies the configuration key name as it appears in the web server instance’s configuration file.
.PARAMETER SiteDeploymentType
Specifies the deployment type of web server instance. There are two possible values: RootSite and SubSite.
-   Use SubSite if the web server instance was created as a sub-site (web application) to a container website. If you specify SubSite, you will have to set the -ContainerSiteName parameter. If the subsite is under the default container website 'Microsoft Dynamics NAV [Version] Web Client' then you can omit this parameter.
-   RootSite is the web server instance was created as a root-level website. 
.PARAMETER ContainerSiteName
Specifies the name of the container website that the SubSite-type web server instance belongs to. This setting is only used if SiteDeploymentType has been set to "SubSite". If the subsite is under the default container website 'Microsoft Dynamics NAV [Version] Web Client' then you can omit this parameter.
.EXAMPLE
Get-NAVWebServerInstanceConfiguration -WebServerInstance DynamicsNAV -KeyName ClientServicesCredentialType
This example reads 'ClientServicesCredentialType' confgiration value.
#>
function Get-NAVWebServerInstanceConfiguration
(
    [Parameter(Mandatory = $true)]
    [string] $WebServerInstance,
    [Parameter(Mandatory = $true)]
    [string] $KeyName,
    [ValidateSet('SubSite', 'RootSite')]
    [string] $SiteDeploymentType = "SubSite",
    [string] $ContainerSiteName
) {
    Import-Module WebAdministration

    $ContainerSiteName = Validate-NavWebContainerSiteName -ContainerSiteName $ContainerSiteName -SiteDeploymentType $SiteDeploymentType

    $iisEntity = Get-NavWebsiteOrApplication -WebServerInstance $WebServerInstance -SiteDeploymentType $SiteDeploymentType -ContainerSiteName $ContainerSiteName
    $physicalPath = $iisEntity.PhysicalPath

    $navSettingFile = Join-Path $physicalPath "navsettings.json"
       
    if (!(Test-Path -Path $navSettingFile -ErrorAction Stop)) {
        throw "$navSettingFile does not exist"
    }

    $config = Get-Content $navSettingFile -Raw | ConvertFrom-Json
    return $config.'NAVWebSettings'.$KeyName
}

function Get-NavWebsiteOrApplication(
    [Parameter(Mandatory = $true)]
    [string] $WebServerInstance,
    [ValidateSet('SubSite', 'RootSite')]
    [string] $SiteDeploymentType = "SubSite",
    [string] $ContainerSiteName
) {
    if ($SiteDeploymentType -eq "SubSite") {
        $webApplication = Get-WebApplication -Name $WebServerInstance -Site $ContainerSiteName
        return $webApplication
    }
    else {
        $website = Get-Website -Name $WebServerInstance
        return $website
    }
    return $physicalPath;
}

<#
.SYNOPSIS
Removes an existing Microsoft Dynamics NAV web server instance.

.DESCRIPTION
The Dynamics NAV Web, Phone, and Tablet clients use a Dynamics NAV web server instance on IIS. Use the Remove-NAVWebServerInstance cmdlet to delete a specific web server instance. The cmdlet deletes all subfolders, web applications, and components that are associated with the web server instance.

.PARAMETER WebServerInstance
Specifies the name of the web server instance in IIS that you want to remove. 

.PARAMETER SiteDeploymentType
Specifies the deployment type of web server instance. There are two possible values: SubSite and RootSite.
-   Use SubSite if the web server instance was created as a sub-site (web application) to a container website. If you specify SubSite, you will have to set the -ContainerSiteName parameter. If the subsite is under the default container website 'Microsoft Dynamics NAV [Version] Web Client' then you can omit this parameter. 
-   Use RootSite if the web server instance was created as a root-level website. If you use this value, all folders and subsites of the instance will be removed.   

.PARAMETER ContainerSiteName
Specifies the name of the container website that the SubSite-type web server instance belongs to. This setting is only used if SiteDeploymentType has been set to "SubSite". If the subsite is under the default container website 'Microsoft Dynamics NAV [Version] Web Client' then you can omit this parameter.

.PARAMETER RemoveContainer
Specifies to remove the container website that the SubSite web server instance belongs to. This will remove all folders and subsites (web applications) of the container website.

.EXAMPLE
Remove-NAVWebServerInstance -WebServerInstance DynamicsNAV -SiteDeploymentType RootSite

This example removes a root-level web server instance.
.EXAMPLE
Remove-NAVWebServerInstance -WebServerInstance DynamicsNAV-AAD

This example removes a web server instance that was created as a SubSite type.
#>
function Remove-NAVWebServerInstance {
    [CmdletBinding(HelpURI = "https://go.microsoft.com/fwlink/?linkid=401381")]
    PARAM
    (  
        [Parameter(Mandatory = $true)]
        [string]$WebServerInstance,
        [ValidateSet('SubSite', 'RootSite')]
        [string] $SiteDeploymentType = "SubSite",
        [string] $ContainerSiteName,
        [switch] $RemoveContainer

    )  
    Import-Module WebAdministration

    $ContainerSiteName = Validate-NavWebContainerSiteName -ContainerSiteName $ContainerSiteName -SiteDeploymentType $SiteDeploymentType

    if ($SiteDeploymentType -eq "SubSite") {
        $website = Get-WebApplication -Name $WebServerInstance
    }
    else {
        $website = Get-Website -Name $WebServerInstance
    }

    if ($website) {
        $appPool = $website.applicationPool
        
        Write-Verbose "Remove application pool: $WebServerInstance"
        Remove-WebAppPool -Name $appPool
        
        Write-Verbose "Remove website: $WebServerInstance"

        if ($SiteDeploymentType -eq "SubSite") {
            Remove-WebApplication -Name $WebServerInstance -Site $ContainerSiteName
            if ($RemoveContainer) {
                Remove-Website -Name $ContainerSiteName
            }
        }
        else {
            Remove-Website -Name $WebServerInstance
        }
    }

    $wwwRoot = Get-WWWRootPath
    $siteRootFolder = Join-Path $wwwRoot $WebServerInstance
    if (Test-Path $siteRootFolder -ErrorAction Stop) {
        Write-Verbose "Remove $siteRootFolder"
        Remove-Item $siteRootFolder -Recurse -Force
    }

    if ($RemoveContainer -and ($SiteDeploymentType -eq "SubSite")) {
        $containerFolder = Join-Path $wwwRoot $ContainerSiteName
        Write-Verbose "Remove $containerFolder"
        Remove-Item $containerFolder -Recurse -Force
    }
}

function Validate-NavWebContainerSiteName(
    [string] $ContainerSiteName,
    [string] $SiteDeploymentType = "SubSite"
) {
    $registryProps = Get-NavWebClientInstallationProperties
    if (!$ContainerSiteName -and $SiteDeploymentType -eq "SubSite") {
        if ($registryProps) {
            $ContainerSiteName = $registryProps.Name
            Write-Verbose "Using container name from registry: $ContainerSiteName"
        }
        else {
            $ContainerSiteName = "NavWebApplicationContainer"
            Write-Verbose "Using default container name: $ContainerSiteName"
        }
    }

    return $ContainerSiteName
}

<#
.SYNOPSIS
Creates new a Dynamics NAV web server instance.

.DESCRIPTION
Creates a new Dynamics NAV web server instance on IIS for hosting the Dynamics NAV Web, Phone, and Tablet clients.

To create a new web server instance, you need access to the **WebPublish** folder that contains the content files for serving the Dynamics NAV Web Client.
- This folder is available on the Dynamics NAV installation media (DVD) and has the path "DVD\WebClient\Microsoft Dynamics NAV\110\Web Client\WebPublish". 
- If you installed the Dynamics NAV Web Server Components, this folder has the path "%systemroot%\Program Files\Microsoft Dynamics NAV\[version number]\Web Client\WebPublish".
You can use either of these locations or you can copy the folder to more convenient location on your computer or network.

.PARAMETER WebServerInstance
Specifies the name to assign the web server instance in IIS, such as DynamicsNAV-AAD. If you are creating a SubSite type web server instance, the name will become part of the URL for the Dynamics NAV Web client. For example, if you set the parameter to MyNavWeb, the URL would be something like ‘http://myWebServer:8080/MyNavWeb/’.  If you are creating a RootSite type web server instance, the name is only used in IIS and does not become part of the URL. For example, if you set the parameter to MyNavWeb, the URL would be something like ‘http://myWebServer:8080/’.

.PARAMETER Server
Specifies the name of the computer that the Dynamics NAV Server instance is installed on. This parameter accepts "localhost" if the server instance and the new web server instance are installed on the same computer.

.PARAMETER ServerInstance
Specifies the name of the Dynamics NAV Server instance that the web server instance will connect to. You can specify either the full name of an instance, such as ‘MicrosoftDynamicsNavServer$myinstance-2’, or the short name such as ‘myinstance-2’.

.PARAMETER ClientServicesCredentialType
Specifies the credential type that is used for authenticating client users. The value must match the credential type that is configured for the Dynamics NAV Server instance that the web server instance connects to. Possible values include: Windows, UserName, NavUserPassword, or AccessControlService.

.PARAMETER ClientServicesPort
Specifies the TCP port that is configured on the Dynamics NAV Server instance for communicating with client services. This value must match the client services port that is configured for the Dynamics NAV Server instance that the web server instance connects to.

.PARAMETER SiteDeploymentType
Specifies how the web server instance is installed IIS regarding its hierarchical structure and relationships. There are two possible values: RootSite and SubSite.

-   RootSite a adds the web server instance as root-level website in IIS that has its own bindings. The URL for the web server has the format: [http://[WebserverComputerName]:[port]/](http://[WebserverComputerName]:[port]/). 
-   SubSite adds the web server instance as an application under an existing or new container website, which you specify with the -ContainerSiteName parameter. If you are adding the SubSite instance to a new container website, you will also have to set the -WebSitePort parameter to setup the binding. You can add multiple SubSites to a container website. The SubSites inherit the binding defined on the container website.

If you omit this parameter, a subsite instance will be added to the default container website called 'Microsoft Dynamics NAV [Version] Web Client". If this contianer website does not exist, it will be added.

.PARAMETER ContainerSiteName
Specifies the name the container website to which you want to add the web server instance. This setting is only used if the -SiteDeploymentType parameter is set to ‘SubSite’. If you specify a container name that does not exist, a new site with is created as a container for the new web server instance. The website has no content but has binding on the port that specify with the -WebSitePort parameter.

.PARAMETER WebSitePort
Specifies the TCP port number under which the web server instance will be running. This is the port will be used to access the Dynamics NAV Web client and will be part of the URL. This parameter is only used if the -SiteDeploymentType parameter is set to ‘RootSite’ or set to ‘SubSite’ if you are creating a new container website.

.PARAMETER AppPoolName
Specifies the application pool that the web server instance will use. If you do not specify an application pool, the default Dynamics NAV Web Client application pool will be used.

.PARAMETER PublishFolder
Specifies the location of the WebPublish folder that contains the content file that is required for Dynamics NAV Web client. If you omit this parameter, the cmdlet will look for the folder path '%systemroot%\Program Files\Microsoft Dynamics NAV\[version number]\Web Client\WebPublish' 

.PARAMETER DnsIdentity
Specifies the DNS identity of the Dynamics NAV Server instance that the web server instance connects to. You set the value to either the Subject or common name (CN) of the security certificate that is used by the Dynamics NAV Server instance. This parameter is only relevant when the ClientServicesCredentialType is set to UserName, NavUserPassword, or AccessControlService because these authentication methods require that security certificates are used on the Dynamics NAV Server and web server instances o protect communication.

Typically, the Subject is prefixed with "CN" (for common name), for example, "CN = NavServer.com", but it can also just be "NavServer.com". It is also possible for the Subject field to be blank, in which case the validation rules will be applied to the Subject Alternative Name field of the certificate.

.PARAMETER CertificateThumbprint
Specifies the thumbprint of the security certificate to use to configure an HTTPS binding for the web server instance. The certificate must be installed in the local computer certificate store. 

.PARAMETER AddFirewallException
Specifies whether to allow inbound communication on the TCP port that is specified by the -WebSitePort parameter. If you use this parameter, an inbound rule for the port will be added to Windows Firewall. 

.PARAMETER HelpServer
Specifies the name of computer that hosts the Dynamics NAV Help Server that provides online help to Dynamics NAV Web client users.

.PARAMETER HelpServerPort
Specifies the TCP port (such as 49000) that is used by the Dynamics NAV Help Server on the computer specified by the -HelpServer parameter.

.EXAMPLE
New-NAVWebServerInstance -WebServerInstance DynamicsNAV110-UP -Server localhost -ServerInstance DynamicsNAV110 -ClientServicesCredentialType NavUserPassword

This example adds a new 'SubSite' web server instance under the existing default container website 'Microsoft Dynamics NAV [Version] Web Client'. The new website instance will be configured for NavUserNamePassword authentication.
.EXAMPLE
New-NAVWebServerInstance -WebServerInstance DynamicsNAV-Root -Server localhost -ServerInstance DynamicsNAV110 -SiteDeploymentType RootSite

This example adds a RootSite type web server instance called 'DynamicsNAV-Root'.
.EXAMPLE
New-NAVWebServerInstance -PublishFolder "C:\NAV\WebClient\Microsoft Dynamics NAV\110\Web Client\WebPublish" -WebServerInstance DynamicsNAV110-Root -Server localhost -ServerInstance DynamicsNAV110 -SiteDeploymentType RootSite

This example adds a new RootSite type web server instance from a web publish folder that is located 'C:\NAV\WebClient\Microsoft Dynamics NAV\110\Web Client\WebPublish'.
#>
function New-NAVWebServerInstance {
    [CmdletBinding(HelpURI = "https://go.microsoft.com/fwlink/?linkid=401381")]
    PARAM
    (  
        [Parameter(Mandatory = $true)]
        [string]$WebServerInstance,

        [Parameter(Mandatory = $true)]
        [string]$Server,

        [Parameter(Mandatory = $true)]
        [string]$ServerInstance,

        [ValidateSet('Windows', 'UserName', 'NavUserPassword', 'AccessControlService')]
        [string]$ClientServicesCredentialType = "Windows",

        [int]$ClientServicesPort = 7046,

        [ValidateSet('SubSite', 'RootSite')]
        [string]$SiteDeploymentType = 'SubSite',

        [string]$ContainerSiteName,

        [int]$WebSitePort,

        [string]$AppPoolName,

        [string]$PublishFolder,

        [string]$DnsIdentity,

        [string]$CertificateThumbprint,

        [switch]$AddFirewallException,

        [string]$HelpServer,

        [int]$HelpServerPort
    )
    $registryProps = Get-NavWebClientInstallationProperties

    # Add default parameter values
    if (!$PublishFolder) {
        if ($registryProps) {
            $PublishFolder = Join-Path $registryProps.Path "WebPublish"
            Write-Verbose "Using publish web folder from registry: $PublishFolder"
        }
    }

    if (!$AppPoolName) {
        $AppPoolName = $WebServerInstance
        Write-Verbose "Using application pool name: $AppPoolName"
    }

    if ($ContainerSiteName -and $SiteDeploymentType -eq "RootSite") {
        throw "ContainerSiteName parameter is only valid when 'SiteDeploymentType' is set to SubSite"
    }


    if (!$ContainerSiteName) {
        if ($registryProps) {
            $ContainerSiteName = $registryProps.Name
            Write-Verbose "Using container name from registry: $ContainerSiteName"
        }
        else {
            $ContainerSiteName = "NavWebApplicationContainer"
            Write-Verbose "Using default container name: $ContainerSiteName"
        }
    }

    if ($WebSitePort -eq 0) {
        if ($CertificateThumbprint) {
            $WebSitePort = 443    
        }
        else {
            $WebSitePort = 80
        }

        Write-Verbose "Using default website port: $WebSitePort"
    }

    if (!(Test-Path -Path $PublishFolder -ErrorAction Stop)) {
        throw "$PublishFolder does not exist"
    }

    Import-Module WebAdministration

    # Create the website
    $siteRootFolder = New-NavWebSite -SourcePath $PublishFolder -WebServerInstance $WebServerInstance -ContainerSiteName $ContainerSiteName -SiteDeploymentType $SiteDeploymentType -AppPoolName $AppPoolName  -Port $WebSitePort -CertificateThumbprint $CertificateThumbprint

    # Set the Nav configuration
    Write-Verbose "Update configuration: navsettings.json"

    $navSettingFile = Join-Path $siteRootFolder "navsettings.json"
    if (!(Test-Path $navSettingFile -ErrorAction Stop)) {
        throw "$navSettingFile does not exist"
    }

    $config = Get-Content $navSettingFile -Raw | ConvertFrom-Json
    $config.NAVWebSettings.Server = $Server
    $config.NAVWebSettings.ServerInstance = $ServerInstance
    $config.NAVWebSettings.ClientServicesCredentialType = $ClientServicesCredentialType
    $config.NAVWebSettings.DnsIdentity = $DnsIdentity
    
    if ($HelpServer) {
        $config.NAVWebSettings.HelpServer = $HelpServer
    }

    if ($HelpServerPort -gt 0) {
        $config.NAVWebSettings.HelpServerPort = $HelpServerPort
    }

    if (!$CertificateThumbprint) {
        # Disable requiring SSL when no SSL thumbprint was specified (insecure)
        $config.NAVWebSettings.RequireSsl = "false"
    }
     
    $config.NAVWebSettings.ClientServicesPort = $ClientServicesPort
    $config.NAVWebSettings.UnknownSpnHint = "(net.tcp://${Server}:${ClientServicesPort}/${ServerInstance}/Service)=NoSpn"
    $config | ConvertTo-Json | set-content $navSettingFile

    # Set firewall rule
    if ($AddFirewallException) {
        Set-NavWebFirewallRule -Port $WebSitePort
    }

    Write-Verbose "Done Configuring Web Client"

    # Ignore errors if the site cannot start in cases when e.g. the port is being already used 
    Restart-WebAppPool -Name $AppPoolName -ErrorAction Ignore
}

function New-NavWebSite
(
    [string] $SourcePath,
    [string] $WebServerInstance,
    [string] $ContainerSiteName,
    [ValidateSet('SubSite', 'RootSite')]
    [string] $SiteDeploymentType,
    [string] $AppPoolName,
    [string] $Port,
    [string] $CertificateThumbprint
) {
    $wwwRoot = Get-WWWRootPath
    $siteRootFolder = Join-Path $wwwRoot $WebServerInstance
    
    if (Test-Path $siteRootFolder) {
        Write-Verbose "Remove $siteRootFolder"
        Remove-Item $siteRootFolder -Recurse -Force
    }

    Write-Verbose "Copy files to WWW root $siteRootFolder"
    Copy-Item $SourcePath -Destination $siteRootFolder -Recurse -Container -Force
    

    Write-Verbose "Create the application pool $AppPoolName"
    if (Test-Path "IIS:\AppPools\$AppPoolName") {
        Write-Verbose "Removing existing application pool $AppPoolName"
        Remove-WebAppPool $AppPoolName
    }

    $appPool = New-WebAppPool -Name $AppPoolName -Force
    $appPool.managedRuntimeVersion = '' # No Managed Code
    $appPool.managedPipelineMode = "Integrated"
    $appPool.startMode = "AlwaysRunning"
    $appPool.enable32BitAppOnWin64 = "false"
    $appPool.recycling.logEventOnRecycle = "Time,Requests,Schedule,Memory,IsapiUnhealthy,OnDemand,ConfigChange,PrivateMemory"
    $appPool.processModel.identityType = "ApplicationPoolIdentity" 
    $appPool.processModel.loadUserProfile = "true"
    $appPool.processModel.idleTimeout = "1.00:00:00"
    $appPool | Set-Item

    $user = New-Object System.Security.Principal.NTAccount("IIS APPPOOL\$($appPool.Name)")
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "ListDirectory, ReadAndExecute, Write, Delete", "ContainerInherit, ObjectInherit", "None", "Allow")

    # Get and Set the same ACL to make sure ACL is in canonical form
    $acl = Get-Acl -Path $siteRootFolder
    Set-Acl -Path $siteRootFolder $acl
    $acl = $null

    $extractedResourcesFolder = Join-Path $siteRootFolder "\wwwroot\Resources\ExtractedResources"
    $acl = Get-Acl -Path $extractedResourcesFolder
    $acl.AddAccessRule($rule)
    Set-Acl -Path $extractedResourcesFolder $acl
    $acl = $null

    $thumbnailsFolder = Join-Path $siteRootFolder "\wwwroot\Thumbnails"
    $acl = Get-Acl -Path $thumbnailsFolder
    $acl.AddAccessRule($rule)
    Set-Acl -Path $thumbnailsFolder $acl
    $acl = $null

    $reportsFolder = Join-Path $siteRootFolder "\wwwroot\Reports"
    $acl = Get-Acl -Path $reportsFolder
    $acl.AddAccessRule($rule)
    Set-Acl -Path $reportsFolder $acl
    $acl = $null

    if ($SiteDeploymentType -eq "SubSite") {

        # Create NavWebContainer if does not exist
        $containerDirectory = Join-Path $wwwRoot $ContainerSiteName
        New-Item $containerDirectory -type directory -Force | Out-Null

        # Create container website
        $containerSite = Get-Website -Name $ContainerSiteName
        if (!$containerSite) {
            New-NavSiteWithBindings -PhysicalPath $containerDirectory -SiteName $ContainerSiteName -CertificateThumbprint $CertificateThumbprint -Port $Port
        }
        if (Get-WebApplication -Site $ContainerSiteName -Name $WebServerInstance) {
            Remove-WebApplication -Site $ContainerSiteName -Name $WebServerInstance
        }
        New-WebApplication -Site $ContainerSiteName -Name $WebServerInstance -PhysicalPath $siteRootFolder -ApplicationPool $AppPoolName | Out-Null

        Set-NavSiteAuthenticationSettings -SiteLocation "$ContainerSiteName/$WebServerInstance"
    }
    else {
        New-NavSiteWithBindings -PhysicalPath $siteRootFolder -SiteName $WebServerInstance -AppPoolName $AppPoolName -CertificateThumbprint $CertificateThumbprint -Port $Port
        Set-NavSiteAuthenticationSettings -SiteLocation $WebServerInstance
    }

    return $siteRootFolder
}

function Set-NavSiteAuthenticationSettings
(
    [string] $SiteLocation
) {
    Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name enabled -Value true -Location $SiteLocation -Force
    Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/anonymousAuthentication' -Name enabled -Value true -Location $SiteLocation -Force
}

function New-NavSiteWithBindings
(
    [string] $PhysicalPath,
    [string] $SiteName,
    [string] $CertificateThumbprint,
    [string] $AppPoolName,
    [int] $Port
) {
    # Remove existing site
    Get-WebSite -Name $SiteName | Remove-WebSite

    if ($CertificateThumbprint) {
        Write-Verbose "Create website: $SiteName with SSL"
        New-Website -Name $SiteName -ApplicationPool $AppPoolName -PhysicalPath $PhysicalPath -Port $Port -Ssl | Out-Null
        $binding = Get-WebBinding -Name $SiteName -Protocol "https"
        $binding.AddSslCertificate($CertificateThumbprint, 'My') | Out-Null
    }
    else {
        Write-Verbose "Create website: $SiteName without SSL"
        New-Website -Name $SiteName -ApplicationPool $AppPoolName -PhysicalPath $PhysicalPath -Port $Port | Out-Null
    }
}

function Get-NavWebClientInstallationProperties
() {
    $keyPath = "HKLM:\Software\Microsoft\Microsoft Dynamics NAV\110\Web Client"
    if (Test-Path $keyPath) {
        return Get-ItemProperty -Path $keyPath
    }
}

function Set-NavWebFirewallRule
(
    [int] $Port
) {
    $firewallRule = Get-NetFirewallRule -DisplayName "Microsoft Dynamics NAV Web Client" -ErrorAction Ignore

    if (!$firewallRule) {
        New-NetFirewallRule -DisplayName "Microsoft Dynamics NAV Web Client" -Direction Inbound -LocalPort $Port -Protocol "TCP" -Action Allow -RemoteAddress "any" | Out-Null    
        return
    }

    $ports = $firewallRule | Get-NetFirewallPortFilter
    if ($ports.LocalPort -is [array]) {
        if (!($ports.LocalPort -contains $Port)) {
            Set-NetFirewallRule -DisplayName "Microsoft Dynamics NAV Web Client" -LocalPort ($ports.LocalPort + $Port)
        }

        return
    }
    if ($ports.LocalPort -ne $Port) {
        Set-NetFirewallRule -DisplayName "Microsoft Dynamics NAV Web Client" -LocalPort ($ports.LocalPort, $Port)
    }
}

function Get-WWWRootPath {
    $wwwRootPath = (Get-Item "HKLM:\SOFTWARE\Microsoft\InetStp").GetValue("PathWWWRoot")
    $wwwRootPath = [System.Environment]::ExpandEnvironmentVariables($wwwRootPath)

    return $wwwRootPath
}

function Get-NavWebSiteUrl(
    $Website,
    $Application
) {
    $protocol = $Website.Bindings.Collection.protocol
    $port = $Website.Bindings.Collection.bindingInformation -replace ".*\:([\d]+)\:", '$1'

    if ($Application) {
        return "${protocol}://${env:computername}:$port/" + $Application.Path.Trim('/')
    }
    else {
        return "${protocol}://${env:computername}:$port"
    }
}

Export-ModuleMember -Function Get-NAVWebServerInstance, New-NAVWebServerInstance, Remove-NAVWebServerInstance, Set-NAVWebServerInstanceConfiguration, Get-NAVWebServerInstanceConfiguration


# SIG # Begin signature block
# MIIkBQYJKoZIhvcNAQcCoIIj9jCCI/ICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDBSRyb0Lux8OrF
# 2lKzIeom/5BBDMeqz0DTU3JmX4lkqKCCDYIwggYAMIID6KADAgECAhMzAAAAww6b
# p9iy3PcsAAAAAADDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTcwODExMjAyMDI0WhcNMTgwODExMjAyMDI0WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC7V9c40bEGf0ktqW2zY596urY6IVu0mK6N1KSBoMV1xSzvgkAqt4FTd/NjAQq8
# zjeEA0BDV4JLzu0ftv2AbcnCkV0Fx9xWWQDhDOtX3v3xuJAnv3VK/HWycli2xUib
# M2IF0ZWUpb85Iq2NEk1GYtoyGc6qIlxWSLFvRclndmJdMIijLyjFH1Aq2YbbGhEl
# gcL09Wcu53kd9eIcdfROzMf8578LgEcp/8/NabEMC2DrZ+aEG5tN/W1HOsfZwWFh
# 8pUSoQ0HrmMh2PSZHP94VYHupXnoIIJfCtq1UxlUAVcNh5GNwnzxVIaA4WLbgnM+
# Jl7wQBLSOdUmAw2FiDFfCguLAgMBAAGjggF/MIIBezAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUpxNdHyGJVegD7p4XNuryVIg1Ga8w
# UQYDVR0RBEowSKRGMEQxDDAKBgNVBAsTA0FPQzE0MDIGA1UEBRMrMjMwMDEyK2M4
# MDRiNWVhLTQ5YjQtNDIzOC04MzYyLWQ4NTFmYTIyNTRmYzAfBgNVHSMEGDAWgBRI
# bmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEt
# MDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAE2X
# TzR+8XCTnOPVGkucEX5rJsSlJPTfRNQkurNqCImZmssx53Cb/xQdsAc5f+QwOxMi
# 3g7IlWe7bn74fJWkkII3k6aD00kCwaytWe+Rt6dmAA6iTCXU3OddBwLKKDRlOzmD
# rZUqjsqg6Ag6HP4+e0BJlE2OVCUK5bHHCu5xN8abXjb1p0JE+7yHsA3ANdkmh1//
# Z+8odPeKMAQRimfMSzVgaiHnw40Hg16bq51xHykmCRHU9YLT0jYHKa7okm2QfwDJ
# qFvu0ARl+6EOV1PM8piJ858Vk8gGxGNSYQJPV0gc9ft1Esq1+fTCaV+7oZ0NaYMn
# 64M+HWsxw+4O8cSEQ4fuMZwGADJ8tyCKuQgj6lawGNSyvRXsN+1k02sVAiPGijOH
# OtGbtsCWWSygAVOEAV/ye8F6sOzU2FL2X3WBRFkWOCdTu1DzXnHf99dR3DHVGmM1
# Kpd+n2Y3X89VM++yyrwsI6pEHu77Z0i06ELDD4pRWKJGAmEmWhm/XJTpqEBw51sw
# THyA1FBnoqXuDus9tfHleR7h9VgZb7uJbXjiIFgl/+RIs+av8bJABBdGUNQMbJEU
# fe7K4vYm3hs7BGdRLg+kF/dC/z+RiTH4p7yz5TpS3Cozf0pkkWXYZRG222q3tGxS
# /L+LcRbELM5zmqDpXQjBRUWlKYbsATFtXnTGVjELMIIHejCCBWKgAwIBAgIKYQ6Q
# 0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5
# WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQD
# Ex9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4
# BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe
# 0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato
# 88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v
# ++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDst
# rjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN
# 91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4ji
# JV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmh
# D+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbi
# wZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8Hh
# hUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaI
# jAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTl
# UAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNV
# HQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQF
# TuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29m
# dC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcC
# ARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnlj
# cHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5
# AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oal
# mOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0ep
# o/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1
# HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtY
# SWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInW
# H8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZ
# iWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMd
# YzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7f
# QccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKf
# enoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOpp
# O6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZO
# SEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCFdkwghXVAgEBMIGVMH4xCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jv
# c29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAADDDpun2LLc9ywAAAAAAMMw
# DQYJYIZIAWUDBAIBBQCggcgwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEMoPcrM
# mQFzBFjdTcM2OY/ZowQhknhKou4qEIbH/njXMFwGCisGAQQBgjcCAQwxTjBMoC6A
# LABNAGkAYwByAG8AcwBvAGYAdAAgAEQAeQBuAGEAbQBpAGMAcwAgAE4AQQBWoRqA
# GGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTANBgkqhkiG9w0BAQEFAASCAQCrWNN1
# 9CTE1nuj5PpCeMDMNVbvGtcMT2NaPAKI63zG1wU7o8HbFNqb1hSQ++c8PdbBcI8w
# je6aTA1z8jnRDBqZl7XgsRI5ldf+BqwXbeiWOgzs7J9oN2uTcVx2ema9C2u+f2r4
# GzL2Ah5cmDgKPALVOvP+UkYpi/5azyGLMVrsghkQ/ARCCpJRqoII54J1bCCinPpM
# hSKLsech+lFAIXGA3BcMto1+l/58pMq048JMB26SKlMo+gtpAKUQy5zKOKULBotJ
# 9FMYWdaxDz6xISX2BM7qZhYgdCRZYa+f9ETaMCUvdXDVgipK8PCLUDRNcNlFCeVk
# 2yW9xEQ/zbmyqnX8oYITSTCCE0UGCisGAQQBgjcDAwExghM1MIITMQYJKoZIhvcN
# AQcCoIITIjCCEx4CAQMxDzANBglghkgBZQMEAgEFADCCATwGCyqGSIb3DQEJEAEE
# oIIBKwSCAScwggEjAgEBBgorBgEEAYRZCgMBMDEwDQYJYIZIAWUDBAIBBQAEIGPC
# 3aOrVwAR24u6vGUtPBdCPMqYf6suMEqO21uDyni6AgZZ2z4LKvcYEzIwMTcxMTIy
# MjA1NDM0LjIyOFowBwIBAYACAfSggbikgbUwgbIxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xDDAKBgNVBAsTA0FPQzEnMCUGA1UECxMebkNpcGhl
# ciBEU0UgRVNOOjdBQjUtMkRGMi1EQTNGMSUwIwYDVQQDExxNaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBTZXJ2aWNloIIOzTCCBnEwggRZoAMCAQICCmEJgSoAAAAAAAIwDQYJ
# KoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0
# eSAyMDEwMB4XDTEwMDcwMTIxMzY1NVoXDTI1MDcwMTIxNDY1NVowfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCpHQ28dxGKOiDs/BOX9fp/aZRrdFQQ1aUKAIKF++18aEssX8XD5WHCdrc+
# Zitb8BVTJwQxH0EbGpUdzgkTjnxhMFmxMEQP8WCIhFRDDNdNuDgIs0Ldk6zWczBX
# JoKjRQ3Q6vVHgc2/JGAyWGBG8lhHhjKEHnRhZ5FfgVSxz5NMksHEpl3RYRNuKMYa
# +YaAu99h/EbBJx0kZxJyGiGKr0tkiVBisV39dx898Fd1rL2KQk1AUdEPnAY+Z3/1
# ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpOBpG2iAg16HgcsOmZzTznL0S6p/TcZL2k
# AcEgCZN4zfy8wMlEXV4WnAEFTyJNAgMBAAGjggHmMIIB4jAQBgkrBgEEAYI3FQEE
# AwIBADAdBgNVHQ4EFgQU1WM6XIoxkPNDe3xGG8UzaFqFbVUwGQYJKwYBBAGCNxQC
# BAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYD
# VR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZF
# aHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9v
# Q2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcw
# AoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJB
# dXRfMjAxMC0wNi0yMy5jcnQwgaAGA1UdIAEB/wSBlTCBkjCBjwYJKwYBBAGCNy4D
# MIGBMD0GCCsGAQUFBwIBFjFodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vUEtJL2Rv
# Y3MvQ1BTL2RlZmF1bHQuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABf
# AFAAbwBsAGkAYwB5AF8AUwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEB
# CwUAA4ICAQAH5ohRDeLG4Jg/gXEDPZ2joSFvs+umzPUxvs8F4qn++ldtGTCzwsVm
# yWrf9efweL3HqJ4l4/m87WtUVwgrUYJEEvu5U4zM9GASinbMQEBBm9xcF/9c+V4X
# NZgkVkt070IQyK+/f8Z/8jd9Wj8c8pl5SpFSAK84Dxf1L3mBZdmptWvkx872ynoA
# b0swRCQiPM/tA6WWj1kpvLb9BOFwnzJKJ/1Vry/+tuWOM7tiX5rbV0Dp8c6ZZpCM
# /2pif93FSguRJuI57BlKcWOdeyFtw5yjojz6f32WapB4pm3S4Zz5Hfw42JT0xqUK
# loakvZ4argRCg7i1gJsiOCC1JeVk7Pf0v35jWSUPei45V3aicaoGig+JFrphpxHL
# mtgOR5qAxdDNp9DvfYPw4TtxCd9ddJgiCGHasFAeb73x4QDf5zEHpJM692VHeOj4
# qEir995yfmFrb3epgcunCaw5u+zGy9iCtHLNHfS4hQEegPsbiSpUObJb2sgNVZl6
# h3M7COaYLeqN4DMuEin1wC9UJyH3yKxO2ii4sanblrKnQqLJzxlBTeCG+SqaoxFm
# MNO7dDJL32N79ZmKLxvHIa9Zta7cRDyXUHHXodLFVeNp3lfB0d4wwP3M5k37Db9d
# T+mdHhk4L7zPWAUu7w2gUDXa7wknHNWzfjUeCLraNtvTX4/edIhJEjCCBNkwggPB
# oAMCAQICEzMAAACrXkCd7kbfLGwAAAAAAKswDQYJKoZIhvcNAQELBQAwfDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMTYwOTA3MTc1NjU0WhcNMTgwOTA3
# MTc1NjU0WjCBsjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEM
# MAoGA1UECxMDQU9DMScwJQYDVQQLEx5uQ2lwaGVyIERTRSBFU046N0FCNS0yREYy
# LURBM0YxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCz5n5QmKBGCbBmASaKNNMpyX2Y
# NZoMLN0zygPPDgLXC++74cguSaTT0Nncc9O7RYWcXeUB9fwrpmKb4YACp/M3KEVL
# Nd64um77hpDt4asQ8jjwd8Jbz0AT7jlKG9Iqeh78iwH4qbyaj3kDw+Nw0awA86bA
# yyHddNTUh4Qoga0aWVJi3uz9zMUDiUxNB7Og1B6eewHCOs1jaQmQiBOTwy2UoSwE
# Kbg31Uq1MYrkvm6RM9t87swyfFzBLeG4sNYiiSEqJHni5KPPLhnWVclIESSkqMn1
# SMhSwjGSkPpmNgD5oTAaaA+taWRLWvHraZ9zhnq2YB+UkV6OIL3U3w4qkMhLAgMB
# AAGjggEbMIIBFzAdBgNVHQ4EFgQUDcdH0Bxgy+nAa5TMXwYOYrjYaqcwHwYDVR0j
# BBgwFoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0
# cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljVGltU3Rh
# UENBXzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNUaW1TdGFQQ0Ff
# MjAxMC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcD
# CDANBgkqhkiG9w0BAQsFAAOCAQEAP5/+ui5h8XIqraoVZpWgBEt9s8JG3dDrW0A8
# 9Ix1Ba2hgW8kew0u0qOJuvA2K/nIxXcOerh83lTi/Q8mXzwMdi36GNGiEKiIXksq
# WZXIX3d//kQkuAKZhJGUrwLHpiqGhLGL+JEkx9Buoza/+/i4B5pvPmnttvGbYWdU
# rTbo2/La5WKmO8htzEOaJiLzRIzrLUcmddPC5pvWip0VT5PogCDODi2VA1PzQOAa
# 3GlcTCHXShMoL0XVgv2kwd8hO8nrPzilPzL6zQZLuB+8mxqzkbGTXeL/eaEW0bg1
# 9uGRyvdx7P3+isPgZTVYy6ReD5bmpyKvaPM+z96kjarY7hKk4qGCA3cwggJfAgEB
# MIHioYG4pIG1MIGyMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MQwwCgYDVQQLEwNBT0MxJzAlBgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3QUI1LTJE
# RjItREEzRjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIl
# CgEBMAkGBSsOAwIaBQADFQDJ7LtILTXZlL62jvcmqTFuioeOMqCBwTCBvqSBuzCB
# uDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEMMAoGA1UECxMD
# QU9DMScwJQYDVQQLEx5uQ2lwaGVyIE5UUyBFU046MjY2NS00QzNGLUM1REUxKzAp
# BgNVBAMTIk1pY3Jvc29mdCBUaW1lIFNvdXJjZSBNYXN0ZXIgQ2xvY2swDQYJKoZI
# hvcNAQEFBQACBQDdv8I9MCIYDzIwMTcxMTIyMDkzMDM3WhgPMjAxNzExMjMwOTMw
# MzdaMHcwPQYKKwYBBAGEWQoEATEvMC0wCgIFAN2/wj0CAQAwCgIBAAICKEQCAf8w
# BwIBAAICGVswCgIFAN3BE70CAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGE
# WQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDANBgkqhkiG9w0BAQUFAAOCAQEA
# UpSLT7cmHqyMDA5hvOG+7JdDoKDNF4zmW1/1sNa37AfASnIzQgbk785wWnf0ICVs
# gCmh4wGZrwypVWJZXUHRXNh/bdzRuH3kvvVYT73H0RaJUimP6wu58lsTnJ4BUuXl
# gQeAIHZL3NyQVYigRbnpgkz/Aag2w1pWgVfkLeWod75ruiYGm2OScVsxkjdyONAy
# aUPDBW1L/bx3ODLB3G3m/xcVADY7GQBNLK5D/pPqwFWXQsDWyeV6jFhe5QIB7Fyn
# LRmaoZqW1HYeNzZxz/t/ANVkc7qe+6PhZjRqh0qyMDErumZQEhzCFo39R4F+n5HD
# U58t67MTgvTtWVKn+onXajGCAvUwggLxAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0
# YW1wIFBDQSAyMDEwAhMzAAAAq15Ane5G3yxsAAAAAACrMA0GCWCGSAFlAwQCAQUA
# oIIBMjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIE
# INFDEPViYMRDLWYC/FjvLErxGRsQd7KqA9/Eyi6KXWUuMIHiBgsqhkiG9w0BCRAC
# DDGB0jCBzzCBzDCBsQQUyey7SC012ZS+to73JqkxboqHjjIwgZgwgYCkfjB8MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNy
# b3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAKteQJ3uRt8sbAAAAAAAqzAW
# BBS/MtjKfpExqKTCw4HQ/aCZvQEcZzANBgkqhkiG9w0BAQsFAASCAQAfAkNRS8mR
# Op4bRNRDxYEDay0TtAyBMuyGUC5nucCTmQNPT20a1etu+FY7KbE5oTrDvcWXM5OW
# 2ygLBOTDEHMbabc9oBEr2vj/dTFQ9beKko8ERAqjIYBTMeo+u6Tf+asYwuNrHI0O
# XHUC9LFmrberTjAV8CtZ77NdCd6BqB3MbQoKPf8b1naCSkFdzMXdhsBKymjDmg87
# VUctqgG+xdSDvDi2Lz/CzpFUmOz/xL27+gr8kQyXH3Xng/zjr+E6qmqxIHnbCLeu
# YSx8KDeGhfMFudqqugh5TvR2ebredVcfDYciqdz0DYwog0N2QkwEMxXP77c4Xv83
# SPZ9r8CH/ydn
# SIG # End signature block
