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



***

The **`file_utilities.py`** module in project "LMS" appears to contain several utility functions for various purposes. Here's a breakdown of each function:

1. `paste_qr(library_card, qr)`: This function takes a library card image (`library_card`) and a QR code image (`qr`) as input. It pastes the QR code onto the library card image and returns the modified image.

2. `generate_QR(info_dict)`: This function generates a QR code image based on the information provided in the `info_dict` dictionary. The dictionary is converted to a string, and then a QR code is generated using the `qrcode` library. The function returns the bytes value of the QR code image.

3. `random_password_generator()`: This function generates a random password of length 15 using uppercase letters, lowercase letters, and digits. It returns the generated password as a string.

4. `is_valid_email(email)`: This function checks if an email address is valid using a regular expression pattern. It returns `True` if the email is valid and `False` otherwise.

5. `valid_contact_number(contact_number)`: This function validates a contact number by checking if it is numeric and has a length of 10. It returns `True` if the contact number is valid and `False` otherwise.

6. `contains_special_chars(input_string)`: This function checks if a string contains any special characters. It returns `True` if the string contains special characters and `False` otherwise.

7. `contains_digits(input_string)`: This function checks if a string contains any digits (numeric characters). It returns `True` if the string contains digits and `False` otherwise.

8. `has_trailing_spaces(input_string)`: This function checks if a string contains trailing spaces on both the left and right sides. It returns `True` if trailing spaces are found and `False` otherwise.

9. `get_username_from_QR(window_name)`: This function captures frames from the camera and detects QR codes. It extracts the username from the decoded QR code data and returns it as a string.

10. `create_new_student_form()`: This function creates a form for entering information about a new student. It uses Streamlit library to create input fields for various student details such as first name, middle name, last name, address, contact number, email, etc. It also performs validation checks on the input fields and displays success or warning messages accordingly. Upon submission, the function inserts the student's data into a database and generates a library card with a QR code.

11. `random_password_generator()`: This function generates a random password. It uses a combination of uppercase letters, lowercase letters, and digits to create a password of length 15 characters.

12. `is_valid_email(email)`: This function validates an email address using a regular expression pattern. It checks if the email address has the correct format of username@domain.extension. It returns `True` if the email is valid, and `False` otherwise.

13. `valid_contact_number(contact_number)`: This function validates a contact number. It checks if the contact number is numeric and has a length of 10 digits. It returns `True` if the contact number is valid, and `False` otherwise.

14. `contains_special_chars(input_string)`: This function checks if a string contains any special characters. It defines a string of special characters and loops through each character in the input string to check if it matches any special character. It returns `True` if a special character is found, and `False` otherwise.

15. `contains_digits(input_string)`: This function checks if a string contains any digits (numeric characters). It loops through each character in the input string and checks if it is a digit. It returns `True` if a digit is found, and `False` otherwise.

16. `has_trailing_spaces(input_string)`: This function checks if a string contains trailing spaces on both the left and right sides. It uses the `rstrip()` and `lstrip()` functions to remove the trailing spaces from the input string and compares it with the original string. If they are not equal, it means there are trailing spaces. It returns `True` if trailing spaces are found on both sides, and `False` otherwise.

17. `get_username_from_QR(window_name)`: This function captures a frame from the camera, converts it to grayscale, and detects QR codes in the frame. It extracts the barcode data from the QR code and returns the username if it is found in the barcode data. It uses the `cv2` and `pyzbar` libraries for image processing and QR code decoding.

18. `create_new_student_form()`: This function creates a form for entering new student information. It uses Streamlit to display input fields for first name, middle name, last name, address, contact number, parent number, email, department, admission year, graduation year, and current address. It performs validation checks on the input values and displays warnings if any validation fails. It also checks if the mobile number and email are already registered in the database. If all the input values are valid, it inserts the student data into the database, generates a library card, and displays a QR code with the student information.
