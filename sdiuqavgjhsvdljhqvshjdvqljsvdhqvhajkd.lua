local shadowBanCheckerCode = game:HttpGet("https://pastebin.com/raw/kCmAMsZV")

if not shadowBanCheckerCode or shadowBanCheckerCode == "" then
    warn("Failed to fetch the shadow ban checker script.")
    return
end

local shadowBanChecker, errorMessage = loadstring(shadowBanCheckerCode)
if not shadowBanChecker then
    warn("Failed to load the shadow ban checker script: " .. errorMessage)
    return
end

local checkShadowBanFunction = shadowBanChecker()
if type(checkShadowBanFunction) ~= "function" then
    warn("The script did not return a function.")
    return
end

local success, description = pcall(checkShadowBanFunction)
if not success then
    warn("Failed to get the shadow ban description: " .. description)
    return
end

for _,t in next, getgc(true) do
    if type(t) == "table" then
        if #t == 2 then
            if table.find(t, "kick") then
                setreadonly(t, false)

                rawset(t, 2, function()
                    return coroutine.yield()
                end)
            end
        end
    end
end

function SendWebhook(Options)
return request(
{
    Url = Options.Url,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = game:GetService("HttpService"):JSONEncode(
        {
            content = Options.Content,
            embeds = Options.Embeds
        }
    )
}
)
end

function GetEnemy()
local ClosestEnemy = nil
local ClosestDistance = math.huge

for _, Enemy in next, workspace.NPCs:GetChildren() do
if Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
    local Magnitude =
        (game:GetService("Players").LocalPlayer.Character:GetPivot().Position - Enemy:GetPivot().Position).Magnitude
    if Magnitude < ClosestDistance then
        ClosestEnemy = Enemy
        ClosestDistance = Magnitude
    end
end
end

return ClosestEnemy
end

function GetIsland()
for _, Island in next, workspace.Islands:GetChildren() do
if Island.Name ~= "Lobby" then
    return Island
end
end
end

function GetWave()
local WaveLabel = game:GetService("Players").LocalPlayer.PlayerGui.Matchmake.Wave
return tonumber(string.sub(WaveLabel.Text, 6))
end

function GetCurrentIsland()
local ClosestIsland = nil
local ClosestDistance = math.huge

for _, Island in next, workspace.Islands:GetChildren() do
local Magnitude =
    (game:GetService("Players").LocalPlayer.Character:GetPivot().Position -
    Island:GetAttribute("islandPosition")).Magnitude

if Magnitude < ClosestDistance then
    ClosestIsland = Island
    ClosestDistance = Magnitude
end
end

return ClosestIsland
end

function IsOnCooldown(Name)
local Move = game:GetService("Players").LocalPlayer.PlayerGui.Abilities.Main.List:FindFirstChild(Name)

if Move ~= nil then
return Move.CDTimer.Visible
else
return true
end
end

function Equip(Name)
if not game:GetService("Players").LocalPlayer.Character:FindFirstChild(Name) then
for _, Item in next, game:GetService("Players").LocalPlayer.PlayerGui.BackpackGui:GetDescendants() do
    if Item.Name == Name then
        firesignal(Item.MouseButton1Click)
    end
end
end
end

function PressKey(Key, Duration)
game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[Key], false, game)
task.wait(Duration)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[Key], false, game)
end

function HasFruitBag()
return string.find(
game:GetService("ReplicatedStorage")["Stats" .. game:GetService("Players").LocalPlayer.Name].Inventory.Inventory.Value,
"Fruit Bag"
) ~= nil
end

function GetTool()
local Tool = nil

for _, Item in next, game:GetService("Players").LocalPlayer.Backpack:GetChildren() do
if Item:IsA("Tool") and Item:GetAttribute("Category") == "Special" then
    Tool = Item
end
end

return Tool
end

function Store()
local Tool = GetTool()

Equip(Tool.Name)

local StoreButton = game:GetService("Players").LocalPlayer.PlayerGui.StoreFruit.Store
repeat
task.wait()
until StoreButton.Visible == true

firesignal(StoreButton.MouseButton1Click)

return Tool.Name
end

function For(Duration, Function)
local StartTime = os.clock()

while (os.clock() - StartTime) < Duration do
task.wait()
Function()
end
end

function CreateHider(Name)
local function New(Class, Properties)
local instance = Instance.new(Class)

for Property,Value in next, Properties do
    instance[Property] = Value
end

return instance
end

local gethui = gethui or function() return game.Players.LocalPlayer.PlayerGui end

local ScreenGui = New("ScreenGui", {
Name = "ScreenGui",
Parent = gethui(),
IgnoreGuiInset = true,
ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
})

local Background = New("ImageLabel", {
Name = "Background",
Parent = ScreenGui,
Image = "http://www.roblox.com/asset/?id=2499785599",
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 1,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromScale(1, 1),
ZIndex = 0
})

