-- Kizrak



local function grid(left_top,offset,width,hcolor,vcolor,surface)
	local x = left_top.x
	local y = left_top.y
	local surface = surface or "nauvis"
	rendering.draw_line{from={x,y+offset},to={x,y-offset},surface=surface,color=vcolor,width=width}
	rendering.draw_line{from={x+offset,y},to={x-offset,y},surface=surface,color=hcolor,width=width}
end


local function derp(event)
	local area = event.area
	local chunkPosition = event.position
	local surface = event.surface
	local left_top = area.left_top

	grid(left_top,0.1,0.001,{0,0,0},{1,1,1},"nauvis")
end

script.on_event({
	defines.events.on_chunk_generated
},derp)

