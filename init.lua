kill_list = {}
hp_list = {}

minetest.register_privilege("kill", {
    description = "The player will be killed immediately", 
    give_to_singleplayer = true
  })

minetest.register_privilege("set_hp", {
    description = "Allows to change other player's HP", 
    give_to_singleplayer = true
  })


minetest.register_chatcommand("kill", {
    params = "<playername> | leave playername empty to see help message",
    description = "The player will be klled immediately",
    privs = {kill=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Usage: /kill <playername>")
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


minetest.register_chatcommand("hp", {
    params = "<playername> <value>| leave params empty to see help message",
    description = "Allows to change other player's HP. /hp <playername> 0 is equal to /kill command",
    privs = {set_hp=true},
    func = function(name, param)
        if param == "" then
            minetest.chat_send_player(name, "Usage: /hp <playername> <value>")
            return
        end
        user, hp = string.match(param, " *([%w%-]+) *(%w*)")
        if minetest.env:get_player_by_name(user) then
            table.insert(hp_list, {user, hp})
            minetest.chat_send_player(name, user .. "'s HP set to " .. hp .. ".")
            minetest.log("action", name .. " has set " .. user .. "'s HP to " .. hp ..".")
            return
        end
    end
})


minetest.register_globalstep(
   function(dtime)
           for j,kill in ipairs(kill_list) do
               minetest.env:get_player_by_name(kill):set_hp(0)
               minetest.log("action", name .. " was instantly killed.")                               
               table.remove(kill_list,j)
           end

           for j,hps in ipairs(hp_list) do
               minetest.env:get_player_by_name(hps[1]):set_hp(hps[2])
               minetest.log("action", name .. "'s HP have been changed to " .. hps[1] .. ".")                               
               table.remove(hp_list,j)
           end
   end
)



