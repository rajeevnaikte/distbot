*** Keywords ****
select ${item} in ${label} dropdown
	select ${item} in combobox[title=${label}] in current window

Click ${label} button
	Click element button[title=${label}],button[text=${label}] in current window

Input ${text} into ${label} textbox
	Input ${text} into element textfield[title=${label}] in current window

Input ${text} into textbox in fieldset ${label}
	Input ${text} into element fieldset[title=${label}] textfield in current window

Get ${label} value
	${value}=  Get value of displayfield[fieldLabel=${label}]
	[Return]  ${value}

select ${item} in ${label} dropdown in ${panel name} panel
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}] panel[itemId=${panel name}][loadMask],panel[title=${panel name}][loadMask]
	select ${item} in panel[itemId=${panel name}],panel[title=${panel name}] combobox[title=${label}] in current window

Click ${label} button in ${panel name} panel
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}] panel[itemId=${panel name}][loadMask],panel[title=${panel name}][loadMask]
	Click element panel[itemId=${panel name}],panel[title=${panel name}] button[title=${label}],button[text=${label}] in current window
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}][isLoading=true]

Input ${text} into ${label} textbox in ${panel name} panel
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}] panel[itemId=${panel name}][loadMask],panel[title=${panel name}][loadMask]
	Input ${text} into element panel[itemId=${panel name}],panel[title=${panel name}] textfield[title=${label}] in current window

Get ${label} value in ${panel name} panel
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}] panel[itemId=${panel name}][loadMask],panel[title=${panel name}][loadMask]
	${value}=  Get value of panel[itemId=${panel name}],panel[title=${panel name}] displayfield[fieldLabel=${label}]
	[Return]  ${value}

window must have message with text ${text}
	Element label should contain text ${text} in current window

panel ${panel name} must have message with text ${text}
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}] panel[itemId=${panel name}][loadMask],panel[title=${panel name}][loadMask]
	Element panel[itemId=${panel name}],panel[title=${panel name}] label should contain text ${text} in current window

Element ${ext query} should contain text ${text} in current window
	wait until page contains Element  extJs=window[title=${window name}] ${ext query}
    Capture Page Screenshot  ${TEST NAME}-{index}.png
    ${message}=  get text  extJs=window[title=${window name}] ${ext query}
    Should Contain  ${message}  ${text}

Set up extjs
    Add Location Strategy  extJs  get web element from extJs query
	Add Location Strategy  extJsInput  get input web element from extJs query
	${jsscript}=  Get Binary File  ${EXECDIR}/examples/base/getElementByExtJSQuery.js
	Set Suite Variable  ${getElementByExtJSQuery}  ${jsscript}
	${jsscript}=  Get Binary File  ${EXECDIR}/examples/base/getCaseInsensitiveExtJSQuery.js
	Set Suite Variable  ${getCaseInsensitiveExtJSQuery}  ${jsscript}
	
get web element from extjs query
	[Arguments]  ${browser}  ${locator}  ${tag}  ${constraints}
	${web element}=  get web element using extJs component query  ${locator}  getId
	[Return]  ${web element}

get input web element from extjs query
	[Arguments]  ${browser}  ${locator}  ${tag}  ${constraints}
	${web element}=  get web element using extJs component query  ${locator}  inputId
	[Return]  ${web element}

get web element using extJs component query
	[Arguments]  ${comp query}  ${id function}
	${comp query}=  Execute Javascript  ${getCaseInsensitiveExtJSQuery}  ARGUMENTS  ${comp query}
	log to console  Searching ${comp query}
	${web element}=  Execute Javascript  ${getElementByExtJSQuery}  ARGUMENTS  ${comp query}  ${id function}
	[Return]  ${web element}

Check ${window name} window is open
	Wait Until Element Is Visible  extJs=window[title=${window name}]
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}][isLoading=true]
	Set Suite Variable  \${window name}  ${window name}
	Double Click Element  extJs=window[title=${window name}] title

Close current window
	Click Element  extJs=window[title=${window name}] tool[tooltip='Close dialog']

Switch to ${new window name} window
	Sleep  500 millisecond  waiting for default focus
	${extjs query}=  Execute Javascript  ${getCaseInsensitiveExtJSQuery}  ARGUMENTS  window[title=${new window name}]
	Execute Javascript  Ext.ComponentQuery.query('${extjs query}')[0].show()
	Set Suite Variable  ${window name}  ${new window name}

Click element ${extjs query} in current window
	${extjs query}=  wait for component ${extjs query} in current window
	Click Element  extJs=${extjs query}
	Sleep  500 millisecond  waiting for loading start
	Wait Until Page Does Not Contain Element  extJs=window[title=${window name}][isLoading=true]

Input ${text} into element ${extjs query} in current window
	Wait Until Page Contains Element  extJsInput=window[title=${window name}] ${extjs query}
	Wait Until Element Is Visible  extJsInput=window[title=${window name}] ${extjs query}
	wait Until Page Does Not Contain Element  extJs=window[title=${window name}] ${extjs query + '[loadMask]'}
	Input Text  extJsInput=window[title=${window name}] ${extjs query}  ${text}

Search ${text} in combobox ${extjs query}
	Wait Until Page Contains Element  extJsInput=${extjs query}
	Wait Until Element Is Visible  extJsInput=${extjs query}
	Sleep  500 millisecond  waiting for default focus
	${elementId}=  Execute Javascript  return Ext.ComponentQuery.query('${extjs query}')[0].id;
	Input Text  extJsInput=${extjs query}  ${text}
	Wait Until Element Is Visible  extJs=boundlist[id=${elementId}-picker]
	Wait Until Element Is Not Visible  extJs=loadmask
	Execute Javascript  var combo=Ext.getCmp('${elementId}-picker');combo.select(combo.getStore().getAt(0));

select ${text} in ${extjs query} in current window
	${extjs query}=  wait for component ${extjs query} in current window
	${extjs query}=  Execute Javascript  ${getCaseInsensitiveExtJSQuery}  ARGUMENTS  ${extjs query}
	Execute Javascript  var combo=Ext.ComponentQuery.query('${extjs query}')[0];combo.select(combo.getStore().byText.get('${text}'));

Get value of ${extjs query}
	${extjs query}=  wait for component ${extjs query} in current window
	${extjs query}=  Execute Javascript  ${getCaseInsensitiveExtJSQuery}  ARGUMENTS  ${extjs query}
	${value}=  Execute Javascript  return Ext.ComponentQuery.query('${extjs query}')[0].value;
	[Return]  ${value}

wait for component ${extjs query} in current window
	${extjs query}=  Catenate  window[title=${window name}]  ${extjs query}
	Wait Until Page Contains Element  extJs=${extjs query}
	Wait Until Element Is Visible  extJs=${extjs query}
	wait Until Page Does Not Contain Element  extJs=${extjs query + '[loadMask]'}
	[Return]  ${extjs query}
