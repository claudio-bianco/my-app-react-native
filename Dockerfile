FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    curl unzip openjdk-17-jdk nodejs npm git zip \
    android-sdk adb wget build-essential \
    && apt-get clean

# Set environment variables for Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

# Install Android SDK command line tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O sdk-tools.zip && \
    unzip sdk-tools.zip -d latest && rm sdk-tools.zip

# Accept licenses and install platforms
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Install Expo and EAS CLI globally
RUN npm install -g expo-cli eas-cli

WORKDIR /app
