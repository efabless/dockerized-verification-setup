all: build
build:
	docker build -t efabless/dv_setup:latest . | tee build.log