local Workspace = Game:GetService("Workspace")

local Players = Game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player:WaitForChild("Character")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local CollectiblesFolder = Workspace:WaitForChild("Collectibles")

for _, Token in ipairs(CollectiblesFolder:GetChildren()) do
    local Pos = Token.CFrame
    HumanoidRootPart.CFrame = Vector3.new(Pos)
end
