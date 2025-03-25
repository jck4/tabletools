import 'dart:math';

/// Service that provides various quick generators for RPG content
class QuickGeneratorService {
  static final Random _random = Random();
  
  // Name generators
  static final List<String> _maleFirstNames = [
    'Alaric', 'Baern', 'Cedric', 'Dorian', 'Eadric', 'Fendrel',
    'Gareth', 'Hadrian', 'Idris', 'Jareth', 'Keldorn', 'Lucan',
    'Magnus', 'Norvin', 'Orin', 'Percival', 'Quincy', 'Roland',
    'Seamus', 'Thaddeus', 'Ulric', 'Valen', 'Weston', 'Xavier'
  ];
  
  static final List<String> _femaleFirstNames = [
    'Adeline', 'Brenna', 'Cora', 'Delia', 'Elora', 'Freya',
    'Gwendolyn', 'Helena', 'Isolde', 'Jessa', 'Keira', 'Lyra',
    'Mira', 'Nessa', 'Ophelia', 'Piper', 'Quinn', 'Rowan',
    'Selene', 'Thea', 'Una', 'Vera', 'Willow', 'Yara'
  ];
  
  static final List<String> _lastNames = [
    'Ambershield', 'Blackwood', 'Crestfall', 'Dawnhammer', 'Emberforge',
    'Frostmantle', 'Goldheart', 'Highwind', 'Ironhide', 'Jadewalker',
    'Kingsley', 'Lightbringer', 'Moonshadow', 'Nightweaver', 'Oakenheel',
    'Proudmane', 'Quicksilver', 'Ravencrest', 'Silverthorn', 'Thorngage',
    'Underlook', 'Valesong', 'Wintermere', 'Wyvernshield'
  ];

  // Location generators
  static final List<String> _tavernPrefixes = [
    'The Dancing', 'The Prancing', 'The Slumbering', 'The Laughing', 'The Drunken',
    'The Sleeping', 'The Rusty', 'The Golden', 'The Silver', 'The Bronze',
    'The Broken', 'The Howling', 'The Leaping', 'The Lonely', 'The Wandering',
    'The Wild', 'The Crimson', 'The Black', 'The Green', 'The Blue'
  ];
  
  static final List<String> _tavernSuffixes = [
    'Dragon', 'Unicorn', 'Gryphon', 'Stag', 'Wolf',
    'Boar', 'Hare', 'Eagle', 'Tankard', 'Flagon',
    'Goblet', 'Mug', 'Barrel', 'Crown', 'Shield',
    'Sword', 'Hammer', 'Anvil', 'Lantern', 'Kettle'
  ];
  
  static final List<String> _townPrefixes = [
    'North', 'South', 'East', 'West', 'High', 'Low', 'Great', 'Little',
    'New', 'Old', 'Middle', 'Upper', 'Lower', 'Fair', 'Green',
    'Red', 'Black', 'White', 'Oak', 'Elm'
  ];
  
  static final List<String> _townSuffixes = [
    'shire', 'ford', 'bridge', 'hold', 'hollow', 'field', 'haven',
    'vale', 'town', 'stead', 'wood', 'grove', 'port', 'water', 'lake',
    'stone', 'mill', 'bury', 'ton', 'wick'
  ];

  // Treasure generators
  static final List<String> _adjectives = [
    'Ancient', 'Arcane', 'Blessed', 'Curious', 'Dusty', 'Enchanted',
    'Forgotten', 'Gleaming', 'Haunted', 'Illustrious', 'Mythical', 'Ornate',
    'Peculiar', 'Radiant', 'Ruined', 'Shimmering', 'Tarnished', 'Unusual',
    'Weathered', 'Wondrous'
  ];
  
  static final List<String> _items = [
    'Amulet', 'Bracelet', 'Compass', 'Dagger', 'Emblem', 'Flask',
    'Gloves', 'Helmet', 'Idol', 'Journal', 'Key', 'Lantern',
    'Map', 'Necklace', 'Orb', 'Pendant', 'Quill', 'Ring',
    'Scepter', 'Talisman'
  ];
  
