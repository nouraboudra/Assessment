@echo off
echo ====================================
echo Todo App Robot Framework Test Suite
echo ====================================
echo.

REM Create results directory with timestamp
set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set RESULTS_DIR=results\%TIMESTAMP%
mkdir %RESULTS_DIR% 2>nul

REM Check if app is running
echo Checking if Todo app is running...
curl -s http://localhost:3000 >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Todo app is not running!
    echo Please start the app with: npm run dev
    exit /b 1
)
echo [OK] Todo app is running
echo.

REM Display menu
echo Select test suite to run:
echo 1. All Tests
echo 2. API Tests Only
echo 3. UI Tests Only
echo 4. E2E Tests Only
echo 5. Smoke Tests (Quick)
echo 6. Critical Tests Only
echo.

set /p choice="Enter your choice (1-6): "

REM Set test command based on choice
if "%choice%"=="1" (
    set TEST_CMD=tests/
    echo Running all tests...
) else if "%choice%"=="2" (
    set TEST_CMD=tests/api/
    echo Running API tests...
) else if "%choice%"=="3" (
    set TEST_CMD=tests/ui/
    echo Running UI tests...
) else if "%choice%"=="4" (
    set TEST_CMD=tests/e2e/
    echo Running E2E tests...
) else if "%choice%"=="5" (
    set TEST_CMD=--include Smoke tests/
    echo Running Smoke tests...
) else if "%choice%"=="6" (
    set TEST_CMD=--include Critical tests/
    echo Running Critical tests...
) else (
    echo Invalid choice!
    exit /b 1
)

echo.
echo Starting test execution...
echo Results will be saved to: %RESULTS_DIR%
echo.

REM Run Robot Framework tests
robot ^
    --outputdir %RESULTS_DIR% ^
    --report report.html ^
    --log log.html ^
    --xunit xunit.xml ^
    --loglevel INFO ^
    --variable BROWSER:chrome ^
    %TEST_CMD%

REM Check test results
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ====================================
    echo ALL TESTS PASSED!
    echo ====================================
) else (
    echo.
    echo ====================================
    echo SOME TESTS FAILED!
    echo ====================================
)

echo.
echo Test reports available at:
echo - %RESULTS_DIR%\report.html
echo - %RESULTS_DIR%\log.html
echo.

REM Open report in browser
set /p open="Open report in browser? (y/n): "
if /i "%open%"=="y" start %RESULTS_DIR%\report.html

pause