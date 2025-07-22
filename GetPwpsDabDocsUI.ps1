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
########          #####        ##################| |#   Version                 : 1.0
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
$sorted_functions = Get-Content -Path '.\sorted_functions.json' | ConvertFrom-Json

$WINDOW_WIDTH = 1000
$WINDOW_HEIGHT = 800

$ui = New-Object System.Windows.Forms.Form
    $ui.Text = "PWPS Documentation"
    $ui.AutoScaleMode = 2
    $ui.Size = New-Object System.Drawing.Size($WINDOW_WIDTH, $WINDOW_HEIGHT)
    $ui.StartPosition = "CenterScreen"

$WINDOW_WIDTH = $ui.Width
$WINDOW_HEIGHT = $ui.Height

# List Verbs 
$verb_table_title = New-Object System.Windows.Forms.Label
    $verb_table_title.Location = New-Object System.Drawing.Point(10, 10)
    $verb_table_title.AutoSize = $true
    $verb_table_title.Text = "Verb"

# Verb Table
$verb_table = New-Object System.Windows.Forms.CheckedListBox
    $verb_table.Location = New-Object System.Drawing.Point(10, 30)
    $verb_table.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.25), ($WINDOW_HEIGHT * 0.9))
    $verb_table.CheckOnClick = $true
    $verb_table.ThreeDCheckBoxes = $true

# populate table
$verb_list = $sorted_functions.Verbs
$verb_table.Items.AddRange(($verb_list.Verb | Sort-Object))

# Add function list
$function_table_label = New-Object System.Windows.Forms.Label
    $function_table_label.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.25) + 30), 10)
    $function_table_label.AutoSize = $true
    $function_table_label.Text = "Functions"

# function table
$function_table = New-Object System.Windows.Forms.ListBox
    $function_table.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.25) + 30), 30)
    $function_table.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.25), ($WINDOW_HEIGHT * 0.9))
    $function_table.ScrollAlwaysVisible = $true

# populate function table
$function_table_content = [System.Collections.ArrayList]@()
$verb_table.Add_MouseUp({
    $function_table_content.clear()
    foreach($verb in $verb_table.CheckedItems){
        $function_table_content += ($sorted_functions.Verbs | Where-Object {$_.Verb -eq $verb}).Functions
    }
    $function_table.Items.Clear()
    $function_table.Items.AddRange($function_table_content)
})

# add documentation textbox
$doc_label = New-Object System.Windows.Forms.Label
    $doc_label.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.5) + 50), 10)
    $doc_label.AutoSize = $true
    $doc_label.Text = 'Documentation'

# add results textbox
$doc_results = New-Object System.Windows.Forms.TextBox
    $doc_results.Location = New-Object System.Drawing.Point((($WINDOW_WIDTH * 0.5) + 50), 30)
    $doc_results.Size = New-Object System.Drawing.Size(($WINDOW_WIDTH * 0.4), ($WINDOW_HEIGHT * 0.9))
    $doc_results.Multiline = $true
    $doc_results.WordWrap = $false
    $doc_results.ReadOnly = $true
    $doc_results.ScrollBars = 3

# add documentation to textbox when function is selected
$function_table.Add_SelectedIndexChanged({
    $doc_results.Text = (Get-Help $function_table.SelectedItem -full | Out-String)
})

# add verb table content
$ui.Controls.Add($verb_table_title)
$ui.Controls.Add($verb_table)

# add function table content
$ui.Controls.Add($function_table_label)
$ui.Controls.Add($function_table)

# add documentation results
$ui.Controls.Add($doc_label)
$ui.Controls.Add($doc_results)

$ui.ShowDialog()

# SIG # Begin signature block
# MIIFlAYJKoZIhvcNAQcCoIIFhTCCBYECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpLP0J+t6TLgUgv9KLcuoTD4c
# H+SgggMiMIIDHjCCAgagAwIBAgIQFuWtlV1oWoBD/IAKE+2oCzANBgkqhkiG9w0B
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
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUf8bTx0JRJUD60SVEPZi4
# HwBgp7QwDQYJKoZIhvcNAQEBBQAEggEAJ0EDzB9aReDEu8gghvSju7eCIhI6gU/w
# sPlTWuNk+dO2GavIzcPvqOlzm6s/yJSsgoVbu654Q5+fMz5AWVTAbl+75IEdzFa2
# 9DMUwylyHVcTXzemnXn5Zozl7O8X6PzAW+7h1Jxx8cdKpvwDZhDpw/jFSBJk9kSK
# afbmpHR1w0aTkSNGqeMFGuP06BKaDKmzS8n3DNn0l0Ysd+/AnyfDDp8x/jolfN+A
# vfkilpXyvJShu4TLcBxrtW0+v8OH5QPyXj5zH3FTW5s3sQhy1ZumtFViupWj8Jls
# OBxTJUA8bip0f4jW5FGeMSwDLjdwY0uXH4/jjiwiRS/ZFOl0WHZheQ==
# SIG # End signature block
