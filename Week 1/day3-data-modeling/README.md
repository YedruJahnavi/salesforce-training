# Day 3 Data Modeling

## Goal for Day 3
- Objects, Fields, and Records
- Standard vs Custom Objects
- Relationships in Salesforce
- Formula Fields
- Validation Rules
- Importance of structured enterprise data

---

# Difference Between App, Object, Record, and Field

| Component | Explanation |
|-----------|-------------|
| App | A collection of tabs, objects, and features designed for a business purpose |
| Object | A database table used to store information |
| Record | A single entry inside an object |
| Field | A column that stores specific information inside a record |

### Example

Object = Student  
Record = Jahnavi Yedru  
Fields = Name, Roll Number, Email, Branch

---

# Standard vs Custom Objects

| Standard Objects | Custom Objects |
|-----------------|----------------|
| Provided by Salesforce by default | Created by users based on business needs |
| Examples: Account, Contact, Opportunity | Examples: Student, Faculty, Course |
| Used in common CRM processes | Used for organization-specific applications |

---

# My College Management System Data Model

## App Name
College Management System

---

# Objects Used

## Standard Objects
- Account
- Contact

## Custom Objects
- Student
- Faculty
- Course
- Department

---

# Relationships Between Objects

| Parent Object | Child Object | Relationship Type |
|---------------|-------------|-------------------|
| Department | Faculty | Lookup |
| Department | Course | Lookup |
| Course | Student | Lookup |
| Faculty | Course | Lookup |

---
