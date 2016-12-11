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
local function addword(msg, name)
    local hash = 'chat:'..msg.to.id..':badword'
    redis:hset(hash, name, 'nwrd')
    return "تـ(✅)ـم حـضـ(📵)ـر الـكـ{🌝}ـلـمـة\n↜"..name
end

local function get_variables_hash(msg)

    return 'chat:'..msg.to.id..':badword'

end 

local function list_variablesbad(msg)
  local hash = get_variables_hash(msg)

  if hash then
    local names = redis:hkeys(hash)
    local text = '⇓ الـكـلـ(🔞)ـمـاتـ» الـمـحـ{🚨}ـضـوره ⇓\n\n'
    for i=1, #names do
      text = text..'> '..names[i]..'\n'
    end
    return text
	else
	return 
  end
end

function clear_commandbad(msg, var_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:del(hash, var_name)
  return 'تـ{✅}ـم مـسـ(‼️)ـح الـكـلـ(🔞)ـمـاتـ» الـمـحـ{🚨}ـضـوره️'
end

local function list_variables2(msg, value)
  local hash = get_variables_hash(msg)
  
  if hash then
    local names = redis:hkeys(hash)
    local text = ''
    for i=1, #names do
	if string.match(value, names[i]) and not is_momod(msg) then
	if msg.to.type == 'channel' then
	delete_msg(msg.id,ok_cb,false)
	else
	kick_user(msg.from.id, msg.to.id)

	end
return 
end
      --text = text..names[i]..'\n'
    end
  end
end
local function get_valuebad(msg, var_name)
  local hash = get_variables_hash(msg)
  if hash then
    local value = redis:hget(hash, var_name)
    if not value then
      return
    else
      return value
    end
  end
end
function clear_commandsbad(msg, cmd_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:hdel(hash, cmd_name)
  return 'تـ(✅)ـم الـسـ{🚸}ـمـاح بـالـكـ(🌝)ـلـمـة\n↜'..cmd_name.. ' '
end

local function run(msg, matches)
  if matches[2] == 'f' or matches[2] == 'منع' then
  if not is_momod(msg) then
   return 'لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط'
  end
  local name = string.sub(matches[3], 1, 50)

  local text = addword(msg, name)
  return text
  end
  if matches[2] == 'a' or matches[2] == 'الكلمات المحضورة' then
  return list_variablesbad(msg)
  elseif matches[2] == 's' or matches[2] == 'مسح الكلمات' then
if not is_momod(msg) then return 'لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط' end
  local asd = '1'
    return clear_commandbad(msg, asd)
  elseif matches[2] == 'g' or matches[2] == 'الغاء منع' then
   if not is_momod(msg) then return 'لـلـمـ{🏆}ـدراء فـقـ(‼️)ـط' end
    return clear_commandsbad(msg, matches[3])
  else
    local name = user_print_name(msg.from)
  
    return list_variables2(msg, matches[1])
  end
end

return {
  patterns = {
  "^([!/])(g) (.*)$",
  "^([!/])(f) (.*)$",
    "^([!/])(a)$",
    "^([!/])(s)$",
  "^()(الغاء منع) (.*)$",
  "^()(منع) (.*)$",
    "^()(الكلمات المحضورة)$",
    "^()(مسح الكلمات)$",
"^(.+)$",
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