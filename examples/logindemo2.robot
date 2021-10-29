*** Settings ***
Suite Setup  Setup All
Suite Teardown  Close All
Resource  ${EXECDIR}/examples/base/github.robot

*** Test Cases ***
Test github login
    Login to github
    capture screenshot
    
