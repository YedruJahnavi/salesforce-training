# Placement Management System

A Salesforce-based Placement Management System that allows students to maintain their profiles, view eligible job opportunities, apply for jobs, and track their applications.

# Component Tree

The application follows a parent-child Lightning Web Component structure.

```text
PlacementHome
│
├── StudentProfile
│
├── EligibleJobs
│   │
│   └── JobCard
│
├── MyApplications
│   │
│   └── ApplicationCard
│       │
│       └── StatusBadge
│
└── EmptyState
````

### Component Responsibilities

### `placementHome`

The main parent component of the Placement Management System.

Responsibilities:

* Displays the placement portal dashboard.
* Displays student information.
* Contains the Student Profile component.
* Contains the Eligible Jobs component.
* Contains the My Applications component.
* Handles communication between child components.
* Updates application count and status.

### `studentProfile`

Responsible for displaying and updating student information.

Fields include:

* Student Name
* Phone Number
* Email
* Date of Birth
* Department
* CGPA

### `eligibleJobs`

Responsible for retrieving and displaying eligible jobs.

It receives job data from Apex and passes individual job records to `jobCard`.

### `jobCard`

Displays individual job information.

It displays:

* Job Name
* Company
* Location
* Minimum CGPA
* Salary
* Closing Date

It also provides:

* View Details
* Apply

functionality.

### `myApplications`

Displays applications submitted by the current student.

### `applicationCard`

Displays information about an individual application.

### `statusBadge`

Reusable component used to display application status such as:

* Applied
* Selected
* Rejected

### `emptyState`

Reusable component that displays a message when there are no eligible jobs.

---

# Communication

The application uses both **Parent → Child** and **Child → Parent** communication.

---

## Parent → Child

Parent-to-child communication is implemented using public properties with `@api`.

For example, `EligibleJobs` passes a job object to `JobCard`.

```html
<c-job-card
    key={job.Id}
    job={job}
    onapply={handleApply}>
</c-job-card>
```

The child component receives the job using:

```javascript
@api job;
```

This allows `JobCard` to display the information of the specific job passed by the parent.

### Parent calling a Child Method

The parent can also call a public method exposed by a child component.

For example:

```javascript
const jobsComponent =
    this.template.querySelector('c-eligible-jobs');

if (jobsComponent) {
    jobsComponent.refreshJobs();
}
```

This is used after the student profile is saved so that the eligible jobs can be refreshed.

---

## Child → Parent

Child-to-parent communication is implemented using **Custom Events**.

### Apply Event

When the student clicks Apply in `JobCard`, the component dispatches an event:

```javascript
const applyEvent = new CustomEvent('apply', {
    detail: {
        jobId: this.job.Id
    }
});

this.dispatchEvent(applyEvent);
```

The parent listens for the event:

```html
<c-job-card
    key={job.Id}
    job={job}
    onapply={handleApply}>
</c-job-card>
```

The parent then handles the application using:

```javascript
handleApply(event)
```

---

## View Details Event

The `JobCard` component sends the selected job ID to its parent using a custom event.

The parent receives it using:

```javascript
handleViewDetails(event) {

    const jobId = event.detail.jobId;

    // Find the selected job
}
```

This allows `PlacementHome` to display the selected job's details.

---

## Profile Saved Event

When the student saves the profile, `StudentProfile` sends a custom event to the parent.

The parent listens using:

```html
<c-student-profile
    onprofilesaved={handleProfileSaved}>
</c-student-profile>
```

The parent then refreshes the eligible jobs.

```javascript
handleProfileSaved() {

    const jobsComponent =
        this.template.querySelector('c-eligible-jobs');

    if (jobsComponent) {
        jobsComponent.refreshJobs();
    }
}
```

---

## Application Submitted Event

After a successful application, the child component communicates with the parent.

The parent:

* Updates the application status.
* Increases the application count.
* Refreshes My Applications.

```javascript
handleApplicationSubmitted(event) {

    this.status = 'Applied';

    this.applications =
        this.applications + 1;

    const myApplications =
        this.template.querySelector('c-my-applications');

    if (myApplications) {
        myApplications.refreshApplications();
    }
}
```

---

# Data Strategy

The application uses Apex, `@wire`, imperative Apex, and `refreshApex` according to the type of operation.

---

## LDS

Lightning Data Service is **not directly used** for the main job and application operations in this implementation.

The project uses Apex because the application requires custom business logic such as:

* CGPA eligibility checking
* Duplicate application checking
* Closing-date validation
* Finding the current student's profile
* Creating Application records
* Retrieving application history

Therefore, the main data operations are handled through Apex.

---

# Wire

The `@wire` mechanism is used for retrieving data reactively.

## Eligible Jobs

`EligibleJobs` uses:

```javascript
@wire(getEligibleJobs)
wiredJobs(result) {

    if (result.data) {

        this.jobs = result.data.map(job => {

            return {
                ...job,
                isSubmitting: false,
                isApplied: false,
                successMessage: '',
                errorMessage: ''
            };

        });

    } else if (result.error) {

        console.error(result.error);

        this.jobs = [];
    }
}
```

The Apex method is:

```apex
@AuraEnabled(cacheable=true)
public static List<Job__c> getEligibleJobs()
```

Wire is appropriate because the job information can be retrieved reactively and refreshed when the student's profile changes.

---

## My Applications

`MyApplications` also uses `@wire`:

```javascript
@wire(getMyApplications)
wiredApplications(result) {

    this.wiredApplicationsResult = result;

    if (result.data) {

        this.applications = result.data;

    } else if (result.error) {

        console.error(
            'Error loading applications:',
            result.error
        );

        this.applications = [];
    }
}
```

The wired result is stored so it can be refreshed later.

---

# Imperative Apex

Imperative Apex is used when an operation must happen because of a specific user action.

The Apply button calls:

```javascript
const applicationId =
    await submitApplication({
        jobId: jobId
    });
