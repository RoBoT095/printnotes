FROM ghcr.io/cirruslabs/flutter:3.35.1 AS build

# Set up the working directory
WORKDIR /app/rpg/Programming/Github

# Copy the project files into the container
COPY . .

# Install Android SDK and other dependencies for building APKs and AppImage
RUN apt-get update && apt-get install -y \
    libglu1-mesa \
    libssl-dev \
    wget \
    unzip \
    bash \
    git \
    build-essential \
    cmake \
    clang \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    libcurl4-openssl-dev \
    python3-dev 

# Accept android licenses
RUN yes | flutter doctor --android-licenses

# Ensure flutter is available and up-to-date
RUN flutter doctor --verbose

# Disable analytic reports
RUN flutter config --no-analytics

# Get all flutter dependencies
RUN flutter pub get

# Remove WASM binaries as they are not needed
RUN dart run pdfrx:remove_wasm_modules

# Build the default APK
RUN flutter build apk --release

# Build the APKs for different ABIs (arm64-v8a, armeabi-v7a, x86_64)
RUN flutter build apk --release --split-per-abi

# Make output folder
RUN mkdir -p /app/rpg/Programming/Github/output

# Move all files from build to output folder
RUN cp -r build/app/outputs/flutter-apk/. /app/rpg/Programming/Github/output/

# The default working directory inside the container
CMD ["bash"]