# import json
#
# from PIL import Image
#
import json
import cv2
from pyzbar import pyzbar

def get_username_from_QR():
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
        cv2.imshow("QR Code Reader", frame)

        if barcodes:break

        # Exit loop on 'q' key press
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release camera and close all OpenCV windows
    cap.release()
    cv2.destroyAllWindows()
    return username


def get_book_isbn_from_QR():
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
        cv2.imshow("QR Code Reader", frame)

        if barcodes:break

        # Exit loop on 'q' key press
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release camera and close all OpenCV windows
    cap.release()
    cv2.destroyAllWindows()
    return isbn

import psycopg2


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



# print(get_book_isbn_from_QR())

# print(get_book_details('9780136042594'))




#
#
#
# user = get_username_from_QR()
# print('No user found!!!' if user==None else user)


"""
import sql_quries
sql_quries.store_username_password('johndoe-librarian-2023-04-09-3210','johndoe-librarian')



from PIL import Image, ImageDraw, ImageFont

def write_bellow_center_image(image,caption):
    # Open the image
    # image = Image.open("example.jpg")

    # Get the image size
    image_width, image_height = image.size

    # Create an ImageDraw object to draw on the image
    draw = ImageDraw.Draw(image)

    # Define the caption text
    # caption = "Hello, ChatGPT!"

    # Define the font style, size, and color
    font = ImageFont.truetype("arial.ttf", 24)  # Specify the font and its size
    text_color = (0, 0, 0)  # White color
    text_color = int(text_color[0] << 16 | text_color[1] << 8 | text_color[2])

    # Get the size of the caption text
    caption_width, caption_height = draw.textsize(caption, font)

    # Calculate the position of the caption at the bottom center of the image
    x = (image_width - caption_width) // 2  # Centered horizontally
    y = image_height - caption_height - 10  # 10 pixels above the bottom edge

    # Add the caption to the image
    draw.text((x, y), caption, fill=text_color, font=font)

    print("type of image",type(image))

    return image

"""