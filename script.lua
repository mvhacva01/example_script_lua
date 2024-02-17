-- local json = require "example/json"
local json = require "json"

function sleep(second)
    os.execute("ping -n " .. second+1 .. " 127.0.0.1 >nul")
end

function run_command(command, max_retry)
    local retry_count = 0
    local success = false
    local response
    
    while retry_count < max_retry and not success do
        local handle = io.popen(command)
        response = handle:read("*a")
        handle:close()
        if string.len(response) > 0 then
            success = true
        else
            -- print("Request failed, retrying after 1 second...")
            sleep(1) -- Chờ 1 giây trước khi gửi lại
            retry_count = retry_count + 1
        end
    end

    return response, success
end

function send_bypass_captcha(apikey, type_captcha, path_image) -- type_captcha = TIKTOK_ROTATE_APP | TIKTOK_OBJ | ALL_CAPTCHA_SLIDE
    local command = 'curl --form \"Image=@' .. path_image .. '" "https://hmcaptcha.com/recognition?Type=' .. type_captcha .. '&apikey=' .. apikey .. '"'
    local res_json, status = run_command(command, 3)
    local decodedJson = json.parse(res_json)
    if decodedJson["Code"] ~= 0 then
        error(decodedJson["Message"])
    end
    local taskid = decodedJson["TaskId"]
    
    local Data
    while true do
        sleep(1) -- Chờ 1 giây trước khi gửi lại
        command = 'curl "https://hmcaptcha.com/getResult?apikey=' .. apikey .. '&taskid=' .. taskid .. '"'
        res_json, status = run_command(command, 3)
        decodedJson = json.parse(res_json)
        if decodedJson["Status"] == "SUCCESS" or decodedJson["Status"] == "ERROR" then
            Data = decodedJson["Data"]
            break
        end
    end
    
    return Data
end

-- using
local apikey = "admin-MWlzWAAdAmuZIJidhVdUHndYWyk9fy38"
local type_captcha = "TIKTOK_ROTATE_APP" -- | TIKTOK_OBJ | ALL_CAPTCHA_SLIDE
local path_image = "1.png"

local result = send_bypass_captcha(apikey, type_captcha, path_image)
print("=====================")
print(json.stringify(result))
print("=====================")