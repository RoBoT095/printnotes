FROM ghcr.io/cirruslabs/flutter:3.32.5 AS build

# Set up the working directory
WORKDIR /app

# Copy the project files into the container
COPY . .

# Install Android SDK and other dependencies for building APKs and AppImage
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
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

# Set Java 17 as the default version instead of 21
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1
RUN update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

# Ensure flutter is available and up-to-date
RUN flutter doctor --verbose

# Disable analytic reports
RUN flutter config --no-analytics

# Get all flutter dependencies
RUN flutter pub get

# Build the default APK
RUN flutter build apk --release

# Build the APKs for different ABIs (arm64-v8a, armeabi-v7a, x86_64)
RUN flutter build apk --release --split-per-abi

# Make output folder
RUN mkdir -p /app/output

# Move all files from build to output folder
RUN cp build/app/outputs/flutter-apk/. /app/output/

# The default working directory inside the container
CMD ["bash"]