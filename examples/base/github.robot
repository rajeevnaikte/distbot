*** Settings ***
Library  SeleniumLibrary  15
Library  DatabaseLibrary
Library  Collections
Library  OperatingSystem
Resource  Config.robot

*** Keywords ****
Setup All
	Connect to database
	Set up variables

Close All
	#Disconnect From Database
	Close All Browsers

Get data from sql script file
	[Arguments]  ${scriptFile}
	${getScript}=  Get Binary File  ${scriptFile}
	${results}=  Query  ${getScript}
	[Return]  ${results}

Update data with sql script file
	[Arguments]  ${scriptFile}
	${getScript}=  Get Binary File  ${scriptFile}
	Execute SQL string  ${getScript}

Login to github
	Login to github with user ${USERNAME} and password ${PASSWORD}

Login to github with user ${username} and password ${password}
	Open Browser  ${URL}  ${BROWSER}  ${SUITE NAME}  remote_url=${REMOTEURL}
	Maximize Browser Window
	Wait Until Page Contains Element  login_field
	Input Text  login_field  ${username}
	Input Password  password  ${password}
	Click Element  commit
	Wait Until Page Contains Element  //img[@alt='@${username}']

capture screenshot
	Capture Page Screenshot  ${TEST NAME}-{index}.png
