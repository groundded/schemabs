local HWIDTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/groundded/schemabs/main/shdbahvamasdasdiwawhitelis.lua"))() -- We are making a variable for where your HWID / ClientID table is going to be located. (You can use pastebin / github)

local HWID = game:GetService("RbxAnalyticsService"):GetClientId()


for i, v in pairs(HWIDTable) do
    if v == HWID then
        print("Welcome" .. HWID)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/groundded/schemabs/main/sdgajhsdvghjwcvkashdvwjhkachfgci13y21ckasdasdasd"))()
    elseif v ~= HWID then
        print("The HWID is not Whitelisted. HWID: ", HWID)
    end
end
