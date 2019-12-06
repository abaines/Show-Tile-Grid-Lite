-- Kizrak



local function makeGridForChunk(surface,left_top)
	local x = left_top.x
	local y = left_top.y

	local settings_color_r = settings.global["show-tite-grid-color-r"].value
	local settings_color_g = settings.global["show-tite-grid-color-g"].value
	local settings_color_b = settings.global["show-tite-grid-color-b"].value
	local settings_color_a = settings.global["show-tite-grid-color-a"].value

	local s_color = {r=settings_color_r,g=settings_color_g,b=settings_color_b,a=settings_color_a}

	local settings_length = settings.global["show-tite-grid-length"].value
	local settings_width = settings.global["show-tite-grid-width"].value

	local o = settings_length -- offset

	rendering.draw_line{from={x,y+o}, to={x,y-o}, surface=surface, color=s_color, width=settings_width}
	rendering.draw_line{from={x+o,y}, to={x-o,y}, surface=surface, color=s_color, width=settings_width}
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

	local function starts_with(str, start)
		return str:sub(1, #start) == start
	end

	if starts_with(setting,"show-tite-grid-") then
		game.print(setting,{g=255})
		redrawGrid()
	else
		game.print(setting,{r=255})
	end
end

script.on_event({
	defines.events.on_runtime_mod_setting_changed
},on_runtime_mod_setting_changed)

