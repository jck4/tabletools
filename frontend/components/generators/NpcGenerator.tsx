import React from 'react';
import { View, Text } from 'react-native';
import BaseGenerator from '../BaseGenerator';
import { getNpc } from '../../lib/api';

export default function NpcGenerator({ 
  setGeneratedContent, 
  storedContent 
}: { setGeneratedContent: (content: any) => void; storedContent: any | null }) {

  const renderNpc = (data: any) => (
    <View className="mt-4 p-4 bg-blue-200 rounded-lg shadow">
      <Text className="text-xl font-bold">{data.name}</Text>
      <Text className="text-gray-700 italic">
        {data.race} – {data.occupation}
      </Text>
      <Text className="text-sm text-gray-600 mt-2">Background: {data.background}</Text>
      {data.personality_traits && (
        <View className="mt-2">
          <Text className="font-bold">Personality Traits:</Text>
          {data.personality_traits.map((trait: string, index: number) => (
            <Text key={index} className="text-blue-700">• {trait}</Text>
          ))}
        </View>
      )}
      {data.quirks && (
        <View className="mt-2">
          <Text className="font-bold">Quirks:</Text>
          {data.quirks.map((quirk: string, index: number) => (
            <Text key={index} className="text-blue-700">• {quirk}</Text>
          ))}
        </View>
      )}
    </View>
  );

  return <BaseGenerator 
    title="NPC" 
    fetchFunction={getNpc} 
    buttonColor="bg-blue-500" 
    setGeneratedContent={setGeneratedContent} 
    storedContent={storedContent} 
    renderContent={renderNpc}
  />;
}
