*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    http://localhost:3000
${BROWSER}    chrome

*** Test Cases ***
Test Todo App Is Running
    Open Browser    ${URL}    ${BROWSER}
    Page Should Contain    Todo
    Close Browser