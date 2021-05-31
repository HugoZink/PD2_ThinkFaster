-- Holds removed attention objects. This is necessary for maps that might switch from loud back to stealth.
local removed_attention_objects = {}

local function is_attention_obj_unnecessary_for_loud(attention_object)
    return not attention_object.nav_tracker and not attention_object.unit:vehicle_driving() or attention_object.unit:in_slot(1) or attention_object.unit:in_slot(17) and attention_object.unit:character_damage()
end

local function unregister_attention_objects(self)
	local ai_attention_objects = self:get_all_AI_attention_objects()

	for u_key, attention_object in pairs(ai_attention_objects) do
		if is_attention_obj_unnecessary_for_loud(attention_object) then
			removed_attention_objects[u_key] = attention_object
			attention_object.handler:set_attention(nil)
		end
	end
end

local function reregister_attention_objects(self)
    local ai_attention_objects = self:get_all_AI_attention_objects()

    for u_key, attention_object in pairs(removed_attention_objects) do
        -- First, check if the attention object was actually registered again in the meantime. If so, skip it.
        -- If not registered, check if it still exists and is valid.
        if ai_attention_objects[u_key] then
            removed_attention_objects[u_key] = nil
        elseif attention_object and alive(attention_object.unit) then
            self:register_AI_attention_object(attention_object.unit, attention_object.handler, attention_object.nav_tracker, attention_object.team, attention_object.SO_access)
            removed_attention_objects[u_key] = nil
        end
    end
end

-- When stealth is enabled/disabled, unregister or re-register "attention objects" that are only useful in stealth (broken windows, corpses, etc.)
-- Thanks RedFlame for bringing this to my attention!
Hooks:PostHook(GroupAIStateBase, "set_whisper_mode", "thinkfaster_unregister_attentionobjects_on_loud", function(self, enabled)
    -- Perform as server only
    if Network and not Network:is_server() then
        return
    end

    if enabled then
        -- Going stealth, register previously disabled attention objects again
        reregister_attention_objects(self)
    else
        -- Going loud, unregister useless attention objects
        unregister_attention_objects(self)
    end
end)

-- Additionally, when a new object is registered, check if it should actually be registered or not.
local register_attention_obj_orig = GroupAIStateBase.register_AI_attention_object
function GroupAIStateBase:register_AI_attention_object(unit, handler, nav_tracker, team, SO_access)
    -- In stealth, always register the object normally
    if managers.groupai:state():whisper_mode() then
        return register_attention_obj_orig(self, unit, handler, nav_tracker, team, SO_access)
    end

    local attention_obj = {
		unit = unit,
		handler = handler,
		nav_tracker = nav_tracker,
		team = team,
		SO_access = SO_access
	}

    if is_attention_obj_unnecessary_for_loud(attention_obj) then
        -- Object is unnecessary, add it to the local table of removed objects so that it could still be re-added later
        removed_attention_objects[unit:key()] = attention_obj
    else
        -- Object is necessary for loud, register it normally
        return register_attention_obj_orig(self, unit, handler, nav_tracker, team, SO_access)
    end    
end
