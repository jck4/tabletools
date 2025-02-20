import React from 'react';
import { View, Text } from 'react-native';
import BaseGenerator from '../BaseGenerator';
import { getTrap } from '../../lib/api';

export default function TrapGenerator({ 
  setGeneratedContent, 
  storedContent 
}: { setGeneratedContent: (content: any) => void; storedContent: any | null }) {

  const renderTrap = (data: any) => (
    <View className="mt-4 p-4 bg-red-200 rounded-lg shadow">
      <Text className="text-xl font-bold">{data.name}</Text>
      <Text className="text-gray-700 italic">{data.location}</Text>

      {/* Trap Type */}
      <Text className="text-sm text-gray-600 mt-2">🛠️ Type: {data.trap_type}</Text>

      {/* Trigger */}
      <Text className="text-sm text-gray-600">⚡ Trigger: {data.trigger}</Text>

      {/* Mechanism */}
      <Text className="text-sm text-gray-600">⚙️ Mechanism: {data.mechanism}</Text>

      {/* Effects */}
      {data.effects && (
        <View className="mt-2">
          <Text className="text-lg font-bold">Effects:</Text>
          {data.effects.map((effect: string, index: number) => (
            <Text key={index} className="text-red-600">💥 {effect}</Text>
          ))}
        </View>
      )}

      {/* Disarm Info */}
      <Text className="text-sm text-blue-600 mt-2">
        🛡️ Disarm Check: {data.disarm_check} (DC {data.disarm_difficulty})
      </Text>
    </View>
  );

  return <BaseGenerator 
    title="Trap" 
    fetchFunction={getTrap} 
    buttonColor="bg-red-500" 
    setGeneratedContent={setGeneratedContent} 
    storedContent={storedContent} 
    renderContent={renderTrap}
  />;
}
