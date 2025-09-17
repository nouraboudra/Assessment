*** Settings ***
Documentation    UI Tests for Todo Functionality
Library          SeleniumLibrary
Resource         ../../resources/keywords/common.robot
Resource         ../../resources/variables/config.robot
Test Setup       Setup Todo Test
Test Teardown    Close Browser

*** Keywords ***
Setup Todo Test
    Open Todo Application
    Click Link    REGISTER
    ${username}=    Generate Random String    10    [LETTERS]
    Register New User    ${username}    Test123!
    Set Test Variable    ${TEST_USERNAME}    ${username}

*** Test Cases ***
Test Add Todo Item
    [Documentation]    Test adding a new todo item
    [Tags]    UI    Todo    Smoke    Critical

    # Add todo
    ${todo_text}=    Set Variable    Buy groceries for dinner
    Input Text    ${TODO_INPUT}    ${todo_text}
    Press Keys    ${TODO_INPUT}    RETURN

    # Verify todo added
    Wait Until Page Contains    ${todo_text}
    ${count}=    Get Element Count    ${TODO_ITEM}
    Should Be Equal As Integers    ${count}    1

Test Add Multiple Todos
    [Documentation]    Test adding multiple todo items
    [Tags]    UI    Todo    Smoke

    # Add multiple todos
    @{todos}=    Create List    Task 1    Task 2    Task 3
    FOR    ${todo}    IN    @{todos}
        Input Text    ${TODO_INPUT}    ${todo}
        Press Keys    ${TODO_INPUT}    RETURN
        Wait Until Page Contains    ${todo}
    END

    # Verify all todos added
    ${count}=    Get Element Count    ${TODO_ITEM}
    Should Be Equal As Integers    ${count}    3

Test Mark Todo Complete
    [Documentation]    Test marking a todo as complete
    [Tags]    UI    Todo    Critical

    # Add a todo
    Input Text    ${TODO_INPUT}    Complete this task
    Press Keys    ${TODO_INPUT}    RETURN
    Wait Until Page Contains    Complete this task

    # Mark as complete
    ${checkbox}=    Get WebElement    xpath=//div[contains(text(),'Complete this task')]/..//input[@type='checkbox']
    Click Element    ${checkbox}

    # Verify completed style
    ${todo_element}=    Get WebElement    xpath=//div[contains(text(),'Complete this task')]
    ${class}=    Get Element Attribute    ${todo_element}    class
    Should Contain    ${class}    completed

Test Delete Todo
    [Documentation]    Test deleting a todo item
    [Tags]    UI    Todo    Critical

    # Add a todo
    Input Text    ${TODO_INPUT}    Task to delete
    Press Keys    ${TODO_INPUT}    RETURN
    Wait Until Page Contains    Task to delete

    # Delete todo
    ${delete_btn}=    Get WebElement    xpath=//div[contains(text(),'Task to delete')]/..//button[contains(@class,'delete')]
    Click Element    ${delete_btn}

    # Verify deleted
    Wait Until Page Does Not Contain    Task to delete

Test Edit Todo
    [Documentation]    Test editing a todo item
    [Tags]    UI    Todo

    # Add a todo
    Input Text    ${TODO_INPUT}    Original task
    Press Keys    ${TODO_INPUT}    RETURN
    Wait Until Page Contains    Original task

    # Double click to edit
    ${todo_text}=    Get WebElement    xpath=//div[contains(text(),'Original task')]
    Double Click Element    ${todo_text}

    # Edit the text
    ${edit_input}=    Get WebElement    xpath=//input[@class='edit-todo']
    Clear Element Text    ${edit_input}
    Input Text    ${edit_input}    Updated task
    Press Keys    ${edit_input}    RETURN

    # Verify updated
    Wait Until Page Contains    Updated task
    Page Should Not Contain    Original task

Test Todo Persistence After Refresh
    [Documentation]    Test that todos persist after page refresh
    [Tags]    UI    Todo    Integration

    # Add todos
    Input Text    ${TODO_INPUT}    Persistent task 1
    Press Keys    ${TODO_INPUT}    RETURN
    Input Text    ${TODO_INPUT}    Persistent task 2
    Press Keys    ${TODO_INPUT}    RETURN

    Wait Until Page Contains    Persistent task 1
    Wait Until Page Contains    Persistent task 2

    # Refresh page
    Reload Page

    # Verify todos still exist
    Wait Until Page Contains    Persistent task 1
    Wait Until Page Contains    Persistent task 2

Test Empty Todo Validation
    [Documentation]    Test that empty todos cannot be added
    [Tags]    UI    Todo    Negative

    # Try to add empty todo
    Input Text    ${TODO_INPUT}    ${SPACE}
    Press Keys    ${TODO_INPUT}    RETURN

    # Verify no todo added
    ${count}=    Get Element Count    ${TODO_ITEM}
    Should Be Equal As Integers    ${count}    0

Test Long Todo Text
    [Documentation]    Test adding todo with very long text
    [Tags]    UI    Todo    Edge

    ${long_text}=    Generate Random String    200    [LETTERS][NUMBERS]
    Input Text    ${TODO_INPUT}    ${long_text}
    Press Keys    ${TODO_INPUT}    RETURN

    # Verify todo added (might be truncated in display)
    Wait Until Page Contains Element    ${TODO_ITEM}

Test Dark Mode Toggle
    [Documentation]    Test dark mode functionality
    [Tags]    UI    Theme

    # Check initial mode
    ${body_class}=    Get Element Attribute    tag=body    class

    # Toggle dark mode
    Click Element    ${DARK_MODE_TOGGLE}

    # Verify mode changed
    Sleep    1s    # Wait for animation
    ${new_body_class}=    Get Element Attribute    tag=body    class
    Should Not Be Equal    ${body_class}    ${new_body_class}