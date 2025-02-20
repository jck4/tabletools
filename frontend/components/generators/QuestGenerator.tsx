import React from 'react';
import { View, Text } from 'react-native';
import BaseGenerator from '../BaseGenerator';
import { getQuest } from '../../lib/api';

export default function QuestGenerator({ 
  setGeneratedContent, 
  storedContent 
}: { setGeneratedContent: (content: any) => void; storedContent: any | null }) {

  const renderQuest = (data: any) => (
    <View className="mt-4 p-4 bg-purple-200 rounded-lg shadow">
      <Text className="text-xl font-bold">{data.title}</Text>
      <Text className="text-gray-700 italic">{data.setting}</Text>
      <Text className="text-sm text-gray-600 mt-2">Hook: {data.hook}</Text>
      {data.complications && (
        <View className="mt-2">
          <Text className="font-bold">Complications:</Text>
          {data.complications.map((comp: string, index: number) => (
            <Text key={index} className="text-purple-700">• {comp}</Text>
          ))}
        </View>
      )}
      {data.potential_outcomes && (
        <View className="mt-2">
          <Text className="font-bold">Potential Outcomes:</Text>
          {data.potential_outcomes.map((outcome: string, index: number) => (
            <Text key={index} className="text-purple-700">• {outcome}</Text>
          ))}
        </View>
      )}
    </View>
  );

  return <BaseGenerator 
    title="Quest" 
    fetchFunction={getQuest} 
    buttonColor="bg-purple-500" 
    setGeneratedContent={setGeneratedContent} 
    storedContent={storedContent} 
    renderContent={renderQuest}
  />;
}
