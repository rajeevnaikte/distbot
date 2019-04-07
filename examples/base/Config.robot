*** Keywords ****
Set up variables
    ${URL}=  Set Variable If  
    ...  '${ENV}'=='dev'  https://github.com/login
    ...  '${ENV}'=='stage'  https://github.com/login
	...  '${ENV}'=='preprod'  https://github.com/login
    ...  '${ENV}'=='local'  https://localhost/login
	Set Suite Variable  \${URL}  ${URL}

Connect to database
    ${host}=  Set Variable If  
    ...  '${ENV}'=='dev'  dev.mysql.com
    ...  '${ENV}'=='local'  local.mysql.com
    ...  '${ENV}'=='stage'  stage.mysql.com
    #Connect to Database  pymysql  tempdb  mysql  mysql  ${host}  1433
