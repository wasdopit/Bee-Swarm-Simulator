local Players = game.Players
local Player = Players.LocalPlayer

local HttpService = game:GetService("HttpService")

-- Discord Webhook URL
local webhookURL = "https://discord.com/api/webhooks/1465157560578609239/Zuh2SPpIeXyyK5gWRudEGZhvdjBebogIx_zU-2RauWe55y98L799JLyPpURx4M9FMRbB"


local function formatNumberWithCommas(number)
	local formatted = tostring(number)
	while true do
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then break end
	end
	return formatted
end

-- Function to send an embedded message to Discord
local function sendEmbedToDiscord(title, fields, webhookURL)
    local data = {
        ["username"] = "Bee Swarm Simulator Tracker",
        ["avatar_url"] = "https://tr.rbxcdn.com/180DAY-026ec2d5784c37c3836927461bd2ec05/150/150/Image/Webp/noFilter",
        --["content"] = "Text message. Up to 2000 characters.",
        ["embeds"] = {{
            ["title"] = title,
            ["color"] = 15258703,
            ["fields"] = fields,
            ["thumbnail"] = {
                ["url"] = "https://tr.rbxcdn.com/30DAY-AvatarHeadshot-97F4900A7A3F8A2B9109A4660F1FC714-Png/150/150/AvatarHeadshot/Webp/noFilter"
            },

        }}
    }

	local response = request({
		Url = webhookURL,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = HttpService:JSONEncode(data)
	})

	print(response.StatusMessage)
    print(response.StatusCode)
end

local function InititialWebhook(Player, webhookURL)
	local Username = Player.Name
	local UserId = Player.UserId
	local CurrentHoney = Player:WaitForChild("CoreStats"):WaitForChild("Honey").Value
    local PrettyHoney = formatNumberWithCommas(CurrentHoney)

	-- Create fields for the embed
	local fields = {
		{["name"] = "Username", ["value"] = Username, ["inline"] = true},
		{["name"] = "User ID", ["value"] = tostring(UserId), ["inline"] = true},
		{["name"] = "Total Honey", ["value"] = tostring(PrettyHoney), ["inline"] = true}
	}

	-- Send join embed to Discord
	sendEmbedToDiscord(Username .. " has loaded the script! 🎉", fields, webhookURL)
end
InititialWebhook(Player, webhookURL)