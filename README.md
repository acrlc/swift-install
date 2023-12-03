### Install swift package executables *swiftly* 

#### To build from source and run
```sh
cd swift-install && make
./swift-install
```
#### Usage
```sh
swift-install (or swift install) <optional package>

# install without specifying package path
swift-install

# install with package path
swift-install path/to/swift/package
```
#### Known Limitations
- requires environment variable `SWIFTINSTALL` to be exported
- supports installing binaries that match the name of the contained folder
