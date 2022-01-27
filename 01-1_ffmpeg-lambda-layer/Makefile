clean: 
	rm -rf build

build: 
	mkdir -p build/layer/bin
	rm -rf build/ffmpeg*
	cd build && curl https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz | tar x
	mv build/ffmpeg*/ffmpeg build/ffmpeg*/ffprobe build/layer/bin