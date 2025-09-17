*** Settings ***
Documentation    API Tests for Authentication Endpoints
Library          RequestsLibrary
Library          JSONLibrary
Library          String
Resource         ../../resources/variables/config.robot
Resource         ../../resources/keywords/common.robot

*** Test Cases ***
Test User Registration API Success
    [Documentation]    Test successful user registration via API
    [Tags]    API    Auth    Smoke    Critical

    ${username}=    Generate Random String    10    [LETTERS]
    ${user_data}=    Create Dictionary
    ...    username=${username}
    ...    password=Test123!
    ...    confirmPassword=Test123!

    ${response}=    POST    ${API_URL}/auth/register
    ...    json=${user_data}
    ...    headers=${DEFAULT_HEADERS}

    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    message
    Should Contain    ${response.json()['message']}    success

Test User Registration API Duplicate Username
    [Documentation]    Test registration with existing username
    [Tags]    API    Auth    Negative

    # First registration
    ${username}=    Generate Random String    10    [LETTERS]
    ${user_data}=    Create Dictionary
    ...    username=${username}
    ...    password=Test123!
    ...    confirmPassword=Test123!

    POST    ${API_URL}/auth/register    json=${user_data}

    # Try to register again with same username
    ${response}=    POST    ${API_URL}/auth/register
    ...    json=${user_data}
    ...    expected_status=400

    Should Contain    ${response.json()['error']}    already exists

Test User Login API Success
    [Documentation]    Test successful user login
    [Tags]    API    Auth    Smoke    Critical

    # Register user first
    ${username}=    Generate Random String    10    [LETTERS]
    ${register_data}=    Create Dictionary
    ...    username=${username}
    ...    password=Test123!
    ...    confirmPassword=Test123!

    POST    ${API_URL}/auth/register    json=${register_data}

    # Login
    ${login_data}=    Create Dictionary
    ...    username=${username}
    ...    password=Test123!

    ${response}=    POST    ${API_URL}/auth/login
    ...    json=${login_data}

    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token
    Should Not Be Empty    ${response.json()['token']}

Test User Login API Invalid Credentials
    [Documentation]    Test login with wrong password
    [Tags]    API    Auth    Negative

    ${login_data}=    Create Dictionary
    ...    username=nonexistentuser
    ...    password=WrongPass123!

    ${response}=    POST    ${API_URL}/auth/login
    ...    json=${login_data}
    ...    expected_status=401

    Should Contain    ${response.json()['error']}    Invalid

Test Registration API Required Fields
    [Documentation]    Test registration without required fields
    [Tags]    API    Auth    Negative

    # Missing password
    ${user_data}=    Create Dictionary    username=testuser
    ${response}=    POST    ${API_URL}/auth/register
    ...    json=${user_data}
    ...    expected_status=400

    Should Contain    ${response.json()['error']}    required

Test Password Mismatch Registration
    [Documentation]    Test registration with mismatched passwords
    [Tags]    API    Auth    Negative

    ${user_data}=    Create Dictionary
    ...    username=testuser
    ...    password=Test123!
    ...    confirmPassword=Different123!

    ${response}=    POST    ${API_URL}/auth/register
    ...    json=${user_data}
    ...    expected_status=400

    Should Contain    ${response.json()['error']}    match