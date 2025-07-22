# Project Wise Powershell Documentation UI
**Version: Alpha 1.0<br>
Author: Robert Book (rdbook@burnsmcd.com)**

This software is a UI in powershell developed to aid in research and documentation lookup for the [pwps_dab powershell module](https://www.powershellgallery.com/packages/pwps_dab/24.0.2)

## Feature List
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
In order to run this software, you must have the latest version of pwps_dab installed on your machine. <br>There should be a provided JSON file that contains all of the functions for version 24.0.2 of pwps_dab. For 

### Updating list of functions
To update the list of functions, you need to have python3 installed on your machine.
1) Go to [pwps_dab module Powershll Gallery](https://www.powershellgallery.com/packages/pwps_dab/24.0.2) page
2) Under "Package Details", copy all of the functions.
3) Paste the copied list into all_pwps_functions.txt
4) run SortPwpsFunctions.py

This will update the json file containing all of the functions sorted by their verbs.

## Change Log
Alpha 1.2 (7/22/2025)
* Added Search bar for functions

Alpha 1.1: (7/22/2025)
* Added digital signature to scripts to allow them to run on more secure machines
* Added Documentation (file headers)

Alpha 1.0: (7/21/2025)
* Initial Creation
* Added Basic functionality

## Future Updates
* Search functions by keyword (ctrl-f)
* better format for help documentation?



