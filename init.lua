kill_list = {}

minetest.register_privilege("kill", {
    description = "The player will be killed immediately", 
    give_to_singleplayer = true
  })

minetest.register_chatcommand("kill", {
    params = "<playername> | leave playername empty to see help message",
    description = "The player will be klled immediately",
    privs = {kill=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Usage: /kill <Player name>")
            return
        end
        if minetest.env:get_player_by_name(param) then
            table.insert(kill_list, param)
            minetest.chat_send_player(name, param .. " is killed.")
            minetest.log("action", name .. " has killed " .. param .. ".")
            return
        end
    end
})


minetest.register_globalstep(
   function(dtime)
           for j,kill in ipairs(kill_list) do
               minetest.env:get_player_by_name(kill):set_hp(0)
                  table.remove(kill_list,j)
                  minetest.log("action", name .. " was instantly killed.")                  
              
           end
   end
)


