import base64

i=0
folder = 'imgs2process'
#for i in range(1,8):
while True:
    filein=f"{folder}\img{i}.png"
    
    with open(filein, "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read())

    with open(filein+".txt", "a") as out_file:
        out_file.write('''<img src="data:image/png;base64,'''+encoded_string.decode("utf-8")+'''"/>''')

    i+=1    
