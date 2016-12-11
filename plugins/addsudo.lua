--[[
 _____ ____     ____   ___ _____ 
|_   _|  _ \   | __ ) / _ \_   _|
  | | | |_) |  |  _ \| | | || |  
  | | |  __/   | |_) | |_| || |  
  |_| |_|      |____/ \___/ |_|  
                                 
KASPER  TP (BY @kasper_dev)
 _  __    _    ____  ____  _____ ____     _____ ____  
| |/ /   / \  / ___||  _ \| ____|  _ \   |_   _|  _ \ 
| ' /   / _ \ \___ \| |_) |  _| | |_) |    | | | |_) |
| . \  / ___ \ ___) |  __/| |___|  _ <     | | |  __/ 
|_|\_\/_/   \_\____/|_|   |_____|_| \_\    |_| |_|    
                                                      
--]]
local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 
function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end 
   function run(msg, matches) 
    if tonumber (msg.from.id) == 219844437 then --امسح ايدي وخلي ايدي ماتك
       if matches[1]:lower() == "ssudo" or matches[1]:lower() == "رفع مطور" then 
          table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2] ..' لـقـ(💟)ـد اصـبـ{🔸}ـح مـطـ(💠)ـور جـ{🔱}ـديـد فـي الـبـ(🤖)ـوتـ»') 
     save_config() 
     reload_plugins(true) 
      return matches[2] ..' لـقـ(💟)ـد اصـبـ{🔸}ـح مـطـ(💠)ـور جـ{🔱}ـديـد فـي الـبـ(🤖)ـوتـ»' 
   elseif matches[1]:lower() == "dsudo" or matches[1]:lower() == "تنزيل مطور" then 
      local k = tonumber(matches[2]) 
          table.remove(_config.sudo_users, getindex( _config.sudo_users, k)) 
      print(matches[2] ..' لـقـ(💟)ـد تـ{⛔️}ـم حـ(❌)ـذفـ» مـطـ{💠}ـور') 
     save_config() 
     reload_plugins(true) 
      return matches[2] ..' لـقـ(💟)ـد تـ{⛔️}ـم حـ(❌)ـذفـ» مـطـ{💠}ـور' 
      end 
   end 
end 
return { 
patterns = { 
"^[#!/](ssudo) (%d+)$", 
"^[#!/](dsudo) (%d+)$",
"^(رفع مطور) (%d+)$", 
"^(تنزيل مطور) (%d+)$",
}, 
run = run
}
--[[
 _____ ____     ____   ___ _____ 
|_   _|  _ \   | __ ) / _ \_   _|
  | | | |_) |  |  _ \| | | || |  
  | | |  __/   | |_) | |_| || |  
  |_| |_|      |____/ \___/ |_|  
                                 
KASPER  TP (BY @kasper_dev)
 _  __    _    ____  ____  _____ ____     _____ ____  
| |/ /   / \  / ___||  _ \| ____|  _ \   |_   _|  _ \ 
| ' /   / _ \ \___ \| |_) |  _| | |_) |    | | | |_) |
| . \  / ___ \ ___) |  __/| |___|  _ <     | | |  __/ 
|_|\_\/_/   \_\____/|_|   |_____|_| \_\    |_| |_|    
                                                      
--]]