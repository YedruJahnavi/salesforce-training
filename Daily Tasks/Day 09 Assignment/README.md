# Sprint 09 – Student Placement Portal

## Overview

Sprint 09 focuses on building an interactive **Student Placement Portal** using Lightning Web Components (LWC).

The main goal is to move from simply displaying eligible jobs to allowing students to **apply for jobs** through a complete business workflow.

The application follows this flow:

```text
Student
   ↓
Lightning Web Component
   ↓
Apex Controller
   ↓
Application Service
   ↓
Business Rules
   ↓
Salesforce Data
```

## Business Problem

Students can view eligible placement opportunities, but viewing an opportunity is not enough. The student should be able to apply for a job and immediately understand whether the application was successful or unsuccessful.

This project solves that problem by providing an interactive Apply workflow with:

* Apply button
* User event handling
* Imperative Apex
* Application service processing
* Eligibility validation
* Duplicate application handling
* Loading/processing feedback
* Success and failure messages
* UI refresh after data changes

## Features

### 1. Eligible Jobs

Students can view eligible job opportunities containing:

* Company
* Role
* Package
* Location
* Deadline

### 2. Apply Workflow

When the student clicks **Apply**:

```text
Apply Button
    ↓
Event Handler
    ↓
Imperative Apex
    ↓
Application Service
    ↓
Retrieve Student
    ↓
Retrieve Job
    ↓
Check Duplicate
    ↓
Validate Eligibility
    ↓
Create Application
    ↓
Return Result
    ↓
Update Screen
```

### 3. Application States

#### Ready

```text
[ APPLY ]
```

#### Processing

```text
[ SUBMITTING... ]
```

#### Success

```text
✓ APPLICATION SUBMITTED
```

#### Failure

```text
Application could not be submitted.
<Useful explanation>
```

## Component Architecture

```text
eligibleJobs
    ↓
jobCard
```

### `eligibleJobs`

Responsible for:

* Retrieving jobs
* Maintaining overall state
* Handling refresh
* Coordinating application actions

### `jobCard`

Responsible for:

* Displaying one job
* Presenting job information
* Capturing user interaction
* Communicating relevant events

## Component Communication

### Parent → Child

The parent passes job information to the child using `@api`.

```javascript
import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {
    @api job;
}
```

### Child → Parent

The child communicates user actions using a custom event.

```javascript
const event = new CustomEvent('apply', {
    detail: {
        jobId: this.job.Id
    }
});

this.dispatchEvent(event);
```

The parent listens for the event:

```html
<c-job-card
    job={job}
    onapply={handleApply}>
</c-job-card>
```

## Data Flow

```text
Student
   ↓
Lightning Web Component
   ↓
Apex Controller
   ↓
Application Service
   ↓
SOQL / DML
   ↓
Salesforce Database
   ↓
Trigger
   ↓
Trigger Handler
   ↓
Business Services
   ↓
Queueable / Other Async Work
```

## Imperative Apex

The Apply action is an explicit user-driven operation, so an imperative Apex call is used.

```apex
@AuraEnabled
public static Id submitApplication(Id jobId) {
    return ApplicationService.submitApplication(jobId);
}
```

JavaScript:

```javascript
import submitApplication
    from '@salesforce/apex/ApplicationController.submitApplication';

async handleApply(event) {
    const jobId = event.target.dataset.jobId;

    try {
        const applicationId = await submitApplication({
            jobId: jobId
        });

        // Success
    } catch (error) {
        // Failure
    }
}
```

### Engineering Principle

> **The UI Requests. The Business Layer Decides.**

Eligibility rules should not be duplicated in JavaScript. They should remain in the business layer so they can be reused by multiple entry points.

## Preventing Duplicate Applications

The backend protects data integrity, while the frontend protects the user experience.

```text
Before Click
[ APPLY ]

After Click
[ PROCESSING... ]
```

This prevents repeated accidental clicks while the request is being processed.

