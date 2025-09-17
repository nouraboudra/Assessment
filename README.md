Todo App - Robot Framework Test Suite
Overview
This test suite provides comprehensive automated testing for the Todo App using Robot Framework. It includes API tests, UI tests, and end-to-end scenarios.
Project Selection
Application: https://github.com/hoangsonww/ToDo-App-NextJS-Fullstack
This Next.js full-stack todo application was selected because:

Clean architecture with separate frontend and API layers
Real-time synchronization features (WebSocket testing)
Authentication system for security testing
CRUD operations for comprehensive functional testing
Modern tech stack representing real-world applications

Test Structure
todo-app-rf-tests/
├── tests/
│   ├── api/         # API endpoint tests
│   ├── ui/          # UI functionality tests
│   └── e2e/         # End-to-end workflows
├── resources/       # Shared resources
├── results/         # Test execution reports
└── libraries/       # Custom Python libraries
Prerequisites

Python 3.8+
Node.js 16+
Chrome browser
MongoDB (local or Atlas)

Installation

Install Python dependencies:

bashpip install -r requirements.txt

Download WebDriver:

bashwebdrivermanager chrome

Start the Todo App:

bashcd ToDo-App-NextJS-Fullstack
npm install
npm run dev
Running Tests
Windows:
batchrun_tests.bat
Command Line:
bash# Run all tests
robot tests/

# Run specific suite
robot tests/api/auth_api.robot

# Run by tags
robot --include Smoke tests/
robot --include Critical tests/
robot --exclude Slow tests/

# Run with custom output directory
robot --outputdir results/custom tests/
Test Coverage
1. Authentication Flow (Critical)

User registration (API & UI)
User login/logout
Session persistence
Input validation
Security testing

2. Todo CRUD Operations (Critical)

Create todos
Read/display todos
Update/edit todos
Delete todos
Mark complete/incomplete

3. Real-time Synchronization (Critical)

WebSocket connection
Multi-session sync
Data persistence
Conflict resolution

Test Categories

Smoke Tests: Quick validation of core functionality
Critical Tests: Must-pass scenarios
API Tests: Backend endpoint validation
UI Tests: Frontend functionality
E2E Tests: Complete user workflows
Negative Tests: Error handling and validation

Key Features Tested

Functional Testing

All CRUD operations
Authentication flows
Data persistence


Integration Testing

API-UI integration
Database operations
Session management


Security Testing

XSS prevention
Authentication bypass attempts
Session hijacking prevention


Performance Testing

Load testing with multiple todos
Response time validation
Resource usage monitoring


Usability Testing

Dark mode functionality
Responsive design
Error messaging



Test Execution Results
Results are saved in timestamped directories under results/:

report.html - High-level test report
log.html - Detailed execution log
output.xml - Raw results for CI/CD

CI/CD Integration
For Jenkins/GitHub Actions:
yaml- name: Run Robot Framework Tests
  run: |
    pip install -r requirements.txt
    robot --outputdir results tests/
Known Issues & Limitations

WebSocket tests may be flaky on slow connections
MongoDB must be running for full test execution
Chrome WebDriver must match browser version

Best Practices Implemented

Page Object Model: Separation of page elements
Keyword-Driven: Reusable keywords
Data-Driven: External test data
Tag Management: Organized test execution
Error Handling: Screenshot on failure
Cleanup: Proper teardown procedures

Troubleshooting
Issue: Tests fail to find elements
Solution: Check if app is running on correct port
Issue: WebDriver errors
Solution: Update ChromeDriver to match browser
Issue: Database connection errors
Solution: Verify MongoDB connection string in .env.local
Future Enhancements

Add API performance benchmarking
Implement visual regression testing
Add accessibility testing
Enhance mobile testing coverage
Add security penetration tests

Contact
For questions about this test suite, please refer to the test documentation or create an issue in the repository.