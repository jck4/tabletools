import React from 'react';
import { View, Text } from 'react-native';

interface BaseCardProps {
  title: string;
  children: React.ReactNode; // Allows custom content inside
  footer?: string; // Optional footer for extra info
}

export default function BaseCard({ title, children, footer }: BaseCardProps) {
  return (
    <View className="mt-4 p-4 bg-gray-200 rounded-lg shadow">
      <Text className="text-xl font-bold">{title}</Text>
      <View className="mt-2">{children}</View>
      {footer && <Text className="text-sm text-gray-600 mt-2">{footer}</Text>}
    </View>
  );
}
