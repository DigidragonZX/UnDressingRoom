-- Create the Addon Frame
local UDR = CreateFrame("Frame", "UnDressingRoomFrame", DressUpFrame)

-- 1. Initialize Saved Variables
UDR:RegisterEvent("ADDON_LOADED")
UDR:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "UnDressingRoom" then
        -- Default to true if the variable doesn't exist yet
        if UDR_Config == nil then UDR_Config = true end
        UDR_AutoUndressCheckbox:SetChecked(UDR_Config)
    end
end)

-- 2. Create the "Auto Undress" Checkbox
local cb = CreateFrame("CheckButton", "UDR_AutoUndressCheckbox", DressUpFrame, "UICheckButtonTemplate")
cb:SetWidth(22)
cb:SetHeight(22)
cb:SetPoint("BOTTOMLEFT", DressUpFrame, "BOTTOMLEFT", 22, 103)
cb:SetScript("OnClick", function() 
    UDR_Config = this:GetChecked() 
end)

local cbText = cb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
cbText:SetPoint("LEFT", cb, "RIGHT", 0, 1)
cbText:SetText("Auto Undress")

-- 3. Create the "Undress" Button
local btn = CreateFrame("Button", "UDR_UndressButton", DressUpFrame, "UIPanelButtonTemplate")
btn:SetWidth(80)
btn:SetHeight(22)
btn:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", 0, 0)
btn:SetText("Undress")
btn:SetScript("OnClick", function() DressUpModel:Undress() end)

-- 4. Logic: Hook the DressUp Function
local OriginalDressUpItemLink = DressUpItemLink

DressUpItemLink = function(link)
    if not link then return end
    
    if not DressUpFrame:IsVisible() then
        ShowUIPanel(DressUpFrame)
        DressUpModel:SetUnit("player")
        
        if UDR_Config then
            DressUpModel:Undress()
        end
    end

    -- Always apply the item at the end
    OriginalDressUpItemLink(link)
end