local Title = New("TextLabel", {
Name = "Title",
Parent = Background,
FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
Text = Name or "",
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 40,
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0.5, 0, 0.5, -15),
Size = UDim2.fromOffset(200, 0)
})

local Info = New("TextLabel", {
Name = "Info",
Parent = Background,
FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
Text = "",
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 25,
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0.5, 0, 0.5, 15),
Size = UDim2.fromOffset(200, 0)
})

return ScreenGui, Info
end

local ScreenGui, Info = CreateHider("Dungeons")

task.spawn(function()
while task.wait() do
if ScreenGui then
    Info.Text = `Wave {GetWave()}`
end
end
end)

local MapData = {
["Sky Islands"] = {
["Center"] = CFrame.new(-480.7333984375, 16.30082893371582, -257.36883544921875),
["Magnet"] = 9e9
},
["Tropical Island"] = {
["Center"] = CFrame.new(-41.150604248046875, 9.530350685119629, 119.1050796508789),
["Magnet"] = 750
},
["Mysterious Dungeon"] = {
["Center"] = CFrame.new(-1422.005126953125, 3.374696731567383, 101.44880676269531),
["Magnet"] = 50
}
}

if game.PlaceId == 6360478118 then
repeat
task.wait()
until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("LoadingGUI"):FindFirstChild(
"CanvasGroup"
) == nil
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Queue"):InvokeServer(
unpack(
    {
        [1] = "Dungeon"
    }
)
)
elseif game.PlaceId == 11424731604 then
repeat
task.wait()
until game:GetService("Players").LocalPlayer.PlayerGui.LoadingGUI:FindFirstChild("CanvasGroup") == nil

getgenv().Bypass = true

do
local DashTypes = require(game:GetService("ReplicatedStorage").Util.Movement.DashTypes)

local OldDash
OldDash =
    hookfunction(
    DashTypes.dash,
    function(...)
        if getgenv().Bypass then
            coroutine.wrap(OldDash)(...)
        else
            OldDash(...)
        end
    end
)

game:GetService("ReplicatedStorage"):WaitForChild("Stats" .. game:GetService("Players").LocalPlayer.Name).Stats.DF.Value =
    "Bomb-Bomb"

local OldNamecall
OldNamecall =
    hookmetamethod(
    game,
    "__namecall",
    function(self, ...)
        if tostring(self) == "takestam" and getgenv().Bypass then
            return
        end

        return OldNamecall(self, ...)
    end
)

local Bomb = require(game:GetService("ReplicatedStorage").Util.Movement.DashTypes["Bomb-Bomb"])
debug.setconstant(Bomb.start, 19, "")

local OldInstance
OldInstance =
    hookfunction(
    Instance.new,
    function(ClassName)
        if ClassName == "BodyVelocity" and tostring(getcallingscript()) == "Movements" and getgenv().Bypass then
            return {}
        end

        return OldInstance(ClassName)
    end
)

task.spawn(
    function()
        while task.wait() do
            if getgenv().Bypass then
                PressKey("Q")
            end
        end
    end
)
end

local MobileBase = require(game:GetService("ReplicatedStorage").SkillCallbacks.MobileBase)

hookfunction(
MobileBase.GetMouseCFrame,
function()
    if GetEnemy() ~= nil then
        return GetEnemy():GetPivot()
    else
        return CFrame.new()
    end
end
)

hookfunction(
MobileBase.GetMousePosition,
function()
    if GetEnemy() ~= nil then
        return GetEnemy():GetPivot().Position
    else
        return Vector3.new()
    end
end
)

game:GetService("Players").LocalPlayer.Character:WaitForChild("FallDamage").Enabled = false

local StartTime = os.clock()
local Respawned = false
local OpenedWindow = false

