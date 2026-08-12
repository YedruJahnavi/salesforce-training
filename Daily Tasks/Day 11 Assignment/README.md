# Placement Management System

## 1. Business Problem

The Placement Management System manages students, jobs, and job applications in Salesforce.

When a student's application status changes to **Selected**, the selected candidate must be synchronized with an external recruitment system.

The integration should:

- Automatically detect selected candidates.
- Send candidate information to the external recruitment system.
- Track the integration status.
- Store the external candidate ID.
- Record integration errors.
- Record the latest integration attempt.
- Avoid duplicate candidate submissions.
- Handle temporary external-system failures safely.

---

## 2. External System

The Placement Management System integrates with an external Recruitment API.

The API endpoint is configured through a Salesforce Named Credential:

```text
Recruitment_API
````

The Queueable Apex class uses the following endpoint:

```text
callout:Recruitment_API/posts
```

HTTP method:

```text
POST
```

The integration sends candidate information from Salesforce to the external recruitment system.

---

## 3. Data Flow

The integration follows this flow:

```text
Application Status Changes to Selected
                |
                v
       Application Trigger
                |
                v
    Check External Candidate ID
                |
          ID is blank?
          /          \
        Yes           No
         |             |
         v             v
  Queueable Apex    Do not submit
         |
         v
   Named Credential
         |
         v
    Recruitment API
         |
         v
   Process Response
         |
         v
Update Application Integration Fields
```

### Candidate Information Sent

The following information is sent to the external recruitment system:

* Student ID
* Student Name
* Email
* Department / Branch
* CGPA
* Job ID
* Company
* Job Role
* Selection Date

---

## 4. Authentication

Authentication and external endpoint configuration are handled through the Salesforce Named Credential:

```text
Recruitment_API
```

The Apex code does not directly store authentication credentials.

The Queueable Apex class references the Named Credential using:

```text
callout:Recruitment_API/posts
```

This keeps the external integration configuration separate from the Apex code.

---

## 5. Integration Pattern

The system uses an **asynchronous integration pattern**.

The Application Trigger does not perform the external HTTP callout directly.

Instead:

```text
Application Trigger
        |
        v
System.enqueueJob()
        |
        v
CandidateSyncQueueable
        |
        v
HTTP Callout
        |
        v
