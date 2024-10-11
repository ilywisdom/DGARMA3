util.AddNetworkString("PickupItem")

function PickupItem(ply, itemID, amount)
    local item = ITEMS[itemID]
    if not item then return end

    -- Add the item to the player's inventory
    if ply:AddItem(itemID, amount) then
        -- Remove the item from the world or notify the player
        ply:ChatPrint("You picked up " .. amount .. " " .. item.name .. "(s).")
    end
end

hook.Add("PlayerSay", "PickupItemCommand", function(ply, text)
    local splitText = string.Explode(" ", text)
    if splitText[1] == "!pickup" and splitText[2] then
        local itemID = splitText[2]
        PickupItem(ply, itemID, 1) -- Assume amount is 1 for simplicity
        return ""
    end
end)
