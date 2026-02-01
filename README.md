# API Test Automation Framework

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Postman](https://img.shields.io/badge/Postman-Collections-orange.svg)](https://www.postman.com/)
[![Newman](https://img.shields.io/badge/Newman-CLI-blue.svg)](https://www.npmjs.com/package/newman)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive API test automation framework built with Postman and Newman, with full test coverage, CI/CD integration, data-driven testing and detailed reporting.

### AI-Assisted Development

This project leverages AI tools to enhance documentation quality and optimize framework configuration. The comprehensive README, setup guides and troubleshooting documentation were created with AI assistance to ensure clarity, consistency and professional standards.

Core test strategy, architecture decisions and quality standards remain human-driven.


## Table of Contents

- [Overview](#-overview)
- [Tech Stack](#-tech-stack)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Local Development Setup](#-local-development-setup)
- [Test Execution](#-test-execution)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Test Coverage](#-test-coverage)
- [Reports](#-reports)
- [Contributing](#-contributing)
- [License](#-license)
- [Author](#-author)

## Overview

- **4 Comprehensive Test Collections** covering CRUD operations, workflows, E2E journeys and negative scenarios
- **Multi-Environment Support** (DEV, QA, PROD)
- **Data-Driven Testing** with CSV and JSON data files
- **Automated CI/CD Pipeline** with GitHub Actions
- **Detailed HTML Reports** using newman-reporter-htmlextra
- **Security Testing** including SQL injection and XSS prevention tests

### APIs Under Test

| API | Purpose | Documentation |
|-----|---------|---------------|
| **GoRest** | Primary API for user, post, comment and todo management | [gorest.co.in](https://gorest.co.in/) |
| **JSONPlaceholder** | Secondary API for integration testing | [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com/) |
| **ReqRes** | Secondary API for authentication testing | [reqres.in](https://reqres.in/) |

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Postman** | API testing platform |
| **Newman** | Command-line collection runner for Postman |
| **newman-reporter-htmlextra** | Enhanced HTML report generation |
| **Node.js 18+** | JavaScript runtime |
| **GitHub Actions** | CI/CD automation |
| **Bash** | Shell scripting for test execution |

## Features

### Test Design
- **CRUD Operations** - Complete Create, Read, Update, Delete testing
- **Request Chaining** - Dynamic data passing between requests
- **Schema Validation** - JSON schema validation for responses
- **Performance Testing** - Response time assertions
- **Negative Testing** - Error handling and edge cases
- **Security Testing** - SQL injection and XSS prevention

### Framework Features
- **Multi-Environment** - DEV, QA, PROD configurations
- **Data-Driven Testing** - CSV and JSON data files
- **Dynamic Variables** - Faker-like random data generation
- **Detailed Logging** - Comprehensive console output
- **HTML Reports** - Beautiful, detailed test reports
- **CI/CD Ready** - GitHub Actions workflow included

## Project Structure

```
api-test-automation-postman-newman/
├── .github/
│   └── workflows/
│       └── api-tests.yml          # GitHub Actions CI/CD pipeline
├── collections/
│   ├── GoRest_UserManagement.postman_collection.json
│   ├── GoRest_PostsAndComments.postman_collection.json
│   ├── E2E_UserJourney.postman_collection.json
│   └── NegativeScenarios.postman_collection.json
├── environments/
│   ├── DEV.postman_environment.json
│   ├── QA.postman_environment.json
│   ├── PROD.postman_environment.json
│   └── LOCAL.postman_environment.json  # Generated locally (gitignored)
├── data/
│   ├── test-data.csv              # Data-driven test data
│   └── users.json                 # Batch testing data
├── reports/                       # Generated test reports (gitignored)
├── scripts/
│   └── inject-secrets.sh          # Local environment setup script
├── .env                           # Local secrets (gitignored)
├── .env.example                   # Environment template
├── .gitignore
├── package.json
├── LICENSE
└── README.md
```

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download](https://nodejs.org/)
- **Git** - [Download](https://git-scm.com/)
- **GoRest Token** - [Get Token](https://gorest.co.in/consumer/login)
- **ReqRes API-Key** - [Get Key](https://reqres.in/)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/priyanka-r-arora/api-test-automation-postman-newman.git
cd api-test-automation-postman-newman
```

### 2. Install Dependencies

```bash
npm install
```

#### Local Development Setup

The framework uses an industry-standard pattern with separate commands for local development (`local:*`) and CI/CD (`test:*`). 

### One-Time Setup

#### 1. Create your `.env` file

```bash
cp .env.example .env
```

#### 2. Add your actual tokens to `.env`

Edit `.env` and add your credentials for DEV env:

```bash
GOREST_AUTH_TOKEN=your_actual_gorest_token_here
REQRES_API_KEY=your_actual_reqres_key_here
```

**Important:**
- Get GoRest token from [gorest.co.in](https://gorest.co.in/consumer/login)
- Get ReqRes key from [reqres.in](https://reqres.in/)
- Don't use quotes around values
- Never commit `.env` file to git

#### 3. Run local setup

This creates a `LOCAL.postman_environment.json` file with your credentials:

```bash
npm run local:setup
```

### Running Tests Locally

Once setup is complete, run tests using `local:*` commands:

```bash
# Run smoke tests
npm run local:smoke

# Run all test collections
npm run local:all

# Run specific collections
npm run local:users       # User management tests
npm run local:posts       # Posts & comments tests
npm run local:e2e         # E2E journey tests
npm run local:negative    # Negative scenarios
npm run local:data-driven # Data-driven tests with CSV
```

### How It Works

1. **local:setup** - Runs `inject-secrets.sh` script that:
   - Loads credentials from `.env` file
   - Copies `DEV.postman_environment.json` to `LOCAL.postman_environment.json`
   - Injects actual credentials into the LOCAL environment file

2. **local:*** commands - Wraps test commands with `dotenv-cli`:
   - Automatically loads environment variables from `.env`
   - Passes them to Newman for test execution
   - Uses `LOCAL.postman_environment.json` as the environment

3. **test:*** commands - Direct Newman execution (used by CI/CD):
   - Uses environment variable `TEST_ENV` to select environment
   - Defaults to `LOCAL` for local runs
   - CI/CD sets `TEST_ENV` to DEV/QA/PROD

### Troubleshooting Local Setup

**"GOREST_AUTH_TOKEN is not set"**
- Ensure `.env` file exists in project root
- Check file has correct values: `cat .env`
- Run `npm run local:setup` again

**"No such file: environments/LOCAL.postman_environment.json"**
- Run `npm run local:setup` first
- Check if `inject-secrets.sh` is executable: `chmod +x scripts/inject-secrets.sh`

**Tests fail with 401 Unauthorized**
- Verify token is valid (not expired)
- Re-run `npm run local:setup` after updating `.env`

### 3. Configure API Token (For CI/CD)

For GitHub Actions, configure secrets in your repository settings:

1. Go to repository Settings → Secrets and variables → Actions
2. Add repository secrets or use GitHub Environments (DEV/QA/PROD)

| Secret | Description |
|--------|-------------|
| `GOREST_AUTH_TOKEN` | Your GoRest API authentication token |
| `REQRES_API_KEY` | Your ReqRes API key (optional) |

### 4. Make Scripts Executable (macOS/Linux)

```bash
chmod +x scripts/*.sh
```

### Test Execution

#### Local Development Commands

Use `local:*` commands for running tests on your local machine:

| Command | Description |
|---------|-------------|
| `npm run local:setup` | **One-time setup** - Create LOCAL environment with credentials |
| `npm run local:all` | Run all test collections |
| `npm run local:smoke` | Run smoke tests only |
| `npm run local:users` | Run User Management tests |
| `npm run local:posts` | Run Posts & Comments tests |
| `npm run local:e2e` | Run E2E Journey tests |
| `npm run local:negative` | Run Negative Scenario tests |
| `npm run local:data-driven` | Run data-driven tests with CSV |

### CI/CD Commands

These commands are used by GitHub Actions (can also be used locally with environment variables):

| Command | Description |
|---------|-------------|
| `npm run test:all` | Run all test collections |
| `npm run test:smoke` | Run smoke tests only |
| `npm run test:regression` | Run full regression suite |
| `npm run test:users` | Run User Management tests |
| `npm run test:posts` | Run Posts & Comments tests |
| `npm run test:e2e` | Run E2E Journey tests |
| `npm run test:negative` | Run Negative Scenario tests |
| `npm run test:data-driven` | Run data-driven tests with CSV |

### Utility Commands

| Command | Description |
|---------|-------------|
| `npm run report` | Open reports folder |
| `npm run clean` | Clean generated reports |

### Newman CLI (Advanced)

For advanced use cases, run Newman directly:

```bash
# Run a specific collection
npx newman run collections/GoRest_UserManagement.postman_collection.json \
    -e environments/QA.postman_environment.json \
    -r cli,htmlextra \
    --reporter-htmlextra-export reports/report.html

# Run with data file
npx newman run collections/GoRest_UserManagement.postman_collection.json \
    -e environments/QA.postman_environment.json \
    -d data/test-data.csv \
    -r htmlextra
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/api-tests.yml`) is fully integrated with the npm scripts.

### Workflow Features

- **Environment Selection**: Manual workflow dispatch allows choosing DEV/QA/PROD
- **Automated Triggers**: Push, Pull Request and scheduled runs
- **Secret Management**: Uses GitHub Environments for secure credential storage
- **HTML Reports**: Generated and available as artifacts

### Triggers
- **Push** to `main` or `feature/**` branches
- **Pull Requests** to `main`
- **Scheduled** runs daily at 2 AM UTC
- **Manual** workflow dispatch with environment selection


### GitHub Secrets Configuration

Configure secrets using GitHub Environments for better organization:

1. Go to: **Settings** → **Environments** → Create environments: `DEV`, `QA`, `PROD`
2. Add environment secrets to each:

| Secret | Description |
|--------|-------------|
| `GOREST_AUTH_TOKEN` | Your GoRest API authentication token |
| `REQRES_API_KEY` | Your ReqRes API key (optional) |

## Test Coverage

### Collection 1: User Management
| Test Scenario | Method | Assertions |
|---------------|--------|------------|
| Get All Users - Pagination | GET | Status, Schema, Headers |
| Get Single User | GET | Status, Schema, ID Match |
| Create User | POST | Status 201, Response Body |
| Update User (Full) | PUT | Status 200, Data Updated |
| Partial Update | PATCH | Status 200, Partial Update |
| Delete User | DELETE | Status 204, Cleanup |

### Collection 2: Posts & Comments Workflow
| Step | Action | Validation |
|------|--------|------------|
| 1 | Create User | User ID stored |
| 2 | Create Post | Linked to User |
| 3 | Add Comment | Linked to Post |
| 4 | Update Post | Content Updated |
| 5 | Get Comments | Comment Exists |
| 6-8 | Cleanup | Resources Deleted |

### Collection 3: E2E User Journey
- User Registration → Profile View → Profile Update → Content Creation → Task Management → Account Deactivation → Deletion

### Collection 4: Negative Scenarios
- Authentication Errors (Invalid/Missing/Empty Token)
- Validation Errors (Missing Fields, Invalid Formats)
- 404 Not Found (Non-existent Resources)
- Malformed Payloads (Invalid JSON)
- Security Testing (SQL Injection, XSS)
- Edge Cases (Long Names, Unicode, Null Values)

## Reports

### HTML Reports

After running tests, HTML reports are generated in the `reports/` directory:

```
reports/
├── smoke-test-report.html
├── user-management-report.html
├── posts-comments-report.html
├── e2e-journey-report.html
└── negative-scenarios-report.html
```

### Report Features
- Summary dashboard with pass/fail metrics
- Detailed request/response logs
- Response time graphs
- Failed test highlighting
- Search and filter capabilities

### Switching Environments

**Local Development:**
```bash
# Always uses LOCAL environment (auto-generated from .env)
npm run local:smoke
npm run local:all
```

**CI/CD:**
```bash
# Set TEST_ENV to choose environment
TEST_ENV=DEV npm run test:smoke
TEST_ENV=QA npm run test:all
TEST_ENV=PROD npm run test:regression
```

**Newman CLI:**
```bash
# Specify environment file directly
npx newman run collections/GoRest_UserManagement.postman_collection.json \
    -e environments/PROD.postman_environment.json
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Guidelines
- Follow existing code style and patterns
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Priyanka Arora**

- LinkedIn: [Priyanka Arora](https://linkedin.com/in/priyanka-r-arora)

---

## Acknowledgments

- [GoRest](https://gorest.co.in/) - Free REST API for testing
- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - Fake REST API
- [ReqRes](https://reqres.in/) - Test API for prototyping
- [Newman](https://www.npmjs.com/package/newman) - Postman CLI
- [newman-reporter-htmlextra](https://www.npmjs.com/package/newman-reporter-htmlextra) - Enhanced HTML reports

---

<p align="center">
  "Quality is not an act, it is a habit." - Aristotle
</p>
