-- Kizrak
local sb = serpent.block -- luacheck: ignore 211

local function sbs(obj) -- luacheck: ignore 211
    local s = sb(obj):gsub("%s+", " ")
    return s
end

local function checkPlayerCursor(player)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        log(player.cursor_stack.valid_for_read)
        return player.cursor_stack.valid_for_read
    elseif player.cursor_ghost and player.cursor_ghost.valid then
        log(player.cursor_ghost.valid)
        return player.cursor_ghost.valid
    end

    log("checkPlayerCursor nothing")
end

local importantTypes = {
    ["artillery-wagon"] = true,
    ["cargo-wagon"] = true,
    ["curved-rail"] = true,
    ["electric-pole"] = true,
    ["fluid-wagon"] = true,
    ["locomotive"] = true,
    ["radar"] = true,
    ["rail-chain-signal"] = true,
    ["rail-signal"] = true,
    ["roboport"] = true,
    ["straight-rail"] = true,
    ["train-stop"] = true
}

local function isSelectedImportant(player)
    if player.selected and player.selected.valid then
        local selected_type = player.selected.type
        log(player .. selected_type)

        if selected_type == "entity-ghost" then
            selected_type = player.selected.ghost_type
        end

        local isImportant = importantTypes[selected_type]
        return isImportant
    end
end

local function parse_show_tile_grid_setting(ret, player)
    local show_tile_grid_setting =
        player.mod_settings["show-tile-grid-for-user"].value

    if show_tile_grid_setting == "Always" then
        table.insert(ret, player)
    elseif show_tile_grid_setting == "Auto" and checkPlayerCursor(player) then
        table.insert(ret, player)
    elseif show_tile_grid_setting == "Auto" and isSelectedImportant(player) then
        table.insert(ret, player)
    end
end

local function getPlayersToRenderFor()
    local ret = {}

    for _, player in pairs(game.players) do
        parse_show_tile_grid_setting(ret, player)
    end

    return ret
end

local function makeGridForChunk(playersToRenders, surface, left_top)
    local x = left_top.x
    local y = left_top.y

    local settings_color_r = settings.global["show-tile-grid-color-r"].value
    local settings_color_g = settings.global["show-tile-grid-color-g"].value
    local settings_color_b = settings.global["show-tile-grid-color-b"].value
    local settings_color_a = settings.global["show-tile-grid-color-a"].value

    local s_color = {
        r = settings_color_r,
        g = settings_color_g,
        b = settings_color_b,
        a = settings_color_a
    }

    local settings_length = assert(tonumber(
                                       settings.global["show-tile-grid-length"]
                                           .value))
    local settings_width = assert(tonumber(
                                      settings.global["show-tile-grid-width"]
                                          .value))

    local o = settings_length -- offset

    local settings_shape = settings.global["show-tile-grid-shape"].value

    if #playersToRenders > 0 then
        if settings_shape == "Cross" then
            rendering.draw_line {
                from = {x, y + o},
                to = {x, y - o},
                surface = surface,
                color = s_color,
                width = settings_width,
                players = playersToRenders
            }
            rendering.draw_line {
                from = {x + o, y},
                to = {x - o, y},
                surface = surface,
                color = s_color,
                width = settings_width,
                players = playersToRenders
            }

        elseif settings_shape == "Circle" then
            settings_width = math.max(settings_width, 0.001)
            rendering.draw_circle {
                target = {x, y},
                surface = surface,
                color = s_color,
                radius = settings_length,
                width = settings_width,
                players = playersToRenders
            }

        else
            log("unknown shape: " .. settings_shape)
        end
    end
end

local function on_chunk_generated(event)
    local area = event.area
    -- local chunkPosition = event.position
    local surface = event.surface
    local left_top = area.left_top

    local playersToRenders = getPlayersToRenderFor()

    makeGridForChunk(playersToRenders, surface, left_top)
end

script.on_event({defines.events.on_chunk_generated}, on_chunk_generated)

