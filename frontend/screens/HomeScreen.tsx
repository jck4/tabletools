// screens/HomeScreen.tsx
import React from 'react';
import { ImageBackground, SafeAreaView, Text, View } from 'react-native';

// Use require() to load local images in React Native.
const image = require('../assets/bg.jpg');

export default function HomeScreen() {
  return (
    <SafeAreaView className="flex-1 bg-purple-900 justify-center items-center p-6">
      <ImageBackground
        source={image}
        resizeMode="cover"
        className="flex-1 w-full justify-center items-center"
      >
        {/* Main Card */}
        <View className="bg-white bg-opacity-70 p-4 rounded-lg">
          {/* Title */}
          <Text className="text-4xl font-bold text-center text-indigo-800 mb-4">
            TableTools
          </Text>

          {/* Description */}
          <Text className="text-lg text-center text-gray-900 mb-6">
            Enhance your tabletop RPG sessions! Create custom encounters, craft unique traps, and explore exciting tools.
          </Text>

          {/* Features List */}
          <View className="space-y-3">
            <Text className="text-base text-gray-800">
              ✅ Generate new encounters, traps, and items
            </Text>
            <Text className="text-base text-gray-800">
              ⏳ Save them to your personal compendium <Text className="italic">(coming soon)</Text>
            </Text>
            <Text className="text-base text-gray-800">
              ✅ Enhance storytelling with quick tools
            </Text>
          </View>

          {/* Note on pricing & future features */}
          <Text className="mt-4 text-center text-sm text-gray-600">
            All core features are free for now – premium tools and advanced features will be available later!
          </Text>
        </View>
      </ImageBackground>
    </SafeAreaView>
  );
}
