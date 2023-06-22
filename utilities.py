from io import BytesIO

import streamlit as st
import datetime
import re

import demo
import main
import sql_quries

import os

import json
import cv2
from pyzbar import pyzbar



from PIL import Image
# from reportlab.lib.pagesizes import letter, landscape
# from reportlab.platypus import SimpleDocTemplate, Image as RLImage

import qrcode

from PIL import Image

def paste_qr(library_card,qr):
    img_01 = library_card
    img_02 = Image.open(BytesIO(qr))

    img_02 = img_02.resize((200, 200))

    # Get the sizes of the images
    img_01_size = img_01.size
    img_02_size = img_02.size

    # Calculate the coordinates to paste img_02 in the right-side center of img_01
    paste_x = img_01_size[0] - img_02_size[0]
    paste_y = (img_01_size[1] - img_02_size[1]) // 2

    # Paste img_02 on img_01
    img_01.paste(img_02, (paste_x, paste_y))

    # Save the merged image
    img_01.save("merged_images.png", "PNG")

    # Show the merged image
    # img_01.show()
    return img_01


def generate_QR(info_dict):
    # Convert dictionary to string
    info_str = json.dumps(info_dict)

    # Generate QR code with text
    qr = qrcode.QRCode(version=1, box_size=10, border=5)
    qr.add_data(info_str)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    # Create a BytesIO object
    output = BytesIO()

    # Save the image to the BytesIO object in PNG format
    img.save(output, format='PNG')

    # Get the bytes value from the BytesIO object
    img_bytes = output.getvalue()

    # Return the bytes value
    return img_bytes


def random_password_generator():
    import random
    import string

    # Define the characters you want to include in the random string
    characters = string.ascii_letters + string.digits

    # Set the length of the random string
    length = 15

    # Generate the random string
    random_string = ''.join(random.choice(characters) for _ in range(length))
    return random_string


def is_valid_email(email):
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return re.match(pattern, email) is not None

def valid_contact_number(contact_number):
    """
    Function to validate a contact number.

    Parameters:
        - contact_number (str): Contact number to be validated.

    Returns:
        - bool: True if the contact number is valid, False otherwise.
    """

    # Check if the cleaned input is numeric and has a length of 10
    if contact_number.isnumeric() and len(contact_number) == 10:
        return True
    else:
        return False

def contains_special_chars(input_string):
    """
    Function to check if a string contains any special characters.

    Parameters:
        - input_string (str): Input string to be checked.

    Returns:
        - bool: True if the input string contains any special characters, False otherwise.
    """
    # Check if the input is a string
    if not isinstance(input_string, str):
        return False

    # Define a string of special characters
    special_chars = "!@#$%^&*()_+-=[]{}|;':\"<>,.?/\\"

    # Loop through each character in the input string
    for char in input_string:
        # Check if the character is a special character
        if char in special_chars:
            return True  # Return True if a special character is found

    return False  # Return False if no special character is found

def contains_digits(input_string):
    """
    Function to check if a string contains any digits (numeric characters).

    Parameters:
        - input_string (str): Input string to be checked.

    Returns:
        - bool: True if the input string contains any digits, False otherwise.
    """
    # Check if the input is a string
    if not isinstance(input_string, str):
        return False

    # Loop through each character in the input string
    for char in input_string:
        # Check if the character is a digit
        if char.isdigit():
            return True  # Return True if a digit is found

    return False  # Return False if no digit is found

def has_trailing_spaces(input_string):
    """
    Function to check if a string contains trailing spaces on both left and right sides.

    Parameters:
        - input_string (str): Input string to be checked.

    Returns:
        - bool: True if the input string contains trailing spaces on both left and right sides, False otherwise.
    """
    # Check if the input is a string
    if not isinstance(input_string, str):
        return False

    # Check if the input string ends with spaces
    if input_string.rstrip() != input_string or input_string.lstrip() != input_string:
        return True  # Return True if trailing spaces are found on both left and right sides

    return False  # Return False if no trailing spaces are found on both left and right sides

