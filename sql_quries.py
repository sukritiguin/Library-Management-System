import bcrypt
import psycopg2
import streamlit as st


def is_student_mobile_present(mobile_number):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )
    # Create a cursor object to interact with the database
    cur = conn.cursor()

    cur.execute("SELECT COUNT(*) FROM student WHERE contact_number = %s", (mobile_number,))
    mobile_number_count = cur.fetchone()[0]

    if mobile_number_count>0:
        indicator = True
    else:
        indicator = False

    # Close the cursor, commit the transaction, and close the database connection
    cur.close()
    conn.commit()
    conn.close()

    return indicator


def is_student_email_present(personal_email):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )
    # Create a cursor object to interact with the database
    cur = conn.cursor()

    cur.execute("SELECT COUNT(*) FROM student WHERE personal_email = %s", (personal_email,))
    personal_email_count = cur.fetchone()[0]

    if personal_email_count>0:
        indicator = True
    else:
        indicator = False

    # Close the cursor, commit the transaction, and close the database connection
    cur.close()
    conn.commit()
    conn.close()

    return indicator



def store_username_password(username,password):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )
    # Create a cursor object to interact with the database
    cur = conn.cursor()

    # Define the password to be hashed
    password = password.encode('utf-8')

    # Hash the password using bcrypt
    hashed_password = bcrypt.hashpw(password, bcrypt.gensalt())

    # Insert the user with hashed password into the database
    try:
        cur.execute("INSERT INTO users_credentials (username, password) VALUES (%s, %s)",
                    (username, hashed_password))
        conn.commit()
        st.warning("✅ User inserted successfully with hashed password.")
    except Exception as e:
        st.warning('❌ Unable to store username and password.')
        conn.rollback()

    # Close the cursor and connection
    cur.close()
    conn.close()


# Define the function to validate password
def validate_password(username, entered_password):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    # Create a cursor to interact with the database
    cur = conn.cursor()
    # Execute SQL query to get stored password for the given username
    cur.execute("SELECT password FROM users_credentials WHERE username = %s", (username,))
    result = cur.fetchone()

    # If no password found, return False
    if result is None:
        # Close the cursor and database connection
        cur.close()
        conn.close()
        return False

    # Extract the stored password from the query result
    stored_hashed_password = result[0]
    # Convert the entered password to bytes
    entered_password_bytes = entered_password.encode('utf-8')

    # Convert the stored hashed password from bytes to bytes-like object
    stored_hashed_password_bytes = stored_hashed_password.tobytes()

    # Close the cursor and database connection
    cur.close()
    conn.close()
    # Compare the entered password with the stored hashed password
    if bcrypt.checkpw(entered_password_bytes, stored_hashed_password_bytes):
        return True
    else:
        return False

def insert_user(first_name,last_name,username,email,role):
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    # Create a cursor object to interact with the database
    cur = conn.cursor()

    # Use a parameterized query to insert data into the table
    cur.execute("""
        INSERT INTO users
        (first_name, last_name, username, email, role)
        VALUES (%s, %s, %s, %s, %s)
    """, (first_name, last_name, username, email, role))

    # Close the cursor and database connection
    conn.commit()
    cur.close()
    conn.close()


def get_user_role(username):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )


    # Create a cursor object to interact with the database
    cur = conn.cursor()

    # Execute a SELECT query to retrieve the role associated with the given username
    cur.execute("SELECT role FROM users WHERE username = %s", (username,))

    # Fetch the result
    result = cur.fetchone()

    # Close the cursor and database connection
    cur.close()
    conn.close()

    # If a result is found, return the role. Otherwise, return None
    if result:
        return result[0]
    else:
        return None



def get_book_details(isbn):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    # Create a cursor object to interact with the database
    cur = conn.cursor()

    # Execute the query to retrieve the book details
    cur.execute("SELECT title, author, isbn, edition, publication_year FROM books WHERE isbn = %s", (isbn,))

    # Fetch the row from the query result
    row = cur.fetchone()

    # If no row is found for the specified ISBN, return None
    if row is None:
        cur.close()
        conn.close()
        return None

    # Create a dictionary to store the book details
    book = {
        'title': row[0],
        'author': row[1],
        'isbn': row[2],
        'edition': row[3],
        'publication_year': row[4]
    }

    # Close the cursor and connection to the database
    cur.close()
    conn.close()

    # Return the dictionary of book details
    return book


