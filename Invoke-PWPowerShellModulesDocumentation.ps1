#####################################################################################################################################################################################################################
#####################################################################################################################################################################################################################
#################################################| |# 
################### #############################| |#   Name                    : GetPwpsDabDocs.ps1
#################     ###########################| |#   Type                    : UI Application
###############         #########################| |#   Purpose                 : Easier access to pwps_dab documentation
################          #######################| |#   Author                  : Robert D. Book (rdbook@burnsmcd.com)
##################          #####################| |#   Creation Date           : 7/21/2025
##########    ######          ###################| |#   Modified By             :
########        #####           #################| |#   Modified Date           :
########          #####        ##################| |#   Version                 : 1.3
##########          #####     ###################| |#   PowerShell Version      : 5.1.26100.4652
############          ###########################| |#   ProjectWise Version     : 
#############           #########################| |#   PWPS Module Version     : 24.0.2
###############          ########################| |#   
##########  #####          ######################| |#   Requirements:
########      #####          ####################| |#   - pwps_dab module installed
#######        ######          ##################| |#   - 
#######          ######          ################| |#   - 
#########          ######          ##############| |#   -  
###########          ######          ############| |#   -  
#############          #####           ##########| |#   -  
###############          #####           ########| |#   -  
#################          #####          #######| |#   -  
###################          #####          #####| |#   -  
####################          ######         ####| |#   -  
#################################################| |#
#####################################################################################################################################################################################################################
## 
## Description/Notes:
## - This is just a simple UI to facilitate easier access to the pwps_dab documentation.
## 
#####################################################################################################################################################################################################################
## 
## Change Log:
## Alpha 1.3
## - Increased window size
##
## Alpha 1.2
## - Added search bar
## 
## Alpha 1.1
## - Signed ps1 script to allow for execution on more secure machines
## - Added documentation for ps1 and py files
##
## Alpha 1.0
## - Initial release
## - Basic functionality
## 
## 
#####################################################################################################################################################################################################################
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)][switch]$IgnorePWPS,
    [Parameter(Mandatory=$false)][switch]$IgnoreDAB,
    [Parameter(Mandatory=$false)][switch]$IgnoreCloud
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

New-Variable -Name PWPS_FUNCTIONS -Value ([hashtable]::new()) -Scope Script -Force
New-Variable -Name DAB_FUNCTIONS -Value ([hashtable]::new()) -Scope Script -Force
New-Variable -Name CLOUD_FUNCTIONS -Value ([hashtable]::new()) -Scope Script -Force

New-Variable -Name MAIN_WINDOW_H -Value 800 -Scope Script -Force
New-Variable -Name MAIN_WINDOW_W -Value 1200 -Scope Script -Force
New-Variable -Name MAIN_WINDOW_COLS -Value 4 -Scope Script -Force
New-Variable -Name PADDING -Value 5 -Scope Script -Force
New-Variable -Name LIST_ITEM_SIZE -Value 20 -Scope Script -Force

New-Variable -Scope Script -Force -Name COL_STYLE -Value ([System.Windows.Forms.ColumnStyle]@{SizeType=2; Width=(100/$MAIN_WINDOW_COLS)})

New-Variable -Name MAIN_WINDOW -Value $null -Scope Script -Force
New-Variable -Name MAIN_WINDOW_SIZE -Value ([System.Drawing.Size]::new($MAIN_WINDOW_W, $MAIN_WINDOW_H)) -Scope Script -Force
New-Variable -Name VERB_CB_LIST -Value $null -Scope Script -Force

New-Variable -Name ANCHOR_STYLES -Value (@{NONE=0;TOP=1;BOTTOM=2;LEFT=4;RIGHT=8;ALL=15}) -Scope Script -Force
New-Variable -Name DOCK_STYLES -Value (@{NONE=0;TOP=1;BOTTOM=2;LEFT=3;RIGHT=4;FILL=5}) -Scope Script -Force


function Main([Parameter(Mandatory=$true)][hashtable]$InParams){
    try{
        Invoke-Startup -MainParams $InParams

        Invoke-MainWindow

        Load-Modules $InParams

        # Load-ModuleVerbs $InParams

        $MAIN_WINDOW.ShowDialog()
    }catch{
        Write-Error $_
    }
}

