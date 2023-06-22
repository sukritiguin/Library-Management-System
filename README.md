## Database Schema
![image](https://github.com/sukritiguin/Library-Management-System/assets/89704581/bc4745f8-9d10-4a58-ada7-b97ad1cc423b)
![image](https://github.com/sukritiguin/Library-Management-System/assets/89704581/c0a9a27a-f42b-4489-a9a8-c7dea2997bd1)


# Title: Building a Library Management System with Python and PostgreSQL

**Introduction:**
In this article, we will explore how to build a Library Management System using Python and PostgreSQL. A Library Management System is a crucial tool for organizing and managing the resources of a library efficiently. We will focus on key functionalities such as user authentication, book management, and transaction tracking. To accomplish this, we will utilize the bcrypt library for password hashing and the psycopg2 library to interact with the PostgreSQL database.

**Section 1: Setting up the Environment**
The first step is to set up the development environment. We need to install Python, PostgreSQL, and the necessary libraries, including bcrypt and psycopg2. Once the environment is ready, we can proceed to the implementation of different functionalities.

**Section 2: User Authentication**
User authentication is a fundamental component of any system. We will implement functions to store and validate usernames and passwords securely using bcrypt for password hashing. Additionally, we will create functions to retrieve the role of a user and determine if a user is a librarian.

**Section 3: Book Management**
Managing books is a core aspect of a library management system. We will implement functions to check the availability of books, retrieve book details based on ISBN, and insert new books into the system. We will also incorporate features to issue books to users and update the available copies accordingly.

**Section 4: Transaction Tracking**
Tracking book transactions is vital for monitoring the borrowing and returning of books. We will create functions to issue books to users, update the transaction status, and calculate the duration a book has been borrowed. This information will be valuable for managing overdue books and maintaining accurate records.

**Section 5: User Management**
Apart from books, managing user data is also essential. We will implement functions to store user information, including personal details and contact information. These functions will ensure the availability of accurate user data for various system operations.

**Conclusion:**
Building a Library Management System using Python and PostgreSQL provides an efficient and organized approach to manage library resources. With user authentication, book management, and transaction tracking functionalities, the system becomes a powerful tool for librarians and library staff. By leveraging the bcrypt library for secure password hashing and the psycopg2 library for seamless interaction with the PostgreSQL database, we ensure data integrity and user privacy. This article serves as a starting point for implementing a robust Library Management System, which can be further enhanced and customized based on specific requirements.

In summary, this article has outlined the process of building a Library Management System using Python and PostgreSQL. By following the provided code snippets and explanations, developers can gain a solid foundation for creating their own library management solutions. With the system in place, librarians can efficiently manage books, track transactions, and provide seamless services to library users.



***

**Several functions that interact with a PostgreSQL database using the psycopg2 library.**
These functions serve different purposes related to managing the Library Management System (LMS). Let's go through each function and describe its functionality:

1. `is_student_mobile_present(mobile_number)`: This function checks if a student with the given `mobile_number` is present in the database. It establishes a connection with the PostgreSQL database, executes a SQL query to count the number of rows matching the mobile number, and returns a boolean indicator.

2. `is_student_email_present(personal_email)`: This function checks if a student with the given `personal_email` is present in the database. Similar to the previous function, it establishes a database connection, executes a SQL query, and returns a boolean indicator.

3. `store_username_password(username, password)`: This function stores the `username` and hashed `password` in the `users_credentials` table of the database. It uses the bcrypt library to hash the password before storing it securely.

4. `validate_password(username, entered_password)`: This function validates the entered password for a given `username`. It retrieves the stored hashed password from the database, hashes the entered password, and compares them for verification.

5. `insert_user(first_name, last_name, username, email, role)`: This function inserts a new user into the `users` table with the provided details: `first_name`, `last_name`, `username`, `email`, and `role`.

6. `get_user_role(username)`: This function retrieves the role of a user with the given `username` from the `users` table.

7. `get_book_details(isbn)`: This function retrieves details about a book with the given `isbn` from the `books` table.

8. `get_name_and_department_from_student_or_faculty_table(table, username)`: This function retrieves the `first_name`, `middle_name`, `last_name`, and `department` of a user from the specified `table` based on the `username`.

9. `is_librarian(username)`: This function checks if a user with the given `username` has the role of a librarian.

10. `is_username_present(username)`: This function checks if a username is present in the `student` table.

11. `insert_new_student_data(values)`: This function inserts a new student's data into the `student` table using the provided `values`.

12. `is_isbn_present(isbn)`: This function checks if a book with the given `isbn` is present in the `books` table.

13. `insert_new_book(values)`: This function inserts a new book into the `books` table using the provided `values`.

14. `issue_book_to_user(username, isbn, librarian_username)`: This function issues a book to a user with the given `username` by updating the `transactions` table and the `available_copies` count of the book in the `books` table.

15. Lastly, there is a piece of code at the end that includes a transactional query to retrieve book details for a particular user based on their borrowed transactions.

Overall, these functions provide various functionalities for user management, book management, and transaction handling within the Library Management System.
