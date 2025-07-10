FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl unzip openjdk-17-jdk nodejs npm git zip wget \
    build-essential libc6 libstdc++6 lib32z1 libbz2-1.0 libncurses5 \
    libtinfo5 libx11-6 libgl1-mesa-glx

# Set Android SDK environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

# Download and install Android SDK command line tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip sdk.zip -d cmdline-tools && \
    rm sdk.zip && \
    ln -s $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest

# Accept licenses and install required components
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses && \
    $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager \
      "platform-tools" \
      "platforms;android-34" \
      "build-tools;34.0.0"

# Install EAS CLI and Expo CLI
RUN npm install -g expo-cli eas-cli

WORKDIR /app
