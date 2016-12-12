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
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = '🔓',
		  lock_link = "🔓",
          flood = '🔒',
		  lock_spam = '🔒',
		  lock_sticker = '🔓',
		  member = '🔓',
		  public = '🔓',
		  lock_rtl = '🔓',
		  lock_tgservice = '🔒',
		  lock_contacts = '🔓',
		  strict = '🔓',
		  lock_fwd = '🔒'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text1 = 'تـ{✅}ـم تـفـعـ(💡)ـيـل الـبـ{🤖}ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text1, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local text1 = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل الـبـ{🤖}ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text1, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="مـعلـ(ℹ️)ـومـاتـ« الـمـجـ{🌐}ـمـوعـة: "..result.title.."\n\n"
local admin_num = "عـ(♻️)ـدد الادمـ{🎖}ـنـيـه: "..result.admins_count.."\n"
local user_num = "عـ(♻️)ـدد الاعـ(🙊)ـضـاء: "..result.participants_count.."\n"
local kicked_num = "عـ(♻️)ـدد الـمـطـ{👞}ـروديـن: "..result.kicked_count.."\n"
local channel_id = "ID 🆔: "..result.peer_id.."\n"
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username Channel : @DevPointTeam
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end
--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == '🔒' then
   local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ روابـ(🖇)ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_link'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ روابـ(🖇)ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end
local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ روابـ(🖇)ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_link'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ روابـ(🖇)ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end
end

