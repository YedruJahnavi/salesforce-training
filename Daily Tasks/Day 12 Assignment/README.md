# Placement Management System

A Salesforce-based Placement Management System for managing students, jobs, applications, eligibility, and placement workflows.

## Project Overview

The Placement Management System provides a centralized Salesforce application for managing:

- Student profiles
- Job opportunities
- Student applications
- Eligibility information
- Application status and integration details
- Placement-related workflows

The project uses Salesforce metadata and source-driven development so that the application can be version-controlled, reviewed, tested, and deployed through Git and Salesforce CLI.

## Major Salesforce Components

### Custom Objects

- `Student__c` — stores student profile information.
- `Job__c` — stores job opportunity information.
- `Application__c` — stores student job applications and application status.

### Apex

The project contains Apex services/controllers for application processing, student profiles, eligible jobs, notifications, statistics, alumni processing, and candidate synchronization.

### Lightning Web Components

The project includes Lightning Web Components such as:

- `placementHome`
- `studentProfile`
- `eligibleJobs`
- `jobCard`
- `applicationCard`
- `myApplications`
- `statusBadge`
- `emptyState`

### Asynchronous Processing

The project includes Queueable Apex for candidate synchronization.

## Project Structure

```text
PlacementManagementSystem/
├── README.md
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           ├── lwc/
│           ├── objects/
│           └── triggers/
├── config/
├── scripts/
├── .gitignore
└── sfdx-project.json
````

## Prerequisites

Before working with the project, install and configure:

* Salesforce CLI
* Git
* VS Code with Salesforce Extension Pack
* Access to the Salesforce development/test org
* Appropriate Salesforce permissions

Verify the tools:

```bash
git --version
sf --version
```

## Clone the Repository

Clone the repository and move into the project directory:

```bash
git clone https://github.com/YedruJahnavi/PlacementManagementSystem.git
cd PlacementManagementSystem
```

## Authenticate Salesforce

Authenticate the Salesforce org using Salesforce CLI:

```bash
sf org login web --alias placement-dev
```

Verify the connected org:

```bash
sf org display --target-org placement-dev
```

Always verify the intended target org before retrieving or deploying metadata.

## Retrieve Metadata

Retrieve metadata from the Salesforce org into the local project.

Example:

```bash
sf project retrieve start --metadata CustomObject:Job__c --target-org placement-dev
```

Other project objects can be retrieved similarly:

```bash
sf project retrieve start --metadata CustomObject:Application__c --target-org placement-dev
sf project retrieve start --metadata CustomObject:Student__c --target-org placement-dev
```

After retrieval, review the generated source files under:

```text
force-app/main/default/
```

## Git Workflow

Use a feature branch for development:

```bash
git checkout -b feature/<feature-name>
```

Review changes:

```bash
git status
git diff
```

Stage changes:

```bash
git add .
```

Commit a logical change:

```bash
git commit -m "Describe the change"
```

Push the feature branch:

```bash
git push -u origin feature/<feature-name>
```

Create a Pull Request and complete code review before merging into `main`.

## Deployment Workflow

1. Authenticate the Salesforce org using Salesforce CLI and verify the intended target org alias.
2. Retrieve Salesforce metadata into the local project.
3. Review and commit metadata changes to Git.
4. Push the feature branch to GitHub.
5. Create a Pull Request and complete code review.
6. Run Apex tests before deployment and confirm that the tests pass.
7. Deploy the validated metadata to the target Salesforce org.
8. Verify that the deployed metadata is available and working correctly in the target org.

## Run Apex Tests

Run local Apex tests:

```bash
sf apex run test --target-org placement-dev --test-level RunLocalTests
```

For synchronous results:

```bash
sf apex run test --target-org placement-dev --test-level RunLocalTests --synchronous
```

Review the test results before deployment.

## Deploy Metadata

Deploy the project metadata to the target Salesforce org:

```bash
sf project deploy start --source-dir force-app/main/default --target-org placement-dev
```

For a validation-only deployment, use the appropriate Salesforce CLI validation options before a production deployment.

## Verify After Deployment

After deployment:

1. Confirm the deployment completed successfully.
2. Open the target Salesforce org.
3. Verify the required objects, fields, Apex classes, triggers, and LWCs.
4. Test the relevant business workflow manually.
5. Confirm that Apex tests completed successfully.

Open the org with:

```bash
sf org open --target-org placement-dev
```

## Troubleshooting

### 1. Authentication Failure

If Salesforce CLI cannot connect to the org, authenticate again:

```bash
sf org login web --alias placement-dev
```

Then verify:

```bash
sf org display --target-org placement-dev
```

### 2. Missing Metadata Dependency

A deployment can fail when a component depends on metadata that is missing from the target org.

Check the relevant objects, fields, Apex classes, LWCs, triggers, and other dependencies before deploying.

### 3. Apex Test Failure

Run the tests and inspect the failed test results:

```bash
sf apex run test --target-org placement-dev --test-level RunLocalTests --synchronous
```

Fix the failing code or test before deployment.

### 4. Git Merge Conflict

If Git reports a conflict:

```bash
git status
```

Open the conflicted file, understand both changes, resolve the conflict, then:

```bash
git add <file>
git commit
```

Do not blindly choose `ours` or `theirs`; understand which behavior is correct.

### 5. Deployment Error

Review the Salesforce CLI deployment output and identify the failed metadata component. Check dependencies, permissions, configuration, and test failures before retrying.

## Development and Deployment Principles

* The Salesforce org is an environment; the Git repository is the record of development.
* Keep source code and metadata under version control.
* Separate code, metadata, and business data.
* Use feature branches for isolated changes.
* Review changes through Pull Requests.
* Test before deployment.
* Always verify the target Salesforce org.
* Think about metadata dependencies during deployment.
* Verify the target org after deployment.

## Deployment Environment Model

A typical controlled workflow can be:

```text
Developer
   ↓
Git Feature Branch
   ↓
Pull Request
   ↓
Code Review
   ↓
Tests
   ↓
Developer / QA Environment
   ↓
UAT
   ↓
Production
```

## Salesforce Deployment Approaches

| Approach       | Best understood as                                         |
| -------------- | ---------------------------------------------------------- |
| Salesforce CLI | Developer-oriented command-line workflow                   |
| Metadata API   | Programmatic metadata deployment/retrieval mechanism       |
| Changesets     | Salesforce-native metadata movement between related orgs   |
| Scratch Orgs   | Temporary source-driven development environments           |
| Sandboxes      | Longer-lived environments for development, testing, or UAT |

## Repository Workflow

```text
Working Files
     ↓
git add
     ↓
Staging Area
     ↓
git commit
     ↓
Local Repository
     ↓
git push
     ↓
Remote Repository
     ↓
Pull Request
     ↓
Code Review
     ↓
Testing
     ↓
Merge
     ↓
Deployment
     ↓
Verification

```
## Author

**Jahnavi Yedru**

B.Tech – Computer Science and Engineering  
Vishnu Institute of Technology

This version follows the Chapter 12 requirement that the README cover **Prerequisites, Clone, Authenticate, Deploy, Test, Verify, and Troubleshooting with at least three common problems**. :contentReference[oaicite:0]{index=0}
```
