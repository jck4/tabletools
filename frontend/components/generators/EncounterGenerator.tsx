import React from 'react';
import { View, Text } from 'react-native';
import BaseGenerator from '../BaseGenerator';
import { getEncounter } from '../../lib/api';

export default function EncounterGenerator({ 
  setGeneratedContent, 
  storedContent 
}: { setGeneratedContent: (content: any) => void; storedContent: any | null }) {

  const renderEncounter = (data: any) => (
    <View className="mt-4 p-4 bg-green-200 rounded-lg shadow">
      <Text className="text-xl font-bold">{data.title}</Text>
      <Text className="text-gray-700 italic">{data.setting}</Text>

      {/* Factions */}
      {data.factions && data.factions.length > 0 && (
        <View className="mt-2">
          <Text className="text-lg font-bold">Factions:</Text>
          {data.factions.map((faction: any, index: number) => (
            <Text key={index} className="text-gray-600">
              ⚔️ {faction.name} - {faction.description}
            </Text>
          ))}
        </View>
      )}

      {/* Clues */}
      {data.clues && data.clues.length > 0 && (
        <View className="mt-2">
          <Text className="text-lg font-bold">Clues:</Text>
          {data.clues.map((clue: string, index: number) => (
            <Text key={index} className="text-gray-600">🔍 {clue}</Text>
          ))}
        </View>
      )}

      {/* Environmental Hazards */}
      {data.environmental_hazards && data.environmental_hazards.length > 0 && (
        <View className="mt-2">
          <Text className="text-lg font-bold">Hazards:</Text>
          {data.environmental_hazards.map((hazard: string, index: number) => (
            <Text key={index} className="text-red-600">⚠️ {hazard}</Text>
          ))}
        </View>
      )}
    </View>
  );

  return <BaseGenerator 
    title="Encounter" 
    fetchFunction={getEncounter} 
    buttonColor="bg-green-500" 
    setGeneratedContent={setGeneratedContent} 
    storedContent={storedContent} 
    renderContent={renderEncounter}
  />;
}