def get_name_and_department_from_student_or_faculty_table(table,username):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    # Create a cursor object to interact with the database
    cur = conn.cursor()

    cur.execute('SELECT first_name, middle_name, last_name, department FROM "{}" WHERE username = %s'.format(table), (username,))

    result = cur.fetchone()
    dict_ = {
        'first_name': result[0],
        'middle_name': result[1],
        'last_name': result[2],
        'department': result[3]
    }

    cur.close()
    conn.close()

    return dict_


def is_librarian(username):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    cursor = conn.cursor()

    # Execute the query
    cursor.execute("SELECT COUNT(*) FROM users WHERE username = %s AND role = 'librarian'", (username,))
    result = cursor.fetchone()

    # Check if the user is a librarian
    is_librarian_indicator = False
    if result[0] > 0:
        is_librarian_indicator = True

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return is_librarian_indicator

# Create a boolean function
def is_username_present(username):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    cur = conn.cursor()
    # Execute a SELECT query with a WHERE clause to filter by the username
    cur.execute("SELECT EXISTS (SELECT 1 FROM student WHERE username = %s)", (username,))
    result = cur.fetchone()[0]

    # Close the cursor and connection
    cur.close()
    conn.close()
    return result


def insert_new_student_data(values):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    # Define the INSERT query with parameter placeholders
    insert_query = """
    INSERT INTO student (first_name, middle_name, last_name, contact_number, parent_number, personal_email,
                         department, addmission_year, graduation_year, current_address, address)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
    """

    # Execute the INSERT query with the values
    cur.execute(insert_query, values)

    # Commit the transaction
    conn.commit()

    # Close the cursor and database connection
    cur.close()
    conn.close()


def is_isbn_present(isbn):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )
    cursor = conn.cursor()

    cursor.execute("SELECT COUNT(*) FROM books WHERE isbn = %s", (isbn,))
    result = cursor.fetchone()

    indicator = False
    if result[0]>=1:
        indicator = True

    cursor.close()
    conn.close()
    return indicator

def insert_new_book(values):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    # Prepare the SQL query with placeholders
    sql = """
        INSERT INTO books (title, author, isbn, publication_year, edition, description, total_copies, available_copies)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
    """

    # Execute the SQL query with the data
    cur.execute(sql, values)

    # Commit the transaction to save the changes
    conn.commit()

    # Close the cursor and database connection
    cur.close()
    conn.close()



import psycopg2
from datetime import datetime

def issue_book_to_user(username, isbn,librarian_username):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    # Create a cursor object to interact with the database
    cur = conn.cursor()

    try:
        # Start a transaction
        conn.autocommit = False

        # Check if the book with the given ISBN is available and not already issued to the user
        cur.execute("SELECT COUNT(*) FROM transactions WHERE isbn = %s AND username = %s AND transaction_status = %s", (isbn, username,'borrowed'))
        count = cur.fetchone()[0]
        if count > 0:
            st.warning("The book with ISBN {} is already issued to user {}".format(isbn, username))
            raise Exception("The book with ISBN {} is already issued to user {}".format(isbn, username))

        # Check if the user has not already issued 5 books
        cur.execute("SELECT COUNT(*) FROM transactions WHERE username = %s AND transaction_status = %s", (username,'borrowed'))
        count = cur.fetchone()[0]
        if count >= 5:
            st.warning("User {} has already issued 5 books".format(username))
            raise Exception("User {} has already issued 5 books".format(username))

        # Check if the book with the given ISBN is available
        cur.execute("SELECT available_copies FROM books WHERE isbn = %s", (isbn,))
        available_copies = cur.fetchone()[0]
        if available_copies < 1:
            st.warning("Book with ISBN {} is not available".format(isbn))
            raise Exception("Book with ISBN {} is not available".format(isbn))

        # Issue the book to the user
        cur.execute("INSERT INTO transactions (transaction_id, username, isbn, transaction_status, issued_by) VALUES (%s, %s, %s, %s, %s)", (str(datetime.now()).replace(' ','-')+'-'+username ,username, isbn, 'borrowed',librarian_username))

        # Update the book's available copies count
        cur.execute("UPDATE books SET available_copies = available_copies - 1 WHERE isbn = %s", (isbn,))

        # Commit the transaction
        conn.commit()

        print("Book with ISBN {} issued to user {}".format(isbn, username))
        st.success("Book with ISBN {} issued to user {}".format(isbn, username))

    except Exception as e:
        # Roll back the transaction on error
        conn.rollback()
        print("Error: {}".format(e))

    finally:
        cur.close()
        conn.close()






