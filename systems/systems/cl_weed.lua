-- Create a variable to store the current progress
local isHarvesting = false
local progress = 0
local harvestTime = 10 -- Time in seconds to harvest a bud

-- Network message to notify the server about harvesting
util.AddNetworkString("GiveWeedBud")

-- Function to start harvesting
local function StartHarvesting()
    if not isHarvesting then
        isHarvesting = true
        progress = 0

        -- Start a timer to fill the progress bar
        timer.Create("WeedHarvesting", 0.1, harvestTime * 10, function()
            if progress < 100 then
                progress = progress + 1
            end

            if progress >= 100 then
                -- Time is up, give the player a bud
                net.Start("GiveWeedBud")
                net.SendToServer()
                
                -- Reset the progress and stop harvesting
                progress = 0
                isHarvesting = false
                timer.Remove("WeedHarvesting")
            end
        end)
    end
end

-- Function to stop harvesting
local function StopHarvesting()
    if isHarvesting then
        isHarvesting = false
        progress = 0
        timer.Remove("WeedHarvesting")
    end
end

-- Hook for key press to start harvesting
hook.Add("Think", "WeedHarvestingThink", function()
    if input.IsKeyDown(KEY_E) then
        StartHarvesting()
    else
        StopHarvesting()
    end
end)

-- Draw the progress bar on the screen
hook.Add("HUDPaint", "DrawWeedHarvestingProgress", function()
    if isHarvesting then
        local w, h = 200, 20 -- Width and height of the progress bar
        local x, y = (ScrW() - w) / 2, ScrH() - 100 -- Centered on the screen

        -- Draw the background
        surface.SetDrawColor(0, 0, 0, 150) -- Black background with some transparency
        surface.DrawRect(x, y, w, h)

        -- Draw the progress
        surface.SetDrawColor(0, 255, 0, 255) -- Green color for the progress
        surface.DrawRect(x, y, w * (progress / 100), h) -- Width is proportional to progress

        -- Draw text showing the progress
        draw.SimpleText("Harvesting: " .. math.floor(progress) .. "%", "DermaDefault", x + w / 2, y + h / 2 - 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER,