External Recruitment API
```

The Queueable class implements:

```text
Queueable
Database.AllowsCallouts
```

This allows the external HTTP callout to execute asynchronously.

---

## 6. Why Asynchronous Integration?

The integration uses asynchronous processing because the external API call should not block the main Salesforce transaction.

When the Application status changes to `Selected`, the trigger queues the synchronization job.

The Queueable then performs the external API call separately.

This provides separation between:

* Salesforce application processing
* External API communication

---

## 7. API Request

### Endpoint

```text
callout:Recruitment_API/posts
```

### Method

```text
POST
```

### Header

```text
Content-Type: application/json
```

### Example Request

```json
{
    "studentId": "a01XXXXXXXXXXXX",
    "name": "Test Student",
    "email": "test@example.com",
    "branch": "CSE",
    "cgpa": 8.5,
    "jobId": "a02XXXXXXXXXXXX",
    "company": "KSquare",
    "role": "Salesforce Developer",
    "selectionDate": "2026-08-12"
}
```

---

## 8. API Response Handling

The integration handles different HTTP responses.

### 200 OK / 201 Created

The candidate synchronization is considered successful.

The Application record is updated:

```text
Integration_Status__c = Sent
```

If the external system returns an ID, it is stored in:

```text
External_Candidate_Id__c
```

The integration error is cleared.

---

### 400 Bad Request

The Application is marked:

```text
Integration_Status__c = Failed
```

The API response is stored in:

```text
Integration_Error__c
```

---

### 401 Unauthorized

The Application is marked:

```text
Integration_Status__c = Failed
```

The authentication error is stored in:

```text
Integration_Error__c
```

---

### 403 Forbidden

The Application is marked:

```text
Integration_Status__c = Failed
```

The authorization error is stored in:

```text
Integration_Error__c
```

---

### 500 Internal Server Error

The Application is marked:

```text
Integration_Status__c = Retry Required
```

The external server error is stored in:

```text
Integration_Error__c
```

This status indicates that the failure may be temporary and the record can be considered for retry.

---

### Unexpected HTTP Response

Unexpected responses are recorded as:

```text
Integration_Status__c = Failed
```

The response status code and response body are stored in:

```text
Integration_Error__c
```

---

### Apex Exception

If an exception occurs while processing the callout, the Application is marked:

```text
Integration_Status__c = Retry Required
```

The exception message is stored in:

```text
Integration_Error__c
```

---

## 9. Integration Tracking Fields

The Application object contains the following integration fields:

| Field                         | Purpose                                                    |
| ----------------------------- | ---------------------------------------------------------- |
| `Integration_Status__c`       | Tracks the current integration state                       |
| `External_Candidate_Id__c`    | Stores the candidate ID returned by the external system    |
| `Integration_Error__c`        | Stores integration error information                       |
| `Last_Integration_Attempt__c` | Stores the date and time of the latest integration attempt |

---

## 10. Retry Strategy

Temporary external-system failures are represented by:

```text
Retry Required
```

This status is used for:

* HTTP 500 responses
* Apex exceptions during the integration

The record remains in Salesforce with its error information so that it can be considered for a later retry.

Retry processing should operate on the existing Application record rather than creating a new Application record.

Retry attempts should also be controlled to prevent unlimited repeated submissions.

---

## 11. Idempotency and Duplicate Prevention

The integration uses:

```text
External_Candidate_Id__c
```

to identify a candidate that has already been successfully synchronized.

Before submitting a candidate, the trigger checks whether the external candidate ID is already populated.

If:

```text
External_Candidate_Id__c
```

is already populated, the candidate should not be submitted again.

This prevents duplicate candidate submissions when an Application is changed to `Selected` again.

The existing Salesforce Application record remains the source record for the synchronization.

---

## 12. Trigger Behavior

The Application Trigger detects when an Application becomes:

```text
Selected
```

The trigger then queues:

```text
CandidateSyncQueueable
```

The Queueable receives the Application record ID and performs the external synchronization.

The trigger therefore remains lightweight and does not directly perform the HTTP callout.

---

## 13. Queueable Apex

The synchronization logic is implemented in:

```text
CandidateSyncQueueable.cls
```

The class implements:

```text
Queueable
Database.AllowsCallouts
```

Its responsibilities are:

1. Retrieve the Application and related Student and Job information.
2. Update the integration attempt timestamp.
3. Set the integration status to `Pending`.
4. Construct the candidate request.
5. Send the HTTP POST request.
6. Process the external API response.
7. Store the external candidate ID when successful.
8. Store errors when the integration fails.
9. Update the Application record.

---

## 14. Testing

The integration contains Apex test classes for the Queueable and Application Trigger.

### Queueable Test

```text
CandidateSyncQueueableTest
```

The test uses an:

```text
HttpCalloutMock
```

to simulate the external Recruitment API.

The successful synchronization test verifies:

* Integration status becomes `Sent`.
* External candidate ID is stored.
* Integration error is null.
* Last integration attempt is populated.

Error-handling scenarios are also tested.

---

### Trigger Test

```text
ApplicationTriggerTest
```

The trigger test verifies that changing an Application to:

```text
Selected
```

queues the candidate synchronization process.

The test also verifies that the candidate is synchronized successfully and that duplicate submissions are prevented.

---

## 15. Test Data

The tests create:

```text
Student__c
Job__c
Application__c
```

records and use an HTTP callout mock to simulate the external Recruitment API.

This allows the integration to be tested without making an actual external API request.

---

## 16. Project Components

Important project components include:

```text
force-app/
└── main/
    └── default/
        ├── classes/
        │   ├── CandidateSyncQueueable.cls
        │   ├── CandidateSyncQueueableTest.cls
        │   └── ApplicationTriggerTest.cls
        │
        └── triggers/
            └── ApplicationTrigger.trigger

candidate-api.md
README.md
```

---

## 17. Integration Summary

The complete integration works as follows:

```text
Student + Job
      |
      v
Application
      |
      v
Status = Selected
      |
      v
Application Trigger
      |
      v
CandidateSyncQueueable
      |
      v
Named Credential
      |
      v
Recruitment API
      |
      v
Process Response
      |
      +----------------------+
      |                      |
      v                      v
   Success                Failure
      |                      |
      v                      v
    Sent              Failed / Retry Required
      |
      v
External Candidate ID
stored in Salesforce
```

---

## 18. Key Design Decisions

### Asynchronous Processing

Queueable Apex is used for the external callout so that the Application transaction remains lightweight.

### Named Credential

The Named Credential manages the external endpoint and authentication configuration.

### Error Tracking

Integration errors are stored on the Application record instead of being lost after the transaction.

### Retry Required Status

Temporary failures are represented using:

```text
Retry Required
```

so they can be handled by a retry process.

### Duplicate Prevention

The external candidate ID is used to identify candidates that have already been synchronized.

---

## 19. Conclusion

The Placement Management System integrates Salesforce with an external Recruitment API using a trigger-driven asynchronous integration pattern.

When an Application becomes `Selected`, the system queues a Queueable Apex job. The Queueable sends candidate information to the external Recruitment API through a Named Credential and updates the Application with the result.

The integration also provides response handling, error tracking, retry identification, duplicate prevention, and automated Apex testing.

```
# Placement Management System

**Author:** Jahnavi Yedru
```
