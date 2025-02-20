namespace :seed do
    desc "Generate and seed 10 random records for each generator type"
    task generate_all: :environment do
      client = OpenAI::Client.new
  
      # Helper lambda to generate and save a record for a given model and prompt.
      generate_and_save = lambda do |model_class, prompt|
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            response_format: { type: "json_object" },
            messages: [
              { role: "system", content: "You are an AI that generates structured JSON for #{model_class.name.pluralize}. Respond with only valid JSON, no markdown, no explanations." },
              { role: "user", content: prompt }
            ],
            temperature: 0.9
          }
        )
        raw_response = response.dig('choices', 0, 'message', 'content')
        begin
          parsed = JSON.parse(raw_response.gsub(/```json|```/, '').strip)
          record = model_class.new(parsed)
          if record.save
            puts "Saved #{model_class.name}: #{record.try(:title) || record.try(:name)}"
          else
            puts "Error saving #{model_class.name}: #{record.errors.full_messages.join(', ')}"
          end
        rescue JSON::ParserError => e
          puts "Error parsing JSON for #{model_class.name}: #{e.message}"
        end
      end
  
      # -------------------------
      # Encounter (without pre-supplied title)
      # -------------------------
      encounter_settings = [
        "An unknown land...", "Deep in a foggy forest",
        "At the edge of civilization", "Among ancient ruins",
        "In a forgotten valley", "Under a starlit sky"
      ]
      encounter_prompt_builder = lambda do
        setting = encounter_settings.sample
        random_seed = rand(1000)
        <<~PROMPT
          Generate a structured DnD encounter in strict JSON format.
          Respond with only valid JSON, no explanations or preamble.
          (Seed: #{random_seed})
          
          Fields:
          - title: (string) Generate a unique encounter title.
          - setting: (string) Description of the environment (use "#{setting}" as a hint).
          - factions: (array of objects) Groups involved in the encounter.
          - clues: (array of strings) Clues the players can find.
          - objectives: (array of objects) Goals of different groups.
          - environmental_hazards: (array of strings) Environmental dangers.
          - reactive_elements: (array of objects) How the world reacts to player actions.
          - outcomes: (array of strings) Possible resolutions.
          
          Example output:
          {
            "title": "Unexpected Ambush at Dawn",
            "setting": "#{setting}",
            "factions": [{"name": "Faction A", "description": "A group with hidden motives."}],
            "clues": ["Mysterious symbol", "Cryptic message"],
            "objectives": [{"actor": "Faction A", "goal": "Seize control"}],
            "environmental_hazards": ["Sudden storm"],
            "reactive_elements": [{"trigger": "Player action", "reaction": "An unexpected ally appears"}],
            "outcomes": ["Peaceful resolution", "Escalation into conflict"]
          }
        PROMPT
      end
  
      puts "Generating 10 random encounters..."
      10.times { generate_and_save.call(Encounter, encounter_prompt_builder.call) }
  
      # -------------------------
      # Trap
      # -------------------------
      trap_names = ["A Devious Trap", "Hidden Pitfall", "Ambush Mechanism", "Cunning Snare", "Insidious Snare", "Perilous Contraption"]
      trap_locations = ["An abandoned corridor", "Deep in a dungeon", "Inside a forgotten temple", "At a crumbling ruin", "Under ancient stones"]
      trap_prompt_builder = lambda do
        name = trap_names.sample
        location = trap_locations.sample
        random_seed = rand(1000)
        <<~PROMPT
          Generate a structured DnD trap in strict JSON format.
          Respond with only valid JSON, no explanations or preamble.
          (Seed: #{random_seed})
          
          Fields:
          - name: (string) The name of the trap (use "#{name}" as a suggestion).
          - location: (string) Where the trap is located (hint: "#{location}").
          - trap_type: (string) The type of trap (e.g., Mechanical, Magical).
          - trigger: (string) What triggers the trap.
          - mechanism: (string) How the trap functions.
          - effects: (array of strings) Effects when triggered.
          - disarm_check: (string) The ability used to disarm the trap.
          - disarm_difficulty: (number) The difficulty rating to disarm the trap.
          
          Example output:
          {
            "name": "#{name}",
            "location": "#{location}",
            "trap_type": "Mechanical",
            "trigger": "When a pressure plate is stepped on",
            "mechanism": "Hidden spikes emerge from the floor",
            "effects": ["Piercing damage", "Knockback"],
            "disarm_check": "Dexterity",
            "disarm_difficulty": 15
          }
        PROMPT
      end
  
      puts "Generating 10 random traps..."
      10.times { generate_and_save.call(Trap, trap_prompt_builder.call) }
  
      # -------------------------
      # NPC
      # -------------------------
      npc_names = ["A Mysterious Stranger", "Elder Sage", "Wandering Bard", "Silent Assassin", "Mystic Oracle", "Roguish Trickster"]
      npc_races = ["Human", "Elf", "Dwarf", "Halfling", "Orc", "Tiefling"]
      npc_occupations = ["Wanderer", "Merchant", "Scholar", "Guard", "Mystic", "Adventurer"]
      npc_prompt_builder = lambda do
        name = npc_names.sample
        race = npc_races.sample
        occupation = npc_occupations.sample
        random_seed = rand(1000)
        <<~PROMPT
          Generate a structured DnD NPC in strict JSON format.
          Respond with only valid JSON, no explanations or preamble.
          (Seed: #{random_seed})
          
          Fields:
          - name: (string) The name of the NPC (e.g., "#{name}").
          - race: (string) The race of the NPC.
          - occupation: (string) The NPC's role or job (e.g., "#{occupation}").
          - background: (string) A brief background description.
          - personality_traits: (array of strings) Notable personality traits.
          - quirks: (array of strings) Unique quirks or mannerisms.
          
          Example output:
          {
            "name": "#{name}",
            "race": "#{race}",
            "occupation": "#{occupation}",
            "background": "An enigmatic past shrouded in mystery",
            "personality_traits": ["Cautious", "Curious"],
            "quirks": ["Speaks in riddles", "Always stares into the distance"]
          }
        PROMPT
      end
  
      puts "Generating 10 random NPCs..."
      10.times { generate_and_save.call(Npc, npc_prompt_builder.call) }
  
      # -------------------------
      # Treasure
      # -------------------------
      treasure_names = ["Enchanted Relic", "Mystic Amulet", "Ancient Tome", "Cursed Dagger", "Arcane Orb", "Forgotten Sigil"]
      treasure_types = ["Magical Artifact", "Ancient Relic", "Mystical Item", "Cursed Object"]
      treasure_rarities = ["Common", "Rare", "Legendary"]
      treasure_prompt_builder = lambda do
        name = treasure_names.sample
        treasure_type = treasure_types.sample
        rarity = treasure_rarities.sample
        random_seed = rand(1000)
        <<~PROMPT
          Generate a structured DnD treasure in strict JSON format.
          Respond with only valid JSON, no explanations or preamble.
          (Seed: #{random_seed})
          
          Fields:
          - name: (string) The name of the treasure (suggestion: "#{name}").
          - treasure_type: (string) The category of the treasure (e.g., "#{treasure_type}").
          - rarity: (string) The rarity level (e.g., "#{rarity}").
          - description: (string) A brief description.
          - properties: (array of strings) Special properties or magical effects.
          
          Example output:
          {
            "name": "#{name}",
            "treasure_type": "#{treasure_type}",
            "rarity": "#{rarity}",
            "description": "An item imbued with arcane power and mystery.",
            "properties": ["Glows in darkness", "Whispers secrets"]
          }
        PROMPT
      end
  
      puts "Generating 10 random treasures..."
      10.times { generate_and_save.call(Treasure, treasure_prompt_builder.call) }
  
      # -------------------------
      # Quest/Plot Hook
      # -------------------------
      quest_settings = [
        "A bustling medieval town", "A quiet village",
        "An ancient ruin", "A mysterious forest",
        "A coastal port", "A mountain stronghold"
      ]
      quest_prompt_builder = lambda do
        setting = quest_settings.sample
        random_seed = rand(1000)
        <<~PROMPT
          Generate a structured DnD quest/plot hook in strict JSON format.
          Respond with only valid JSON, no explanations or preamble.
          (Seed: #{random_seed})
          
          Fields:
          - title: (string) Generate a unique title for the quest.
          - setting: (string) Description of the environment (hint: "#{setting}").
          - hook: (string) The inciting incident.
          - complications: (array of strings) Challenges that may arise.
          - potential_outcomes: (array of strings) Possible resolutions.
          
          Example output:
          {
            "title": "The Lost Heirloom",
            "setting": "#{setting}",
            "hook": "A mysterious message arrives, hinting at a hidden danger.",
            "complications": ["Local tensions rise", "A rival faction is involved"],
            "potential_outcomes": ["The quest succeeds", "Unexpected betrayal", "A heroic sacrifice"]
          }
        PROMPT
      end
  
      puts "Generating 10 random quests..."
      10.times { generate_and_save.call(Quest, quest_prompt_builder.call) }
  
      puts "Finished seeding 10 random records for each generator type!"
    end
  end
  