## Error Handling

Possible failures include:

* Deadline expiration
* Duplicate application
* Eligibility changes
* Server errors
* Network problems

Technical errors should not be directly shown to students.

Instead, display useful messages such as:

```text
Applications for this job are now closed.
```

```text
You have already applied for this opportunity.
```

```text
We could not submit your application.
Please try again or contact the Placement Office.
```

## Refreshing the Interface

After a successful application, the database changes. The UI should also reflect the updated state.

After a mutation, consider:

* Which displayed data became stale?
* Which component owns the data?
* Which data source needs refreshing?
* Which dependent component needs to know about the change?

## Student Journey

```text
Open Placement Portal
        ↓
View Eligible Jobs
        ↓
Select Opportunity
        ↓
View Details
        ↓
Click Apply
        ↓
See Processing State
        ↓
Backend Validates
        ↓
Application Saved
        ↓
Automation Executes
        ↓
Background Work Begins
        ↓
UI Refreshes
        ↓
Student Sees Confirmation
```

## Project Components

### Student Summary

Displays:

* Name
* Branch
* CGPA
* Placement Status

### Eligible Jobs

Displays:

* Company
* Role
* Package
* Location
* Deadline

### Job Card

Allows:

* View Details
* Apply

### My Applications

Displays:

* Company
* Role
* Application Status
* Interview Status

### Offer Summary

Displays:

* Accepted offers
* Active offers

## Engineering Decisions

### 1. Keep Eligibility Rules in Apex

Eligibility rules remain in the business layer instead of being duplicated in JavaScript.

### 2. Separate the Job Card

The Job Card is separated into a child component because it represents an independent UI responsibility.

### 3. Use Imperative Apex for Apply

The Apply action starts from an explicit user action, so an imperative Apex call provides explicit control over execution.

### 4. Protect Against Repeated Clicks

The frontend provides processing feedback and prevents unnecessary repeated requests.

### 5. Separate User Errors from Developer Errors

Students receive meaningful business messages, while technical information can be used by developers for debugging.

## Debugging Approach

If clicking **Apply** produces no visible result, investigate systematically:

1. Did the click event occur?
2. Did the handler execute?
3. Was the correct Job Id received?
4. Was Apex called?
5. Did Apex return success or failure?
6. Did the component state change?
7. Did the template reflect that state?

> **Do not guess. Follow the data.**

## Repository Structure

```text
Sprint-09-LWC
│
├── README.md
├── architecture/
├── force-app/
├── screenshots/
└── learning-notes/
```

## Screenshots

Add screenshots for:

```text
screenshots/eligible-jobs.png
screenshots/loading-state.png
screenshots/application-success.png
screenshots/error-state.png
```

## Challenges Faced

One important debugging challenge is ensuring that the Apply action produces a visible result and that the UI remains consistent with the backend after the application is submitted.

The debugging flow is:

```text
Click Event
   ↓
Handler
   ↓
Job Id
   ↓
Apex
   ↓
Service
   ↓
Database
   ↓
Result
   ↓
Component State
   ↓
Template
```

## Learning

This sprint demonstrated that building an LWC is not only about writing HTML and JavaScript.

Key learnings include:

* Designing LWC around user capabilities
* Using HTML for presentation
* Using JavaScript for component behavior
* Responding to user events
* Using imperative Apex for explicit actions
* Keeping business rules outside the UI
* Handling loading, success, empty, and error states
* Preventing repeated submissions
* Dividing interfaces into parent and child components
* Passing data from parent to child
* Communicating from child to parent using events
* Thinking about stale data after mutations
* Tracing a request from the browser to the database and back

## Sprint Summary

Sprint 09 transformed the Placement Management System from an interface that only displays opportunities into an interactive application that students can actually use.

> **Build interfaces that are simple because the architecture underneath them is strong — not because the business rules have been ignored.**

---

**Author:** Jahnavi Yedru
