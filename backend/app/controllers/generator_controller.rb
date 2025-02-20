class GeneratorController < ApplicationController
    # For free-tier, just pull a record from the database
  
    def generate_encounter
      encounter = Encounter.order("RANDOM()").first
      if encounter.present?
        render json: encounter
      else
        render json: { error: "No encounter available" }, status: 404
      end
    end
  
    def generate_trap
      trap = Trap.order("RANDOM()").first
      if trap.present?
        render json: trap
      else
        render json: { error: "No trap available" }, status: 404
      end
    end
  
    def generate_npc
      npc = Npc.order("RANDOM()").first
      if npc.present?
        render json: npc
      else
        render json: { error: "No NPC available" }, status: 404
      end
    end
  
    def generate_treasure
      treasure = Treasure.order("RANDOM()").first
      if treasure.present?
        render json: treasure
      else
        render json: { error: "No treasure available" }, status: 404
      end
    end
  
    def generate_quest
      quest = Quest.order("RANDOM()").first
      if quest.present?
        render json: quest
      else
        render json: { error: "No quest available" }, status: 404
      end
    end
  end
  