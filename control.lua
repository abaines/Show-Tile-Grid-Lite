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

	makeGrid(left_top,0.1,0.001,{1,1,1,0.1},{1,1,1,0.9},surface)
end

script.on_event({
	defines.events.on_chunk_generated
},on_chunk_generated)