local function lock_group_all(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['all'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end


local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['all'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end
local function lock_group_etehad(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_etehad_lock = data[tostring(target)]['settings']['etehad']
  if group_etehad_lock == '🔒' then
    return ''
  else
    data[tostring(target)]['settings']['etehad'] = '🔒'
    save_data(_config.moderation.data, data)
    return ''
  end
end

local function unlock_group_etehad(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_etehad_lock = data[tostring(target)]['settings']['etehad']
  if group_etehad_lock == '🔓' then
    return ''
  else
    data[tostring(target)]['settings']['etehad'] = '🔓'
    save_data(_config.moderation.data, data)
    return ''
  end
end

local function lock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_leave_lock = data[tostring(target)]['settings']['leave']
  if group_leave_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمـغـ(🚷)ـادرة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['leave'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمـغـ(🚷)ـادرة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_leave_lock = data[tostring(target)]['settings']['leave']
  if group_leave_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمـغـ(🚷)ـادرة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['leave'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـمـغـ(🚷)ـادرة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == '🔒' then
    return ''
  else
    data[tostring(target)]['settings']['operator'] = '🔒'
    save_data(_config.moderation.data, data)
    return ''
  end
end

local function unlock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == '🔓' then
    return ''
  else
    data[tostring(target)]['settings']['operator'] = '🔓'
    save_data(_config.moderation.data, data)
    return ''
  end
end

local function lock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـ(🔃)ـردود\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['reply'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـ(🔃)ـردود\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـ(🔃)ـردود\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['reply'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـ(🔃)ـردود\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمـ؏ـ(Ⓜ️)ـرفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['username'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمـ؏ـ(Ⓜ️)ـرفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمـ؏ـ(Ⓜ️)ـرفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['username'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـمـ؏ـ(Ⓜ️)ـرفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمـيـ(🔕)ـديـا\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['media'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمـيـ(🔕)ـديـا\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمـيـ(🔕)ـديـا\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['media'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـمـيـ(🔕)ـديـا\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_fosh(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fosh_lock = data[tostring(target)]['settings']['fosh']
  if group_fosh_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـفـ(🔞)ـاض\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fosh'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـفـ(🔞)ـاض\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_fosh(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fosh_lock = data[tostring(target)]['settings']['fosh']
  if group_fosh_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـفـ(🔞)ـاض\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fosh'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـفـ(🔞)ـاض\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_join(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_join_lock = data[tostring(target)]['settings']['join']
  if group_join_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـدخـ(🚷)ـول بـرابـ{🖇}ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['join'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـدخـ(🚷)ـول بـرابـ{🖇}ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_join(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_join_lock = data[tostring(target)]['settings']['join']
  if group_join_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـدخـ(🚷)ـول بـرابـ{🖇}ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['join'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـدخـ(🚷)ـول بـرابـ{🖇}ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـتـوجـ(↻)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fwd'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـتـوجـ(↻)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـتـوجـ(↻)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n' 
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['fwd'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـتـوجـ(↻)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ لـغـة الانـكـ(🔠)ـلـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['english'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ لـغـة الانـكـ(🔠)ـلـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ لـغـة الانـكـ(🔠)ـلـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['english'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ لـغـة الانـكـ(🔠)ـلـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـسـمـ(⛷)ـايـلاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['emoji'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـسـمـ(⛷)ـايـلاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـسـمـ(⛷)ـايـلاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['emoji'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـسـمـ(⛷)ـايـلاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـتـ(#)ـاك\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['tag'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـتـ(#)ـاك\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـتـ(#)ـاك\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['tag'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـتـ(#)ـاك\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['all'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط"
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـكـ(📊)ـلايـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_spam'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـكـ(📊)ـلايـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـكـ(📊)ـلايـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_spam'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـكـ(📊)ـلايـش\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـتـ(📑)ـكـرار\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['flood'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـتـ(📑)ـكـرار\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـتـ(📑)ـكـرار\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['flood'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـتـ(📑)ـكـرار\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ لـغـة الـ؏ـربـ(🔡)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_arabic'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ لـغـة الـ؏ـربـ(🔡)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ لـغـة الـ؏ـربـ(🔡)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_arabic'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ لـغـة الـ؏ـربـ(🔡)ـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end


local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الاضـ(👥)ـافـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_member'] = '🔒'
    save_data(_config.moderation.data, data)
  end
  local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الاضـ(👥)ـافـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الاضـ(👥)ـافـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_member'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الاضـ(👥)ـافـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـجـمـ(🎎)ـا؏ـيـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_rtl'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـجـمـ(🎎)ـا؏ـيـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـجـمـ(🎎)ـا؏ـيـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_rtl'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـجـمـ(🎎)ـا؏ـيـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الاشـ(📵)ـارة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tgservice'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الاشـ(📵)ـارة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الاشـ(📵)ـارة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tgservice'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الاشـ(📵)ـارة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمـلـصـ(🎭)ـقـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_sticker'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمـلـصـ(🎭)ـقـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمـلـصـ(🎭)ـقـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_sticker'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـمـلـصـ(🎭)ـقـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـبـوتـ(🤖)ـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_bots'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـبـوتـ(🤖)ـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـبـوتـ(🤖)ـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_bots'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـبـوتـ(🤖)ـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـجـ(☎️)ـهـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_contacts'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـجـ(☎️)ـهـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـجـ(☎️)ـهـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_contacts'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـجـ(☎️)ـهـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ مـشـ(🚨)ـدده\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['strict'] = '🔒'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ مـشـ(🚨)ـدده\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ مـشـ(🚨)ـدده\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['strict'] = '🔓'
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ مـشـ(🚨)ـدده\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end
--End supergroup locks

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  local text = 'تـ(✅)ـم حـفـ{♻️}ـظ الـقـوانـ(📋)ـيـن\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'No rules available.'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..'\nالـقـ(‼️)ـوانـيـن\n'..rules:gsub("/n", " ")
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط"
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == '🔒' then
    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمـراقـ(💯)ـبـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['public'] = '🔒'
    save_data(_config.moderation.data, data)
  end
  local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمـراقـ(💯)ـبـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == '🔓' then
    local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمـراقـ(💯)ـبـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  else
    data[tostring(target)]['settings']['public'] = '🔓'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
    local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل الـمـراقـ(💯)ـبـة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
  end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
    local bots_protection = "🔒"
    if data[tostring(target)]['settings']['lock_bots'] then
    	bots_protection = data[tostring(target)]['settings']['lock_bots']
   	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = '🔓'
		end
        end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['tag'] then
			data[tostring(target)]['settings']['tag'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['emoji'] then
			data[tostring(target)]['settings']['emoji'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['english'] then
			data[tostring(target)]['settings']['english'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fwd'] then
			data[tostring(target)]['settings']['fwd'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['reply'] then
			data[tostring(target)]['settings']['reply'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['join'] then
			data[tostring(target)]['settings']['join'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fosh'] then
			data[tostring(target)]['settings']['fosh'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['username'] then
			data[tostring(target)]['settings']['username'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['media'] then
			data[tostring(target)]['settings']['media'] = '🔓'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['leave'] then
			data[tostring(target)]['settings']['leave'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['all'] then
			data[tostring(target)]['settings']['all'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['operator'] then
			data[tostring(target)]['settings']['operator'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['etehad'] then
			data[tostring(target)]['settings']['etehad'] = '🔓'
		end
	end
  local gp_type = data[tostring(msg.to.id)]['group_type']
  
  local settings = data[tostring(target)]['settings']
  local text = "🌐Settings🌐".."\n"
.."GP NAME➠"..msg.to.title.."\n"
.."💠--------------------------------------------💠".."\n"
.."🖇lock links➠("..settings.lock_link..")".."\n"
.."💳Lock contacts➠("..settings.lock_contacts..")".."\n"
.."📑Lock flood➠("..settings.flood..")".."\n"
.."📜Flood sensitivity➠("..NUM_MSG_MAX..")".."\n"
.."📊Lock spam➠("..settings.lock_spam..")".."\n"
.."🔡Lock Arabic➠("..settings.lock_arabic..")".."\n"
.."🔠Lock english➠("..settings.english..")".."\n"
.."👤Lock Member➠("..settings.lock_member..")".."\n"
.."👥Lock RTL➠("..settings.lock_rtl..")".."\n"
.."💈Lock Tgservice➠("..settings.lock_tgservice..")".."\n"
.."🎭Lock sticker➠("..settings.lock_sticker..")".."\n"
.."ℹLock tag(#)➠("..settings.tag..")".."\n"
.."😏Lock emoji➠("..settings.emoji..")".."\n"
.."🤖Lock bots➠("..bots_protection..")".."\n"
.."↪️Lock fwd(forward)➠("..settings.fwd..")".."\n"
.."♻lock reply➠("..settings.reply..")".."\n"
.."🚶Lock join➠("..settings.join..")".."\n"
.."ⓂLock user(@)➠("..settings.username..")".."\n"
.."🎛Lock media➠("..settings.media..")".."\n"
.."🔞Lock badword➠("..settings.fosh..")".."\n"
.."🚷Lock leave➠("..settings.leave..")".."\n"
.."🛡Lock all➠("..settings.all..")".."\n"
.."💠--------------------------------------------💠".."\n"
.."About G️roup".."\n"
.."💠--------------------------------------------💠".."\n"
.."👥️Group type➠("..gp_type..")".."\n"
.."👮Public➠("..settings.public..")".."\n"
.."🛇Strict settings➠("..settings.strict..")".."\n"
.."💠--------------------------------------------💠".."\n"
.."                     TP B❂T v2".."\n"
.."╔Channel➟ @dev_kasper ╗"
  return text
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' is already a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' is not a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, 'SuperGroup is not added.')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..'\nتـ{✅}ـم تـرقـ(🏅)ـيـتـك اداريـ» مـنـقـ{🎋😐}ـبـل')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..'\nتـ{✅}ـم تـرقـ(🏅)ـيـتـك اداريـ»')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..'\nتـ{✅}ـم تـنـزيـ(⇊)ـلـك↜')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..'\nتـ{✅}ـم تـنـزيـ(⇊)ـلـك↜')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'SuperGroup is not added.'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return 'No moderator in this group.'
  end
  local i = 1
  local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]")
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد نـفـ(☯)ـسـك")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد الـمـ(🏆)ـدراء")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد نـفـ(☯)ـسـك")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد نـفـ(☯)ـسـك")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد الـمـ(🏆)ـدراء")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط")
    end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "تـ{✅}ـم تـرقـ(🎖)ـيـتـك ادمـ{🌚}ـن»↜ "..result.from.first_name
		else
			text = "تـ{✅}ـم تـرقـ(🎖)ـيـتـك ادمـ{🌚}ـن»↜ "..result.from.first_name
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "تـ{✅}ـم تـنـزيـ(⇊)ـلـك↜ "..result.from.first_name
		else
			text = "تـ{✅}ـم تـنـزيـ(⇊)ـلـك↜ "..result.from.first_name
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = "تـ{✅}ـم تـرقـ(🏆)ـيـتـك الـمـ{🌝}ـديـر»↜"..result.from.first_name
			else
				text = "تـ{✅}ـم تـرقـ(🏆)ـيـتـك الـمـ{🌝}ـديـر»↜"..result.from.first_name
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "تـ{✅}ـم فـتـ(🔊)ـح كـ{🔇}ـتـم \n"..result.from.first_name.."")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, "تـ{✅}ـم كـ(🔇)ـتـم \n"..result.from.first_name.."")
		end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "تـ{✅}ـم تـرقـ(🎖)ـيـتـك ادمـ{🌚}ـن»↜ "..result.from.first_name
		else
			text = "تـ{✅}ـم تـرقـ(🎖)ـيـتـك ادمـ{🌚}ـن»↜{} "..result.from.first_name
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "تـ{✅}ـم تـنـزيـ(⇊)ـلـك↜ "..result.from.first_name
			send_large_msg(receiver, text)
		else
			text = "تـ{✅}ـم تـنـزيـ(⇊)ـلـك↜ "..result.from.first_name
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "تـ{✅}ـم تـنـزيـ(⇊)ـلـك↜ "..result.from.first_name
			send_large_msg(channel_id, text)
		else
			text = "تـ{✅}ـم تـنـزيـ(⇊)ـلـك↜ "..result.from.first_name
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "تـ{✅}ـم كـ(🔇)ـتـم".."\n"..result.from.first_name)
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, "تـ{✅}ـم فـتـ(🔊)ـح كـ{🔇}ـتـم".."\n"..result.from.first_name)
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = 'No user @'..member..' in this SuperGroup.'
  else
    text = 'No user ['..memberid..'] in this SuperGroup.'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد نـفـ(☯)ـسـك")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "لـ{🖐🏿}ـا يـمـكـ(‼️)ـنـك طـ{👞}ـرد الـمـ(🏆)ـدراء")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط")
      end
      if v.username then
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]")
      else
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setowner" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "تـ{✅}ـم تـرقـ(🏆)ـيـتـك الـمـ{🌝}ـديـر»↜"..result.from.first_name
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..v.username.." ["..v.peer_id.."]")
      else
        text = "تـ{✅}ـم تـرقـ(🏆)ـيـتـك الـمـ{🌝}ـديـر»↜"..result.from.first_name
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
 elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] as owner by username")
				if result.username then
					text = member_username.."تـ{✅}ـم تـرقـ(🏆)ـيـتـك الـمـ{🌝}ـديـر»↜"..result.from.first_name
				else
					text = "تـ{✅}ـم تـرقـ(🏆)ـيـتـك الـمـ{🌝}ـديـر»↜"..result.from.first_name
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = "["..memberid.."] added as owner"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'تـ{✅}ـم تـحـمـ(♻️)ـيـل الـصـ{📷}ـوره', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

--Run function
local function DevPointTeam(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1] == 'super' or matches[1] == 'تحويل سوبر' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'super' or matches[1] == 'تحويل سوبر' then
			if not is_admin1(msg) then
				return
			end
			local text = 'تـ{✅}ـم تـحـ(♻️)ـويـل سـ{🚀}ـوبـر\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
			if matches[1] == 'start' or matches[1] == 'تفعيل' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
		  local iDev1 = 'مـفـ(💡)ـ؏ـل الـبـ{🤖}ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n' 
return reply_msg(msg.id, iDev1, ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] added SuperGroup")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end
		if matches[1] == 'add1bot' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
			  local iDev1 = 'مـفـ(💡)ـ؏ـل الـبـ{🤖}ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n' 
return reply_msg(msg.id, iDev1, ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end
		if matches[1] == 'stop' or matches[1] == 'تعطيل' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				local text = 'مـ؏ـطـ(📴)ـل الـبـ{🤖}ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end--@DevPointTeam = Dont Remove
		if matches[1] == "gpfo" or matches[1] == "معلومات المجموعه" then
			if not is_owner(msg) then
				return
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1] == "adns" or matches[1] == "الادمنيه" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Adns'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "ower" or matches[1] == "المدير" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "no owner,ask admins in support groups to set owner for your SuperGroup"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
			return "SuperGroup owner is ["..group_owner..']'
		end

		if matches[1] == "mod" or matches[1] == "الادارين" then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1] == "bots" or matches[1] == "كشف البوتات" and is_momod(msg) then
			member_type = 'Bots'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" or matches[1] == "معلومات الاعضاء" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1] == "kked" or matches[1] == "المحضورين" and is_momod(msg) then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1] == 'del' or matches[1] == 'مسح' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1] == 'kick' or matches[1] == 'طرد' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'kick' and string.match(matches[2], '^%d+$') then
			
				local	get_cmd = 'channel_block'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif msg.text:match("@[%a%d]") then
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'id' or matches[1] == 'ايدي' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
				local text = 'ID➠【'..msg.from.id..'】\nID GP➠【'..msg.to.id..'】\n╔Channel➟ @dev_kasper ╗'
        return reply_msg(msg.id, text, ok_cb, false)
			end
		end

		if matches[1] == 'kkme' or matches[1] == 'اطردني' then
			if msg.to.type == 'channel' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] left via kickme")
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

		if matches[1] == 'nlink' or matches[1] == 'رابط جديد' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, 'الـمـ(🏆)ـديـر فـقـ{🖐🏿}ـط يـمـ(no)ـكـنـه اخـ{😴}ـراج الـرابـ(🖇)ـط سـ{🎋🙁}ـوري ')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "تـ(✅)ـم انـشـ{✨}ـاء رابـ(🖇)ـط جـ{💫}ـديـد")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			savelog(msg.to.id, name_log..""..msg.from.id.."\nضـ(♻️)ـع رابـ{🖇}ـط يـ(🖐🏿)ـدوي عـن امـ{☚}ـر /slink ")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1] == 'slink' or matches[1] == 'ضع الرابط' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			local text = 'ارسـ(🚀)ـل الـرابـ{🔗}ـط الان\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
		end

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				local text = 'تـ{✅}ـم حـفـ(♻️)ـظ الـرابـ{🖇}ـط\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
		end

		if matches[1] == 'link' or matches[1] == 'الرابط' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				local text = 'قـ(💡)ـم انـشـ{🍃}ـاء رابط جـديـ(✨)ـد اول\nاضـ(💫)ـغـط هـ(☚)ـنـا /sllin\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			local text = 'اسـ(♍️)ـم الـمـجـ{🌐}ـمـوعـة '..msg.to.title..'\nرابـ{🖇}ـط الـمـجـ(🌐)ـمـوعـة⇓\n'..group_link..'\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == "inte" or matches[1] == "اضافة" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'res' or matches[1] == 'الايدي' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end
			if matches[1] == 'sadmin' or matches[1] == 'رفع ادمن' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setadmin' and string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setadmin'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setadmin' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setadmin'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'rem' or matches[1] == 'تنزيل ادمن' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demoteadmin' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demoteadmin' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'add' or matches[1] == 'رفع المدير' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setowner' and string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'sowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'pro' or matches[1] == 'رفع اداري' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'promote' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "ok"
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "ok"
		end

		if matches[1] == 'qro' or matches[1] == 'تنزيل اداري' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == "sname" or matches[1] == "ضع اسم" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1] == "sabout" or matches[1] == "ضع الوصف" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
			local text = 'تـ(✅)ـم حـفـ{♻️}ـظ الوصـ(📋)ـف\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == "suser" or matches[1] == "ضع المعرف" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "تـ(✅)ـم حـفـ{♻️}ـظ الـمـعـ(Ⓜ️)ـرفـ‹")
				elseif success == 0 then
					send_large_msg(receiver, "Failed to set SuperGroup username.\nUsername may already be taken.\n\nNote: Username can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1] == 'srules' or matches[1] == 'ضع القوانين' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1] == 'spho' or matches[1] == 'ضع الصوره' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
			local text = 'قـ{🖐🏿}ـم بـأرسـ(🚀)ـال صـ{📷}ـورة\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
		end

		if matches[1] == 'd' or matches[1] == 'مسح' then
			if not is_momod(msg) then
				return
			end
			if not is_momod(msg) then
				return "لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط"
			end
			if matches[2] == 'mod' or matches[2] == 'الادارين' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					local text = 'لـ(‼️)ـا تـوجـ{♻️}ـد الادمـ{🎖}ـنـيـه لـلـمـ(🍃)ـسـح\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
				local text = ' تـ{✅}ـم حـ(❌)ـذفـ الادمـ{🎖}ـنـيـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'rules' or matches[2] == 'القوانين' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					local text = 'لـ(‼️)ـا تـوجـ{♻️}ـد قـوانـ(📋)ـيـن لـلـمـ(🍃)ـسـح\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
				local text = ' تـ{✅}ـم حـ(❌)ـذفـ الـقـ{📋}ـوانـيـن\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'about' or matches[2] == 'الوصف' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					local text = 'لـ(‼️)ـا تـوجـ{♻️}ـد وصـ(��)ـف لـلـمـ(🍃)ـسـح\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
				local text = ' تـ{✅}ـم حـ(❌)ـذفـ وصـ{📋}ـف\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'sist' or matches[2] == 'المكتومين' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				local text = ' تـ{✅}ـم حـ(❌)ـذفـ الـمـكـتـ{🔇}ـومـيـن\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
			end
			if matches[2] == 'user' or matches[2] == 'المعرف' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup username cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed to clean SuperGroup username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
		end

		if matches[1] == 'n' or matches[1] == 'قفل' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'all' then
      	local safemode ={
        lock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		lock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		lock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		lock_group_contacts(msg, data, target),
		lock_group_english(msg, data, target),
		lock_group_fwd(msg, data, target),
		lock_group_reply(msg, data, target),
		lock_group_join(msg, data, target),
		lock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		lock_group_media(msg, data, target),
		lock_group_leave(msg, data, target),
		lock_group_bots(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return lock_group_all(msg, data, target), safemode
      end
			     if matches[2] == 'etehad' then
      	local etehad ={
        unlock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		lock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		lock_group_leave(msg, data, target),
		lock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return lock_group_etehad(msg, data, target), etehad
      end
			if matches[2] == 'lin' or matches[2] == 'الروابط' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'joi' or matches[2] == 'الدخول' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked join ")
				return lock_group_join(msg, data, target)
			end
			if matches[2] == 'tag' or matches[2] == 'التاك' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked tag ")
				return lock_group_tag(msg, data, target)
			end			
			if matches[2] == 'spa' or matches[2] == 'الكلايش' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flo' or matches[2] == 'التكرار' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'ara' or matches[2] == 'العربيه' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'mem' or matches[2] == 'الاضافة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end		    
			if matches[2]:lower() == 'rtl' or matches[2]:lower() == 'الجماعية' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
			if matches[2] == 'tgs' or matches[2] == 'الاشعارة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sti' or matches[2] == 'الملصقات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'con' or matches[2] == 'الجهات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked contact posting")
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == 'str' or matches[2] == 'المشدده' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
			if matches[2] == 'eng' or matches[2] == 'الانكلش' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked english")
				return lock_group_english(msg, data, target)
			end
			if matches[2] == 'fwd' or matches[2] == 'التوجيه' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fwd")
				return lock_group_fwd(msg, data, target)
			end
			if matches[2] == 'rep' or matches[2] == 'الرد' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked reply")
				return lock_group_reply(msg, data, target)
			end
			if matches[2] == 'emo' or matches[2] == 'السمايلات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked emoji")
				return lock_group_emoji(msg, data, target)
			end
			if matches[2] == 'bad' or matches[2] == 'الفاض السيئة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fosh")
				return lock_group_fosh(msg, data, target)
			end
			if matches[2] == 'med' or matches[2] == 'الوسائط' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked media")
				return lock_group_media(msg, data, target)
			end
			if matches[2] == 'use' or matches[2] == 'المعرفات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked username")
				return lock_group_username(msg, data, target)
			end
			if matches[2] == 'lea' or matches[2] == 'المغادرة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked leave")
				return lock_group_leave(msg, data, target)
			end
			if matches[2] == 'bot' or matches[2] == 'البوتات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return lock_group_bots(msg, data, target)
			end
			if matches[2] == 'ope' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator")
				return lock_group_operator(msg, data, target)
			end
		end

		if matches[1] == 'u' or matches[1] == 'فتح' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'all' then
      	local dsafemode ={
        unlock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		unlock_group_spam(msg, data, target),
		unlock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		unlock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_all(msg, data, target), dsafemode
      end
	  	if matches[2] == 'etehad' then
      	local detehad ={
        lock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		unlock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_etehad(msg, data, target), detehad
      end
			if matches[2] == 'lin' or matches[2] == 'الروابط' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'joi' or matches[2] == 'الدخول' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked join")
				return unlock_group_join(msg, data, target)
			end
			if matches[2] == 'tag' or matches[2] == 'التاك' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tag")
				return unlock_group_tag(msg, data, target)
			end			
			if matches[2] == 'spa' or matches[2] == 'الكلايش' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flo' or matches[2] == 'التكرار' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood")
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'ara' or matches[2] == 'العربيه' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'mem' or matches[2] == 'الاضافة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ")
				return unlock_group_membermod(msg, data, target)
			end                   
			if matches[2]:lower() == 'rtl' or matches[2]:lower() == 'الجماعية' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
				if matches[2] == 'tgs' or matches[2] == 'الاشعارة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sti' or matches[2] == 'الملصقات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'con' or matches[2] == 'الجهات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'str' or matches[2] == 'المشدده' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
			if matches[2] == 'eng' or matches[2] == 'الانكلش' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked english")
				return unlock_group_english(msg, data, target)
			end
			if matches[2] == 'fwd' or matches[2] == 'التوجيه' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fwd")
				return unlock_group_fwd(msg, data, target)
			end
			if matches[2] == 'rep' or matches[2] == 'الرد' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked reply")
				return unlock_group_reply(msg, data, target)
			end
			if matches[2] == 'emo' or matches[2] == 'السمايلات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled emoji")
				return unlock_group_emoji(msg, data, target)
			end
			if matches[2] == 'bad' or matches[2] == 'الفاض السيئة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fosh")
				return unlock_group_fosh(msg, data, target)
			end
			if matches[2] == 'med' or matches[2] == 'الوسائط' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked media")
				return unlock_group_media(msg, data, target)
			end
			if matches[2] == 'use' or matches[2] == 'المعرفات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled username")
				return unlock_group_username(msg, data, target)
			end
			if matches[2] == 'lea' or matches[2] == 'المغادرة' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked leave")
				return unlock_group_leave(msg, data, target)
			end
			if matches[2] == 'bot' or matches[2] == 'البوتات' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return unlock_group_bots(msg, data, target)
			end
			if matches[2] == 'ope' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator")
				return unlock_group_operator(msg, data, target)
			end
		end

		if matches[1] == 'sflo' or matches[1] == 'ضع التكرار' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 20 then
				return "ضـ(♻️)ـع تـكـ{📑}ـرار مـن 5 الـﮱ 20"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
			return 'Flood has been set to: '..matches[2]
		end
		if matches[1] == 'plic' or matches[1] == 'المراقبة' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' or matches[2] == 'نعم' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' or matches[2] == 'لا' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1] == 'n' or matches[1] == 'قفل' and is_owner(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'aud' or matches[2] == 'الصوت' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					    local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـصـ(🎤)ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					    local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـصـ(🎤)ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'pho' or matches[2] == 'الصور' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـصـ(📷)ـور\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـصـ(📷)ـور\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'vid' or matches[2] == 'الفيديو' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـفـيـ(🎥)ـديـو\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـفـيـ(🎥)ـديـو\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'gif' or matches[2] == 'المتحركه' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمتـحـ(🎳)ـركـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمتـحـ(🎳)ـركـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'doc' or matches[2] == 'الملفات' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـمـلـ(📂)ـفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـمـلـ(📂)ـفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'txt' or matches[2] == 'الكتابه' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـكـتـ(📝)ـابـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـكـتـ(📝)ـابـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'all' or matches[2] == 'الكل' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـفـ؏ـ(💡)ـيـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـفـ(💡)ـ؏ـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
		end
		if matches[1] == 'u' or matches[1] == 'فتح' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'aud' or matches[2] == 'الصوت' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـصـ(🎤)ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـصـ(🎤)ـوتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'pho' or matches[2] == 'الصور' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـصـ(📷)ـور\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـصـ(📷)ـور\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'vid' or matches[2] == 'الفيديو' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـفـيـ(🎥)ـديـو\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـفـيـ(🎥)ـديـو\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'gif' or matches[2] == 'المتحركه' then
			local msg_type = 'Gifs'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـمتـحـ(🎳)ـركـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمتـحـ(🎳)ـركـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'doc' or matches[2] == 'الملفات' then
			local msg_type = 'Documents'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـمـلـ(📂)ـفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـمـلـ(📂)ـفـاتـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'txt' or matches[2] == 'الكتابه' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـكـتـ(📝)ـابـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـكـتـ(📝)ـابـه\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
			if matches[2] == 'all' or matches[2] == 'الكل' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					local text = 'تـ{✅}ـم تـ؏ـطـ(📴)ـيـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				else
					local text = 'مـ؏ـطـ(📴)ـل مـنـ{🛡}ـ؏ الـكـ(⚰)ـلـ«\nيـا '..(msg.from.first_name or "erorr")..'\n'
return reply_msg(msg.id, text, ok_cb, false)
				end
			end
		end


		if matches[1] == "silt" or matches[1] == "كتم" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1] == "silt" or matches[1] == "كتم" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					return "["..user_id.."] removed from the muted users list"
				elseif is_momod(msg) then
					mute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					return "["..user_id.."] added to the muted user list"
				end
			elseif matches[1] == "silt" or matches[1] == "كتم" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1] == "mist" or matches[1] == "اعدادات الوسائط" and is_momod(msg) then
			local chat_id = msg.to.id
			if not has_mutes(chat_id) then
				set_mutes(chat_id)
				return mutes_list(chat_id)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return mutes_list(chat_id)
		end
		if matches[1] == "sist" or matches[1] == "المكتومين" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			return muted_user_list(chat_id)
		end

		if matches[1] == 'sett' or matches[1] == 'الاعدادات' and is_momod(msg) then
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1] == 'rules' or matches[1] == 'القوانين' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		if matches[1] == 'he1lp' and not is_owner(msg) then
			text = "️"
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_owner(msg) then
			local name_log = user_print_name(msg.from)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /superhelp")
			return super_help()
		end

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[#!/]([Ss]tart)$",
	"^[#!/]([Ss]top)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg]pfo)$",
	"^[#!/]([Aa]dns)$",
	"^[#!/]([Oo]wer)$",
	"^[#!/]([Mm]od)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]ked)$",
	"^[#!/]([Kk]ick) (.*)",
	"^[#!/]([Kk]ick)",
	"^[#!/]([Ss]uper)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk]kme)$",
	"^[#!/]([Nn]link)$",
	"^[#!/]([Ss]link)$",
	"^[#!/]([Ll]ink)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Ss]admin) (.*)$",
	"^[#!/]([Ss]admin)",
	"^[#!/]([Qq]ro) (.*)$",
	"^[#!/]([Qq]ro)",
	"^[#!/]([Rr]em) (.*)$",
	"^[#!/]([Rr]em)",
	"^[#!/]([Aa]dd) (.*)$",
	"^[#!/]([Aa]dd)$",
	"^[#!/]([Pp]ro) (.*)$",
	"^[#!/]([Pp]ro)",
	"^[#!/]([Dd]) (.*)$",
	"^[#!/]([Dd]el)",
	"^[#!/]([Ss]name) (.*)$",
	"^[#!/]([Ss]about) (.*)$",
	"^[#!/]([Ss]rules) (.*)$",
	"^[#!/]([Ss]pho)$",
	"^[#!/]([Ss]user) (.*)$",
	"^[#!/]([Nn])(.*)$",
	"^[#!/]([Uu])(.*)$",
	"^[#!/]([Nn])([^%s]+)$",
	"^[#!/]([Uu])([^%s]+)$",
	"^[#!/]([Ss]ilt)$",
	"^[#!/]([Ss]ilt) (.*)$",
	"^[#!/](plic) (.*)$",
	"^[#!/]([Ss]ett)$",
	"^[#!/]([Rr]ules)$",
	"^[#!/]([Ss]flo) (%d+)$",
	"^[#!/](d)(.*)$",
	"^[#!/]([Mm]ist)$",
	"^[#!/]([Ss]ist)$",
  "[#!/](mp) (.*)",
	"[#!/](md) (.*)",
	"^(تفعيل)$",
	"^(تعطيل)$",
	"^(معلومات المجموعه)$",
	"^(الادمنيه)$",
	"^(المدير)$",
	"^(الادارين)$",
	"^(كشف البوتات)$",
	"^(معلومات الاعضاء)$",
	"^(المحضورين)$",
	"^(طرد) (.*)",
	"^(طرد)",
	"^(تحويل سوبر)$",
	"^(ايدي)$",
	"^(ايدي) (.*)$",
	"^(اطردني)$",
	"^(رابط جديد)$",
	"^(ضع الرابط)$",
	"^(الرابط)$",
	"^(الايدي) (.*)$",
	"^(رفع ادمن) (.*)$",
	"^(رفع ادمن)",
	"^(تنزيل اداري) (.*)$",
	"^(تنزيل اداري)",
	"^(تنزيل ادمن) (.*)$",
	"^(تنزيل ادمن)",
	"^(رفع المدير) (.*)$",
	"^(رفع المدير)$",
	"^(رفع اداري) (.*)$",
	"^(رفع اداري)",
	"^(ضع اسم) (.*)$",
	"^(ضع الوصف) (.*)$",
	"^(ضع القوانين) (.*)$",
	"^(ضع الصوره)$",
	"^(ضع المعرف) (.*)$",
	"^(مسح)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(قفل) ([^%s]+)$",
	"^(فتح) ([^%s]+)$",
	"^(كتم)$",
	"^(كتم) (.*)$",
	"^(المراقبة) (.*)$",
	"^(الاعدادات)$",
	"^(القوانين)$",
	"^(ضع التكرار) (%d+)$",
	"^(مسح) (.*)$",
	"^(اعدادات الوسائط)$",
	"^(المكتومين)$",
  "[#!/](mp) (.*)",
	"[#!/](md) (.*)",
  "^(https://telegram.me/joinchat/%S+)$",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(Documents)%]",
	"%[(Gifs)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = DevPointTeam,
  pre_process = pre_process
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