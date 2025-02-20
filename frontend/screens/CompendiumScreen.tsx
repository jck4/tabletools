// screens/CompendiumScreen.tsx
import React from 'react';
import { ImageBackground, SafeAreaView, View, Text, Pressable } from 'react-native';
import { useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../App';

const image = require('../assets/bg.jpg');

export default function CompendiumScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();

  return (
    <SafeAreaView className="flex-1">
      <ImageBackground
        source={image}
        resizeMode="cover"
        className="flex-1 justify-center items-center"
      >
        <View className="p-6 bg-white shadow-lg rounded-xl max-w-md">
          <Text className="text-2xl font-bold text-blue-500 mb-4 text-center">
            Compendium (Coming Soon)
          </Text>
          <Text className="text-gray-600 text-center mb-6">
            This feature is under development. Check back later to view and manage your personal compendium.
          </Text>

        </View>
      </ImageBackground>
    </SafeAreaView>
  );
}
