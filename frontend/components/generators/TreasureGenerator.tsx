import React from 'react';
import { View, Text } from 'react-native';
import BaseGenerator from '../BaseGenerator';
import { getTreasure } from '../../lib/api';

export default function TreasureGenerator({ 
  setGeneratedContent, 
  storedContent 
}: { setGeneratedContent: (content: any) => void; storedContent: any | null }) {

  const renderTreasure = (data: any) => (
    <View className="mt-4 p-4 bg-green-200 rounded-lg shadow">
      <Text className="text-xl font-bold">{data.name}</Text>
      <Text className="text-gray-700 italic">Type: {data.treasure_type} | Rarity: {data.rarity}</Text>
      <Text className="text-sm text-gray-600 mt-2">Description: {data.description}</Text>
      {data.properties && (
        <View className="mt-2">
          <Text className="font-bold">Properties:</Text>
          {data.properties.map((prop: string, index: number) => (
            <Text key={index} className="text-green-700">• {prop}</Text>
          ))}
        </View>
      )}
    </View>
  );

  return <BaseGenerator 
    title="Treasure" 
    fetchFunction={getTreasure} 
    buttonColor="bg-green-500" 
    setGeneratedContent={setGeneratedContent} 
    storedContent={storedContent} 
    renderContent={renderTreasure}
  />;
}
