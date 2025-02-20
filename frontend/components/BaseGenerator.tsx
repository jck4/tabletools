import React, { useEffect, useState } from 'react';
import { View, Text, Pressable, ActivityIndicator } from 'react-native';

interface BaseGeneratorProps {
  title: string;
  fetchFunction: () => Promise<any>; // Fetches from API
  buttonColor?: string;
  setGeneratedContent: (content: any) => void;
  storedContent: any | null;
  renderContent: (data: any) => JSX.Element; // Each generator will provide this
}

export default function BaseGenerator({ 
  title, 
  fetchFunction, 
  buttonColor = "bg-blue-500", 
  setGeneratedContent, 
  storedContent, 
  renderContent
}: BaseGeneratorProps) {
  const [generatedContent, setLocalGeneratedContent] = useState<any | null>(storedContent);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLocalGeneratedContent(storedContent); // Restore content when switching
  }, [storedContent]);

  const handleGenerate = async () => {
    setLoading(true);
    setError(null);

    try {
      const newContent = await fetchFunction(); // Call API
      setLocalGeneratedContent(newContent);
      setGeneratedContent(newContent);
    } catch (err) {
      setError("Failed to generate content.");
      console.error("Error fetching data:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <View>
      {/* Generate Button */}
      <Pressable onPress={handleGenerate} className={`${buttonColor} px-6 py-3 rounded-full self-center`}>
        <Text className="text-white text-lg font-bold">Generate {title}</Text>
      </Pressable>

      {/* Loading Indicator */}
      {loading && <ActivityIndicator size="large" color="#0000ff" className="mt-4" />}

      {/* Error Message */}
      {error && <Text className="text-red-500 mt-4">{error}</Text>}

      {/* Render JSON Response as Custom Component */}
      {generatedContent && renderContent(generatedContent)}
    </View>
  );
}
