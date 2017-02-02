_G._savedEnv = getfenv()
module("ability_item_usage_generic", package.seeall)

-- Include this before require to fix Mac
local dir = GetScriptDirectory();
local function GetScriptDirectory()
  if string.sub(dir, 1, 6) == "/Users" then
    return string.match(dir, '.*/(.+)')
  end
  return dir;
end
-----------------------------------------

local Helper = require(GetScriptDirectory() .. "/helper");

function ItemUsageThink()

  local npcBot = GetBot();

  if npcBot:IsChanneling() then
    return;
  end

  local teammates = npcBot:GetNearbyHeroes(900, false, BOT_MODE_NONE);
  local enemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE);

  for i = 0,5 do
    local item = npcBot:GetItemInSlot(i);

    if (item) and string.find(item:GetName(), "item_necronomicon") and enemies ~= nil and #enemies >= 1 then
      if (item:IsFullyCastable()) then
        npcBot:Action_UseAbility(item);
      end
    end

    if (item) and string.find(item:GetName(), "item_dagon") and enemies ~= nil and #enemies >= 1 then
      if (item:IsFullyCastable()) then
        local weakestEnemy = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', item:GetCastRange(), true);
        if (weakestEnemy ~= nil) then
          npcBot:Action_UseAbilityOnEntity(item, weakestEnemy);
        end
      end
    end

    if (item) and (item:GetName() == "item_tpscroll" or item:GetName() == "item_travel_boots") and item:IsFullyCastable() then

      local target = nil;

      if npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        target = Helper.GetOutermostTower(GetTeam(), LANE_BOT):GetLocation();
      elseif npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID then
        target = Helper.GetOutermostTower(GetTeam(), LANE_MID):GetLocation();
      elseif npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then
        target = Helper.GetOutermostTower(GetTeam(), LANE_TOP):GetLocation();
      elseif npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and item:GetName() == "item_travel_boots" then
        target = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0.0);
      elseif npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID and item:GetName() == "item_travel_boots" then
        target = GetLaneFrontLocation(GetTeam(), LANE_MID, 0.0);
      elseif npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP and item:GetName() == "item_travel_boots" then
        target = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0.0);
      end

      if target ~= nil and GetUnitToLocationDistance(npcBot, target) > 5000 then
        local offset = Vector(-500, -500);
        if (GetTeam() == TEAM_DIRE) then
          offset = Vector(500, 500)
        end
        return npcBot:Action_UseAbilityOnLocation(item, target + offset);
      end
    end

    if (item) and (item:GetName() == "item_mekansm" or item:GetName() == "item_pipe") then
      if item:IsFullyCastable() and teammates ~= nil and #teammates >=2 then
        if npcBot:GetHealth() <= 400 then
          npcBot:Action_UseAbility(item);
        end
        for _, hero in pairs(teammates) do
          if (hero:GetHealth() <= 400) then
            npcBot:Action_UseAbility(item);
            break;
          end
        end
      end
    end

    if (item) and item:GetName() == "item_phase_boots" then
      if (item:IsFullyCastable()) then
        npcBot:Action_UseAbility(item);
      end
    end

    if (item) and item:GetName() == "item_shivas_guard" then
      if (item:IsFullyCastable() and enemies ~= nil and #enemies >= 2) then
        npcBot:Action_UseAbility(item);
      end
    end

    if (item) and (item:GetName() == "item_invis_sword" or item:GetName() == "item_silver_edge") then
      if item:IsFullyCastable() and
        npcBot:GetActiveMode() == BOT_MODE_RETREAT and
        npcBot:DistanceFromFountain() > 1500 then
        npcBot:Action_UseAbility(item);
      end
    end

    if (item) and
      (item:GetName() == "item_orchid" or item:GetName() == "item_recipe_bloodthorn") and
      item:IsFullyCastable() then
      local weakestEnemy = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', item:GetCastRange(), true);
      if (weakestEnemy ~= nil) then
        npcBot:Action_UseAbilityOnEntity(item, weakestEnemy);
      end
    end

    if (item) and item:GetName() == "item_courier" then
      if (item:IsFullyCastable()) then
        npcBot:Action_UseAbility(item);
      end
    end

    if (item) and item:GetName() == "item_flask" then
      if (item:IsFullyCastable() and npcBot:GetHealth() <= 200) then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);
      end
    end

    if (item) and item:GetName() == "item_clarity" then
      if (item:IsFullyCastable() and npcBot:GetMana() <= 200) then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);
      end
    end
  end

end


for k,v in pairs(ability_item_usage_generic) do _G._savedEnv[k] = v end