-- Kizrak


local sb = serpent.block


local function getPlayersToRenderFor()
	local ret = {}

	for i, player in pairs(game.players) do
		local show_tite_grid_for_user = player.mod_settings["show-tile-grid-for-user"].value
		if show_tite_grid_for_user=="Always" then
			table.insert(ret, player)
		end
	end

	return ret
end


local function makeGridForChunk(surface,left_top)
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

	local players = getPlayersToRenderFor()

	local settings_shape = settings.global["show-tile-grid-shape"].value

	if #players > 0 then
		if settings_shape == "Cross" then
			rendering.draw_line{from={x,y+o}, to={x,y-o}, surface=surface, color=s_color, width=settings_width, players=players}
			rendering.draw_line{from={x+o,y}, to={x-o,y}, surface=surface, color=s_color, width=settings_width, players=players}

		elseif settings_shape == "Circle" then
			settings_width = math.max(settings_width,0.001)
			rendering.draw_circle{target={x,y}, surface=surface, color=s_color, radius=settings_length, width=settings_width, players=players}
			rendering.draw_circle{target={x,y}, surface=surface, color=s_color, radius=settings_length, width=settings_width, players=players}

		else
			-- nothing???
		end
	end
end


local function on_chunk_generated(event)
	local area = event.area
	local chunkPosition = event.position
	local surface = event.surface
	local left_top = area.left_top

	makeGridForChunk(surface,left_top)
end

script.on_event({
	defines.events.on_chunk_generated
},on_chunk_generated)



local function redrawGrid()
	rendering.clear("showTileGridLite")

	for _, surface in pairs(game.surfaces) do
		for chunk in surface.get_chunks() do
			local left_top = chunk.area.left_top
			makeGridForChunk(surface,left_top)
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




--[[
TODO:
https://mods.factorio.com/mod/showTileGridLite/discussion/5e1060d620bee9000d7d37ea
Could you please move the turn on/ turn off function from player settings into a shortcut?
]]--

