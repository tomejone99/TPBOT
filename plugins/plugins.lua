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
local function plugin_enabled( name ) 
  for k,v in pairs(_config.enabled_plugins) do 
    if name == v then 
      return k 
    end 
  end 
  return false 
end 
local function plugin_exists( name ) 
  for k,v in pairs(plugins_names()) do 
    if name..'.lua' == v then 
      return true 
    end 
  end 
  return false 
end 
local function list_all_plugins(only_enabled) 
  local text = '' 
  local nsum = 0 
  for k, v in pairs( plugins_names( )) do  
    local status = '🚫' 
    nsum = nsum+1 
    nact = 0 
    -- Check if is enabled 
    for k2, v2 in pairs(_config.enabled_plugins) do 
      if v == v2..'.lua' then 
        status = '✔' 
      end 
      nact = nact+1 
    end 
    if not only_enabled or status == '✔' then 
      -- get the name 
      v = string.match (v, "(.*)%.lua") 
      text = text..status..'➟ '..v..'\n' 
    end 
  end 
  local text = 'جـمـ(♻️)ـيـع الـمـلـ(🗂)ـفـاتـ»\n'..text..'\nالـمـلـ(🗂)ـفـاتـ» الـمـثـ(🗳)ـبـتـه ➠['..nsum..']\n الـمـلـ(🗂)ـفـاتـ» الـمـفـ(💡)ـعـلـه ➠['..nact..']\n الـمـلـ(🗂)ـفـاتـ» الـمـعـ(📵)ـطـلـه ➠['..nsum-nact..']'
  return text 
end 
local function list_plugins(only_enabled) 
  local text = '' 
  local nsum = 0 
  for k, v in pairs( plugins_names( )) do 
    local status = '🚫' 
    nsum = nsum+1 
    nact = 0  
    for k2, v2 in pairs(_config.enabled_plugins) do 
      if v == v2..'.lua' then 
        status = '✔' 
      end 
      nact = nact+1 
    end 
    if not only_enabled or status == '✔' then 
      v = string.match (v, "(.*)%.lua") 
      text = text..status..'➠ '..v..'\n' 
    end 
  end 
  local text = 'جـمـ(♻️)ـيـع الـمـلـ(🗂)ـفـاتـ»\n'..text..'\nالـمـلـ(🗂)ـفـاتـ» الـمـثـ(🗳)ـبـتـه ➠['..nsum..']\n الـمـلـ(🗂)ـفـاتـ» الـمـفـ(💡)ـعـلـه ➠['..nact..']\n الـمـلـ(🗂)ـفـاتـ» الـمـعـ(📵)ـطـلـه ➠['..nsum-nact..']'
  return text 
end 
local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
  return list_plugins(true) 
end 
local function enable_plugin( plugin_name ) 
  print('checking if '..plugin_name..' exists') 
  if plugin_enabled(plugin_name) then 
    return 'مـفـ(💡)ـ؏ـل الـمـ{📂}ـلـف \n➠ '..plugin_name..' ' 
  end 
  if plugin_exists(plugin_name) then 
    table.insert(_config.enabled_plugins, plugin_name) 
    print(plugin_name..' added to _config table') 
    save_config() 
    return reload_plugins( ) 
  else 
    return 'لـ(‼️)ـا يـوجـ{🚫}ـد مـلـ(📂)ـف بـهـ{☜}ـاذه الاسـ(❓)ـم \n➠ 1'..plugin_name..'' 
  end 
end 
local function disable_plugin( name, chat ) 
  if not plugin_exists(name) then 
    return 'لـ(‼️)ـا يـوجـ{🚫}ـد مـلـ(📂)ـف بـهـ{☜}ـاذه الاسـ(❓)ـم \n➠ '..name..' ' 
  end 
  local k = plugin_enabled(name) 
  if not k then 
    return 'مـ؏ـ(📴)ـطـل الـمـ{📂}ـلـف \n➠ '..name..' ' 
  end 
  table.remove(_config.enabled_plugins, k) 
  save_config( ) 
  return reload_plugins(true) 
end 
local function disable_plugin_on_chat(receiver, plugin) 
  if not plugin_exists(plugin) then 
    return "" 
  end 
  if not _config.disabled_plugin_on_chat then 
    _config.disabled_plugin_on_chat = {} 
  end 
  if not _config.disabled_plugin_on_chat[receiver] then 
    _config.disabled_plugin_on_chat[receiver] = {} 
  end 
  _config.disabled_plugin_on_chat[receiver][plugin] = true 
  save_config() 
  return 'Plugin '..plugin..' disabled on this chat' 
end 
local function reenable_plugin_on_chat(receiver, plugin) 
  if not _config.disabled_plugin_on_chat then 
    return 'There aren\'t any disabled plugins' 
  end 
  if not _config.disabled_plugin_on_chat[receiver] then 
    return 'There aren\'t any disabled plugins for this chat' 
  end 
  if not _config.disabled_plugin_on_chat[receiver][plugin] then 
    return 'This plugin is not disabled' 
  end 
  _config.disabled_plugin_on_chat[receiver][plugin] = false 
  save_config() 
  return 'Plugin '..plugin..' is enabled again' 
end 
local function run(msg, matches) 
  if matches[1] == '/p' and is_sudo(msg) then --after changed to moderator mode, set only sudo 
    return list_all_plugins() 
  end 
  if matches[1] == '+' and matches[3] == 'chat' then 
    local receiver = get_receiver(msg) 
    local plugin = matches[2] 
    print("enable "..plugin..' on this chat') 
    return reenable_plugin_on_chat(receiver, plugin) 
  end 
  if matches[1] == '+' and is_sudo(msg) then --after changed to moderator mode, set only sudo 
    local plugin_name = matches[2] 
    print("enable: "..matches[2]) 
    return enable_plugin(plugin_name) 
  end 
  if matches[1] == '-' and matches[3] == 'chat' then 
    local plugin = matches[2] 
    local receiver = get_receiver(msg) 
    print("disable "..plugin..' on this chat') 
    return disable_plugin_on_chat(receiver, plugin) 
  end 
  if matches[1] == '-' and is_sudo(msg) then --after changed to moderator mode, set only sudo 
    if matches[2] == 'p' then 
       return 'This plugin can\'t be disabled' 
    end 
    print("disable: "..matches[2]) 
    return disable_plugin(matches[2]) 
  end 
  if matches[1] == 'reload' and is_sudo(msg) then --after changed to moderator mode, set only sudo 
    return reload_plugins(true) 
  end 
end 

return { 
  description = "Plugin to manage other plugins. Enable, disable or reload.", 
  usage = { 
      moderator = { 
          "!plugins disable [plugin] chat : disable plugin only this chat.", 
          "!plugins enable [plugin] chat : enable plugin only this chat.", 
          }, 
      sudo = { 
          "!plugins : list all plugins.", 
          "!plugins enable [plugin] : enable plugin.", 
          "!plugins disable [plugin] : disable plugin.", 
          "!plugins reload : reloads all plugins." }, 
          }, 
  patterns = { 
    "^/p$", 
    "^/p? (+) ([%w_%.%-]+)$", 
    "^/p? (-) ([%w_%.%-]+)$", 
    "^/p? (+) ([%w_%.%-]+) (chat)", 
    "^/p? (-) ([%w_%.%-]+) (chat)", 
 }, 
  run = run, 
  moderated = true, 
  --privileged = true 
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