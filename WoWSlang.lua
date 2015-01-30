--[[
Author   : Shyam "Doggan" Guthikonda
Modified : 11.19.07
Desc     : The main body of the WoWSlang AddOn.
--]]

-- Constants.
local WoWSlang_USAGE = "WoWSlang Usage: /wowslang <option> or /wowsl <option>";

local FRAME_TITLE = "WoWSlang";

local COLOR_RED = "|cFFFF0000"
local COLOR_GREEN = "|cFF00FF00"
local COLOR_BLUE = "|cFF0000FF"
local COLOR_NORM = "|r"

----------------------------
----- Utility Functions ----
----------------------------

--[[
Desc  : Sort the dictionary, t, alphabetically.
Input : t = a dictionary
Output: An iterator to loop over the table in alphabetical order.
--]]
local function sortDict(t)
    local tempArray = {};
    
    for n in pairs(t) do
        table.insert(tempArray, n);
    end
    
    -- Case insensitive - do sorting in lower-case.
    table.sort(tempArray, function(a, b) return strlower(a) < strlower(b) end);
    
    local i = 0;
    return function()
        i = i + 1;
        return tempArray[i], t[tempArray[i]];
    end
end

--[[
Desc  : Find the definition for 'word' in the dictionary.
Input : word = the word to be looked up
Output: A string containing the definition. If the word doesn't exist, return
        an appropriate message.
--]]
local function lookupDefn(word)
    for a, b in pairs(WoWSlang_dict) do
        -- word Found?
        if strlower(a) == strlower(word) then
            return a .. ": " .. b;
        end
    end
    
    return "Word not found (" .. word .. ").";
end

--[[
Desc  : Print a formatted msg to the chat window. Use the AddOn name, which
        allows the user to know where this message is coming from.
Input : msg = the message to be displayed
Output: -
--]]
local function printMsg(msg)
    DEFAULT_CHAT_FRAME:AddMessage("WoWSlang: " .. msg);
end

--------------------------
----- Event Functions ----
--------------------------

--[[
Desc  : Register slashies and get the dictionary ready for display.
Input : -
Output: -
--]]
function WoWSlang_OnLoad()
    -- Set up our slashies.
    SLASH_WoWSlang1 = "/wowslang";
    SLASH_WoWSlang2 = "/wowsl";
    SlashCmdList["WoWSlang"] = WoWSlang_OnSlashCmd;
    
    -- Parse the dictionary to a string.
    local txt = "";
    for key, val in sortDict(WoWSlang_dict) do
        txt = txt .. COLOR_RED .. key .. COLOR_BLUE .. " = " .. COLOR_NORM .. val .. "|n";
    end
    
    -- Set the strings.
    WoWSlang_Frame_WindowTitle:SetText(FRAME_TITLE);
    WoWSlang_Frame_Scroll_Text:SetText(txt);
end

--[[
Desc  : Handle all slash commands. Display the definition if some word is
        given, or just pop up the main dictionary window if no word is given.
Input : msg = a string to look up in the dictionary, or "" if no word is given.
Output: -
--]]
function WoWSlang_OnSlashCmd(msg)
    -- If a msg is passed in...
    if msg ~= "" then
        -- Print this word's definition.
        printMsg(lookupDefn(msg));
    -- Toggle the window if no message is passed.
    else
        if WoWSlang_Frame:IsShown() then
            WoWSlang_Frame:Hide();
        else
            WoWSlang_Frame:Show();
        end
    end
end