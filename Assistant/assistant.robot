*** Settings ***
Library  AssistantLibrary
Library  Process
Suite Setup  Setup All
Suite Teardown  Close All
Resource  ${EXECDIR}/examples/base/github.robot

*** Tasks ***
interactive
    start assistant

*** Keywords ***
open notpad
    Start Process  notepad.exe
