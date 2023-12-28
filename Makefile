PROJECT_NAME := enver
VERSION := $(shell go run main.go -v)
PACKAGE_NAME := $(PROJECT_NAME)_$(VERSION)
MAINTAINER := Reza Behzadan <rbehzadan@gmail.com>
DESCRIPTION := Simple program to evaluate .env file before running the main app
BUILD_DIR := build

LDFLAGS := -ldflags="-s -w"

run:
	go run main.go

build:
	mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 go build $(LDFLAGS) -o $(BUILD_DIR)/$(PROJECT_NAME) main.go

win64:
	mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(PROJECT_NAME)_win64.exe main.go

win32:
	mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 GOOS=windows GOARCH=386 go build $(LDFLAGS) -o $(BUILD_DIR)/$(PROJECT_NAME)_win32.exe main.go

arm6:
	mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build $(LDFLAGS) -o $(BUILD_DIR)/$(PROJECT_NAME)_arm6 main.go

arm7:
	mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build $(LDFLAGS) -o $(BUILD_DIR)/$(PROJECT_NAME)_arm7 main.go

arm64:
	mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(PROJECT_NAME)_arm64 main.go

install: build
	@echo "Installing $(PROJECT_NAME)"
	@mkdir -p $(DESTDIR)/usr/local/bin
	@cp $(BUILD_DIR)/$(PROJECT_NAME) $(DESTDIR)/usr/local/bin/$(PROJECT_NAME)
	@echo "$(PROJECT_NAME) installed successfully to $(DESTDIR)/usr/local/bin"

tar: build
	mkdir -p $(BUILD_DIR)/$(PACKAGE_NAME)
	cd $(BUILD_DIR)/$(PACKAGE_NAME)
	cp $(PROJECT_NAME) $(PACKAGE_NAME)
	tar -czvf $(PACKAGE_NAME).tar.gz $(PACKAGE_NAME)
	rm -rf $(PACKAGE_NAME)
	cd ..

deb: build
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR)
	mkdir -p $(PACKAGE_NAME)/DEBIAN
	mkdir -p $(PACKAGE_NAME)/usr/bin
	cp $(PROJECT_NAME) $(PACKAGE_NAME)/usr/bin
	echo -e "Package: $(PROJECT_NAME)\nVersion: $(VERSION)\nArchitecture: amd64\nMaintainer: $(MAINTAINER)\nDescription: $(DESCRIPTION)" > $(PACKAGE_NAME)/DEBIAN/control
	dpkg-deb --build $(PACKAGE_NAME)
	rm -r $(PACKAGE_NAME)
	cd ..

clean:
	rm -rf $(BUILD_DIR)

