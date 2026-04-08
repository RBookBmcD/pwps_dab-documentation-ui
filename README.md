# Project Wise Powershell Documentation UI
**Version: Beta 1.1<br>
Author: Robert Book (rdbook@burnsmcd.com)**

This software is a UI in powershell developed to aid in research and documentation lookup for the [pwps_dab powershell module](https://www.powershellgallery.com/packages/pwps_dab/24.0.2)

## Feature List
Beta 1.1
* Changed function retrieval from file to looking directly at module
* Able to provide documentation for any version of pwps_dab

Beta 1.0
* Added Adjustable window size
* Finished [How to Use](#how-to-use) section of documentation 

Alpha 1.3
* Increased window size for easier reading of function documentation

Alpha 1.2
* Search Bar for searching functions

Alpha 1.1
* Headers and documentation in ps1 and py files
* Signed ps1 file to allow it to run on more secure systems

Alpha 1.0:
* Functions sorted by most used Verbs (5+ functions with the same verb)
* From selected function, retrieves Get-Help -full execution on the function
* Ability to look at 1+ verb groups

## How To Use
In order to run this software, you must have any version of pwps_dab installed on your machine.

To use this software:
1) Download Zip file from this github repository (Code > Download ZIP)
2) Extract downloaded files to any location you want
3) Either: <br>
    a) Right click on the "GetPwpsDabDocsUI.ps1" <br>
    b) Select "Run with Powershell" in the options menu
4) Or: <br>
   a) Launch an instance of Powershell <br>
   b) Navigate to the location you extracted the folder to <br>
   c) Type ".\GetPwpsDabDocsUI.ps1" and press enter <br>
5) Or: <br>
   a) Launch an instance of Powershell <br>
   b) Type relative or absolute file path to extracted folder + "\GetPwpsDabDocsUI.ps1" <br>
6) Success!! You should see both a command prompt running powershell pop-up (for verbose messages) as well as a window with the title: "PWPS Documentation" 
7) You may be warned about the certificate being unverified. This is because I signed the script with my own credentials which are not gloably recongnized. You will have to accept the warning to run this script.

### Updating list of functions
With update Beta 1.1, the list of functions will automatically get pulled from the module info in PowerShell. This should allow this script to run with any and all versions of pwps_dab you may have installed on your machine.

## Change Log
Beta 1.1 (4/8/2026)
* Adjusted how functions are provided to the UI
  * Previous method: txt file => json file => read file in PowerShell
  * New Method: read module info in PowerShell
* Silenced annoying version info created by first run of pwps_dab in a PowerShell instance
* Removed files deemed unecessary by function update
  * Kept all functions txt for reference

Beta 1.0 (8/18/2025)
* Added adjustable window size with anchor attributes

Alpha 1.3 (7/29/2025)
* Increased window size and Documentation window size for easier reading of Get-Help results

Alpha 1.2 (7/22/2025)
* Added Search bar for functions

Alpha 1.1: (7/22/2025)
* Added digital signature to scripts to allow them to run on more secure machines
* Added Documentation (file headers)

Alpha 1.0: (7/21/2025)
* Initial Creation
* Added Basic functionality

## Future Updates
* better format for help documentation?
* App info page