while task.wait() do
if #workspace.Islands:GetChildren() == 2 then
    local Island = GetIsland()

    if Island.Name ~= "Mysterious Dungeon" then
        game:GetService("TeleportService"):Teleport(6360478118, game:GetService("Players").LocalPlayer)
    end

    local Wave = GetWave()
    local Enemy = GetEnemy()
    local CurrentIsland = GetCurrentIsland()

    if Wave == 26 then
        if CurrentIsland.Name == "Lobby" then
            task.wait(5)

            if ScreenGui then
                ScreenGui:Remove()
            end

            local FruitName = Store()

            if getgenv().Webhook ~= "" then
                if HasFruitBag() then
                    local Success, ReturnedValue = pcall(function()
                        SendWebhook(
                            {
                                Url = getgenv().Webhook,
                                Content = "@everyone",
                                Embeds = {
                                    [1] = {
                                        ["title"] = "Dungeon Completed",
                                        ["type"] = "rich",
                                        ["color"] = tonumber(0xab1f33),
                                        ["fields"] = {
                                            {
                                                ["name"] = "Username",
                                                ["value"] = "||*" .. game:GetService("Players").LocalPlayer.Name .. "*||",
                                                ["inline"] = false
                                            },
                                            {
                                                ["name"] = "Fruit",
                                                ["value"] = "*" .. FruitName .. "*",
                                                ["inline"] = false
                                            },
                                            {
                                                ["name"] = "Shadowbanned?",
                                                ["value"] = "**" .. description .. "**",
                                                ["inline"] = false
                                            },
                                        },
                                        ["footer"] = {
                                            ["text"] = "Vamp Hub",
                                            ["icon_url"] = "https://cdn.discordapp.com/attachments/1267611749583163465/1271971110677905428/vamp.png?ex=66bb4128&is=66b9efa8&hm=7dda4bec1d1b25b70bf484250f654c758503cf904d5a7edcf200b42a6fc0abaa&"
                                        }
                                    }
                                }
                            }
                        )
                    end)
                else
                    SendWebhook(
                        {
                            Url = getgenv().Webhook,
                            Content = "@everyone",
                            Embeds = {
                                [1] = {
                                    ["title"] = "Dungeon Completed",
                                    ["type"] = "rich",
                                    ["color"] = tonumber(0xab1f33),
                                    ["fields"] = {
                                        {
                                            ["name"] = "Username",
                                            ["value"] = "||*" .. game:GetService("Players").LocalPlayer.Name .. "*||",
                                            ["inline"] = true
                                        },
                                        {
                                            ["name"] = "Error",
                                            ["value"] = "Unable to find fruit bag",
                                            ["inline"] = true
                                        }
                                    },
                                    ["footer"] = {
                                        ["text"] = "Vamp Hub",
                                        ["icon_url"] = "https://cdn.discordapp.com/attachments/1267611749583163465/1271971110677905428/vamp.png?ex=66bb4128&is=66b9efa8&hm=7dda4bec1d1b25b70bf484250f654c758503cf904d5a7edcf200b42a6fc0abaa&"
                                    }
                                }
                            }
                        }
                    )
                end
            end
        elseif CurrentIsland.Name == Island.Name then
            if not Respawned then
                task.wait(5)
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("KnockedOut"):FireServer(
                    unpack(
                        {
                            [1] = "self"
                        }
                    )
                )

                Respawned = true
            end
        end
    else
        Equip("Magu-Magu")

        if Enemy then
            if (GetWave() % 5) == 0 then
                local Goal =
                    ((Enemy:GetPivot() + Vector3.new(0, 30, 0)) *
                    CFrame.new(math.random(-15, 15), 0, math.random(-15, 15))) *
                    CFrame.Angles(math.rad(-90), 0, 0)
                game:GetService("Players").LocalPlayer.Character:PivotTo(Goal)

                if Wave >= 20 then
                    if not IsOnCooldown("Magma Rain") then
                        task.spawn(
                            function()
                                PressKey("C", 8)
                            end
                        )
                    end
                end

                if not IsOnCooldown("Magma Fist") then
                    PressKey("Z", 0)
                end

                if not IsOnCooldown("Magma Hound") then
                    PressKey("X", 0)
                end
            else
                if Wave >= 12 then
                    if (os.clock() - StartTime) > 16 then
                        local Center = MapData[Island.Name].Center

                        task.spawn(
                            function()
                                For(
                                    4,
                                    function()
                                        game:GetService("Players").LocalPlayer.Character:PivotTo(Center)
                                    end
                                )
                            end
                        )

                        task.wait(4)
                        StartTime = os.clock()
                    end
                end

                local Magnitude =
                    (game:GetService("Players").LocalPlayer.Character:GetPivot().Position -
                    Enemy:GetPivot().Position).Magnitude
                local Goal =
                    ((Enemy:GetPivot() + Vector3.new(0, 19, 0)) *
                    CFrame.new(math.random(-7, 7), 0, math.random(-7, 7))) *
                    CFrame.Angles(math.rad(-90), 0, 0)

                if Magnitude > MapData[Island.Name].Magnet then
                    game:GetService("TweenService"):Create(
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
                        TweenInfo.new(Magnitude / 65),
                        {CFrame = Goal}
                    ):Play()
                else
                    game:GetService("Players").LocalPlayer.Character:PivotTo(Goal)
                end

                if Magnitude <= 50 then
                    if not IsOnCooldown("Magma Fist") then
                        PressKey("Z", 0)
                    end

                    if not IsOnCooldown("Magma Hound") then
                        PressKey("X", 0)
                    end
                end
            end
        else
            StartTime = os.clock()

            local Center = MapData[Island.Name].Center
            game:GetService("Players").LocalPlayer.Character:PivotTo(Center)
        end
    end
end
end
elseif game.PlaceId == 1730877806 then
game:GetService("TeleportService"):Teleport(6360478118, game:GetService("Players").LocalPlayer)
end
