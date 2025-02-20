// Tabs.tsx
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import HomeScreen from '../screens/HomeScreen';
import CompendiumScreen from '../screens/CompendiumScreen';
import GeneratorScreen from '../screens/GeneratorScreen';
import { Ionicons } from '@expo/vector-icons';

const Tab = createBottomTabNavigator();

export default function Tabs() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        // Define icons for each tab based on route name
        tabBarIcon: ({ color, size }) => {
          let iconName: string;
          if (route.name === 'Home') {
            iconName = 'home';
          } else if (route.name === 'Compendium') {
            iconName = 'book';
          } else if (route.name === 'Generators') {
            iconName = 'construct';
          } else {
            iconName = 'ellipse';
          }
          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: 'tomato',
        tabBarInactiveTintColor: 'gray',
      })}
    >
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Compendium" component={CompendiumScreen} />
      <Tab.Screen name="Generators" component={GeneratorScreen} />
    </Tab.Navigator>
  );
}
