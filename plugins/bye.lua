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
local function run(msg, matches, callback, extra)
local data = load_data(_config.moderation.data)
local group_bye = data[tostring(msg.to.id)]['group_bye']
if matches[1] == 'dbye' or matches[1] == 'مسح التوديع' and not matches[2] and is_owner(msg) then 
   data[tostring(msg.to.id)]['group_bye'] = nil --delete bye
        save_data(_config.moderation.data, data)
        local text = 'تـ{✅}ـم حـ(❌)ـذفـ الـتـ(👋)ـوديـع\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end
if not is_owner(msg) then 
    return 'لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط'
end
local rules = data[tostring(msg.to.id)]['rules']
if matches[1] == 'rules' and matches[2] and is_owner(msg) then
    if data[tostring(msg.to.id)]['rules'] == nil then --when no rules found....
        return ''
end
data[tostring(msg.to.id)]['group_tbye'] = matches[2]..'\n\nGroup Rules :\n'..rules
        save_data(_config.moderation.data, data)
        local text = 'تـ{✅}ـم حـفـ(💡)ـظ الـتـ(👋)ـوديـع\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end
if not is_owner(msg) then 
    return 'لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط'
end
if matches[1] and is_owner(msg) then
data[tostring(msg.to.id)]['group_bye'] = matches[1]
        save_data(_config.moderation.data, data)
        local text = 'تـ{✅}ـم حـفـ(💡)ـظ الـتـ(👋)ـوديـع\nيـا '..(msg.from.first_name or "erorr")..'\n' 
return reply_msg(msg.id, text, ok_cb, false)
end
if not is_owner(msg) then 
    return 'لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط'
end
end
return {
  patterns = {
  "^[!#/]sbye (.*)$",
  "^[!#/](dbye)$",
  "^ضع التوديع (.*)$",
  "^(مسح التوديع)$",
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