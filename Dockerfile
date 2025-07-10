FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl unzip openjdk-17-jdk nodejs npm git zip wget \
    build-essential libc6 libstdc++6 lib32z1 libbz2-1.0 libncurses5 \
    libtinfo5 libx11-6 libgl1-mesa-glx

# Install Node.js v20 (clean installation)
RUN apt-get update && \
    apt-get remove -y nodejs libnode-dev && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Download and extract Android SDK command line tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    curl -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip cmdline-tools.zip -d tmp && \
    mkdir latest && \
    mv tmp/cmdline-tools/* latest/ && \
    rm -rf tmp cmdline-tools.zip

# Accept licenses and install SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager \
      "platform-tools" \
      "platforms;android-34" \
      "build-tools;34.0.0"

# Install EAS CLI and Expo CLI
RUN npm install -g expo-cli eas-cli

WORKDIR /app
