package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
require("./bot/utils")
local f = assert(io.popen('/usr/bin/git describe --tags', 'r'))
VERSION = assert(f:read('*a'))
f:close()
function on_msg_receive (msg)
  if not started then
    return
  end
  msg = backward_msg_format(msg)
  local receiver = get_receiver(msg)
  print(receiver)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
      if redis:get("bot:markread") then
        if redis:get("bot:markread") == "on" then
          mark_read(receiver, ok_cb, false)
        end
      end
    end
  end
end
function ok_cb(extra, success, result)
end
function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)
  _config = load_config()
  plugins = {}
  load_plugins()
end
function msg_valid(msg)
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end
  if msg.date < os.time() - 5 then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end
  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end
  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end
  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end
  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end
  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end
  if msg.from.id == 777000 then
    return false
  end
  return true
end
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      msg.text = "!!tgservice " .. action.type
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end
  return msg
end
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  if disabled_chats and disabled_chats[receiver] then
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        return true
      end
    end
  end
  return false
end
function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)
      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      if plugin.run then
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      return
    end
  end
end
function _send_msg(destination, text)
  send_large_msg(destination, text)
end
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end
function load_config( )
  local f = io.open('./data/config.lua', "r")
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Sudo user: " .. user)
  end
  return config
end
function create_config( )
  config = {
    enabled_plugins = {    
    "plugins",
    "supergroup",
    "msg_checks",
    "lock_fwd",
    "addsudo",
    "newgroup",
    "anti_spam",
    "azan",
    "banhammer",
    "broadcast",
    "bye",
    "calc",
    "cleanmsg",
    "dowelcome",
    "filter",
    "get",
    "help",
    "invite",
    "kickall",
    "linkpv",
    "lock_badword",
    "lock_english",
    "lock_inline",
    "lock_media",
    "lock_tag",
    "lock_username",
    "me",
    "onservice",
    "redis",
    "s_type",
    "sbye",
    "send",
    "short_link",
    "splug",
    "sticker",
    "tag_english",
    "translate",
    "weather",
    "welcome",
    "photo",
    "mp3",
    "audio",
    "time",
    "leave_ban",
    "lock_join",
    "info",
    "lock_kds"
    },
    sudo_users = {219844437,0},--Sudo users
    moderation = {data = 'data/moderation.json'},
    about_text = [[]],
    help_text_realm = [[]],
    help_text = [[]],
	help_text_super =[[]],
  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end
function on_our_id (id)
  our_id = id
end
function on_user_update (user, what)
end
function on_chat_update (chat, what)
end
function on_secret_chat_update (schat, what)
end
function on_get_difference_end ()
end
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)
    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)
    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
	  print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end
  end
end
function load_data(filename)
	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)
	return data
end
function save_data(filename, data)
	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()
end
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end
  postpone (cron_plugins, false, 120)
end
our_id = 0
now = os.time()
math.randomseed(now)
started = false