function Invoke-Startup([Parameter(Mandatory=$true)][hashtable]$MainParams){
    # Startup processes
    # silence annoying information from loading pwps module 
    if([System.Environment]::GetEnvironmentVariable("SuppressPSOutput").Length -le 0){
        [System.Environment]::SetEnvironmentVariable("SuppressPSOutput", "True")
    }

    if($IgnorePWPS -and $IgnoreDAB -and $IgnoreCloud){
        Write-Warning "Ignoring all powershell modules"
    }

    # load modules into current session
    try{
        if(-not $MainParams.IgnorePWPS){
            Import-Module -Name "pwps" -WarningAction:SilentlyContinue
        }

        if(-not $MainParams.IgnoreDAB){
            Import-Module -Name "pwps_dab" -WarningAction:SilentlyContinue
        }

        if(-not $MainParams.IgnoreCloud){
            Import-Module -Name "pwps_cloud" -WarningAction:SilentlyContinue
        }
    }catch{
        Write-Error "Unable to load one or more modules. Error: $($_)"
    }
}

function Invoke-MainWindow(){
    try{
        $window = [System.Windows.Forms.Form]@{
            MinimumSize     = $MAIN_WINDOW_SIZE
            Text            = "ProjectWise PowerShell Modules Documentation"
            AutoScaleMode   = 2
            StartPosition   = "CenterScreen"
        }

        $main_table = [System.Windows.Forms.TableLayoutPanel]@{
            Dock            = $DOCK_STYLES.FILL
            ColumnCount     = 4
        }

        $title = [System.Windows.Forms.Label]@{
            Location = [System.Drawing.Point]::new(0,0)
            AutoSize = $true
            Text = "Test Text"
        }

        $main_table.SetColumn($title, 0)

        $window.Controls.Add($main_table)

        # $window = Add-VerbList -mainWindow $window

        # $window = Add-FunctionList -mainWindow $window

        # $window = Add-DescriptionField -mainWindow $window

        Set-Variable -Name MAIN_WINDOW -Scope Script -Force -Value $window
    }catch{
        Write-Error "Unable to Instatiate main window. Error: $($_)"
    }
}

function Add-VerbList([Parameter(Mandatory=$true)][System.Windows.Forms.Form]$mainWindow){
    try{
        $col_container = [System.Windows.Forms.Panel]@{
            Size            = $COL_SIZE
            Anchor          = ($ANCHOR_STYLES.TOP + $ANCHOR_STYLES.BOTTOM + $ANCHOR_STYLES.LEFT)
            Margin          = $PADDING
        }

        $verb_table_title = [System.Windows.Forms.Label]@{
            Location        = [System.Drawing.Point]::new(0, 0)
            Height          = $LIST_ITEM_SIZE
            Text            = "Verbs"
        }
        $col_container.Controls.Add($verb_table_title)

        $select_all_verbs = [System.Windows.Forms.Checkbox]@{
            Location        = [System.Drawing.Point]::new($COL_W - $LIST_ITEM_SIZE, $PADDING)
            Height          = $LIST_ITEM_SIZE
            Text            = "All"
        }
        $col_container.Controls.Add($select_all_verbs)

        $verb_table = [System.Windows.Forms.CheckedListBox]@{
            Location            = [System.Drawing.Point]::new($PADDING, $PADDING + $LIST_ITEM_SIZE + $PADDING)
            Dock                = $DOCK_STYLES.LEFT
            CheckOnClick        = $true
            ThreeDCheckBoxes    = $true
            ItemHeight          = $LIST_ITEM_SIZE
            Anchor              = ($ANCHOR_STYLES.TOP + $ANCHOR_STYLES.BOTTOM + $ANCHOR_STYLES.LEFT)
        }
        $mainWindow.Controls.Add($verb_table)
    }catch{
        Write-Error "Unable to Add Verb List Controls. Error $($_)"
    }
    return $mainWindow
}

function Add-FunctionList([Parameter(Mandatory=$true)][System.Windows.Forms.Form]$mainWindow){
    try{
        
    }catch{
        Write-Error "Unable to add Function list control. Error: $($_)"
    }
    return $mainWindow
}

function Add-DescriptionField([Parameter(Mandatory=$true)][System.Windows.Forms.Form]$mainWindow){
    try{

    }catch{
        Write-Error "Unable to add Description field. Error: $($_)"
    }
    return $mainWindow
}

function Load-Modules([Parameter(Mandatory=$true)][hashtable]$IgnoreSwitches){
    try{
        if(-not $IgnoreSwitches.IgnorePWPS){
            Set-Variable -Name PWPS_FUNCTIONS -Scope Script -Force -Value (Get-ModuleFunctionTable -moduleName "pwps")
        }

        if(-not $IgnoreSwitches.IgnoreDAB){
            Set-Variable -Name DAB_FUNCTIONS -Scope Script -Force -Value (Get-ModuleFunctionTable -moduleName "pwps_dab")
        }
        
        if(-not $IgnoreSwitches.IgnoreCloud){
            Set-Variable -Name CLOUD_FUNCTIONS -Scope Script -Force -Value (Get-ModuleFunctionTable -moduleName "pwps_cloud")
        }
    }catch{
        Write-Error "Unable to load module pages. Error: $($_)"
    }
}

