*** Variables ***
# Application URLs
${BASE_URL}              http://localhost:3000
${API_URL}               http://localhost:3000/api
${LANDING_URL}           ${BASE_URL}/landing
${LOGIN_URL}             ${BASE_URL}/auth/login
${REGISTER_URL}          ${BASE_URL}/auth/register

# Browser Settings
${BROWSER}               chrome
${SELENIUM_TIMEOUT}      10 seconds
${IMPLICIT_WAIT}         5 seconds

# Test Users
${TEST_USER}             robottest_${TIMESTAMP}
${TEST_PASSWORD}         Test123!
${TEST_EMAIL}            ${TEST_USER}@test.com
${TIMESTAMP}             ${EMPTY}

# UI Locators - Login/Register
${USERNAME_INPUT}        id=username
${PASSWORD_INPUT}        id=password
${CONFIRM_PASSWORD}      id=confirmPassword
${LOGIN_BUTTON}          xpath=//button[contains(text(),'LOGIN')]
${REGISTER_BUTTON}       xpath=//button[contains(text(),'REGISTER')]
${LOGIN_LINK}           xpath=//a[contains(text(),'Login')]
${REGISTER_LINK}        xpath=//a[contains(text(),'Register')]

# UI Locators - Todo Page
${TODO_INPUT}           xpath=//input[@placeholder='Add a new todo']
${TODO_LIST}            class=todo-list
${TODO_ITEM}            xpath=//div[@class='todo-item']
${ADD_TODO_BUTTON}      xpath=//button[contains(text(),'Add')]
${DARK_MODE_TOGGLE}     xpath=//button[contains(@class,'dark-mode-toggle')]
${LOGOUT_BUTTON}        xpath=//button[contains(text(),'Logout')]

# API Headers
&{DEFAULT_HEADERS}       Content-Type=application/json    Accept=application/json