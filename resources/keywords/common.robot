*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    Collections
Resource   ../variables/config.robot

*** Keywords ***
Open Todo Application
    [Documentation]    Opens the browser and navigates to the application
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Login With Credentials
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${USERNAME_INPUT}
    Input Text    ${USERNAME_INPUT}    ${username}
    Input Password    ${PASSWORD_INPUT}    ${password}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${TODO_INPUT}    timeout=${SELENIUM_TIMEOUT}

Register New User
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${USERNAME_INPUT}
    Input Text    ${USERNAME_INPUT}    ${username}
    Input Password    ${PASSWORD_INPUT}    ${password}
    Input Password    ${CONFIRM_PASSWORD}    ${password}
    Click Element    ${REGISTER_BUTTON}
    Wait Until Page Contains Element    ${TODO_INPUT}    timeout=${SELENIUM_TIMEOUT}

Generate Test User
    ${timestamp}=    Get Current Date    result_format=epoch
    ${username}=    Set Variable    testuser_${timestamp}
    Set Test Variable    ${TEST_USER}    ${username}
    Set Test Variable    ${TEST_EMAIL}    ${username}@test.com
    [Return]    ${username}

Logout User
    Click Element    ${LOGOUT_BUTTON}
    Wait Until Page Contains Element    ${LOGIN_LINK}

Clean Test Data
    [Documentation]    Cleans up test data after test execution
    # Add cleanup logic here if needed
    Log    Cleaning up test data...

Take Screenshot On Failure
    [Documentation]    Takes a screenshot when a test fails
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    results/failure_${timestamp}.png

Wait For Element And Click
    [Arguments]    ${locator}    ${timeout}=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Click Element    ${locator}

Verify Page Contains Text
    [Arguments]    ${text}    ${timeout}=${SELENIUM_TIMEOUT}
    Wait Until Page Contains    ${text}    timeout=${timeout}

Get Random String
    [Arguments]    ${length}=10
    ${random}=    Generate Random String    ${length}    [LETTERS][NUMBERS]
    [Return]    ${random}