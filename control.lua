-- Kizrak



local function makeGrid(left_top,offset,width,hcolor,vcolor,surface)
	local x = left_top.x
	local y = left_top.y
	rendering.draw_line{from={x,y+offset},to={x,y-offset},surface=surface,color=vcolor,width=width}
	rendering.draw_line{from={x+offset,y},to={x-offset,y},surface=surface,color=hcolor,width=width}
end


local function on_chunk_generated(event)
	local area = event.area
	local chunkPosition = event.position
	local surface = event.surface
	local left_top = area.left_top

	local settings_length = settings.global["show-tite-grid-length"].value
	local settings_width = settings.global["show-tite-grid-width"].value


	local grey = 0.35
	local color = {r=grey,g=grey,b=grey,a=0.35}
	makeGrid(left_top,settings_length,settings_width,color,color,surface)

	--local lt = { x = left_top.x+1, y = left_top.y+1 }
	--makeGrid(lt,0.1,0.001,{r=1,g=1,b=1,a=0.1},{r=1,g=1,b=1,a=0.9},surface)
end

script.on_event({
	defines.events.on_chunk_generated
},on_chunk_generated)

