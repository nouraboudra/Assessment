*** Settings ***
Documentation    UI Tests for Authentication
Library          SeleniumLibrary
Resource         ../../resources/keywords/common.robot
Resource         ../../resources/variables/config.robot
Test Setup       Open Todo Application
Test Teardown    Close Browser

*** Test Cases ***
Test User Registration UI Success
    [Documentation]    Test successful user registration through UI
    [Tags]    UI    Auth    Smoke    Critical

    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Wait Until Element Is Visible    ${USERNAME_INPUT}
    Input Text    ${USERNAME_INPUT}    ${username}
    Input Password    ${PASSWORD_INPUT}    Test123!
    Input Password    ${CONFIRM_PASSWORD}    Test123!
    Click Element    ${REGISTER_BUTTON}

    # Verify successful registration and redirect
    Wait Until Page Contains Element    ${TODO_INPUT}    timeout=10s
    Page Should Contain    ToDo

    # Verify logout button is visible
    Element Should Be Visible    ${LOGOUT_BUTTON}

Test User Login UI Success
    [Documentation]    Test successful user login through UI
    [Tags]    UI    Auth    Smoke    Critical

    # First register a user
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!

    # Logout
    Click Element    ${LOGOUT_BUTTON}

    # Login again
    Click Link    LOGIN
    Login With Credentials    ${username}    Test123!

    # Verify successful login
    Page Should Contain    ToDo
    Element Should Be Visible    ${TODO_INPUT}

Test Registration Password Mismatch
    [Documentation]    Test registration with mismatched passwords
    [Tags]    UI    Auth    Negative

    Click Link    REGISTER
    Wait Until Element Is Visible    ${USERNAME_INPUT}
    Input Text    ${USERNAME_INPUT}    testuser
    Input Password    ${PASSWORD_INPUT}    Test123!
    Input Password    ${CONFIRM_PASSWORD}    Different123!
    Click Element    ${REGISTER_BUTTON}

    # Verify error message
    Wait Until Page Contains    Password    timeout=5s

Test Login Invalid Credentials
    [Documentation]    Test login with invalid credentials
    [Tags]    UI    Auth    Negative

    Click Link    LOGIN
    Wait Until Element Is Visible    ${USERNAME_INPUT}
    Input Text    ${USERNAME_INPUT}    nonexistentuser
    Input Password    ${PASSWORD_INPUT}    WrongPass123!
    Click Element    ${LOGIN_BUTTON}

    # Verify error message
    Wait Until Page Contains    Invalid    timeout=5s
    Page Should Not Contain Element    ${TODO_INPUT}

Test Registration Empty Fields
    [Documentation]    Test registration with empty fields
    [Tags]    UI    Auth    Negative

    Click Link    REGISTER
    Wait Until Element Is Visible    ${REGISTER_BUTTON}
    Click Element    ${REGISTER_BUTTON}

    # Should show validation errors
    Page Should Contain    required

Test Logout Functionality
    [Documentation]    Test logout functionality
    [Tags]    UI    Auth    Smoke

    # Register and login
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!

    # Verify logged in
    Element Should Be Visible    ${LOGOUT_BUTTON}

    # Logout
    Click Element    ${LOGOUT_BUTTON}

    # Verify logged out
    Wait Until Page Contains Element    ${LOGIN_LINK}
    Page Should Not Contain Element    ${TODO_INPUT}
    Page Should Contain    Login

Test Session Persistence
    [Documentation]    Test that session persists on page refresh
    [Tags]    UI    Auth    Integration

    # Register user
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!

    # Refresh page
    Reload Page

    # Should still be logged in
    Wait Until Page Contains Element    ${TODO_INPUT}    timeout=10s
    Element Should Be Visible    ${LOGOUT_BUTTON}