minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	
	local privs = minetest.get_player_privs(name)

	privs.fly = true
	privs.fast = true
	privs.teleport = true
	privs.noclip = true
	minetest.set_player_privs(name, privs)
	
-- 	local p = player:get_pos()
-- 	if p.y > -100 then
-- 		player:set_pos({x=0, y=-20000, z= 0})
-- 	end
end)
