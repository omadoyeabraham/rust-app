# Rust Nano S Application 

A simple application that receives a message, displays it, and requests user approval to sign. Can also display an example menu.

## Building

### Prerequisites

This project will try to build [nanos-secure-sdk](https://github.com/LedgerHQ/nanos-secure-sdk), so you will need:

#### Linux

1. A standard ARM gcc (`sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi`)
2. Cross compilation headers (`sudo apt-get install gcc-multilib`)
2. Python3 (`sudo apt-get install python3`)
3. Pip3 (`sudo apt-get install python3-pip`)

#### Windows

1. install [Clang](http://releases.llvm.org/download.html)
2. install an [ARM GCC toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads)
3. [Python](https://www.python.org/)


Other things you will need:
- [Cargo-ledger](https://github.com/LedgerHQ/cargo-ledger.git)
- [Speculos](https://github.com/LedgerHQ/speculos) (make sure you add speculos.py to your PATH by running `export PATH=/path/to/speculos:$PATH`)
- The correct target for rustc: `rustup target add thumbv6m-none-eabi`

You can build on either Windows or Linux with a simple `cargo build` or `cargo build --release`.
It currently builds on stable.

## Loading

You can use [cargo-ledger](https://github.com/LedgerHQ/cargo-ledger.git) which builds, outputs a `hex` file and a manifest file for `ledgerctl`, and loads it on a device in a single `cargo ledger load` command in your app directory.

Some options of the manifest file can be configured directly in `Cargo.toml` under a custom section:

```yaml
[package.metadata.nanos]
curve = "secp256k1"
flags = "0x40"
icon = "btc.gif"
```

## Testing

One can for example use [speculos](https://github.com/LedgerHQ/speculos)

`cargo run --release` defaults to running speculos on the generated binary with the appropriate flags, if `speculos.py` is in your `PATH`.

There is a small test script that sends some of the available commands in `test/test_cmds.py`, or raw APDUs that can be used with `ledgerctl`.


## Setting everything up with docker
You can also use the provided Dockerfile and docker-compose setup instead of installing all the various dependencies on your local machine. This helps save a lot of time battling dependency issues across various operating systems and system setups.

Follow the steps below to get the app up and running using a docker container:

1. Pull all the dependencies and build the application image using
   
    ```
    docker-compose up --build
    ```

2. Next, run the following command to create a temporary container off the image, and immediately access the containers command line:

    ```
    docker-compose run --rm rust_nano_s_app
    ```

3. As per the documentation above, run the application using:

    ```
    cargo run --release
    ```