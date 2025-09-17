*** Settings ***
Documentation    End-to-End Tests for Complete User Workflows
Library          SeleniumLibrary
Library          RequestsLibrary
Resource         ../../resources/keywords/common.robot
Resource         ../../resources/variables/config.robot
Test Setup       Open Todo Application
Test Teardown    Close All Browsers

*** Test Cases ***
Test Complete User Journey
    [Documentation]    Test complete user journey from registration to todo management
    [Tags]    E2E    Critical    Smoke

    # Step 1: Register new user
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!

    # Step 2: Add multiple todos
    @{todos}=    Create List    Buy milk    Call mom    Finish report
    FOR    ${todo}    IN    @{todos}
        Input Text    ${TODO_INPUT}    ${todo}
        Press Keys    ${TODO_INPUT}    RETURN
        Wait Until Page Contains    ${todo}
    END

    # Step 3: Complete a todo
    ${checkbox}=    Get WebElement    xpath=//div[contains(text(),'Buy milk')]/..//input[@type='checkbox']
    Click Element    ${checkbox}

    # Step 4: Logout
    Click Element    ${LOGOUT_BUTTON}
    Wait Until Page Contains Element    ${LOGIN_LINK}

    # Step 5: Login again
    Click Link    LOGIN
    Login With Credentials    ${username}    Test123!

    # Step 6: Verify todos persist
    FOR    ${todo}    IN    @{todos}
        Page Should Contain    ${todo}
    END

    # Verify completed status persists
    ${todo_element}=    Get WebElement    xpath=//div[contains(text(),'Buy milk')]
    ${class}=    Get Element Attribute    ${todo_element}    class
    Should Contain    ${class}    completed

Test Multi-Session Real-Time Sync
    [Documentation]    Test real-time synchronization between multiple sessions
    [Tags]    E2E    WebSocket    Critical

    # Register user
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!

    # Open second browser
    ${first_browser}=    Get Browser Ids
    Execute Javascript    window.open('${BASE_URL}', '_blank')
    Switch Window    NEW

    # Login in second window
    Click Link    LOGIN
    Login With Credentials    ${username}    Test123!

    # Add todo in second window
    ${todo_text}=    Set Variable    Real-time sync test
    Input Text    ${TODO_INPUT}    ${todo_text}
    Press Keys    ${TODO_INPUT}    RETURN

    # Switch back to first window
    Switch Window    MAIN

    # Verify todo appears (real-time sync)
    Wait Until Page Contains    ${todo_text}    timeout=5s

Test Data Validation Across Layers
    [Documentation]    Test data validation in both UI and API
    [Tags]    E2E    Validation

    # Test 1: UI validation
    Click Link    REGISTER
    Click Element    ${REGISTER_BUTTON}
    Page Should Contain    required

    # Test 2: API validation
    ${invalid_data}=    Create Dictionary    username=    password=
    ${response}=    POST    ${API_URL}/auth/register
    ...    json=${invalid_data}
    ...    expected_status=400

    # Test 3: Register valid user
    ${username}=    Generate Random String    10    [LETTERS]
    Input Text    ${USERNAME_INPUT}    ${username}
    Input Password    ${PASSWORD_INPUT}    Test123!
    Input Password    ${CONFIRM_PASSWORD}    Test123!
    Click Element    ${REGISTER_BUTTON}

    # Test 4: Try XSS in todo
    Wait Until Page Contains Element    ${TODO_INPUT}
    ${xss_attempt}=    Set Variable    <script>alert('XSS')</script>
    Input Text    ${TODO_INPUT}    ${xss_attempt}
    Press Keys    ${TODO_INPUT}    RETURN

    # Verify XSS is escaped
    ${source}=    Get Source
    Should Not Contain    ${source}    <script>alert

Test Performance Under Load
    [Documentation]    Test application performance with many todos
    [Tags]    E2E    Performance

    # Register and login
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!

    # Add 50 todos
    ${start_time}=    Get Time    epoch
    FOR    ${i}    IN RANGE    50
        Input Text    ${TODO_INPUT}    Todo item ${i}
        Press Keys    ${TODO_INPUT}    RETURN
    END
    ${end_time}=    Get Time    epoch

    # Calculate time taken
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    Log    Added 50 todos in ${duration} seconds
    Should Be True    ${duration} < 30    Adding todos took too long

    # Verify all todos are displayed
    ${count}=    Get Element Count    ${TODO_ITEM}
    Should Be Equal As Integers    ${count}    50

Test Error Recovery
    [Documentation]    Test application error handling and recovery
    [Tags]    E2E    ErrorHandling

    # Test network error simulation
    Click Link    LOGIN

    # Try login while offline (simulate)
    Execute Javascript    window.navigator.onLine = false

    Input Text    ${USERNAME_INPUT}    testuser
    Input Password    ${PASSWORD_INPUT}    Test123!
    Click Element    ${LOGIN_BUTTON}

    # Should show error message
    Wait Until Page Contains    error    timeout=5s

    # Restore connection
    Execute Javascript    window.navigator.onLine = true
    Reload Page