```

The Apex method:

```apex
@AuraEnabled
public static Id submitApplication(Id jobId)
```

performs the complete application process.

It:

1. Validates the Job ID.
2. Finds the selected job.
3. Checks whether the job is closed.
4. Finds the current student's profile.
5. Checks for duplicate applications.
6. Checks the student's CGPA.
7. Creates the Application record.
8. Returns the Application ID.

Imperative Apex is appropriate because the operation happens specifically when the student clicks the **Apply** button.

---

# refreshApex

`refreshApex` is used to refresh wired data after a successful operation.

In `MyApplications`:

```javascript
@api
async refreshApplications() {

    if (this.wiredApplicationsResult) {

        await refreshApex(
            this.wiredApplicationsResult
        );
    }
}
```

This allows the newly submitted application to appear in **My Applications** without requiring a complete page reload.

---

# Validation Strategy

The project uses both:

* Client-side validation
* Server-side validation

---

# Client Validation

Client-side validation is implemented using Lightning input components with required fields.

Required Student Profile fields include:

* Phone Number
* Email
* Department
* CGPA

For example:

```html
<lightning-input
    label="Department"
    required>
</lightning-input>
```

When a required field is empty, Salesforce displays:

```text
Complete this field.
```

This prevents incomplete profile data from being submitted through the user interface.

---

# Server Validation

Important business rules are validated in Apex.

This ensures that the rules cannot be bypassed by changing the client-side interface.

---

## Missing Job Validation

```apex
if (jobId == null) {

    throw new AuraHandledException(
        'Job is required.'
    );
}
```

---

## Closed Job Validation

The system checks whether the closing date has passed.

```apex
if (
    job.Closing_Date__c != null &&
    job.Closing_Date__c < Date.today()
) {

    throw new AuraHandledException(
        'Applications for this job are now closed.'
    );
}
```

---

## Duplicate Application Validation

The system checks whether the student has already applied for the same job.

```apex
if (!existingApplications.isEmpty()) {

    throw new AuraHandledException(
        'You have already applied for this opportunity.'
    );
}
```

This prevents the same student from submitting multiple applications for the same job.

---

## CGPA Validation

The student's CGPA is compared with the minimum CGPA required by the job.

```apex
if (
    student.CGPA__c == null ||
    student.CGPA__c < job.Minimum_CGPA__c
) {

    throw new AuraHandledException(
        'You do not meet the minimum CGPA requirement for this job.'
    );
}
```

This ensures that only students meeting the job requirements can submit applications.

---

# Reusability

The project contains multiple reusable Lightning Web Components.

---

## 1. JobCard

`JobCard` is a reusable component that displays one job.

It receives the job record using:

```javascript
@api job;
```

The same component is reused for every job displayed by `EligibleJobs`.

This avoids duplicating the job display markup.

---

## 2. ApplicationCard

`ApplicationCard` displays an individual application.

`MyApplications` can reuse the component for every application record.

This keeps application display logic separate and reusable.

---

## 3. StatusBadge

`StatusBadge` is reusable for displaying application statuses such as:

```text
Applied
Selected
Rejected
```

This provides consistent status presentation throughout the application.

---

## 4. EmptyState

`EmptyState` is a reusable component for situations where there is no data.

For example:

```text
No Eligible Jobs
There are currently no jobs matching your eligibility criteria.
```

The same component can be reused for other empty-data situations in the future.

---

# Debugging

One actual problem encountered during development was an error while deploying the `MyApplications` functionality.

The deployment initially failed with:

```text
Method does not exist or incorrect signature:
void getMyApplications()
from the type ApplicationService
```

Another error was:

```text
Unexpected token 'List'. (1:15)
```

The deployment also reported:

```text
Unable to find Apex action method referenced as
ApplicationController.getMyApplications
```

## Cause

The `getMyApplications()` method was not correctly defined inside `ApplicationService`.

`ApplicationController` was calling:

```apex
ApplicationService.getMyApplications();
```

but the corresponding method was missing or incorrectly positioned in the service class.

Therefore, Salesforce could not compile the Apex classes and could not expose the Apex method to the LWC.

---

## Solution

The method was correctly added inside `ApplicationService`:

```apex
public static List<Application__c> getMyApplications() {

    Student__c student;

    try {

        student = [
            SELECT Id
            FROM Student__c
            WHERE Email__c = :UserInfo.getUserEmail()
            LIMIT 1
        ];

    } catch (QueryException e) {

        return new List<Application__c>();
    }

    return [
        SELECT Id,
               Name,
               Status__c,
               Application_Date__c,
               Job__c,
               Job__r.Name,
               Job__r.Company__c,
               Job__r.Location__c
        FROM Application__c
        WHERE Student__c = :student.Id
        ORDER BY Application_Date__c DESC
    ];
}
```

Then it was exposed through `ApplicationController`:

```apex
@AuraEnabled(cacheable=true)
public static List<Application__c> getMyApplications() {

    return ApplicationService.getMyApplications();
}
```

After correcting the class structure, the project was deployed again successfully.

The final deployment returned:

```text
Status: Succeeded
```

---

# Architectural Decision

One important architectural decision was separating **Controllers** from **Services**.

Instead of placing all business logic inside the controller, the project uses:

```text
ApplicationController
        │
        ▼
