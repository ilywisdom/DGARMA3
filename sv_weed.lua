

util.AddNetworkString("PlantWeed")
util.AddNetworkString("WeedStatus")

local function PlantWeed(ply, trace)
    if not IsValid(ply) or not trace.Hit then return end

    local weedPlant = ents.Create("prop_physics")
    weedPlant:SetModel("models/props/de_inferno/flower_barrel_large.mdl") -- Placeholder model for weed plant
    weedPlant:SetPos(trace.HitPos + Vector(0, 0, 10))
    weedPlant:Spawn()

    weedPlant:SetNWInt("GrowthStage", 1) -- Initial growth stage
    weedPlant:SetNWFloat("PlantedTime", CurTime()) -- Store time of planting

    -- Progress the plant's growth
    timer.Create("WeedGrow_" .. weedPlant:EntIndex(), WEED_SYSTEM.GrowthTime / 3, 3, function()
        if not IsValid(weedPlant) then return end
        local currentStage = weedPlant:GetNWInt("GrowthStage")
        weedPlant:SetNWInt("GrowthStage", currentStage + 1)

        -- Change plant model based on growth stage
        if currentStage == 1 then
            weedPlant:SetModel("models/props/de_inferno/potted_plant2.mdl") -- Placeholder for mid-growth
        elseif currentStage == 2 then
            weedPlant:SetModel("models/props_foliage/tree_poplar_01.mdl") -- Placeholder for fully grown
        end
    end)

    -- Inform the player about the plant
    ply:ChatPrint("You planted a weed seed!")
end

-- Hook the planting action to a custom item or command
hook.Add("PlayerSay", "PlantWeedCommand", function(ply, text)
    if string.lower(text) == "!plantweed" then
        local trace = ply:GetEyeTrace()
        PlantWeed(ply, trace)
        return ""
    end
end)

// Processor NPC
-- Client-side code

hook.Add("PostDrawTranslucentRenderables", "DrawWeedPlantStatus", function()
    for _, ent in ipairs(ents.FindByClass("prop_physics")) do
        if ent:GetModel() == "models/props_foliage/tree_poplar_01.mdl" or -- fully grown model
           ent:GetModel() == "models/props/de_inferno/flower_barrel_large.mdl" then -- initial model
            local pos = ent:GetPos() + Vector(0, 0, 60)
            local ang = LocalPlayer():EyeAngles()
            ang:RotateAroundAxis(ang:Right(), 90)
            ang:RotateAroundAxis(ang:Up(), -90)

            cam.Start3D2D(pos, ang, 0.2)
            local growthStage = ent:GetNWInt("GrowthStage")
            local text = "Weed Plant: Stage " .. growthStage

            draw.SimpleTextOutlined(text, "DermaLarge", 0, 0, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
            cam.End3D2D()
        end
    end
end)


util.AddNetworkString("HarvestWeed")

local function HarvestWeed(ply, plant)
    if plant:GetNWInt("GrowthStage") < 3 then
        ply:ChatPrint("This plant is not fully grown yet!")
        return
    end

    -- Reward the player with weed items (can be integrated with DarkRP or custom inventory)
    local amount = WEED_SYSTEM.HarvestAmount
    -- Add code to give player weed items here

    -- Remove the plant after harvesting
    plant:Remove()

    ply:ChatPrint("You have harvested " .. amount .. " weed!")
end

-- Hook to harvest the weed
hook.Add("PlayerSay", "HarvestWeedCommand", function(ply, text)
    if string.lower(text) == "!harvestweed" then
        local trace = ply:GetEyeTrace()
        if IsValid(trace.Entity) and trace.Entity:GetModel() == "models/props_foliage/tree_poplar_01.mdl" then
            HarvestWeed(ply, trace.Entity)
        else
            ply:ChatPrint("You are not looking at a fully grown weed plant.")
        end
        return ""
    end
end)
util.AddNetworkString("GiveWeedBud")

-- Function to give a weed bud to the player
local function GiveWeedBud(ply)
    if IsValid(ply) then
        -- Assuming you have a method to add items to the player's inventory
        ply:AddItem("weed_bud", 1) -- Change "weed_bud" to the actual item ID you use for a weed bud
        ply:ChatPrint("You have harvested a weed bud!")
    end
end

net.Receive("GiveWeedBud", function(len, ply)
    GiveWeedBud(ply)
end)

util.AddNetworkString("SellWeed")

local function SellWeed(ply)
    -- Check if player has weed in their inventory
    local weedAmount = ply:GetNWInt("WeedAmount", 0)

    if weedAmount > 0 then
        -- Add code for selling the weed (cash rewards)
        local reward = weedAmount * 100 -- Example: $100 per weed unit
        ply:addMoney(reward) -- Assuming DarkRP money system

        ply:SetNWInt("WeedAmount", 0) -- Reset weed amount
        ply:ChatPrint("You sold " .. weedAmount .. " weed for $" .. reward)
    else
        ply:ChatPrint("You have no weed to sell!")
    end
end

-- Hook to trigger selling action
hook.Add("PlayerSay", "SellWeedCommand", function(ply, text)
    if string.lower(text) == "!sellweed" then
        SellWeed(ply)
        return ""
    end
end)
util.AddNetworkString("GiveWeedBud")
