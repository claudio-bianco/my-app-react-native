# Base image with Android SDK, JDK 17, Node.js
FROM ghcr.io/cirruslabs/flutter:edge-android

# Install Node.js (adjust version as needed)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Expo and EAS CLI
RUN npm install -g expo-cli eas-cli

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# Set working directory
WORKDIR /app
