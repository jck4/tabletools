class GeneratorController < ApplicationController
  require 'openai'

  def generate_encounter
    # Extract input params (or set defaults)
    title = params[:title] || "A Mysterious Encounter"
    setting = params[:setting] || "An unknown land..."
    factions = params[:factions] || []
    clues = params[:clues] || []
    objectives = params[:objectives] || []
    hazards = params[:environmental_hazards] || []
    reactive_elements = params[:reactive_elements] || []
    outcomes = params[:outcomes] || []

    # OpenAI prompt to strictly return JSON
    prompt = <<~PROMPT
      Generate a structured DnD encounter in **strict JSON format**.
      Respond with only valid JSON, no explanations or preamble.

      Fields:
      - title: (string) The name of the encounter
      - setting: (string) Description of the environment
      - factions: (array of objects) Groups involved in the encounter
      - clues: (array of strings) Clues the players can find
      - objectives: (array of objects) Goals of different groups
      - environmental_hazards: (array of strings) Environmental dangers
      - reactive_elements: (array of objects) How the world reacts to player actions
      - outcomes: (array of strings) Possible resolutions

      Example output:
      ```json
      {
        "title": "#{title}",
        "setting": "#{setting}",
        "factions": [{"name": "Faction A", "description": "A group with goals."}],
        "clues": ["Clue 1", "Clue 2"],
        "objectives": [{"actor": "Faction A", "goal": "Do something."}],
        "environmental_hazards": ["Hazard 1"],
        "reactive_elements": [{"trigger": "Action", "reaction": "Response"}],
        "outcomes": ["Outcome 1", "Outcome 2"]
      }
      ```
    PROMPT

    # Call OpenAI API
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        response_format: { type: "json_object" },
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are an AI that generates structured JSON for DnD encounters, and you ONLY responsd with valid structured json." },
          { role: "user", content: prompt }
        ],
        temperature: 0.7
      }
    )

    # Extract & parse response as JSON
    raw_response = response.dig('choices', 0, 'message', 'content')
    
    begin
      encounter_json = JSON.parse(raw_response)
      render json: encounter_json
    rescue JSON::ParserError => e
      render json: { error: "Failed to parse JSON response", details: e.message }, status: 500
    end
  end
  def generate_trap
    # Extract input params (or set defaults)
    name = params[:name] || "A Devious Trap"
    location = params[:location] || "An abandoned corridor"
    trap_type = params[:trap_type] || "Mechanical"
    trigger = params[:trigger] || "When a pressure plate is stepped on"
    mechanism = params[:mechanism] || "Hidden spikes emerge from the floor"
    effects = params[:effects] || ["Piercing damage", "Knockback"]
    disarm_check = params[:disarm_check] || "Dexterity"
    disarm_difficulty = params[:disarm_difficulty] || 15
  
    # OpenAI prompt to strictly return JSON
    prompt = <<~PROMPT
      Generate a structured DnD trap in **strict JSON format**.
      Respond with only valid JSON, no explanations or preamble.
  
      Fields:
      - name: (string) The name of the trap
      - location: (string) Where the trap is located
      - trap_type: (string) The type of trap (e.g., Mechanical, Magical, etc.)
      - trigger: (string) What triggers the trap
      - mechanism: (string) How the trap functions
      - effects: (array of strings) Effects of the trap when triggered
      - disarm_check: (string) The ability used to disarm the trap
      - disarm_difficulty: (number) The difficulty rating to disarm the trap
  
      Example output:
      {
        "name": "#{name}",
        "location": "#{location}",
        "trap_type": "#{trap_type}",
        "trigger": "#{trigger}",
        "mechanism": "#{mechanism}",
        "effects": ["#{effects.join('", "')}"],
        "disarm_check": "#{disarm_check}",
        "disarm_difficulty": #{disarm_difficulty}
      }
    PROMPT
  
    begin
      # Call OpenAI API
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          response_format: { type: "json_object" }, # 🚀 Forces JSON response
          messages: [
            { role: "system", content: "You are an AI that generates structured JSON for DnD traps. Respond with only valid JSON. No markdown, no explanations." },
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )
  
      # Debugging logs (print full response)
      puts "=== RAW OPENAI RESPONSE ==="
      puts response.inspect
  
      # Extract JSON response
      raw_response = response.dig("choices", 0, "message", "content")
      raise "No response content" if raw_response.nil?
  
      # Ensure we are only getting valid JSON
      clean_json = raw_response.gsub(/```json|```/, '').strip
      trap_json = JSON.parse(clean_json)
  
      render json: trap_json
    rescue JSON::ParserError => e
      puts "=== JSON PARSER ERROR ==="
      puts e.message
      render json: { error: "Failed to parse JSON response", details: e.message, raw_response: raw_response }, status: 500
    rescue Faraday::BadRequestError => e
      puts "=== OPENAI API BAD REQUEST ==="
      puts e.response[:body]
      render json: { error: "OpenAI API Error", details: e.response[:body] }, status: 500
    rescue StandardError => e
      puts "=== UNEXPECTED ERROR ==="
      puts e.message
      render json: { error: "Unexpected Error", details: e.message }, status: 500
    end
  end
  
  
end
