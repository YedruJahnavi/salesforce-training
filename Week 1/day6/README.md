# Day 6 - Triggers & SOQL

## 1. What is SOQL?

SOQL stands for **Salesforce Object Query Language**.

It is used to retrieve data from Salesforce objects such as:
- Account
- Contact
- Opportunity
- Custom Objects

SOQL is similar to SQL, but it is specially designed for Salesforce data.

### Example

```sql
SELECT Id, Name, Industry
FROM Account
WHERE Industry = 'Technology'
```

This query retrieves:
- Account Id
- Account Name
- Industry

from the Account object where Industry is Technology.

---

# 2. What is an Apex Trigger?

An Apex Trigger is a piece of Apex code that executes automatically when records are changed in Salesforce.

Triggers run:
- Before or after insert
- Before or after update
- Before or after delete
- After undelete

Triggers help automate business logic.

### Example

```apex
trigger AccountTrigger on Account (before insert) {
    for(Account acc : Trigger.new) {
        acc.Description = 'New Account Created';
    }
}
```

This trigger automatically sets a description before an Account record is inserted.

---

# 3. Differences

## Flow vs Trigger

| Flow | Trigger |
|------|----------|
| No-code/Low-code automation | Code-based automation |
| Built using Flow Builder | Written in Apex |
| Easy for admins | Requires programming knowledge |
| Best for simple automation | Best for complex logic |
| Slower for heavy processing | Faster and more powerful |
| Easier to maintain | More flexible |

---

## Before Trigger vs After Trigger

| Before Trigger | After Trigger |
|----------------|---------------|
| Executes before record is saved | Executes after record is saved |
| Used to update field values | Used for related records/actions |
| Faster because no extra save required | Record Id is available |
| Cannot access some system values | Can perform callouts and actions |

### Example Use
- Before Insert → Validate or update fields
- After Insert → Create related records

---

# 4. Trigger Use Cases (5 Examples)

## 1. Auto-create Opportunity
When a new Account is created, automatically create an Opportunity.

## 2. Validate Email Format
Prevent saving Contact records if email format is invalid.

## 3. Update Related Records
When an Opportunity is closed, update related Account status.

## 4. Send Notifications
Send notifications when high-priority Cases are created.

## 5. Prevent Record Deletion
Stop deletion of important Account records.

---

# 5. Query Examples (English Query Ideas)

## Example 1
Get all Accounts in the Technology industry.

```sql
SELECT Id, Name
FROM Account
WHERE Industry = 'Technology'
```

---

## Example 2
Get Contacts whose email contains 'gmail'.

```sql
SELECT Id, FirstName, LastName, Email
FROM Contact
WHERE Email LIKE '%gmail%'
```

---

## Example 3
Get Opportunities with amount greater than 50000.

```sql
SELECT Id, Name, Amount
FROM Opportunity
WHERE Amount > 50000
```

---

## Example 4
Get all Cases created today.

```sql
SELECT Id, CaseNumber, Subject
FROM Case
WHERE CreatedDate = TODAY
```

---

## Example 5
Get all Accounts with more than 100 employees.

```sql
SELECT Id, Name, NumberOfEmployees
FROM Account
WHERE NumberOfEmployees > 100
```

---

# 6. Reflection

## Why Enterprise Systems React Automatically to Data Changes

Enterprise systems handle huge amounts of business data every day. Manual monitoring is slow and inefficient. Automatic reactions help businesses work faster and smarter.

Triggers and automation help systems:
- Reduce manual work
- Improve accuracy
- Maintain data consistency
- Save time
- Respond in real time
- Improve customer experience

Examples:
- Automatically creating tasks
- Sending alerts
- Updating related records
- Processing orders instantly

This makes enterprise applications more scalable, efficient, and reliable.

---