function Get-ModuleFunctionTable([Parameter(Mandatory=$true, Position=0)][string]$moduleName){
    try{
        $binary = (Get-Module -Name $moduleName -ListAvailable | Where-Object {$_.ModuleType -eq "Binary"})
        $verb_hash = @{}

        foreach($func in $binary.ExportedCmdlets.Values){
            if($null -eq $verb_hash[$func.Verb]){
                $verb_hash[$func.Verb] = @()
            }
            $verb_hash[$func.Verb] += $func.Name
        }

        return $verb_hash

    }catch{
        Write-Error "Unable to load module functions for module '$($moduleName)'. Error: $($_)"
        return [hashtable]::new()
    }
}

function Populate-Table(){

}


Main -InParams $MyInvocation.BoundParameters

# SIG # Begin signature block
# MIIFlAYJKoZIhvcNAQcCoIIFhTCCBYECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCuFetWDjY/22Kk1+XZ+MdAgq
# jtigggMiMIIDHjCCAgagAwIBAgIQFuWtlV1oWoBD/IAKE+2oCzANBgkqhkiG9w0B
# AQUFADAnMSUwIwYDVQQDDBxSQm9vayBwd3BzX2RhYiBEb2N1bWVudGF0aW9uMB4X
# DTI1MDcyMjE0MDMzNVoXDTI2MDcyMjE0MjMzNVowJzElMCMGA1UEAwwcUkJvb2sg
# cHdwc19kYWIgRG9jdW1lbnRhdGlvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAMVRyDqON3Iv5NfoJ6XhZ0Ti18/nJHWEYIbWqaHWrPK4yW4aKvBW4oOj
# dp9LgQeWRqUUjuf2AzXLNJq++6lRbSNdlGYJiOkxYlVYsd9+gHG/7iZONZMZ/SAX
# jKjBL/aMe5u2QCmYRjruVgTwZmnguv32yhQRTdH5KSMrYNQm7L9fQFCjEoxnQcFJ
# IFaGwlbzeYcrwyrsrTVwcF9IVqKs6rSLBwB1Ltb1CgcqpVnEjNRMzwh45C+EhBux
# cDjTw/Th/IRJDn58TixT2WZzzCJzY9Mx/W/rfZeq2dq3oUB01A5bCI5GEoFUqUBe
# YGBqdJfDx8tGIDOVm/DhMHFPWVEwNhECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBQNhnugq8a4imnLbVC6o6EP
# MFT4ijANBgkqhkiG9w0BAQUFAAOCAQEAO1fcpfi9dV5B+BqfJtgPWwwRky1WZ2N2
# SDVsDn39/pfAwB+VgIxjZtq8seDwtTiuPanOEdQOQfFRzBbi16MVSZ7o7Zp+bg6d
# sSiegY8G3GNauu9W3EnLgv8BEU3lMmztFVytbRzf6ZGugrCsuoPDq0yubOEwR4Vk
# 9mWKPoAYUNtCHAQpgUirqEJQ65uwbYiJoJlXHtnVLF+Tyt4J8IIrQam/ffK5pXLj
# FtiIvkwLmDahlFO5IkDE2J9G1qaSPC0b8v2tik+R19/Iy4A9ip4VmPpQ78rtIspm
# PUCsUn2RIiR5XLGtJTp3BrV3/oA0IiF0HicAD3cAk4+mWR32eyFuIDGCAdwwggHY
# AgEBMDswJzElMCMGA1UEAwwcUkJvb2sgcHdwc19kYWIgRG9jdW1lbnRhdGlvbgIQ
# FuWtlV1oWoBD/IAKE+2oCzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUP74qE2QJmT1MMyT9SqkT
# V7RbkF4wDQYJKoZIhvcNAQEBBQAEggEAK74JtpwCMd1V65YXmf62ETN5w+Jpg6rV
# NC/UD8ZKWK0RSH4gb3qHJ3YojuUq/hlB7ca9EFX1G5/xN9zwDKwMO4ZuWnXi52lg
# e+UYaISS/sD/IMDQ2Cuy86TjGg0CvsWK2uEKRLyF+NPjrRvEmUxz+glDotzakrYi
# iLz1CpqJnerTir3tIx8YUttBhnDHJV9HsLHiMZtMwIL6l+LZsMG2n8eu0xZvFGgW
# SQ92Au1POgtdQGyRz3ZYOr8aK8J8v1tOvF+pa3wZ3EPDz+7Ha5NLh+ARLJ+b9ljI
# Q/+42+DTiERjwOpw5VtGZZC15TsR16N4m2dC9z71T0uQuq5hgD/xbw==
# SIG # End signature block
