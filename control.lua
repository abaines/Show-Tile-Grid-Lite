-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local function checkPlayerCursor(player)
	local hasSomethingOnCursor = player.cursor_stack.valid_for_read or (player.cursor_ghost and player.cursor_ghost.valid)
	return hasSomethingOnCursor
end

local importantTypes = {
	["radar"] = true,
	["roboport"] = true,
	["electric-pole"] = true,
	["straight-rail"] = true,
	["curved-rail"] = true,
	["locomotive"] = true,
	["cargo-wagon"] = true,
	["fluid-wagon"] = true,
	["artillery-wagon"] = true,
	["train-stop"] = true,
	["rail-signal"] = true,
	["rail-chain-signal"] = true,
}

local function isSelectedImportant(player)
	if player.selected and player.selected.valid then
		local selected_type = player.selected.type

		if selected_type == "entity-ghost" then
			selected_type = player.selected.ghost_type
		end

		local isImportant = importantTypes[selected_type]
		return isImportant
	end
end

local function getPlayersToRenderFor()
	local ret = {}

	for i, player in pairs(game.players) do
		local show_tite_grid_for_user = player.mod_settings["show-tile-grid-for-user"].value
		if show_tite_grid_for_user=="Always" then
			table.insert(ret, player)
		elseif show_tite_grid_for_user=="Auto" and checkPlayerCursor(player) then
			table.insert(ret, player)
		elseif show_tite_grid_for_user=="Auto" and isSelectedImportant(player) then
			table.insert(ret, player)
		end
	end

	return ret
end


local function makeGridForChunk(playersToRenders,surface,left_top)
	local x = left_top.x
	local y = left_top.y

	local settings_color_r = settings.global["show-tile-grid-color-r"].value
	local settings_color_g = settings.global["show-tile-grid-color-g"].value
	local settings_color_b = settings.global["show-tile-grid-color-b"].value
	local settings_color_a = settings.global["show-tile-grid-color-a"].value

	local s_color = {r=settings_color_r,g=settings_color_g,b=settings_color_b,a=settings_color_a}

	local settings_length = settings.global["show-tile-grid-length"].value
	local settings_width = settings.global["show-tile-grid-width"].value

	local o = settings_length -- offset

	local settings_shape = settings.global["show-tile-grid-shape"].value

	if #playersToRenders > 0 then
		if settings_shape == "Cross" then
			rendering.draw_line{from={x,y+o}, to={x,y-o}, surface=surface, color=s_color, width=settings_width, players=playersToRenders}
			rendering.draw_line{from={x+o,y}, to={x-o,y}, surface=surface, color=s_color, width=settings_width, players=playersToRenders}

		elseif settings_shape == "Circle" then
			settings_width = math.max(settings_width,0.001)
			rendering.draw_circle{target={x,y}, surface=surface, color=s_color, radius=settings_length, width=settings_width, players=playersToRenders}
			rendering.draw_circle{target={x,y}, surface=surface, color=s_color, radius=settings_length, width=settings_width, players=playersToRenders}

		else -- luacheck: ignore 542
			-- nothing???
		end
	end
end


local function on_chunk_generated(event)
	local area = event.area
	--local chunkPosition = event.position
	local surface = event.surface
	local left_top = area.left_top

	local playersToRenders = getPlayersToRenderFor()

	makeGridForChunk(playersToRenders,surface,left_top)
end

script.on_event({
	defines.events.on_chunk_generated
},on_chunk_generated)



local function redrawGrid()
	rendering.clear("showTileGridLite")

	local playersToRenders = getPlayersToRenderFor()

	for _, surface in pairs(game.surfaces) do
		for chunk in surface.get_chunks() do
			local left_top = chunk.area.left_top
			makeGridForChunk(playersToRenders,surface,left_top)
		end
	end
end


local function on_runtime_mod_setting_changed(event)
	local setting = event.setting -- string: The setting name that changed.
	local setting_type = event.setting_type -- string: The setting type: "runtime-per-user", or "runtime-global".
	local player = game.players[event.player_index]

	local function starts_with(str, start)
		return str:sub(1, #start) == start
	end

	if starts_with(setting,"show-tile-grid-") then
		log(player.name .. " > " .. setting_type .. " > " .. setting)

		redrawGrid()
	end
end

script.on_event({
	defines.events.on_runtime_mod_setting_changed
},on_runtime_mod_setting_changed)


local function on_player_cursor_stack_changed()
	redrawGrid()
end

script.on_event({
	defines.events.on_player_cursor_stack_changed
},on_player_cursor_stack_changed)


local function on_selected_entity_changed()
	redrawGrid()
end

script.on_event({
	defines.events.on_selected_entity_changed
},on_selected_entity_changed)



-- TODO: Event request: on_player_cursor_ghost_changed
-- https://forums.factorio.com/viewtopic.php?f=28&t=68630
local function on_tick()
	global.player_cursor_tick_data = global.player_cursor_tick_data or {}
	local needRedraw = false

	for i, player in pairs(game.players) do
		local hasSomethingOnCursor = checkPlayerCursor(player)

		if global.player_cursor_tick_data[player.index] ~= hasSomethingOnCursor then
			local show_tite_grid_for_user = player.mod_settings["show-tile-grid-for-user"].value
			if show_tite_grid_for_user=="Auto" then
				needRedraw = true
			end
		end

		global.player_cursor_tick_data[player.index] = hasSomethingOnCursor
	end

	if needRedraw then
		log("events.on_tick redrawGrid()")
		redrawGrid()
	end
end

script.on_event({
	defines.events.on_tick
},on_tick)



--[[
TODO:
https://mods.factorio.com/mod/showTileGridLite/discussion/5e1060d620bee9000d7d37ea
Could you please move the turn on/ turn off function from player settings into a shortcut?
]]--

