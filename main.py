from PIL import Image, ImageDraw, ImageFont

# Open the background image
# background = Image.open("library.jpg")
#
# # Get a drawing context for the image
# draw = ImageDraw.Draw(background)
#
# # Load a bold font for text
# font = ImageFont.truetype("arialbd.ttf", 45)
# header_font = ImageFont.truetype("arialbd.ttf", 60)
#
# # Define the student information
# info_dict = {
#     "Name:": "Sukriti Guin",
#     "Contact Number:": "9372725189",
#     "Parent Number:": "8596745263",
#     "Email:": "2811guin@gmail.com",
#     "Department:": "ECE",
#     "Admission Year:": 2020,
#     "Graduation Year:": 2024,
#     "Current Address:": "Nirol Katwa 713140",
#     "Address:": "Nirol Katwa 713140",
#     "Username:" : "sukritiguin-student-ece-2020-2024-5189"
# }
#
# # Set fill color to white and outline color to black
# fill_color = "white"
# outline_color = "black"
#
# # Set fill color for "Name:" text to green
# name_fill_color = "green"
#
# # Draw student information on the image with bold text
# x = 100
# y = 100
#
# header_text = "Netaji Subhash Engineering College"
# draw.text((x, y), header_text, font=header_font, fill='yellow', outline=outline_color)
# y += 120
#
# for key, value in info_dict.items():
#     draw.text((x, y), key, font=font, fill=name_fill_color, outline=outline_color)
#     text_width, text_height = draw.textsize(str(key), font)
#     draw.text((x + text_width + 20, y), str(value), font=font, fill=fill_color, outline=outline_color)
#     y += 100
#
# # Load the college logo image
# logo = Image.open("college_logo.png")
#
# # Resize the logo image to desired size
# logo = logo.resize((200, 200))
#
# # Paste the logo image at the top right corner of the background image
# background.paste(logo, (background.width - logo.width, 0))
#
# # Load the librarian signature image
# librarian_signature = Image.open("librarian_signature-removebg-preview.png")
#
# # Resize the librarian signature image to desired size
# librarian_signature = librarian_signature.resize((200, 100))
#
# # Paste the librarian signature image at the bottom right corner of the background image
# background.paste(librarian_signature, (background.width - librarian_signature.width, background.height - librarian_signature.height))
#
#
# # Show the image
# background.show()
#
# background.save('student_info.png')


def create_library_card(info_dict):
    # Open the background image
    background = Image.open("library.jpg")

    # Get a drawing context for the image
    draw = ImageDraw.Draw(background)

    # Load a bold font for text
    font = ImageFont.truetype("arialbd.ttf", 45)
    header_font = ImageFont.truetype("arialbd.ttf", 60)

    # Define the student information
    # info_dict = {
    #     "Name:": "Sukriti Guin",
    #     "Contact Number:": "9372725189",
    #     "Parent Number:": "8596745263",
    #     "Email:": "2811guin@gmail.com",
    #     "Department:": "ECE",
    #     "Admission Year:": 2020,
    #     "Graduation Year:": 2024,
    #     "Current Address:": "Nirol Katwa 713140",
    #     "Address:": "Nirol Katwa 713140",
    #     "Username:": "sukritiguin-student-ece-2020-2024-5189"
    # }

    # Set fill color to white and outline color to black
    fill_color = "white"
    outline_color = "black"

    # Set fill color for "Name:" text to green
    name_fill_color = "green"

    # Draw student information on the image with bold text
    x = 100
    y = 100

    header_text = "Netaji Subhash Engineering College"
    draw.text((x, y), header_text, font=header_font, fill='yellow', outline=outline_color)
    y += 120

    for key, value in info_dict.items():
        draw.text((x, y), key, font=font, fill=name_fill_color, outline=outline_color)
        text_width, text_height = draw.textsize(str(key), font)
        draw.text((x + text_width + 20, y), str(value), font=font, fill=fill_color, outline=outline_color)
        y += 100

    # Load the college logo image
    logo = Image.open("college_logo.png")

    # Resize the logo image to desired size
    logo = logo.resize((200, 200))

    # Paste the logo image at the top right corner of the background image
    background.paste(logo, (background.width - logo.width, 0))

    # Load the librarian signature image
    librarian_signature = Image.open("librarian_signature-removebg-preview.png")

    # Resize the librarian signature image to desired size
    librarian_signature = librarian_signature.resize((200, 100))

    # Paste the librarian signature image at the bottom right corner of the background image
    background.paste(librarian_signature,
                     (background.width - librarian_signature.width, background.height - librarian_signature.height))

    return background