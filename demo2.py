# from barcode import EAN13
# from barcode.writer import ImageWriter
# from PIL import Image, ImageDraw
#
# # Generate barcode image using python-barcode library
# code = '123456789852'
# ean = EAN13(code, writer=ImageWriter())
# filename = ean.save('barcode.png')
#
# # Create scratch-off layer using PIL library
# barcode_image = Image.open('barcode.png')
# width, height = barcode_image.size
# scratch_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
# draw = ImageDraw.Draw(scratch_layer)
# scratch_color = (255, 255, 255, 255)
# scratch_rect = (0, 0, width, height)
# draw.rectangle(scratch_rect, fill=scratch_color)
# scratch_filename = 'scratch_layer.png'
# scratch_layer.save(scratch_filename)
#
# # Convert barcode image and scratch-off layer to a common mode
# barcode_image = barcode_image.convert('RGBA')
# scratch_layer = scratch_layer.convert('RGBA')
#
# # Perform alpha composite
# composite = Image.alpha_composite(barcode_image, scratch_layer)
#
# # Save the final image with scratch-off layer
# composite.save('barcode_with_scratch.png')