ApplicationService
        │
        ▼
Salesforce Objects
```

## Controller Layer

`ApplicationController` acts as the interface between the Lightning Web Components and Apex business logic.

For example:

```apex
@AuraEnabled
public static Id submitApplication(Id jobId) {

    return ApplicationService.submitApplication(jobId);
}
```

---

## Service Layer

`ApplicationService` contains the actual application business logic.

It handles:

* Job validation
* Closing-date validation
* Student lookup
* Duplicate application checking
* CGPA validation
* Application creation
* Application retrieval

This separation keeps the controller lightweight.

---

## Why this decision improved the design

Separating the Controller and Service layers:

* Keeps controllers simple.
* Keeps business logic centralized.
* Makes the code easier to maintain.
* Makes the business logic reusable.
* Makes future testing easier.
* Prevents the LWC-facing controller from becoming too large.

---

# Apex Architecture

```text
Lightning Web Components
          │
          ▼
   Apex Controllers
          │
          ▼
   Apex Services
          │
          ▼
     SOQL / DML
          │
          ▼
 Salesforce Objects
```

Main Apex classes include:

```text
AlumniService
ApplicationController
ApplicationService
EligibleJobsController
NotificationService
StatisticsService
```

---

# Application Flow

## Student Profile Flow

```text
Student
   ↓
StudentProfile
   ↓
Save Profile
   ↓
Apex
   ↓
Student__c
   ↓
Profile Saved Event
   ↓
EligibleJobs Refresh
```

---

## Job Eligibility Flow

```text
Student CGPA
      ↓
EligibleJobs
      ↓
Apex
      ↓
Job__c records
      ↓
Eligibility filtering
      ↓
JobCard
```

---

## Application Flow

```text
Student
   ↓
Click Apply
   ↓
JobCard
   ↓
Custom Event
   ↓
EligibleJobs
   ↓
Imperative Apex
   ↓
ApplicationController
   ↓
ApplicationService
   ↓
Validation
   ├── Job exists
   ├── Job not closed
   ├── Student exists
   ├── No duplicate application
   └── CGPA requirement
   ↓
Application__c
   ↓
Application Submitted Event
   ↓
PlacementHome
   ↓
MyApplications Refresh
```
---

# Technology Stack

* Salesforce Platform
* Apex
* Lightning Web Components (LWC)
* SOQL
* JavaScript
* HTML
* Salesforce CLI
* Visual Studio Code
* Lightning Design System (SLDS)

---

# Conclusion

The Placement Management System provides a Salesforce-based solution for managing student placement activities.

The application allows students to:

* Maintain their profile.
* View jobs based on eligibility.
* View job details.
* Apply for suitable opportunities.
* Prevent duplicate applications.
* Prevent applications to closed jobs.
* Track submitted applications.
* View application statuses.

The project follows a component-based LWC architecture, uses Apex for business logic, implements both client-side and server-side validation, and uses reusable components to improve maintainability.

```
## Author

**Name:** Jahnavi Yedru  
**Department:** Computer Science and Engineering  
**Institution:** Vishnu Institute of Technology
