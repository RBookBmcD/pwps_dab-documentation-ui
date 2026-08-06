<#
.SYNOPSIS
Allows for logging within the ProjectWise PowerShell module Documentation UI application

.DESCRIPTION
Used for the ProjectWise PowerShell module to allow logging
#>

function Start-Logging([Parameter(Mandatory=$false)][System.IO.Path]$logFile, [Parameter(Mandatory=$false)][string]$Path){
    if([System.IO.Path]::IsNullOrEmpty($logFile)){
        return "Unable"
    }
}

function LOG([Parameter(Mandatory=$false)][string]$Message, [Parameter(Mandatory=$false)][string]$type){

}

function Stop-Logging(){

}

Export-ModuleMember -Function Start-Logging
Export-ModuleMember -Function LOG
Export-ModuleMember -Function Stop-Logging