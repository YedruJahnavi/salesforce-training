# Day 9 - LWC Communication

## Component Communication

Component communication allows Lightning Web Components (LWCs) to exchange data and interact with each other.

### Types of Communication
- Parent to Child (@api)
- Child to Parent (Custom Events)
- Lightning Message Service (Unrelated Components)

---

## Dashboard Design

### Student Dashboard
- Student Information
- Registered Courses
- Attendance Details

### Course Dashboard
- Course List
- Available Seats
- Course Statistics

### Reports Dashboard
- Student Reports
- Attendance Reports
- Performance Analytics

---

## Data Flow Explanation

1. User enters data in the LWC interface.
2. LWC sends data to Apex.
3. Apex processes the request.
4. Salesforce database stores or retrieves records.
5. Data is returned to the component.
6. Updated information is displayed to the user.

---

## Aura vs LWC

| Aura | LWC |
|------|-----|
| Older Framework | Modern Framework |
| More Complex | Simpler |
| Slower | Faster |
| Custom Framework | Uses Web Standards |

### Why LWC is Preferred
- Better performance
- Easier development
- Reusable components
- Modern JavaScript support

---

## Reflection

LWC communication helps components share data efficiently. Using reusable and independent components makes applications easier to maintain, scalable, and user-friendly. Modern frontend architecture improves overall application performance.

---

## Revision Questions

### 1. Why do components communicate?
To share data and work together.

### 2. Difference between parent-child communication and events?
- Parent-child communication passes data directly.
- Events send information from child to parent.

### 3. Why is modular architecture useful?
It improves reusability and maintenance.

### 4. Why did Salesforce move toward LWC?
For better performance and modern development.

### 5. What problems happen in tightly coupled systems?
They are difficult to maintain and update.

### 6. Why is frontend architecture important?
It improves user experience and application structure.

### 7. Why should UI and backend remain separate?
To improve security, maintenance, and scalability.

### 8. Why do large systems need reusable modules?
To reduce development effort and improve consistency.