import psycopg2
from datetime import datetime, timedelta

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="LMSdb",
    user="postgres",
    password="sukritiguin",
    host="localhost",
    port="5432"
)

# Create a cursor object to interact with the database
cur = conn.cursor()

try:
    # Start a transaction
    conn.autocommit = False

    # Get all transactions of a particular user where transaction type is borrowed
    cur.execute("SELECT * FROM transactions WHERE username = %s AND transaction_status = %s", (username, 'borrowed'))
    transactions = cur.fetchall()

    # Create an empty list to store book details
    books_list = []

    # Loop through all the transactions
    for transaction in transactions:
        isbn = transaction[2]
        borrowed_date = transaction[4]

        # Get book details for the current transaction
        cur.execute("SELECT title, author, publication_year, edition FROM books WHERE isbn = %s", (isbn,))
        book_details = cur.fetchone()

        # Calculate the number of days the book has been borrowed for
        days_borrowed = (datetime.now() - borrowed_date).days

        # Create a dictionary to store book details and days borrowed
        book_dict = {
            'title': book_details[0],
            'author': book_details[1],
            'publication_year': book_details[2],
            'edition': book_details[3],
            'borrowed_date': borrowed_date,
            'days_borrowed': days_borrowed
        }

        # Append the book dictionary to the books list
        books_list.append(book_dict)

    # Commit the transaction
    conn.commit()

except Exception as e:
    # Roll back the transaction on error
    conn.rollback()
    print("Error: {}".format(e))

finally:
    cur.close()
    conn.close()




import psycopg2
from datetime import datetime

def get_borrowed_books(username):
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="LMSdb",
        user="postgres",
        password="sukritiguin",
        host="localhost",
        port="5432"
    )

    # Create a cursor object to interact with the database
    cur = conn.cursor()

    try:
        # Get all transactions for the user where transaction_type is 'borrowed'
        cur.execute("SELECT isbn,borrowed_at FROM transactions WHERE username = %s AND transaction_status = %s", (username, 'borrowed'))
        transactions = cur.fetchall()
        # st.success(transactions)

        # Create a dictionary to store the details of all the borrowed books
        borrowed_books = {}

        for transaction in transactions:
            # Get the ISBN of the borrowed book
            isbn = transaction[0]

            # Get the details of the book from the books table
            cur.execute("SELECT title, author, publication_year, edition FROM books WHERE isbn = %s", (isbn,))
            book_details = cur.fetchone()
            # st.success(book_details)

            # Calculate the number of days the book has been borrowed for
            # borrowed_date = transaction[1].day
            # days_borrowed = (datetime.now().day - borrowed_date.day)

            # Create a dictionary containing the book details and the number of days borrowed
            book_dict = {
                'title': book_details[0],
                'author': book_details[1],
                'publication_year': book_details[2],
                'edition': book_details[3],
                'borrowed_date': transaction[1],
                'days_borrowed': (datetime.now() - transaction[1]).days
            }
            # st.success(transactions[1])

            # print("Type of Date : ",type(transactions[1]),type(datetime.now().day))

            # Add the book details to the borrowed_books dictionary
            borrowed_books[isbn] = book_dict

        return borrowed_books

    except Exception as e:
        print("Error: {}".format(e))

    finally:
        cur.close()
        conn.close()





def update_transaction(book_isbn, borrower_username, librarian_username):
    try:
        conn = psycopg2.connect(
            dbname="LMSdb",
            user="postgres",
            password="sukritiguin",
            host="localhost",
            port="5432"
        )

        # Set autocommit to off
        conn.autocommit = False

        # Create a cursor
        cur = conn.cursor()

        # Execute the query
        cur.execute("""
                UPDATE transactions
                SET transaction_status = 'returned',
                    returned_by = %s,
                    returned_at = current_timestamp
                WHERE isbn = %s AND username = %s AND transaction_status = 'borrowed';
            """, (librarian_username, book_isbn, borrower_username))

        # Commit the transaction
        conn.commit()
        st.success(f'Book(ISBN : {book_isbn}) Submitted successfully by librarian({librarian_username})')

    except Exception as error:
        # If an error occurs, rollback the transaction
        conn.rollback()

        # Print the error message
        st.warning(error)
        print("Error: ", error)

    finally:
        # Close the cursor and connection
        cur.close()
        conn.close()

