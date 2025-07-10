FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl unzip openjdk-17-jdk nodejs npm git zip wget \
    build-essential libc6 libstdc++6 lib32z1 libbz2-1.0 libncurses5 \
    libtinfo5 libx11-6 libgl1-mesa-glx

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

# Install Android SDK Command Line Tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip sdk.zip -d latest && rm sdk.zip

# Accept licenses and install essential SDK components
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses && \
    $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager \
      "platform-tools" \
      "platforms;android-34" \
      "build-tools;34.0.0"

# Install Expo CLI and EAS CLI
RUN npm install -g expo-cli eas-cli

WORKDIR /app