local function redrawGrid(reason)
    log("redrawGrid(" .. reason .. ")")

    rendering.clear("showTileGridLite")

    local playersToRenders = getPlayersToRenderFor()

    for _, surface in pairs(game.surfaces) do
        for chunk in surface.get_chunks() do
            local left_top = chunk.area.left_top
            makeGridForChunk(playersToRenders, surface, left_top)
        end
    end
end

local function on_runtime_mod_setting_changed(event)
    if not event.player_index then return end
    local setting = event.setting -- string: The setting name that changed.
    local setting_type = event.setting_type -- string: The setting type: "runtime-per-user", or "runtime-global".
    local player = game.players[event.player_index]

    local function starts_with(str, start) return str:sub(1, #start) == start end

    if starts_with(setting, "show-tile-grid-") then
        log(player.name .. " > " .. setting_type .. " > " .. setting)

        redrawGrid("on_runtime_mod_setting_changed:" .. player.name)
    end
end

script.on_event({defines.events.on_runtime_mod_setting_changed},
                on_runtime_mod_setting_changed)

local function on_selected_entity_changed(event)
    local player = game.players[event.player_index]
    local show_tite_grid_for_user =
        player.mod_settings["show-tile-grid-for-user"].value

    if show_tite_grid_for_user == "Auto" then

        storage.player_selected_entity_data =
            storage.player_selected_entity_data or {}

        local selectedImportant = isSelectedImportant(player)

        if storage.player_selected_entity_data[player.index] ~=
            selectedImportant then
            redrawGrid("on_selected_entity_changed:" .. player.name)
        end

        storage.player_selected_entity_data[player.index] = selectedImportant

    end
end

script.on_event({defines.events.on_selected_entity_changed},
                on_selected_entity_changed)

--[[
-- TODO: Event request: on_player_cursor_ghost_changed or on_player_cursor_stack_changed
-- https://forums.factorio.com/viewtopic.php?f=28&t=68630
local function on_tick()
    storage.player_cursor_tick_data = storage.player_cursor_tick_data or {}
    local needRedraw = {}

    for _, player in pairs(game.players) do
        local hasSomethingOnCursor = checkPlayerCursor(player)

        if storage.player_cursor_tick_data[player.index] ~= hasSomethingOnCursor then
            local show_tite_grid_for_user =
                player.mod_settings["show-tile-grid-for-user"].value
            if show_tite_grid_for_user == "Auto" then
				log(storage.player_cursor_tick_data[player.index])
                table.insert(needRedraw, player.name)
            end
        end

        storage.player_cursor_tick_data[player.index] = hasSomethingOnCursor
    end

    if #needRedraw > 0 then redrawGrid("events.on_tick:" .. sbs(needRedraw)) end
end

script.on_event({defines.events.on_tick}, on_tick)
]] --

-- TODO: events.on_tick always seems to happen before this event, making all of this useless until event API changed
-- https://forums.factorio.com/viewtopic.php?f=28&t=68630
local function on_player_cursor_stack_changed(event)
    storage.player_cursor_tick_data = storage.player_cursor_tick_data or {}

    local player = game.players[event.player_index]
    local show_tite_grid_for_user =
        player.mod_settings["show-tile-grid-for-user"].value

    if show_tite_grid_for_user == "Auto" then
        log('auto')
        local hasSomethingOnCursor = checkPlayerCursor(player)

        if storage.player_cursor_tick_data[player.index] ~= hasSomethingOnCursor then
            redrawGrid("on_player_cursor_stack_changed:" .. player.name)
        end

        storage.player_cursor_tick_data[player.index] = hasSomethingOnCursor
    end
    log("on_player_cursor_stack_changed!" .. show_tite_grid_for_user)
end

script.on_event({defines.events.on_player_cursor_stack_changed},
                on_player_cursor_stack_changed)

--[[
TODO:
https://mods.factorio.com/mod/showTileGridLite/discussion/5e1060d620bee9000d7d37ea
Could you please move the turn on/ turn off function from player settings into a shortcut?
]] --

