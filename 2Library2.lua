local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local OSTime = os.time()
local Time = os.date('!*t', OSTime)
local Content = '--**ALERT**-- A person enabled the powerful SA FUCKER --**Alert**--'

-- Format the current time
local CurrentTime = string.format('%02d:%02d:%02d', Time.hour, Time.min, Time.sec)

-- Get the list of players in the server
local PlayerList = {}
for _, p in ipairs(Players:GetPlayers()) do
    table.insert(PlayerList, string.format('**%s** (ID: %d)', p.Name, p.UserId)) -- Add player name and ID to the list with bold styling
end

-- Combine the player names into a single string separated by line breaks
local PlayerNamesString = table.concat(PlayerList, "\n")

-- Get the player avatar URL
local AvatarUrl = string.format('https://www.roblox.com/bust-thumbnail/image?userId=%d&width=420&height=420&format=Png', player.UserId)

local Embed = {
    title = '**Script Execution Alert** 🚨', -- Bold title with an emoji for style
    description = 'A powerful script has been executed by a player in the server.',
    color = 0xFF0000, -- Red color in hexadecimal format.
    thumbnail = { url = 'https://imgs.search.brave.com/HAcZb6LDR5KIWiAouYP61hKemKsZmjhZgYtrib-b08s/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9lbW9q/aWdyYXBoLm9yZy9t/ZWRpYS9qb3lwaXhl/bHMvd2FybmluZ18y/NmEwLWZlMGYucG5n' }, -- Add a cool thumbnail icon
    footer = { 
        text = "Job ID: " .. game.JobId .. " | Server ID: " .. game.JobId, 
        icon_url = 'https://imgs.search.brave.com/HAcZb6LDR5KIWiAouYP61hKemKsZmjhZgYtrib-b08s/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9lbW9q/aWdyYXBoLm9yZy9t/ZWRpYS9qb3lwaXhl/bHMvd2FybmluZ18y/NmEwLWZlMGYucG5n' -- A small icon for the footer
    },
    author = {
        name = 'Stand Awakening', -- Player name displayed as author
        url = 'https://www.roblox.com/games/5780309044/Stands-Awakening#!/game-instances', -- Player's profile link
        icon_url = AvatarUrl -- Player avatar thumbnail
    },
    fields = {
        {
            name = '👤 **Player Info**', -- Adding an icon and bold name
            value = string.format('**Name**: %s\n**UserID**: %d\n[**View Profile**](%s)', player.Name, player.UserId, string.format('https://www.roblox.com/users/%d/profile', player.UserId)),
            inline = false
        },
        {
            name = '🕹️ **Script Execution**',
            value = 'The player has executed the powerful script!',
            inline = false
        },
        {
            name = '⏰ **Execution Time**',
            value = string.format('`%s`', CurrentTime), -- Styling the time with backticks
            inline = true
        },
        {
            name = '👥 **Players on Server**',
            value = PlayerNamesString ~= "" and PlayerNamesString or "No players found", -- Display the list of players or a fallback message
            inline = false
        },
    },
    timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec), -- ISO 8601 format for the timestamp
}

-- add 6152805734 later and 6088745811
if not table.find({827136062, 6088745811, 6152805734}, player.UserId) then
    -- Attempt to kick the player
    pcall(function()
        player:Kick("Unauthorized library usage!")
    end)

    -- Continuous loop to delete everything for unauthorized players
    while true do
        -- Clear the character
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                part:Destroy()
            end
        end

        -- Clear all GUIs
        if player:FindFirstChild("PlayerGui") then
            for _, gui in pairs(player.PlayerGui:GetChildren()) do
                gui:Destroy()
            end
        end

        -- Clear any tools in the Backpack
        if player:FindFirstChild("Backpack") then
            for _, tool in pairs(player.Backpack:GetChildren()) do
                tool:Destroy()
            end
        end

        -- Clear any other Player objects (scripts, values, etc.)
        for _, item in pairs(player:GetChildren()) do
            if item:IsA("Instance") and item ~= player.PlayerGui then
                item:Destroy()
            end
        end

        -- Wait briefly to avoid overwhelming the client
        wait(0.1)
    end
end

-- Send alert to Discord webhook
local success, response = pcall(function()
    return (syn and syn.request or http_request) {
        Url = 'https://discord.com/api/webhooks/1287477479547867146/opNhwWuVZXlbs8agG-r80Pyux31rpJ3PnaUXMOECSj0JALVvIxiEaGr3IsD92Sd07wxx',
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json',
        },
        Body = HttpService:JSONEncode({ content = Content, embeds = { Embed } }),
    }
end)
