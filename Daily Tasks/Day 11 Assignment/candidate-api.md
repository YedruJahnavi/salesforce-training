# Candidate Recruitment API Contract

## Endpoint

```text
callout:Recruitment_API/posts
````

## HTTP Method

POST

## Purpose

This API is used to send a selected candidate from Salesforce Placement Management System to the external recruitment system.

## Request Headers

```text
Content-Type: application/json
```

Authentication is handled through the Salesforce Named Credential:

```text
Recruitment_API
```

## Request JSON

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

## Response — Success

HTTP Status:

```text
200 OK
```

or

```text
201 Created
```

Example:

```json
{
    "id": 101,
    "title": "Candidate Created"
}
```

When a successful response is received:

```text
Integration Status = Sent
External Candidate Id = returned id
Integration Error = blank
```

## Response — Client Errors

### 400 Bad Request

```text
Integration Status = Failed
```

The response body is stored in:

```text
Integration Error
```

### 401 Unauthorized

```text
Integration Status = Failed
```

The authentication error is stored in:

```text
Integration Error
```

### 403 Forbidden

```text
Integration Status = Failed
```

The authorization error is stored in:

```text
Integration Error
```

## Response — Server Error

### 500 Internal Server Error

```text
Integration Status = Retry Required
```

The server error is stored in:

```text
Integration Error
```

## Unexpected Errors

Unexpected HTTP responses are recorded as:

```text
Integration Status = Failed
```

Unexpected Apex exceptions are recorded as:

```text
Integration Status = Retry Required
```

The exception message is stored in:

```text
Integration Error
```

## Retry Strategy

Only records marked:

```text
Retry Required
```

should be considered for retry.

Retry attempts should be controlled to avoid repeated or unlimited submissions.

The retry process should use the existing Application record and should not create a new Application record.

## Idempotency / Duplicate Prevention

The Salesforce field:

```text
External_Candidate_Id__c
```

is used to identify a candidate that has already been successfully synchronized.

The trigger checks whether:

```text
External_Candidate_Id__c
```

is blank before enqueueing the Queueable.

If the external candidate ID is already populated, the candidate is not submitted again.

This prevents duplicate candidate submissions.

## Salesforce Integration Fields

| Field                       | Purpose                                    |
| --------------------------- | ------------------------------------------ |
| Integration_Status__c       | Tracks integration state                   |
| External_Candidate_Id__c    | Stores external system candidate ID        |
| Integration_Error__c        | Stores error details                       |
| Last_Integration_Attempt__c | Stores the latest integration attempt time |

## Integration Flow

```text
Application Status = Selected
            ↓
Application Trigger
            ↓
Check External Candidate ID
            ↓
ID blank?
       ↙           ↘
     Yes            No
      ↓              ↓
Queueable        Do not submit
      ↓
HTTP POST
      ↓
External Recruitment API
      ↓
Process Response
      ↓
Update Integration Status
```

```
