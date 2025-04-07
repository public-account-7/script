--[[

    B.LUA PREMIUM

]]--

--# // Setup
if not game:IsLoaded() then
    game.IsLoaded:Wait()
end;

local function HttpGet(RequestUrl)
    return request({Url = RequestUrl}).Body
end;

--# // Whitelist

--# // Services
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local VirtualInputManager = game:GetService("VirtualInputManager");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local Request = http_request or http.request or request;

--# // Frameworks
local Fluent = loadstring(HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))();
local SaveManager = loadstring(HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))();
local InterfaceManager = loadstring(HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))();

--# // Variables
local deviceType = UserInputService.TouchEnabled and "Mobile" or "PC";
local LocalPlayer = Players.LocalPlayer;
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local Humanoid = Character:WaitForChild("Humanoid");
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");

local punchEvent = ReplicatedStorage:WaitForChild("PUNCHEVENT");
local grabEvent = ReplicatedStorage:WaitForChild("JALADADEPELOEVENT")

--# // Bools
local auraAttack = false;
local killAll = false;
local killTarget = false;
local killauraAttack = false;
local hitboxEnabled = false;
local noclipping = true;
local atmFarm = false;
local isFarming = false;
local selectedPlayerUsername = nil;
local killselTarget = false

local walkSpeedValue = 16;
local jumpPowerValue = 7.2;
local hipHeightValue = 2;
local teleportDistance = 10;
local hitboxSize = 10;

--# // Tables
local FoodTeleports = {
    Recovery_Drink = CFrame.new(172.21478271484375, 5.886789798736572, -27.25930404663086),
    Chicken = CFrame.new(41.021484375, 7.271762847900391, -104.71846771240234),
    Pretzel = CFrame.new(183.1703338623047, 5.886789798736572, -36.225433349609375),
    Chicken_Bucket = CFrame.new(44.942840576171875, 7.271762847900391, -104.69990539550781),
    Chips = CFrame.new(176.9873504638672, 5.886789798736572, -36.413848876953125),
    Fries = CFrame.new(177.8118133544922, 5.886789798736572, -27.063446044921875),
    Taco = CFrame.new(394.5107421875, 9.192885398864746, -90.5268325805664)
};

local WeaponTeleports = {
    Frying_Pan = CFrame.new(521.1040649414062, 5.597081184387207, 221.19869995117188),
    Tazer = CFrame.new(46.5355224609375, 6.176363945007324, -339.83453369140625),
    RPG = CFrame.new(580.572998046875, 5.534026622772217, -106.40829467773438),
    Mask = CFrame.new(409.9245910644531, 5.648306846618652, -118.70431518554688),
    High_Heels = CFrame.new(409.9245910644531, 5.648306846618652, -112.50022888183594),
    Flame_Thrower = CFrame.new(76.92469024658203, 8.455466270446777, 150.36471557617188),
    Dog_Leash = CFrame.new(192.23028564453125, 5.785022258758545, 406.95867919921875),
};

local AmmoTeleports = {
    RPG_Ammo = CFrame.new(580.5694580078125, 5.534026622772217, -102.40823364257812),
    Flame_Ammo = CFrame.new(80.92475891113281, 8.455435752868652, 150.36822509765625)
};

local ZoneTeleports = {
    Spawn = CFrame.new(279, 9, -105),
    KFC = CFrame.new(44, 9, -19),
    Appartments = CFrame.new(214, 10, 157),
    Dealership = CFrame.new(533, 9, -0),
    Hospital = CFrame.new(491, 10, -200),
    Salon = CFrame.new(487, 10, -279),
    Boxxing = CFrame.new(40, 9, -438),
    Club = CFrame.new(453, 9, 402),
    Tower = CFrame.new(-97, 217, -80),
    Police_Station = CFrame.new(-11, 9, 400)
};

--# // Functions
local function sendNotify(title, text)
    Fluent:Notify({
        Title = title,
        Content = text,
        SubContent = "",
        Duration = 12
    })
end;

local function findProximity(position1, position2)
    return (position1 - position2).Magnitude
end;

local function tweenTo(targetCFrame, duration)
    if not Humanoid or Character then return end
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        {CFrame = targetCFrame}
    )
    tween:Play()
    tween.Completed:Wait()
end;

