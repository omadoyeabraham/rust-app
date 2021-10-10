# The base rust image for the container
FROM rust:1.55

# Install Standard ARM GCC
RUN apt-get update && apt-get install -y gcc-arm-none-eabi binutils-arm-none-eabi

# Install cross compilation headers
RUN apt-get install -y gcc-multilib

# Install python3
RUN apt-get install -y python3

# Install cargo-ledger
RUN cargo install --git https://github.com/LedgerHQ/cargo-ledger

# Install speculos requirements
RUN apt-get install -y cmake gcc-arm-linux-gnueabihf libc6-dev-armhf-cross gdb-multiarch \
    python3-pyqt5 python3-construct python3-flask-restful python3-jsonschema \
    python3-mnemonic python3-pil python3-pyelftools python3-requests \
    qemu-user-static

# Install VNC support requirements for speculos
RUN apt-get install -y libvncserver-dev

# Install clang
RUN apt-get install clang -y --install-suggests

# cd to the root directory of the container
WORKDIR /

# Clone the speculos repository so it can be built
RUN git clone https://github.com/LedgerHQ/speculos.git

# cd into speculos directory
WORKDIR /speculos

# Build speculos (debug build). See https://speculos.ledger.com/installation/build.html if you do not want to use a debug build
RUN cmake -Bbuild -DCMAKE_BUILD_TYPE=Debug -H. -DWITH_VNC=1 \
    && make -C build/

# Add speculos to environment path
RUN echo "export PATH=/speculos/speculos.py:$PATH" >> ~/.bashrc

# use the nightly version of rust (needed because the nano S app uses some nightly rust features)
RUN rustup default nightly

# Setup the correct target for rustc
RUN rustup target add thumbv6m-none-eabi

# cd to the desired directory where the application code will be stored on the container
WORKDIR /usr/app

# Copy the source code from your local machine onto the docker container
COPY . usr/app