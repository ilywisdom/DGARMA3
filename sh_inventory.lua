util.AddNetworkString("OpenInventory")

local PLAYER = FindMetaTable("Player")

function PLAYER:InitializeInventory()
    self.Inventory = {}
    self.MaxWeight = 10 -- Maximum weight limit for inventory
end

function PLAYER:AddItem(itemID, amount)
    local item = ITEMS[itemID]
    if not item then return end

    -- Check if player can carry more weight
    local currentWeight = self:GetInventoryWeight()
    if currentWeight + (item.weight * amount) > self.MaxWeight then
        self:ChatPrint("You can't carry that much!")
        return false
    end

    self.Inventory[itemID] = (self.Inventory[itemID] or 0) + amount
    return true
end

function PLAYER:RemoveItem(itemID, amount)
    if not self.Inventory[itemID] or self.Inventory[itemID] < amount then
        return false
    end

    self.Inventory[itemID] = self.Inventory[itemID] - amount
    if self.Inventory[itemID] <= 0 then
        self.Inventory[itemID] = nil
    end
    return true
end

function PLAYER:GetInventoryWeight()
    local totalWeight = 0
    for itemID, amount in pairs(self.Inventory) do
        totalWeight = totalWeight + (ITEMS[itemID].weight * amount)
    end
    return totalWeight
end

function PLAYER:OpenInventory()
    net.Start("OpenInventory")
    net.WriteTable(self.Inventory)
    net.Send(self)
end
