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


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# get list of sorted functions from json file
# $sorted_functions = Get-Content -Path '.\sorted_functions.json' | ConvertFrom-Json

# Startup processes
# silence annoying information from loading pwps module
if([System.Environment]::GetEnvironmentVariable("SuppressPSOutput").Length -le 0){
    [System.Environment]::SetEnvironmentVariable("SuppressPSOutput", "True")
}

# load pwps_module into current session
Import-Module -Name "pwps_dab" -WarningAction:SilentlyContinue

$pwps_bin = (Get-Module -Name "pwps_dab" | Where-Object {$_.ModuleType -eq "Binary"})

# $sorted_function_names = ($pwps_bin.ExportedCmdlets.Values.Name | Sort-Object)
# Get Verb Hash
$function_verb_hash = @{}
foreach($verb in $pwps_bin.ExportedCmdlets.Values.Verb){
    if(-not $function_verb_hash[$verb]){$function_verb_hash[$verb] = 1}
    else{$function_verb_hash[$verb] += 1}
}
$misc_verbs = ($function_verb_hash.GetEnumerator() | Where-Object {$_.Value -le 20})
$function_verb_table = ($function_verb_hash.GetEnumerator() | Where-Object {$_.Value -gt 20} | Sort-Object Name)
$function_verb_table += [PSCustomObject]@{Name="Misc";Key="Misc";Value=$misc_verbs.Count} # add Misc to end of list

# populate function table helper function
$Global:function_table_content = [System.Collections.ArrayList]@()
function Populate-Table{
    if($verb_table.CheckedItems.Count -gt 0){
        $temp_content = $pwps_bin.ExportedCmdlets.Values | Where-Object {($_.Verb -in $verb_table.CheckedItems) -and ($_.Name -like "*$($function_table_search.Text)*")}
        if($verb_table.CheckedItems -contains "Misc"){$temp_content += $pwps_bin.ExportedCmdlets.Values | Where-Object {($_.Verb -in $misc_verbs.Name) -and ($_.Name -like "*$($function_table_search.Text)*")}}
        $function_table.Items.Clear()
        ($Global:function_table_content).Clear()
        if($temp_content.Count -eq 1){
            $function_table.Items.Add(($temp_content))
            ($Global:function_table_content).Add($temp_content)
        }elseif($temp_content.Count -ne 0){
            $function_table.Items.AddRange(($temp_content))
            ($Global:function_table_content).AddRange($temp_content)
        }
    } else {
        ($Global:function_table_content).Clear()
        $function_table.Items.Clear()
    }
}

$WINDOW_WIDTH = 1200
$WINDOW_HEIGHT = 800

$ui = New-Object System.Windows.Forms.Form
    $ui.Text = "PWPS Documentation"
    $ui.AutoScaleMode = 2
    $ui.MinimumSize = New-Object System.Drawing.Size($WINDOW_WIDTH, $WINDOW_HEIGHT)
    $ui.StartPosition = "CenterScreen"

$WINDOW_WIDTH = $ui.Width
$WINDOW_HEIGHT = $ui.Height

# List Verbs 
$verb_table_title = New-Object System.Windows.Forms.Label
    $verb_table_title.Location = New-Object System.Drawing.Point(10, 10)
    $verb_table_title.AutoSize = $true
    $verb_table_title.Text = "Verbs"

# Verb Table
$verb_table = New-Object System.Windows.Forms.CheckedListBox
    $verb_table.Location = New-Object System.Drawing.Point(10, 30)
    $verb_table.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.25), ($WINDOW_HEIGHT * 0.9))
    $verb_table.CheckOnClick = $true
    $verb_table.ThreeDCheckBoxes = $true
    $verb_table.ItemHeight = 20
    $verb_table.Anchor = 7

# Select All Checkbox
$select_all_verbs = New-Object System.Windows.Forms.CheckBox
    $select_all_verbs.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.25) - 20), 10)
    $select_all_verbs.AutoSize = $true
    $select_all_verbs.Text = "All"

# Action when all button is selected
$select_all_verbs.Add_MouseDown({
    $setCheck = (-not ($verb_table.CheckedItems.Count -eq $verb_table.Items.Count))
    if($select_all_verbs.CheckState -eq 2){
        $setCheck = $false
    }
    for($i = 0; $i -lt $verb_table.Items.Count; $i+=1){
        $verb_table.SetItemChecked($i, $setCheck)
    }
    Populate-Table
})

# populate verb table
$verb_table.Items.AddRange($function_verb_table.Name)

# Add function list
$function_table_label = New-Object System.Windows.Forms.Label
    $function_table_label.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.25) + 30), 10)
    $function_table_label.AutoSize = $true
    $function_table_label.Text = "Functions"

# function table
$function_table = New-Object System.Windows.Forms.ListBox
    $function_table.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.25) + 30), 50)
    $function_table.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.25), ($WINDOW_HEIGHT * 0.87))
    $function_table.ScrollAlwaysVisible = $true
    $function_table.Anchor = 7

# add Search bar
$function_table_search = New-Object System.Windows.Forms.TextBox
    $function_table_search.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.25) + 30), 30)
    $function_table_search.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.25), 20)

$verb_table.Add_MouseDown({
    if($verb_table.CheckedItems.Count -eq $verb_table.Items.Count){$select_all_verbs.CheckState = 2}
})
$verb_table.Add_MouseUp({Populate-Table})
$function_table_search.Add_TextChanged({Populate-Table})

# add documentation textbox
$doc_label = New-Object System.Windows.Forms.Label
    $doc_label.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.5) + 50), 10)
    $doc_label.AutoSize = $true
    $doc_label.Text = 'Documentation'

# add results textbox
$doc_results = New-Object System.Windows.Forms.TextBox
    $doc_results.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.5) + 50), 30)
    $doc_results.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.44), ($WINDOW_HEIGHT * 0.9))
    $doc_results.Multiline = $true
    $doc_results.WordWrap = $false
    $doc_results.ReadOnly = $true
    $doc_results.ScrollBars = 3
    $doc_results.Anchor = 15

# add documentation to textbox when function is selected
$function_table.Add_SelectedIndexChanged({
    $doc_results.Text = (Get-Help $function_table.SelectedItem -full | Out-String)
})

# add verb table content
$ui.Controls.Add($verb_table_title)
$ui.Controls.Add($verb_table)
$ui.Controls.Add($select_all_verbs)

# add function table content
$ui.Controls.Add($function_table_label)
$ui.Controls.Add($function_table)
$ui.Controls.Add($function_table_search)

# add documentation results
$ui.Controls.Add($doc_label)
$ui.Controls.Add($doc_results)

$ui.ShowDialog()

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
