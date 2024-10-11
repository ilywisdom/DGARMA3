local w,h = ScrW(), ScrH()
net.Receive("OpenInventory", function()
    local inventory = net.ReadTable()

    local frame = vgui.Create("DFrame")
    frame:SetSize(w / 40, h / 3)
    frame:SetTitle("")
    frame:Center()
    frame:MakePopup()

    local itemList = vgui.Create("DListView", frame)
    itemList:Dock(FILL)
    itemList:AddColumn("Item")
    itemList:AddColumn("Amount")

    for itemID, amount in pairs(inventory) do
        local item = ITEMS[itemID]
        if item then
            itemList:AddLine(item.name, amount)
        end
    end
end)
