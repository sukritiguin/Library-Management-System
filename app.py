import streamlit as st
import sql_quries, utilities

st.sidebar.header("Login Page")
entered_username = st.sidebar.text_input("Enter Username : ")
entered_password = st.sidebar.text_input("Enter Password : ",type='password')



if st.sidebar.checkbox("Validate"):
    if sql_quries.validate_password(username=entered_username,entered_password=entered_password):
        user_role = sql_quries.get_user_role(username=entered_username)
        if user_role:
            user_role = user_role.capitalize()
            st.subheader("Hey, " + user_role)
            if sql_quries.is_librarian(entered_username):
                book_management, book_issue, book_return, show_library_card_details ,user_management = st.tabs(
                    ["Book Management", "Book Issue", "Book Return", "Show Library Card Details","User Management"]
                )

                with book_management:
                    st.subheader("Insert New Book")
                    utilities.create_new_book_form()
                    pass
                with book_issue:
                    st.header('Issue Book')
                    utilities.issue_book(entered_username)
                    pass
                with book_return:
                    utilities.return_issued_book(librarian_username=entered_username)
                    pass
                with show_library_card_details:
                    st.header('Show Library Card Details')
                    library_card_details_checkbox = st.checkbox('Show',value=False)
                    if library_card_details_checkbox:utilities.show_library_card_details()
                    library_card_details_checkbox = False
                    pass
                with user_management:
                    st.subheader("Create New User")
                    new_user_type = st.radio(label="User Type : ", options=['Student', 'Faculty'])
                    if new_user_type == 'Student':
                        utilities.create_new_student_form()
                    elif new_user_type == 'Faculty':
                        pass
        else:
            st.warning('User not stored in users table')
        pass
    else:
        st.header("Login Failed")

st.sidebar.header('-----------------------------------------')
if st.sidebar.checkbox("Show Library Card Details :"):
    st.header('Show Library Card Details')
    library_card_details_checkbox = st.checkbox('Show', value=False)
    if library_card_details_checkbox: utilities.show_library_card_details()
