BUILD_PATH = .build
BUILD_FLAGS = -c release --build-path $(BUILD_PATH)
EXECUTABLE=$(shell swift build $(BUILD_FLAGS) --show-bin-path)/swift-install
FAST_FLAGS = -Xcc -Ofast -Xswiftc -O

swift-install:
	swift build $(BUILD_FLAGS) $(FAST_FLAGS)
	mv $(EXECUTABLE) ./swift-install

clean:
	rm -frd .build
	rm -f swift-install
