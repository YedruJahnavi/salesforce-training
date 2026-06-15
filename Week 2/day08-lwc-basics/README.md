# Day 8 - Lightning Web Components Basics (LWC)

## 1. What is LWC?

Lightning Web Components (LWC) is Salesforce's modern framework for building fast and reusable user interfaces using standard web technologies such as:

- HTML
- JavaScript
- CSS

LWC allows developers to create interactive and responsive applications on the Salesforce platform.

---

## 2. Why Salesforce Uses LWC

Salesforce uses LWC because it:

- Provides better performance
- Uses modern web standards
- Creates reusable components
- Improves user experience
- Reduces development time

Benefits:
- Faster page loading
- Easy maintenance
- Better scalability
- Mobile-friendly design

---

## 3. Your UI Screens

For the College Management System:

### Student Registration Screen
- Student Name
- Email
- Phone Number
- Course Selection
- Submit Button

### Course Management Screen
- Course Name
- Available Seats
- Instructor Details

### Student Dashboard
- Registered Courses
- Attendance Percentage
- Notifications

### Reports Dashboard
- Total Students
- Course Statistics
- Attendance Reports

---

## 4. Component Breakdown

### Student Registration Component
Handles student registration form submission.

### Course List Component
Displays available courses and seat availability.

### Student Dashboard Component
Shows student information and course details.

### Reports Component
Displays analytics and reports.

### Notification Component
Shows alerts and updates to users.

---

## 5. Frontend vs Backend Logic

| Frontend (LWC) | Backend (Salesforce) |
|----------------|----------------------|
| User Interface | Data Processing |
| Forms & Buttons | Apex Classes |
| Display Data | Triggers |
| User Interaction | Validation Rules |
| Responsive Design | Database Operations |

### Example

Frontend:
- Student fills registration form
- Clicks Submit button

Backend:
- Validation Rules check data
- Apex Trigger updates records
- Database stores information
- Flow sends confirmation email

---

## 6. Reflection

LWC helps developers create modern, fast, and user-friendly Salesforce applications. By separating frontend and backend logic, applications become easier to maintain, scalable, and efficient. Using reusable components improves development speed and provides a better experience for users.

---

## Revision Questions

### 1. What is a component?
A reusable part of a user interface.

### 2. Why are reusable components useful?
They save time and reduce duplicate work.

### 3. Difference between frontend and backend?
- Frontend: What users see.
- Backend: Processes data and logic.

### 4. Why did Salesforce move toward LWC?
For better performance and modern development.

### 5. Why is UI important in enterprise systems?
It makes applications easy to use.

### 6. Why should systems separate UI and business logic?
To improve maintenance and security.

### 7. What security risks exist in enterprise applications?
- Unauthorized access
- Data breaches
- Weak passwords
- Data loss

### 8. Why should developers think modularly?
To make applications easier to build, maintain, and reuse.
