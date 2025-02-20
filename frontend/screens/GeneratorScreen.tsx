import React, { useState } from 'react';
import { SafeAreaView, View, Text, Pressable, ScrollView, ImageBackground } from 'react-native';
import EncounterGenerator from '../components/generators/EncounterGenerator';
import TrapGenerator from '../components/generators/TrapGenerator';
import QuestGenerator from 'components/generators/QuestGenerator';
import NPCGenerator from 'components/generators/NpcGenerator';
import TreasureGenerator from 'components/generators/TreasureGenerator';

// Import the background image
const image = require('../assets/bg.jpg');

// Register all generators
const generatorComponents: Record<
  string,
  React.FC<{ setGeneratedContent: (content: any) => void; storedContent: any | null }>
> = {
  Encounter: EncounterGenerator,
  Trap: TrapGenerator,
  Quest: QuestGenerator,
  Npc: NPCGenerator,
  Treasure: TreasureGenerator,
};

export default function GeneratorScreen() {
  const generatorKeys = Object.keys(generatorComponents);
  const [selectedGenerator, setSelectedGenerator] = useState<string>(generatorKeys[0]);
  const [generatedContent, setGeneratedContent] = useState<Record<string, any | null>>({});

  const handleSetGeneratedContent = (generatorName: string, content: any) => {
    setGeneratedContent((prev) => ({ ...prev, [generatorName]: content }));
  };

  const SelectedGeneratorComponent = generatorComponents[selectedGenerator];

  return (
    <SafeAreaView className="flex-1">
      <ImageBackground source={image} resizeMode="cover" className="flex-1">
        {/* Semi-transparent overlay for better readability */}
        <View className="absolute inset-0 bg-black opacity-40" />

        <ScrollView contentContainerStyle={{ flexGrow: 1 }} className="p-6">
          {/* Generator Type Selector */}
          <View className="flex-row flex-wrap justify-center mb-8">
            {generatorKeys.map((key) => (
              <Pressable
                key={key}
                onPress={() => setSelectedGenerator(key)}
                className={`px-4 py-2 rounded-full mx-2 my-2 ${
                  selectedGenerator === key ? 'bg-green-500' : 'bg-gray-400'
                } shadow-md`}
              >
                <Text className="text-white text-lg font-bold">{key}</Text>
              </Pressable>
            ))}
          </View>

          {/* Render Selected Generator */}
          <View className="p-6 bg-white rounded-xl shadow-2xl mx-auto max-w-md">
            <SelectedGeneratorComponent
              setGeneratedContent={(content) => handleSetGeneratedContent(selectedGenerator, content)}
              storedContent={generatedContent[selectedGenerator] || null}
            />
          </View>
        </ScrollView>
      </ImageBackground>
    </SafeAreaView>
  );
}
