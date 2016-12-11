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
do 
local function run(msg, matches) 
  if matches[1] == "splug" or matches[1] == "جلب ملف" then 
    local file = matches[2] 
    if is_sudo(msg) then --sudo only ! 
      local receiver = get_receiver(msg) 
      send_document(receiver, "./plugins/"..file..".lua", ok_cb, false) 
              local text = 'انـتـ{💠}ـضـر قـلـ(💡)ـيـل مـن فـضـ{🛠}ـلـك\nسـارسـل لـك الـمـلـف↜'..matches[2]..'\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false) 
      else 
        return nil 
    end 
end 
  if matches[1] == "dplug" or matches[1] == "حذف ملف" then 
text = io.popen("rm -rf " .. matches[1]):read('*all') 
  local text = 'تـ{✅}ـم حـ(🕳)ـذف الـمـ{📂}ـلـف\n↝'..matches[2]..'\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end 
end 

return { 
  patterns = { 
  "^[/#!](splug) (.*)$", 
  "^[/#!](dplug) (.*)$", 
  "^(حذف ملف) (.*)",
  "^(جلب ملف) (.*)",

  }, 
  run = run 
} 
end
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