  static final List<String> _materials = [
    'Adamantine', 'Bone', 'Crystal', 'Dragonscale', 'Ebony', 'Frosted Glass',
    'Gold', 'Hornwood', 'Iron', 'Jade', 'Kraken Hide', 'Leather',
    'Mithral', 'Nightwood', 'Obsidian', 'Platinum', 'Quicksilver', 'Ruby-encrusted',
    'Silver', 'Thunderwood'
  ];

  /// Generate a random name with gender option
  static String generateName({String gender = 'any'}) {
    String firstName;
    
    if (gender == 'male') {
      firstName = _maleFirstNames[_random.nextInt(_maleFirstNames.length)];
    } else if (gender == 'female') {
      firstName = _femaleFirstNames[_random.nextInt(_femaleFirstNames.length)];
    } else {
      // Random gender
      if (_random.nextBool()) {
        firstName = _maleFirstNames[_random.nextInt(_maleFirstNames.length)];
      } else {
        firstName = _femaleFirstNames[_random.nextInt(_femaleFirstNames.length)];
      }
    }
    
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    return '$firstName $lastName';
  }
  
  /// Generate a random tavern name
  static String generateTavernName() {
    final prefix = _tavernPrefixes[_random.nextInt(_tavernPrefixes.length)];
    final suffix = _tavernSuffixes[_random.nextInt(_tavernSuffixes.length)];
    return '$prefix $suffix';
  }
  
  /// Generate a random town name
  static String generateTownName() {
    // 50% chance of using a prefix
    final usePrefix = _random.nextBool();
    
    if (usePrefix) {
      final prefix = _townPrefixes[_random.nextInt(_townPrefixes.length)];
      final base = _getRandomBaseNamePart();
      return '$prefix$base';
    } else {
      final base = _getRandomBaseNamePart();
      final suffix = _townSuffixes[_random.nextInt(_townSuffixes.length)];
      return '$base$suffix';
    }
  }
  
  /// Generate a random treasure item
  static String generateTreasureItem() {
    final adjective = _adjectives[_random.nextInt(_adjectives.length)];
    final material = _materials[_random.nextInt(_materials.length)];
    final item = _items[_random.nextInt(_items.length)];
    
    // 50% chance to include the material
    if (_random.nextBool()) {
      return '$adjective $material $item';
    } else {
      return '$adjective $item';
    }
  }
  
  /// Helper to generate a random base for town names
  static String _getRandomBaseNamePart() {
    final baseParts = [
      'wood', 'field', 'water', 'river', 'lake',
      'hill', 'fall', 'dale', 'valley', 'glen',
      'rock', 'stone', 'brook', 'creek', 'ridge',
      'wind', 'haven', 'marsh', 'mist', 'shade'
    ];
    
    return baseParts[_random.nextInt(baseParts.length)];
  }
  
  /// Generate a random plot hook
  static String generatePlotHook() {
    final hooks = [
      "A mysterious stranger arrives seeking help with a cursed artifact.",
      "Local children have gone missing near the old forest.",
      "A noble's prized possession has been stolen under impossible circumstances.",
      "Strange lights have been seen in the abandoned mine.",
      "A prophecy foretells disaster unless an ancient ritual is performed.",
      "The town's water supply is slowly turning black.",
      "Animals in the region are behaving strangely and aggressively.",
      "A local tavern owner pleads for help with a ghost haunting the cellar.",
      "Someone is impersonating a high-ranking official.",
      "A long-sealed tomb has been broken into from the inside.",
      "Crops are failing, and the harvest festival is only weeks away.",
      "A traveling merchant seeks protection for a valuable and unusual cargo.",
      "Messages in an unknown language are appearing on walls overnight.",
      "A rival adventuring party has gone missing on a routine quest.",
      "A local elder remembers a legend about a hidden treasure nearby.",
      "A strange illness is affecting people who visit the market square.",
      "Identical twins have been found murdered in identical ways on opposite sides of town.",
      "A cult is recruiting villagers for an upcoming celestial event.",
      "Ancient stone circles have begun to glow on moonless nights.",
      "A weather pattern is repeating eerily, day after day."
    ];
    
    return hooks[_random.nextInt(hooks.length)];
  }
} 