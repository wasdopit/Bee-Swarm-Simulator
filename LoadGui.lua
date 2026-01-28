local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()



local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Players = game.Players
local Player = Players.LocalPlayer
local Character = Player.Character
local HumanoidRootPart = Character.HumanoidRootPart

local CollectiblesFolder = game.Workspace.Collectibles

local CoreStats = Player:WaitForChild("CoreStats")


local HivePos = Player:WaitForChild("SpawnPos").Value





local AutoFarmEnabled = false
local AutoDigEnabled = false
local CurrentAutoFarmArea = "Sunflower"

local Fields = {"Sunflower","Dandelion", "Mushroom", "Blue_Flower", "Clover", "Strawberry", "Spider", "Bamboo", "Pineapple", "Stump", "Cactus", "Pumpkin", "Pine_Tree", "Rose", "Mountain_Top", "Pepper", "Coconut" }
local FieldPositions = {
   Sunflower =  CFrame.new(-208.951294, 3.5, 176.579224),
   Dandelion = CFrame.new(-29.6986389, 3.5, 221.572845),
   Mushroom = CFrame.new(-89.7000122, 3.95073581, 111.725006),
   Blue_Flower = CFrame.new(146.865021, 4.13494039, 99.3078308),
   Clover = CFrame.new(157.547073, 33.608448, 196.350006),
   Strawberry = CFrame.new(-178.174973, 20.1322384, -9.8549881),
   Spider = CFrame.new(-43.4654312, 20.1220875, -13.5899963),
   Bamboo = CFrame.new(132.963409, 20.1719551, -25.6000061),
   Pineapple = CFrame.new(256.498108, 68.1299973, -207.479324),
   Stump = CFrame.new(424.483276, 96.4255676, -174.810959),
   Cactus = CFrame.new(-188.5, 67.5000153, -101.595818),
   Pumpkin = CFrame.new(-188.5, 67.5000153, -183.845093),
   Pine_Tree = CFrame.new(-328.670013, 67.5, -187.348999),
   Rose = CFrame.new(-327.459839, 19.5552464, 129.496735),
   Mountain_Top = CFrame.new(77.6849823, 175.500015, -165.431),
   Pepper = CFrame.new(-488.761566, 122.701508, 535.680176),
   Coconut = CFrame.new(-254.478104, 70.9707947, 469.459045)

}

local Tokens = {"Sunflower_Seed", "Strawberry", "Blueberry", "Pineapple", "Snowflake", "Honey", "Treat"}
local TokenFrontDecalLookup = {
    ["rbxassetid://1952682401"] = true, -- Sunflower_Seed
    ["rbxassetid://1952740625"] = true, -- Strawberry
    ["rbxassetid://2028453802"] = true, -- Blueberry
    ["rbxassetid://1952796032"] = true, -- Pineapple
    ["rbxassetid://6087969886"] = true, -- Snowflake
    ["rbxassetid://1472135114"] = true, -- Honey
    ["rbxassetid://2028574353"] = true, -- Treat
}


local MovementMethods = {"Tween", "Teleport" }

local MovementMethod = "Tween"
local TweenSpeed = 25




local Window = Rayfield:CreateWindow({
   Name = "BSS",
   Icon = "bug", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Raycon",
   LoadingSubtitle = "by wasdopit",
   ShowText = "Raycon", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Raycon", -- Create a custom folder for your hub/game
      FileName = "BSS"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local AutoFarmTab = Window:CreateTab("Auto Farm", "tractor") -- Title, Image

local AutoFarmAreaSelect = AutoFarmTab:CreateDropdown({
   Name = "Farming Area",
   Options = Fields,
   CurrentOption = {"Sunflower"},
   MultipleOptions = false,
   Flag = "AutoFarmArea", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
      CurrentAutoFarmArea = Options[1]
   end,
})

local AutoFarmConvertMethod = AutoFarmTab:CreateDropdown({
   Name = "Convert Method",
   Options = MovementMethods,
   CurrentOption = {"Tween"},
   MultipleOptions = false,
   Flag = "AutoFarmConvertMethod", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
      MovementMethod = Options[1]
   end,
})

local TweenSpeedSlider = AutoFarmTab:CreateSlider({
   Name = "Tween Speed",
   Range = {1, 50},
   Increment = 1,
   Suffix = "",
   CurrentValue = 25,
   Flag = "TweenSpeedSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      TweenSpeed = Value
   end,
})






local AutoDigToggle = AutoFarmTab:CreateToggle({ -- Turn digging on or off (seperate from auto farm)
    Name = "Auto Dig",
    CurrentValue = false,
    Flag = "AutoDigEnabled",
    Callback = function(Value)
        AutoDigEnabled = Value

        if Value then
            task.spawn(function()
               task.wait(1)
               while AutoDigEnabled do
                  mouse1click()
                  task.wait(0.5)
               end
            end)
        end
    end,
})



local AutoFarmToggle = AutoFarmTab:CreateToggle({ -- Start or end the auto farm process
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarmEnabled",
   Callback = function(Value)
      AutoFarmEnabled = Value

      if Value then
         task.spawn(function()
            if AutoDigEnabled == false then -- Turn on auto dig if it's not already
               AutoDigToggle:Set(true)
            end
            while AutoFarmEnabled do -- While auto farm is enabled
               -- Teleport/tween to chosen field
               if MovementMethod == "Teleport" then -- If player is teleporting not tweening
                  HumanoidRootPart.CFrame = FieldPositions[CurrentAutoFarmArea]
               else -- Use tweening
                  local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(5.01-(TweenSpeed*0.1)), {CFrame = FieldPositions[CurrentAutoFarmArea]})
                  HumanoidRootPart.CanCollide = false
                  Tween:Play()
                  Tween.completed:wait()
                  HumanoidRootPart.CanCollide = true
               end
               while CoreStats.Pollen.Value < CoreStats.Capacity.Value do -- While capacity isn't full (farming logic in field)
                  if not AutoFarmEnabled then -- If not enabled anymore then break
                     break
                  end

                  HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X + math.random(-8, 8), HumanoidRootPart.Position.Y, HumanoidRootPart.Position.Z + math.random(-8, 8))
                  if (HumanoidRootPart.Position - FieldPositions[CurrentAutoFarmArea].Position).Magnitude > 30 then
                     HumanoidRootPart.CFrame = FieldPositions[CurrentAutoFarmArea]
                  end

                  task.wait(1)
               end
               -- Teleport/tween to Hive
               if MovementMethod == "Teleport" then -- If a player is teleporting not tweening
                  HumanoidRootPart.CFrame = HivePos
               else -- Use tweening
                  local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(5.01-(TweenSpeed*0.1)), {CFrame = HivePos})
                  HumanoidRootPart.CanCollide = false
                  Tween:Play()
                  Tween.completed:wait()
                  HumanoidRootPart.CanCollide = true
               end
               -- Simulate pressing and releasing 'E' to start converting pollen
               VirtualInputManager:SendKeyEvent(true, "E", false, game:GetService("Players").LocalPlayer)
               task.wait(0.1) -- Hold duration
               VirtualInputManager:SendKeyEvent(false, "E", false, game:GetService("Players").LocalPlayer)
               while CoreStats.Pollen.Value ~= 0 do -- Wait until the pollen gets to 0 again
                  task.wait()
               end
               task.wait(5) -- Extra pause to ensure the bees convert all pollen
            end
         end)
      end




   end,
})

AutoDigToggle:Set(false)