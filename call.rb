require './ImageCropAndJoiner.rb'

p "start"

p ImageCropAndJoiner.img_size("target.jpg")

ImageCropAndJoiner.crop_img("target.jpg","UNKO")

ImageCropAndJoiner.join_img("./","UNKO","out22222.png")

 p "end"