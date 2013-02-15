require 'rubygems'
require 'RMagick'

CUT_IMG_WIDTH=256
CUT_IMG_HEIGHT=256
EXTENSION=".png"


class ImageCropAndJoiner
  def self.img_size(img_path)
  	# 対象の画像ファイルの読み込み
	img = Magick::Image.read(img_path).first
	#幅  columns
	#高さ rows
	rtnAry=[img.columns,img.rows] 
  end

  def self.crop_img(img_path,prefix)

	# 対象の画像ファイルの読み込み
	org_img = Magick::Image.read(img_path).first

	#分割するファイルの枚数を計算
	w_times=org_img.columns/CUT_IMG_WIDTH
	h_times=org_img.rows/CUT_IMG_HEIGHT+1

	#犀の目にファイルを分割
	h_tmp=0
	h_times.times do |i|
		w_tmp=0
		w_times.times do |j|
			#puts "#{i}-#{j} #{w_tmp}, #{h_tmp}"
			image = org_img.crop(w_tmp, h_tmp, CUT_IMG_WIDTH, CUT_IMG_HEIGHT)
			image.write("#{prefix}#{i}-#{j}#{EXTENSION}")

			w_tmp+=CUT_IMG_WIDTH
		end
		h_tmp+=CUT_IMG_HEIGHT
	end	
  end

  def self.join_img(imgs_dir_path,prefix,out_img_path)

  	#ファイルを取得する
	filelist=Dir.glob("#{imgs_dir_path}#{prefix}*#{EXTENSION}")
	filelist.sort! #一応ソート

	#縦のリストをつくる
	rowList=Array.new
	tmpList = Magick::ImageList.new
	row_marged_img_list=Magick::ImageList.new

	filelist.each do|k|
		#ファイルの行切り替わりチェック
		#行番号取得
		gyo=k.slice("#{imgs_dir_path}#{prefix}".length,k.index("-")-"#{imgs_dir_path}#{prefix}".length).to_i

		#puts "hennkou #{gyo} #{rowList.length}"
		
		#行が変わっている
		if gyo!=0 && gyo!=row_marged_img_list.length then
			#Listを追加する
			img = tmpList.append(false);
			row_marged_img_list<<img

			tmpList=Magick::ImageList.new
		end
		tmpList << Magick::Image.read(k).first
	end
	#最後の行の画像を結合
	img = tmpList.append(false);
	row_marged_img_list<<img

	#出力画像を生成
	out_img=row_marged_img_list.append(true);
	out_img.write(out_img_path)	
  end
end