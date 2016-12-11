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
local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

local function get_weather(location)
  print("Finding weather in ", location)
  local url = BASE_URL
  url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
  url = url..'&units=metric'

  local b, c, h = http.request(url)
  if c ~= 200 then return nil end

  local weather = json:decode(b)
  local city = weather.name
  local country = weather.sys.country
  local temp = 'الاحـوال الـجـويـة لـمـديـنـة :'..city..'\n\n🌡 درجـة حـرارة الـهـواء الـحـالـيـة : '..weather.main.temp..' C\n\nالـضـغـط الـجـوي :'..weather.main.pressure..'\nالـرطـوبـة : '..weather.main.humidity..' %\n\n🔻الـحـد الأدنـى مـن درجـات الـحـرارة الـيـوم :'..weather.main.temp_min..'\n🔺درجـة الـحـرارة الـقـصـوى الـيـوم:'..weather.main.temp_min..'\n\n🌬 سـرعـة الـريـاح : '..weather.wind.speed..'\nالـريـاح : '..weather.wind.deg..'\n\n🔸خـط الـطـول : '..weather.coord.lon..'\n🔹خـط الـعـرض : '..weather.coord.lat
  local conditions = 'أحـوال الـطـقـس الـحـالـيـة:'

  if weather.weather[1].main == 'Clear' then
    conditions = conditions .. 'مـشـمـس ☀️'
  elseif weather.weather[1].main == 'Clouds' then
    conditions = conditions .. 'غـائـم ☁️☁️'
  elseif weather.weather[1].main == 'Rain' then
    conditions = conditions .. 'مـمـطـر ☔️'
  elseif weather.weather[1].main == 'Thunderstorm' then
    conditions = conditions .. 'عـاصـف 🌪🌪🌪🌪'
  elseif weather.weather[1].main == 'Mist' then
    conditions = conditions .. 'مـه 🌫'
  end

  return temp .. '\n\n' .. conditions..'\n\n╔📡Channel➟ @dev_kasper ╗'
end
local function run(msg, matches) 
    city = matches[1]
  local wtext = get_weather(city)
  if not wtext then
    wtext = 'الـمـوقـع غـيـر صـحـيـح'
  end
  return wtext
end

return {

  patterns = {
   "^[/!]hker (.*)$",
   "^الطقس (.*)$",
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