function findPlayerByName(Target)
    for _, v in next, Players:GetPlayers() do
        if v.Name:lower():sub(1, #Target) == Target:lower() or v.DisplayName:lower():sub(1, #Target) == Target then
            return v
        end
    end
    return nil
end;

local function attackPlayer()
	punchEvent:FireServer(1);
    punchEvent:FireServer(2);
end;

local function grabPlayer(amount)
    for i = 1, amount do
        grabEvent:FireServer();
    end
end;

local function processClosestPlayer(action, range)
    pcall(function()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local otherRootPart = player.Character.HumanoidRootPart
                local distance = (HumanoidRootPart.Position - otherRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end

        if closestPlayer and shortestDistance <= range then
            action(closestPlayer, shortestDistance)
        end
    end)
end

local function gotoClosest()
    if not Humanoid or Character then return end
    processClosestPlayer(function(closestPlayer)
        HumanoidRootPart.CFrame = closestPlayer.Character.Head.CFrame * CFrame.new(0, -4, 0) * CFrame.Angles(math.rad(90), 0, 0)
        attackPlayer()
    end, teleportDistance)
end

local function auraAttacking()
    processClosestPlayer(function(closestPlayer)
        attackPlayer()
    end, auraDistance)
end

local function bringPlayers(targetUsername, offset, repetitions)
    if not Humanoid or Character then return end
    local targetPos = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * offset
    local playersToBring = {}

    if targetUsername then
        local targetPlayer = Players[targetUsername]
        if targetPlayer and targetPlayer ~= LocalPlayer then
            table.insert(playersToBring, targetPlayer)
        end
    else
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer then
                table.insert(playersToBring, otherPlayer)
            end
        end
    end

    for _, player in ipairs(playersToBring) do
        local otherCharacter = player.Character
        if otherCharacter then
            local otherHumanoidRootPart = otherCharacter:FindFirstChild("HumanoidRootPart")
            if otherHumanoidRootPart then
                for _ = 1, repetitions do
                    otherHumanoidRootPart.CFrame = CFrame.new(targetPos)
                end
                pcall(function()
                    otherHumanoidRootPart.Size = Vector3.new(10, 10, 10)
                    otherHumanoidRootPart.Transparency = 1
                    otherHumanoidRootPart.CanCollide = false
                end)
            end
        end
    end
end

local function bringAllPlayers()
    bringPlayers(nil, 5, 1)
end

local function BringTarget()
    bringPlayers(selectedPlayerUsername, 3, 15)
    grabPlayer(10);
end

local function voidTarget()
    bringPlayers(selectedPlayerUsername, 3, 15)
    grabPlayer(10);
    task.wait(1.5);
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -400, 0)
end

local function quickBuy(itemPosition)
    if not Humanoid or Character then return end
    local oldPosition = HumanoidRootPart.CFrame

    local function teleportTo(position, delay)
        HumanoidRootPart.CFrame = position
        task.wait(delay or 0.3)
    end

    local function interactWithNearbyPrompts()
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                local promptPart = descendant.Parent
                if promptPart and promptPart:IsA("BasePart") then
                    local promptPosition = promptPart.Position
                    if findProximity(Character.PrimaryPart.Position, promptPosition) <= 5 then
                        fireproximityprompt(descendant)
                    end
                end
            end
        end
    end

    teleportTo(itemPosition)
    interactWithNearbyPrompts()
    teleportTo(oldPosition)
end

--# // UI
local Window = Fluent:CreateWindow({
    Title = "Baddies.lua | Premium",
    SubTitle = "By Lx16, MoonSecV3",
    TabWidth = 95,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
});

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "layout-grid" }),
    Main = Window:AddTab({ Title = "Blatant", Icon = "swords" }),
    Legit = Window:AddTab({ Title = "Legit", Icon = "shield" }),
    Targeting = Window:AddTab({ Title = "Targeting", Icon = "target" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "wind" }),
	Teleport = Window:AddTab({ Title = "Teleports", Icon = "compass" }),
    Exploit = Window:AddTab({ Title = "Exploits", Icon = "activity" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
};

local Options = Fluent.Options;

do
	-- **HOME TAB** --
	Tabs.Home:AddButton({
        Title = "Copy Discord Invite",
        Description = "Join our discord for more scripts!",
        Callback = function()
            setclipboard("https://discord.gg/CBQD3vg5FM")
        end
    });

    Tabs.Home:AddParagraph({
        Title = "Update Log:",
        Content = ""
    });

    Tabs.Home:AddParagraph({
        Title = "v0.0.4",
        Content = "- Rewrote Source"
    });

    Tabs.Home:AddParagraph({
        Title = "v0.0.4",
        Content = "- Added ATM Farm\n- Added Instant Kill\n- Added Instant Bring\n- Added Anti Hit\n- Added Target Player\n- Added Lag Server"
    });

	-- **MAIN TAB** --
	local Toggle1 = Tabs.Main:AddToggle("TeleportAura", {Title = "Teleport Aura", Default = false })
    Toggle1:OnChanged(function()
        auraAttack = Options.TeleportAura.Value
    end);

	local Slider = Tabs.Main:AddSlider("Slider1", {
        Title = "Teleport Distance",
        Description = "How far until you lock onto a player.",
        Default = 10,
        Min = 5,
        Max = 50,
        Rounding = 1,
        Callback = function(Value)
            teleportDistance = Value
        end
    });

    local Toggle2 = Tabs.Main:AddToggle("KillAll", {Title = "Kill All", Default = false })
    Toggle2:OnChanged(function()
        killAll = Options.KillAll.Value
    end);

    -- **LEGIT TAB** --
    local Toggle8 = Tabs.Legit:AddToggle("KillAura", {Title = "Kill Aura", Default = false })
    Toggle8:OnChanged(function()
        killauraAttack = Options.KillAura.Value
    end);

	local Slider = Tabs.Legit:AddSlider("Slider9", {
        Title = "Aura Distance",
        Description = "How far until you start hitting a player.",
        Default = 15,
        Min = 5,
        Max = 35,
        Rounding = 1,
        Callback = function(Value)
            auraDistance = Value
        end
    });

    local Toggle99 = Tabs.Legit:AddToggle("Hitbox", {Title = "Hitbox Expander", Default = false })
    Toggle99:OnChanged(function()
        hitboxEnabled = Options.Hitbox.Value
    end);

	local Slider = Tabs.Legit:AddSlider("Slider10", {
        Title = "Hitbox Size",
        Description = "How much you want to expand other players hitboxes.",
        Default = 10,
        Min = 5,
        Max = 75,
        Rounding = 1,
        Callback = function(Value)
            hitboxSize = Value
        end
    });
    -- **TARGETING TAB** --
    local Input55 = Tabs.Targeting:AddInput("Input", {
        Title = "Player Name",
        Default = "",
        Placeholder = "Enter Display Name",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input55:OnChanged(function(Value)
        local playerName = Value
        if playerName and playerName ~= "" then
            local player = findPlayerByName(playerName)
            if player then
                sendNotify("Success!", "Found player: " ..player.Name)
                selectedPlayerUsername = player.Name
            else
                sendNotify("Error!", "Player not found.")
            end
        end
    end)

    local Toggle999 = Tabs.Targeting:AddToggle("bringing", {Title = "Kill Target", Default = false })
    Toggle999:OnChanged(function()
        killselTarget = Options.bringing.Value
    end);

   -- **MOVEMENT TAB** --
   Tabs.Movement:AddButton({
    Title = "Admin",
    Description = "Loads IYFE allowing you to use flight etc..",
    Callback = function()
        loadstring(HttpGet(LPS_ENCSTR("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source")))();
    end
    });

    Tabs.Movement:AddButton({
        Title = "Anti AFK",
        Description = "Doesn't let you get afk kicked.",
        Callback = function()
            LocalPlayer.Idled:connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
                task.wait(1);
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
            end)
        end
    });

	local Slider5 = Tabs.Movement:AddSlider("Slider5", {
		Title = "Walk Speed",
		Description = "",
		Default = 16,
		Min = 16,
		Max = 100,
		Rounding = 1,
		Callback = function(Value)
			walkSpeedValue = Value
			Humanoid.WalkSpeed = walkSpeedValue
		end
	});

	local Slider5 = Tabs.Movement:AddSlider("Slider6", {
		Title = "Jump Power",
		Description = "",
		Default = 50,
		Min = 50,
		Max = 1000,
		Rounding = 1,
		Callback = function(Value)
            Humanoid.UseJumpPower = true;
			jumpPowerValue = Value
			Humanoid.JumpPower = jumpPowerValue
		end
	});

	local Slider7 = Tabs.Movement:AddSlider("Slider7", {
		Title = "Hip Height",
		Description = "",
		Default = 2,
		Min = 2,
		Max = 100,
		Rounding = 1,
		Callback = function(Value)
			hipHeightValue = Value
			Humanoid.HipHeight = hipHeightValue
		end
	});

	-- **TELEPORTS TAB** --
    local Toggle12 = Tabs.Teleport:AddToggle("farmingATMS", {Title = "ATM Farm", Default = false })
    Toggle12:OnChanged(function()
        atmFarm = Options.farmingATMS.Value
    end);

    local Dropdown = Tabs.Teleport:AddDropdown("Dropdown", {
        Title = "Zones",
        Values = {"Spawn", "KFC", "Appartments", "Dealership", "Hospital", "Salon", "Boxxing", "Club", "Tower", "Police_Station "},
        Multi = false,
        Default = nil,
    });

    Dropdown:OnChanged(function(Value)
        local targetCFrame = ZoneTeleports[Value]
        if targetCFrame then
            HumanoidRootPart.CFrame = targetCFrame
            sendNotify("Success!", "Teleported to" .. Value)
        end
    end);

    local Dropdown3 = Tabs.Teleport:AddDropdown("Dropdown3", {
        Title = "Weapons",
        Values = {"Frying_Pan", "Tazer", "RPG", "Mask", "High_Heels", "Flame_Thrower", "Dog_Leash"},
        Multi = false,
        Default = nil,
    });

    Dropdown3:OnChanged(function(Value)
        local targetCFrame = WeaponTeleports[Value]
        if targetCFrame then
            quickBuy(targetCFrame)
            sendNotify("Success!", "Teleported to " .. Value)
        end
    end);

    local Dropdown5 = Tabs.Teleport:AddDropdown("Dropdown3", {
        Title = "Ammo",
        Values = {"RPG_Ammo", "Flame_Ammo"},
        Multi = false,
        Default = nil,
    });

    Dropdown5:OnChanged(function(Value)
        local targetCFrame = AmmoTeleports[Value]
        if targetCFrame then
            quickBuy(targetCFrame)
            sendNotify("Success!", "Teleported to " .. Value)
        end
    end);

    local Dropdown2 = Tabs.Teleport:AddDropdown("Dropdown2", {
        Title = "Food",
        Values = {"Recovery_Drink", "Chicken", "Pretzel", "Chicken_Bucket", "Chips", "Fries", "Taco"},
        Multi = false,
        Default = nil,
    });

    Dropdown2:OnChanged(function(Value)
        local targetCFrame = FoodTeleports[Value]
        if targetCFrame then
            quickBuy(targetCFrame)
            sendNotify("Success!", "Teleported to " .. Value)
        end
    end);

    Tabs.Teleport:AddButton({
        Title = "Grab Stop Sign",
        Description = "Instantly grabs a stop sign.",
        Callback = function()
            for _, v in pairs(workspace.PickUpItems:GetChildren()) do
                if v.Name == "StopSign" then 
                    quickBuy(v.CFrame)
                    break
                end
            end 
        end
    });

    Tabs.Teleport:AddButton({
        Title = "Grab Toilet",
        Description = "Instantly grabs a toilet.",
        Callback = function()
            for _, v in pairs(workspace.PickUpItems:GetChildren()) do
                if v.Name == "toilet" then 
                    quickBuy(v.CFrame)
                    break
                end
            end  
        end
    });

    Tabs.Teleport:AddButton({
        Title = "Grab Pipe",
        Description = "Instantly grabs a pipe.",
        Callback = function()
            for _, v in pairs(workspace.PickUpItems:GetChildren()) do
                if v.Name == "RustyPipe" then 
                    quickBuy(v.CFrame)
                    break
                end
            end 
        end
    });

	-- **EXPLOITS TAB** --
    local Input = Tabs.Exploit:AddInput("Input", {
        Title = "Player Name",
        Default = "",
        Placeholder = "Enter Display Name",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function(Value)
        local playerName = Input.Value
        if playerName and playerName ~= "" then
            local player = findPlayerByName(playerName)
            if player then
                sendNotify("Success!", "Found player: " ..player.Name)
                selectedPlayerUsername = player.Name
            else
                sendNotify("Error!", "Player not found.")
                selectedPlayerUsername = nil
            end
        end
    end)

    Tabs.Exploit:AddButton({
        Title = "Bring Player",
        Description = "Instantly brings a player to you (FE).",
        Callback = function()
            BringTarget();
        end
    });

    Tabs.Exploit:AddButton({
        Title = "Kill Player",
        Description = "Instantly voids a player and you (FE).",
        Callback = function()
            voidTarget();
        end
    });

	sendNotify("Successfully Loaded!", "If you have any problems feel free to report in our discord!")
end;

--# // Finalize
Window:SelectTab(1);
SaveManager:SetLibrary(Fluent);
InterfaceManager:SetLibrary(Fluent);
InterfaceManager:SetFolder("Aerial");
SaveManager:SetFolder("Aerial/AerialConfigs");
InterfaceManager:BuildInterfaceSection(Tabs.Settings);
SaveManager:BuildConfigSection(Tabs.Settings);

RunService.Heartbeat:Connect(function()
	if auraAttack then
    	gotoClosest();
	end

	if killAll then
		bringAllPlayers();
        attackPlayer();
	end

    if killauraAttack then
        auraAttacking();
    end

    if atmFarm then
        atmFarming();
        getMoney();
    end

    if killselTarget then
        loopkillTarget();
    end;
end);

RunService.RenderStepped:Connect(function()
    if hitboxEnabled then
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= LocalPlayer.Name then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    v.Character.HumanoidRootPart.Transparency = 1
                    v.Character.HumanoidRootPart.CanCollide = false
                end)
            end
        end
    end
end);