import cv2
import json
from pyzbar import pyzbar


def get_username_from_QR(window_name):
    # Open camera
    cap = cv2.VideoCapture(0)
    username = None

    while True:
        # Capture frame from camera
        ret, frame = cap.read()

        # Convert frame to grayscale
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        # Detect QR codes in the frame
        barcodes = pyzbar.decode(gray)

        # Loop through detected barcodes
        for barcode in barcodes:
            # Extract barcode data
            barcode_data = barcode.data.decode("utf-8")
            print("Barcode Data:", barcode_data)
            type(barcode_data)
            barcode_data_demo = json.loads(barcode_data)
            if 'Username:' in barcode_data_demo.keys():
                username = barcode_data_demo['Username:']

            # Draw bounding box around barcode
            (x, y, w, h) = barcode.rect
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

            # Display barcode data on the frame
            cv2.putText(frame, barcode_data, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

        # Display the frame
        cv2.imshow(window_name, frame)

        if barcodes:break

        # Exit loop on 'q' key press
        if cv2.waitKey(1) & 0xFF == ord('q'):
            cap.release()
            cv2.destroyAllWindows()
            break

    # Release camera and close all OpenCV windows
    cap.release()
    cv2.destroyAllWindows()
    return username


def create_new_student_form():
    col1, col2 = st.columns(2)
    first_name_ok = False
    middle_name_ok = False
    last_name_ok = False
    address_ok = False
    current_address_ok = False
    academics_ok = False
    contact_number_ok = False
    parent_number_ok = False
    email_ok = False
    with col1:
        first_name = st.text_input("Enter First Name : ", max_chars=255)
        if len(first_name) < 3:
            st.warning('❌ First name length should not be less than 3')
        if len(first_name) > 255:
            st.warning('❌ First name length should not be grether than 255')
        if contains_special_chars(first_name):
            st.warning('❌ First name should not contains any special characters')
        if contains_digits(first_name):
            st.warning('❌ First name should not contains any digits')
        if has_trailing_spaces(first_name):
            st.warning("❌ No trilling space is allowed")

        if len(first_name)>=3 and len(first_name)<=255 and not contains_digits(first_name) and not contains_special_chars(first_name) and not has_trailing_spaces(first_name):
            st.success('✅ All OK!')
            first_name_ok = True



        middle_name = st.text_input("Enter Middle Name : ", max_chars=255)
        if contains_special_chars(middle_name):
            st.warning('❌ Middle name should not contains any special characters')
        if contains_digits(middle_name):
            st.warning('❌ Middle name should not contains any digits')
        if has_trailing_spaces(middle_name):
            st.warning("❌ No trilling space is allowed")
        if len(middle_name)==0 or (len(middle_name)<=255 and not contains_digits(middle_name) and not contains_special_chars(middle_name) and not has_trailing_spaces(middle_name)):
            st.success('✅ All OK!')
            middle_name_ok = True


        last_name = st.text_input("Enter Last Name : ", max_chars=255)
        if len(last_name) < 3:
            st.warning('❌ Last name length should not be less than 3')
        if len(last_name) > 255:
            st.warning('❌ Last name length should not be grether than 255')
        if contains_special_chars(last_name):
            st.warning('❌ Last name should not contains any special characters')
        if contains_digits(last_name):
            st.warning('❌ Last name should not contains any digits')
        if has_trailing_spaces(last_name):
            st.warning("❌ No trilling space is allowed")
        if len(last_name)>=3 and len(last_name)<=255 and not contains_digits(last_name) and not contains_special_chars(last_name)\
                and not has_trailing_spaces(last_name):
            st.success('✅ All OK!')
            last_name_ok = True

        address = st.text_input("Enter permanent addresss : ",max_chars=255)
        if len(address)>=6:
            st.success('✅ All OK!')
            address_ok = True
        else:
            st.warning('❌ Type minimum address')

        current_address = address
        current_address_ok = True
        is_same_current_address = st.checkbox('Current Address is same as permanent address.',value=True)
        if not is_same_current_address:
            current_address = st.text_input("Enter current addresss : ", max_chars=255)
            if len(address) >= 6:
                st.success('✅ All OK!')
                current_address_ok = True
            else:
                st.warning('❌ Type minimum address')

    with col2:
        all_department_options = ['CSE','ECE','IT','AIML','EE','ME','CE','DS','BCA','MCA']
        department = st.selectbox(label="Select Department : ",options=all_department_options)
        addmission_year = st.slider("Select Addmission Year : ",min_value=datetime.datetime.now().year - 10,
                                    max_value=datetime.datetime.now().year,step=1,
                                    value=datetime.datetime.now().year)
        graduation_year = st.slider(label="Select Graduation Year : ",min_value=datetime.datetime.now().year - 10,
                                    max_value=datetime.datetime.now().year + 10, step=1,
                                    value=datetime.datetime.now().year)
        if graduation_year<addmission_year:
            st.warning("❌ Graduation year should not be less than addmission year")
        elif graduation_year-addmission_year<2:
            st.warning('❌ No course with less than 2 years of duaration')
        else:
            st.success(f'✅ All OK! {addmission_year} - {graduation_year} {department} Batch')
            academics_ok = True
        concatact_number = st.text_input("Enter Contact Number : ",max_chars=10)
        if not valid_contact_number(contact_number=concatact_number):
            st.warning("❌ Invalid Mobile Number")
        elif sql_quries.is_student_mobile_present(concatact_number):
            st.warning('❌ This mobile number is already registered.')
        else:
            st.success('✅ All OK!')
            contact_number_ok = True
        parent_number = st.text_input("Enter Your Parent Number : ",max_chars=10)
        if not valid_contact_number(contact_number=parent_number):
            st.warning("❌ Invalid Mobile Number")
        else:
            st.success('✅ All OK!')
            parent_number_ok = True

        email = st.text_input('Enter Your Email : ')
        if not is_valid_email(email):
            st.warning('❌ Enter valid email!')
        elif sql_quries.is_student_email_present(personal_email=email):
            st.warning('❌ This email is already registered!')
        else:
            st.success('✅ All OK! Valid Email')
            email_ok = True

    # Now time to accept response
    download_path = 'E:/library_cards/'
    directory_path = st.text_input(label='Enter directory : ', placeholder=download_path)
    submit_form = st.button('Insert New Student')
    if submit_form:
        # print(type(department),department)
        if first_name_ok and middle_name_ok and last_name_ok and address_ok and current_address_ok and academics_ok and contact_number_ok \
                and parent_number_ok and email_ok:
            current_username = first_name.lower() + middle_name.lower() + last_name.lower() + '-student-' + department.lower() + '-' \
                               + str(addmission_year) + '-' + str(graduation_year) + '-' + concatact_number[-4:]
            if sql_quries.is_username_present(username=current_username):
                st.warning(f'This User ({current_username}) Data already stored in database')
            else:
                values = (first_name,None if middle_name=='' else middle_name,last_name,concatact_number,parent_number,email,department,addmission_year,
                          graduation_year,current_address,address)
                try:
                    sql_quries.insert_new_student_data(values=values)
                    sql_quries.insert_user(first_name=first_name,last_name=last_name,username=current_username,email=email,role='student')
                    st.success('✅ User data inserted successfully.!!! 🟢')
                except Exception as e:
                    st.warning('Something went wrong !!!')
                    st.warning(e)
                st.subheader("Library Card")
                info_dict = {
                    "Name:": first_name + " " + middle_name + " " + last_name,
                    "Contact Number:": concatact_number,
                    "Parent Number:": parent_number,
                    "Email:": email,
                    "Department:": department,
                    "Admission Year:": addmission_year,
                    "Graduation Year:": graduation_year,
                    "Current Address:": current_address,
                    "Address:": address,
                    "Username:": current_username
                }
                random_password = random_password_generator()
                sql_quries.store_username_password(username=current_username, password=random_password)
                info_dict['password'] = random_password
                qr_code = generate_QR(info_dict=info_dict)
                library_card = main.create_library_card(info_dict=info_dict)
                library_card.save('library_card.jpg')
                qr_library_card = paste_qr(library_card=library_card,qr=qr_code)

                with open('qr_code.png', 'wb') as f:
                    f.write(qr_code)

                st.success('📃 Scane QR and get and change password')
                st.image(qr_library_card)


                byte_stream = BytesIO()
                qr_library_card.save(byte_stream,
                                format='PNG')  # You can choose any format you prefer, such as JPEG or BMP
                byte_stream.seek(0)
                file_bytes = byte_stream.read()

                # st.download_button(label='Download Library Card',data = file_bytes,file_name=current_username+".png",mime='png')



                # Create the download directory if it doesn't exist
                os.makedirs(download_path, exist_ok=True)

                # change_directory_checkbox = st.checkbox('Change Directory')
                # if change_directory_checkbox:

                if directory_path!='':download_path = directory_path

                # download_library_card_button = st.checkbox('Download Library Card')
                # if download_library_card_button:
                # Save file to download path
                # try:
                file_name = current_username + ".png"
                download_file_path = os.path.join(download_path, file_name)
                try:
                    with open(download_file_path, 'wb') as download_file:
                        download_file.write(file_bytes)
                    # Create download button
                # st.download_button(label='Download Library Card', data=file_bytes, file_name=file_name,
                #                    mime='png')
                    st.success('✅ Library Card Downloaded Successfully.')
                except:
                    st.warning('❌ Something went wrong. Please check directory')



            pass
        else:
            st.warning('❌❌❌ Something Invalid !!!')



def create_new_book_form():
    editions = []

    for i in range(1, 51):
        if i == 1:
            edition = '1st Edition'
        elif i == 2:
            edition = '2nd Edition'
        elif i == 3:
            edition = '3rd Edition'
        else:
            edition = f'{i}th Edition'
        editions.append(edition)

    col1,col2 = st.columns(2)
    with col1:
        title = st.text_input("Enter Title : ",max_chars=255)
        author = st.text_input("Author : ",max_chars=255)
        isbn = st.text_input("ISBN : ",max_chars=255)
        if sql_quries.is_isbn_present(isbn=isbn):
            st.warning('❌ This book is already present')
        publication_year = int(st.number_input("Enter Publication Year : ",step=1))
        if publication_year>datetime.datetime.now().year:
            st.warning('❌ Publication Year should not be greater than current year.')
        if publication_year<0:
            st.warning('❌ Publication Year should not be negative')
    with col2:
        edition = st.selectbox(label="Enter Edition : ",options=editions)
        description = st.text_input(label="Description : ")
        total_copies = int(st.number_input("Total Copies : ",step=1,min_value=1))
        available_copies = int(st.number_input("Available Copies : ",step=1,value=total_copies,min_value=1))
        if available_copies>total_copies:
            st.warning('❌ Available copies should not be greater than total copies')

    download_path = 'E:/books_qr/'
    directory_path = st.text_input(label='Enter directory to store books QR : ', placeholder=download_path)
    submit = st.button("Submit")
    if submit:
        try:
            sql_quries.insert_new_book((title,author,isbn,publication_year,edition,description,total_copies,available_copies))
            book_qr_dict = {
                'title': title,
                'author': author,
                'isbn': isbn,
                'publication_year': publication_year,
                'edition': edition,
                'description': description,
                'total_copies': total_copies
            }
            book_QR_img = generate_QR(info_dict=book_qr_dict)
            book_QR_img = Image.open(BytesIO(book_QR_img))
            book_QR_img = demo.write_bellow_center_image(book_QR_img,isbn)
            # book_QR_img = book_QR_img.tobytes()
            # Create the download directory if it doesn't exist
            os.makedirs(download_path, exist_ok=True)

            # change_directory_checkbox = st.checkbox('Change Directory')
            # if change_directory_checkbox:

            if directory_path != '': download_path = directory_path

            # download_library_card_button = st.checkbox('Download Library Card')
            # if download_library_card_button:
            # Save file to download path
            # try:
            file_name = isbn + ".png"
            download_file_path = os.path.join(download_path, file_name)
            try:
                book_QR_img.save(download_file_path)
                # with open(download_file_path, 'wb') as download_file:
                #     download_file.write(book_QR_img)
                # Create download button
                # st.download_button(label='Download Library Card', data=file_bytes, file_name=file_name,
                #                    mime='png')
                st.success('✅ Book QR Downloaded Successfully.')
            except:
                st.warning('❌ Something went wrong. Please check directory')
            st.success('Book inserted sucessfully!!!')
        except Exception as e:
            st.warning(e)


def get_book_isbn_from_QR(window_name):
    # Open camera
    cap = cv2.VideoCapture(0)
    isbn = None

    while True:
        # Capture frame from camera
        ret, frame = cap.read()

        # Convert frame to grayscale
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        # Detect QR codes in the frame
        barcodes = pyzbar.decode(gray)

        # Loop through detected barcodes
        for barcode in barcodes:
            # Extract barcode data
            barcode_data = barcode.data.decode("utf-8")
            # print("Barcode Data:", barcode_data)
            # type(barcode_data)
            barcode_data_demo = json.loads(barcode_data)
            # print(barcode_data_demo)
            # print(barcode_data_demo.keys())
            if 'isbn' in barcode_data_demo.keys():
                isbn = barcode_data_demo['isbn']

            # Draw bounding box around barcode
            (x, y, w, h) = barcode.rect
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

            # Display barcode data on the frame
            cv2.putText(frame, barcode_data, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

        # Display the frame
        cv2.imshow(window_name, frame)
        if barcodes:break

        # Exit loop on 'q' key press
        if cv2.waitKey(1) & 0xFF == ord('q'):
            cap.release()
            cv2.destroyAllWindows()
            break

    # Release camera and close all OpenCV windows
    cap.release()
    cv2.destroyAllWindows()
    return isbn




def issue_book(entered_username):
    get_user = st.radio(label='Get User',options=['Check QR','Username'],index=1)
    # get_user = st.checkbox(label='Check QR',value=False)
    if get_user == 'Check QR':
        user = get_username_from_QR("Show QR on Library Card : Issue Book")
        if user == None:
            st.warning('No User Found')
        else:
            role = sql_quries.get_user_role(username=user)
            if role == None:
                st.warning('❌ User name found but not stored in database')
            else:
                dict_ = sql_quries.get_name_and_department_from_student_or_faculty_table(table=role,username=user)
                dict_['role'] = role
                st.markdown("<h5 style='color: yellowgreen;'>User Details</h5>", unsafe_allow_html=True)
                st.dataframe(data=dict_)
                curr_book_isbn = get_book_isbn_from_QR("Show QR on Book : Issue Book")
                if curr_book_isbn == None:
                    st.warning('❌ Book isbn not found. Provide correct QR')
                else:
                    curr_book_details = sql_quries.get_book_details(isbn=curr_book_isbn)
                    st.markdown("<h5 style='color: yellowgreen;'>Scaned Book Details</h5>", unsafe_allow_html=True)
                    st.dataframe(curr_book_details)
                    sql_quries.issue_book_to_user(username=user,isbn=curr_book_isbn,librarian_username=entered_username)
                st.markdown("<h5 style='color: yellowgreen;'>Recently Issued Book</h5>", unsafe_allow_html=True)
                currently_all_issued_books = sql_quries.get_borrowed_books(username=user)
                st.dataframe(currently_all_issued_books)

    return True

def show_library_card_details():
    st.markdown("<h4 style='color: yellowgreen;'>Scan Library Card QR from pop up camera</h4>", unsafe_allow_html=True)
    user = get_username_from_QR("Show QR on Library Card : Show Library Card Details")
    if user == None:
        st.warning('No User Found')
    else:
        role = sql_quries.get_user_role(username=user)
        if role == None:
            st.warning('❌ User name found but not stored in database')
        else:
            dict_ = sql_quries.get_name_and_department_from_student_or_faculty_table(table=role, username=user)
            dict_['role'] = role
            st.markdown("<h5 style='color: yellowgreen;'>Library Card Details</h5>", unsafe_allow_html=True)
            st.dataframe(data=dict_)
            currently_all_issued_books = sql_quries.get_borrowed_books(username=user)
            # st.success(currently_all_issued_books)
            st.markdown("<h5 style='color: yellowgreen;'>Currently Borrowed Books</h5>", unsafe_allow_html=True)
            st.dataframe(currently_all_issued_books)

def return_issued_book(librarian_username):
    st.header('Return Book')
    book_return_checkbox = st.radio(label='Get User', options=['Select', 'Not Select'], index=1)
    # book_return_checkbox = st.checkbox('Return Book')
    # if 'load_state' not in st.session_state:
    #     st.session_state.load_state = False
    # if book_return_checkbox or st.session_state.load_state:
    if book_return_checkbox == 'Select':
        st.markdown("<h4 style='color: yellowgreen;'>Scan Library Card QR from pop up camera</h4>", unsafe_allow_html=True)
        user = get_username_from_QR("Show QR on Library Card : Book Return")
        if user == None:
            st.warning('No User Found')
        else:
            role = sql_quries.get_user_role(username=user)
            if role == None:
                st.warning('❌ User name found but not stored in database')
            else:
                curr_book_isbn = get_book_isbn_from_QR("Show QR on Book : Book Return")
                borrowd_book_dict = sql_quries.get_borrowed_books(username=user)
                # st.write(borrowd_book_dict)
                if curr_book_isbn not in borrowd_book_dict.keys():
                    st.warning(f'This Book(ISBN : {curr_book_isbn}) is not borrowed by this user({user}).')
                else:
                    days_borrowed = borrowd_book_dict[curr_book_isbn]['days_borrowed']
                    fine_days = 0
                    fine_amount = 0
                    if days_borrowed<=10:
                        st.success(f'Fine for {fine_days} days and fine amount Rs.{fine_amount}')
                        sql_quries.update_transaction(book_isbn=curr_book_isbn, borrower_username=user,
                                                      librarian_username=librarian_username)
                    else:
                        fine_days = days_borrowed - 10
                        fine_amount = fine_days*2
                        st.warning(f'Fine for {fine_days} days and fine amount Rs.{fine_amount}')
                        sql_quries.update_transaction(book_isbn=curr_book_isbn, borrower_username=user, librarian_username=librarian_username)
                        pass
                    # submitting_fine(fine_amount=fine_amount,curr_book_isbn=curr_book_isbn,user=user,librarian_username=librarian_username)

                    # fine_submitted_click = st.button(label=f'Fine Rs.{fine_amount} submitted')
                    # if fine_submitted_click:
                    #     sql_quries.update_transaction(book_isbn=curr_book_isbn, borrower_username=user,
                    #                                   librarian_username=librarian_username)

                    # Use streamlit.hash() to prevent the page from reloading when the button is clicked
                    # fine_submitted_click = st.radio(label='Fine Submitted ?', options=['NO', 'YES'], index=0)
                    # if fine_submitted_click == 'YES':
                    #     sql_quries.update_transaction(book_isbn=curr_book_isbn, borrower_username=user,
                    #                                   librarian_username=librarian_username)
                pass
        pass


import streamlit as st


def get_borrowed_books(username):
    return sql_quries.get_borrowed_books(username)


def get_user_role(username):
    return sql_quries.get_user_role(username)

"""
def return_issued_book(librarian_username):
    st.header('Return Book')
    book_return_checkbox = st.checkbox('Return Book')
    if 'load_state' not in st.session_state:
        st.session_state.load_state = False
    if book_return_checkbox or st.session_state.load_state:
        st.markdown("<h4 style='color: yellowgreen;'>Scan Library Card QR from pop up camera</h4>", unsafe_allow_html=True)
        user = get_username_from_QR("Show QR on Library Card : Book Return")
        if user == None:
            st.warning('No User Found')
        else:
            role = get_user_role(user)
            if role == None:
                st.warning('❌ User name found but not stored in database')
            else:
                curr_book_isbn = get_book_isbn_from_QR("Show QR on Book : Book Return")
                borrowd_book_dict = get_borrowed_books(user)
                # st.write(borrowd_book_dict)
                if curr_book_isbn not in borrowd_book_dict.keys():
                    st.warning(f'This Book(ISBN : {curr_book_isbn}) is not borrowed by this user({user}).')
                else:
                    days_borrowed = borrowd_book_dict[curr_book_isbn]['days_borrowed']
                    fine_days = 0
                    fine_amount = 0
                    if days_borrowed>10:
                        fine_days = days_borrowed - 10
                        fine_amount = fine_days*2
                        st.warning(f'Fine for {fine_days} days and fine amount Rs.{fine_amount}')
                        pass

                    # Use streamlit.hash() to prevent the page from reloading when the button is clicked
                    fine_submitted_click = st.radio(label='Fine Submitted ?', options=['NO', 'YES'], index=0)
                    if fine_submitted_click == 'YES':
                        sql_quries.update_transaction(book_isbn=curr_book_isbn, borrower_username=user,
                                                      librarian_username=librarian_username)
"""
"""

"""
"""

def return_issued_book(librarian_username):
    with st.form(key='return_form'):
        st.markdown("<h4 style='color: yellowgreen;'>Scan Library Card QR from pop up camera</h4>", unsafe_allow_html=True)
        user = get_username_from_QR("Show QR on Library Card : Book Return")
        if user == None:
            st.warning('No User Found')
        else:
            role = sql_quries.get_user_role(username=user)
            if role == None:
                st.warning('❌ User name found but not stored in database')
            else:
                curr_book_isbn = get_book_isbn_from_QR("Show QR on Book : Book Return")
                borrowd_book_dict = sql_quries.get_borrowed_books(username=user)
                # st.write(borrowd_book_dict)
                if curr_book_isbn not in borrowd_book_dict.keys():
                    st.warning(f'This Book(ISBN : {curr_book_isbn}) is not borrowed by this user({user}).')
                else:
                    days_borrowed = borrowd_book_dict[curr_book_isbn]['days_borrowed']
                    fine_days = 0
                    fine_amount = 0
                    if days_borrowed>10:
                        fine_days = days_borrowed - 10
                        fine_amount = fine_days*2
                        st.warning(f'Fine for {fine_days} days and fine amount Rs.{fine_amount}')
                        pass
                    # submitting_fine(fine_amount=fine_amount,curr_book_isbn=curr_book_isbn,user=user,librarian_username=librarian_username)
                    fine_submitted_click = st.radio(label='Fine Submitted ?',options=['NO','YES'],index=0)
                    if fine_submitted_click == 'YES':
                        sql_quries.update_transaction(book_isbn=curr_book_isbn, borrower_username=user,
                                                      librarian_username=librarian_username)
                pass
        pass
"""