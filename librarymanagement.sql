-- Create Database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Books Table
CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    ISBN VARCHAR(20) UNIQUE,
    Publisher VARCHAR(255),
    Year INT,
    Copies_Available INT DEFAULT 1
);

-- Members Table
CREATE TABLE Members (
    Member_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Address TEXT,
    Membership_Date DATE DEFAULT CURRENT_DATE
);

-- Transactions Table
CREATE TABLE Transactions (
    Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
    Member_ID INT,
    Book_ID INT,
    Issue_Date DATE DEFAULT CURRENT_DATE,
    Due_Date DATE,
    Return_Date DATE,
    Fine DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- Librarians Table
CREATE TABLE Librarians (
    Librarian_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Password VARCHAR(255) NOT NULL
);

-- Insert Sample Books
INSERT INTO Books (Title, Author, Genre, ISBN, Publisher, Year, Copies_Available)
VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', '9780743273565', 'Scribner', 1925, 5),
('1984', 'George Orwell', 'Dystopian', '9780451524935', 'Plume', 1949, 3),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', '9780061120084', 'Harper', 1960, 4);

-- Insert Sample Members
INSERT INTO Members (Name, Email, Phone, Address)
VALUES 
('Alice Johnson', 'alice@example.com', '9876543210', '123 Maple Street'),
('Bob Smith', 'bob@example.com', '9876543211', '456 Oak Avenue');

-- Insert Sample Librarians
INSERT INTO Librarians (Name, Email, Phone, Password)
VALUES 
('John Doe', 'john.doe@example.com', '1234567890', 'securepass123');

-- Insert Sample Transactions
INSERT INTO Transactions (Member_ID, Book_ID, Issue_Date, Due_Date)
VALUES 
(1, 2, '2025-03-10', '2025-03-24'),
(2, 1, '2025-03-12', '2025-03-26');

-- Query: Retrieve Available Books
SELECT * FROM Books WHERE Copies_Available > 0;

-- Query: Find Books Borrowed by a Member
SELECT B.Title, B.Author, T.Issue_Date, T.Due_Date 
FROM Transactions T
JOIN Books B ON T.Book_ID = B.Book_ID
WHERE T.Member_ID = 1 AND T.Return_Date IS NULL;

-- Query: Check Overdue Books & Fines Calculation
SELECT M.Name, B.Title, T.Due_Date, 
       DATEDIFF(CURDATE(), T.Due_Date) AS Days_Overdue, 
       CASE 
           WHEN DATEDIFF(CURDATE(), T.Due_Date) > 0 
           THEN DATEDIFF(CURDATE(), T.Due_Date) * 2 -- Fine: $2 per day
           ELSE 0 
       END AS Fine
FROM Transactions T
JOIN Members M ON T.Member_ID = M.Member_ID
JOIN Books B ON T.Book_ID = B.Book_ID
WHERE T.Return_Date IS NULL AND T.Due_Date < CURDATE();

-- Query: Return a Book & Update Availability
UPDATE Transactions 
SET Return_Date = CURDATE(), Fine = 
    CASE 
        WHEN DATEDIFF(CURDATE(), Due_Date) > 0 
        THEN DATEDIFF(CURDATE(), Due_Date) * 2 
        ELSE 0 
    END
WHERE Transaction_ID = 1;

UPDATE Books 
SET Copies_Available = Copies_Available + 1
WHERE Book_ID = (SELECT Book_ID FROM Transactions WHERE Transaction_ID = 1);

-- Query: View Most Borrowed Books
SELECT B.Title, COUNT(T.Book_ID) AS Borrow_Count
FROM Transactions T
JOIN Books B ON T.Book_ID = B.Book_ID
GROUP BY T.Book_ID
ORDER BY Borrow_Count DESC
LIMIT 5;

-- Query: Register a New Member
INSERT INTO Members (Name, Email, Phone, Address) 
VALUES ('Charlie Davis', 'charlie@example.com', '9876543212', '789 Pine Street');

-- Query: Delete Old Records (Archived Members who haven’t borrowed in 2 years)
DELETE FROM Members 
WHERE Member_ID NOT IN (SELECT DISTINCT Member_ID FROM Transactions WHERE Issue_Date > DATE_SUB(CURDATE(), INTERVAL 2 YEAR));
