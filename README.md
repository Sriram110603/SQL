# 📚 LibraryDB – MySQL Database Schema for Library Management System

A comprehensive and normalized **MySQL database schema** for a Library Management System, designed to handle books, members, librarians, transactions, and fines efficiently.

---

## 🗃️ Overview

This project provides the SQL script for creating and managing a relational database called `LibraryDB`, ideal for use in:

- College or school library systems
- Academic projects
- Backend prototypes for full-stack applications
- REST API integration with Java, Python, Node.js, etc.

---

## 📌 Database Features

- 🔖 Book Inventory Management  
- 👥 Member Registration & Lookup  
- 👨‍💼 Librarian Login System  
- 🔁 Book Issue & Return Transactions  
- 🧮 Fine Calculation for Overdue Books  
- 📈 Insights: Most Borrowed Books, Availability, etc.

---

## 🏗️ Tables & Relationships

### 📘 `Books`
Stores all book details including metadata and availability.

| Column            | Type        | Description                  |
|------------------|-------------|------------------------------|
| `Book_ID`         | INT         | Primary Key (Auto Increment) |
| `Title`, `Author` | VARCHAR     | Book title & author          |
| `Genre`, `ISBN`   | VARCHAR     | Genre & unique ISBN          |
| `Publisher`, `Year` | VARCHAR/INT | Publisher info & publish year |
| `Copies_Available`| INT         | Tracks available stock       |

---

### 👤 `Members`
Tracks library members and their contact details.

| Column             | Type        | Description               |
|-------------------|-------------|---------------------------|
| `Member_ID`        | INT         | Primary Key               |
| `Name`, `Email`, `Phone`, `Address` | VARCHAR/TEXT | Personal contact details |
| `Membership_Date`  | DATE        | Default: current date     |

---

### 🔄 `Transactions`
Handles issue/return records with due date, return status, and fines.

| Column           | Type         | Description                       |
|------------------|--------------|-----------------------------------|
| `Transaction_ID` | INT          | Primary Key                       |
| `Member_ID`, `Book_ID` | INT   | Foreign Keys                      |
| `Issue_Date`, `Due_Date`, `Return_Date` | DATE | Loan status fields   |
| `Fine`           | DECIMAL      | Auto-calculated late fee          |

---

### 🧑‍🏫 `Librarians`
Stores librarian account credentials (ideal for login systems).

| Column         | Type     | Description           |
|----------------|----------|-----------------------|
| `Librarian_ID` | INT      | Primary Key           |
| `Name`, `Email`, `Phone` | VARCHAR | Identity details  |
| `Password`     | VARCHAR  | (Hash in production)  |

---

## 🔍 Sample SQL Queries

- 📦 Get all available books:  
  ```sql
  SELECT * FROM Books WHERE Copies_Available > 0;

