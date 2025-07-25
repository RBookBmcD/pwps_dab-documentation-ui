#####################################################################################################################################################################################################################
#####################################################################################################################################################################################################################
#################################################| |# 
################### #############################| |#   Name                    : SortPwpsFunctions.py
#################     ###########################| |#   Type                    : Reformatting Script
###############         #########################| |#   Purpose                 : Reformats a list of space (' ' ) separated items into json file
################          #######################| |#   Author                  : Robert D. Book (rdbook@burnsmcd.com)
##################          #####################| |#   Creation Date           : 7/21/2025
##########    ######          ###################| |#   Modified By             :
########        #####           #################| |#   Modified Date           :
########          #####        ##################| |#   Version                 : 1.0
##########          #####     ###################| |#   Python Version          : 3.13.5
############          ###########################| |#
#############           #########################| |# 
###############          ########################| |#   
##########  #####          ######################| |#   Requirements:
########      #####          ####################| |#   - python 3.13.5 or later installed
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
## - This script just reads a file containing a list of items separated by spaces, and reformats it to a json file.
## - All functions (format: Verb-FunctionName) are sorted by their verb in the json object.
## 
#####################################################################################################################################################################################################################
## 
## Change Log:
## Alpha 1.1
## - Added header
##
## Alpha 1.0
## - Initial release
## - Basic functionality
## 
## 
#####################################################################################################################################################################################################################

import json

def GetFunctionList(file_name: str) -> list[str]:
    file = open(file_name, 'r')
    file_content = file.read().split(' ')
    file.close()
    file_content.sort()
    file_content.remove('\n')
    return file_content

def WriteListToFile(file_name: str, in_list: list[str]) -> None:
    file = open(file_name, 'w')

    for line in in_list:
        file.write(f"{line}\n")

    file.close()

def GetHeaderCounts(function_list: list[str]) -> dict:
    header_count = dict()
    for fn in function_list:
        header = fn.split('-')[0]
        if header in header_count:
            header_count[header] = header_count[header] + 1
        else:
            header_count[header] = 1

    return header_count

def GetSortedFunctions(function_list: list[str], header_count: dict) -> dict:
    sorted_functions = dict({"Misc": []})

    for fn in function_list:
        header = fn.split('-')[0]
        if header_count[header] >= 5:
            if header in sorted_functions:
                sorted_functions[header].append(fn)
            else:
                sorted_functions[header] = [fn]
        else:
            sorted_functions["Misc"].append(fn)

    return sorted_functions

def ConvertToJson(functions_dict: dict):
    out_json_dict = dict({"Verbs": []})
    for key in list(functions_dict.keys()):
        out_json_dict["Verbs"].append(dict({"Verb": key, "Functions": functions_dict[key]}))

    return out_json_dict


func_list = GetFunctionList("all_pwps_functions.txt")
func_types = GetHeaderCounts(func_list)
sorted_functions = GetSortedFunctions(func_list, func_types)

sorted_functions_json = ConvertToJson(sorted_functions)

file = open('sorted_functions.json', 'w')
file.write(json.dumps(sorted_functions_json))