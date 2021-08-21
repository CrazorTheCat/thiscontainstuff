if not isfile("snowGuiConf.txt") then
   writefile("snowGuiConf.txt", "0")
end
print("made by SkyPoulet on v3rm yeah shitty name i was young ¯\\_(ツ)_/¯")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wally2", true))()
local plr = game:GetService('Players').LocalPlayer
local replicatedStorage = game:GetService('ReplicatedStorage')
local remoteEvents = replicatedStorage:WaitForChild('RemoteEvents')
local localEvents = replicatedStorage:WaitForChild('LocalEvents')
local lighthingService = game:GetService('Lighting')
lighthingService.GlobalShadows = false

_G.moddedTools = false
_G.infiniteStamina = false
_G.noCooldownTools = false
_G.noCooldownVehicle = false
_G.moddedVehicle = false
_G.hideGroupInvites = false
local equipedTool = nil

vector3Hook = hookfunction(Vector3.new, function(...)
   if not checkcaller() then
      local Args = {...}
      local callingScript = tostring(getcallingscript(vector3Hook))
      if callingScript == "LocalPlowScript" and Args[1] ~= nil and _G.moddedVehicle == true then
         return vector3Hook(Args[1] * 2, 6, Args[3] * 2)
      end
   end
   return vector3Hook(...)
end)

gameHooks = hookmetamethod(game, "__namecall", function(...)
   if not checkcaller() then
      local Args = {...}
      local Self = tostring(Args[1])
      local NamecallMethod = getnamecallmethod()
      local callingScript = tostring(getcallingscript(gameHooks))

      if NamecallMethod == "TweenPosition" and tostring(getcallingscript(gameHooks)) == "GroupInviteScript" and _G.hideGroupInvites == true then
         return
      end

      if NamecallMethod == "InvokeServer" or NamecallMethod == "Invoke" or NamecallMethod == "Fire" or NamecallMethod == "FireServer" then
         if Self == "GetToolStats" and _G.moddedTools == true then 
            return {speed = 0, shovelArea = Vector3.new(15, 15, 15), strength = 3} 
         end

         if Self == "GetToggleState" and _G.getGmpState == true then
            return true
         end

         if Self == "PlayerHasPass" and _G.getGmpState == true then
            return true
         end
      end

      if NamecallMethod == "IsInGroup" then
         return true -- why not
      end
   end
   return gameHooks(...)
end)

waitFunc = hookfunction(wait, function(seconds)
   if not checkcaller() then
      local callingScript = tostring(getcallingscript(waitFunc))
      if callingScript == "MasterScript" and seconds ~= nil and _G.noCooldownTools == true then
         return
      end

      if callingScript == "LocalPlowScript" and seconds ~= nil and _G.noCooldownVehicle == true then
         return waitFunc(0)
      end

      if callingScript == "ClientScript" and seconds == 5 and _G.noCooldownTools == true then
         return waitFunc(0)
      end
   end
   return waitFunc(seconds)
end)

local teleportTab = Library:CreateWindow("Teleports")
teleportTab:Section("Snow")

teleportTab:Button('Sell Snow', function()
   plr.Character:MoveTo(Vector3.new(365.06704711914, 2.7808394432068, -90.793975830078))
   wait(0.2)
   remoteEvents.SellSnow:FireServer(true)
end)

teleportTab:Button('Backpack Shop', function()
   plr.Character:MoveTo(Vector3.new(194.17140197754, 6.2880702018738, -43.013042449951))
end)

teleportTab:Button('Tools Shop', function()
   plr.Character:MoveTo(Vector3.new(-0.25614875555038, 4.0307092666626, -26.07732963562))
end)

teleportTab:Button('Plow Shop', function()
   plr.Character:MoveTo(Vector3.new(239.68185424805, 4.0956449508667, -152.31907653809))
end)

teleportTab:Button('Plow Parking', function()
   plr.Character:MoveTo(Vector3.new(35.098575592041, 3.6527299880981, -190.37637329102))
end)

teleportTab:Button('Pets Shop', function()
   plr.Character:MoveTo(Vector3.new(-1.040429353714, 5.2575216293335, 274.56121826172))
end)

teleportTab:Button('Cursed Shop', function()
   plr.Character:MoveTo(Vector3.new(73.605758666992, 5.1527299880981, 81.77384185791))
end)

teleportTab:Button('Parking Plot', function()
   plr.Character:MoveTo(Vector3.new(-477.94714355469, 3.6285593509674, 71.441551208496))
end)

teleportTab:Section("Ice")

teleportTab:Button('Ice Backpack Shop', function()
   plr.Character:MoveTo(Vector3.new(91.338302612305, 3.2248678207397, -574.11071777344))
end)

teleportTab:Button('Ice Tools Shop', function()
   plr.Character:MoveTo(Vector3.new(131.78569030762, 3.2976760864258, -562.94067382813))
end)

teleportTab:Button('Mountain Camp', function()
   plr.Character:MoveTo(Vector3.new(5.1332588195801, 59.547492980957, -1048.1463623047))
end)

teleportTab:Button('Mountain Top', function()
   plr.Character:MoveTo(Vector3.new(292.46438598633, 553.52917480469, -1639.5784912109))
end)

teleportTab:Button('Crystal Cave', function()
   plr.Character:MoveTo(Vector3.new(-244.1909942627, -241.64538574219, -609.39178466797))
end)

teleportTab:Button('Mountain Hiker', function()
   plr.Character:MoveTo(Vector3.new(394.80355834961, 173.94239807129, -2024.9892578125))
end)

teleportTab:Button('Larry House', function()
   plr.Character:MoveTo(Vector3.new(-638.47015380859, 202.60606384277, -2006.8583984375))
end)

teleportTab:Button('Teleport To Boss Room', function()
   remoteEvents.TeleportToBossRoom:FireServer()
end)

local toolsOwned = {}
for toolName in string.gmatch(plr.Stats.storedTools.Value, "([^,]+)") do
   table.insert(toolsOwned, tostring(toolName))
end

local backpackOwned = {}
for backpackName in string.gmatch(plr.Stats.backpacks.Value, "([^,]+)") do
   table.insert(backpackOwned, tostring(backpackName))
end


local toolsTab = Library:CreateWindow("Tools")
toolsTab:Section("Cheats")

toolsTab:Section("Equip a stored item that you own")
local ownedToolsDropdown = toolsTab:Dropdown("Equip Owned Shovel", {flag = "SelecTool", list = toolsOwned}, function(selectedTool)
   remoteEvents.RetrieveItem:FireServer(tostring(selectedTool))
end)

toolsTab:Section("Equip a backpack that you own")
local ownedBackpackDropdown = toolsTab:Dropdown("Equip Owned Backpack", {flag = "SelecBackpack", list = backpackOwned}, function(selectedBackpack)
   remoteEvents.BuyBackpack:FireServer(tostring(selectedBackpack), Color3.fromRGB(138, 171, 133))
end)

plr.Stats.storedTools.Changed:Connect(function(proprety)
   toolsOwned = {}
   for toolName in string.gmatch(plr.Stats.storedTools.Value, "([^,]+)") do
      table.insert(toolsOwned, tostring(toolName))
   end
   ownedToolsDropdown.Refresh(toolsOwned)
end)

plr.Stats.backpacks.Changed:Connect(function(proprety)
   backpackOwned = {}
   for backpackName in string.gmatch(plr.Stats.backpacks.Value, "([^,]+)") do
      table.insert(backpackOwned, tostring(backpackName))
   end
   ownedBackpackDropdown.Refresh(backpackOwned)
end)

toolsTab:Button("Get Easter Tools", function()
   remoteEvents.BuyShovel:FireServer("Easter Staff")
   remoteEvents.BuyShovel:FireServer("Easter Shovel")
end)

toolsTab:Toggle("No Cooldown", {flag = "noCooldownToolsState"}, function()
   _G.noCooldownTools = toolsTab.flags.noCooldownToolsState
end)

toolsTab:Toggle("Bigger collect range", {flag = "moddedToolsState"}, function()
   _G.moddedTools = toolsTab.flags.moddedToolsState
   wait(0.2)
   for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
      if v:IsA("Tool") then
         equipedTool = v
         plr.Character.Humanoid:UnequipTools(equipedTool)
         plr.Character.Humanoid:EquipTool(equipedTool)
      end
   end
end)

local petsOwned = {}
for petsName in string.gmatch(plr.Stats.pets.Value, "([^,]+)") do
   table.insert(petsOwned, tostring(petsName))
end

local petsTab = Library:CreateWindow("Pets")
petsTab:Section("Cheats")

petsTab:Section("Equip a pet that you own")
local ownedPetsDropdown = petsTab:Dropdown("Equip Owned Pet", {flag = "SelecPet", list = petsOwned}, function(selectedPet)
   remoteEvents.BuyPet:FireServer(tostring(selectedPet))
end)

plr.Stats.pets.Changed:Connect(function(proprety)
   petsOwned = {}
   for petName in string.gmatch(plr.Stats.pets.Value, "([^,]+)") do
      table.insert(petsOwned, tostring(petName))
   end
   ownedPetsDropdown.Refresh(petsOwned)
end)

petsTab:Button("Unlock Robux Pets", function()
   remoteEvents.BuyPet:FireServer("Noob Archer")
   remoteEvents.BuyPet:FireServer("Otherworldly Pet")
end)

petsTab:Button("Unlock Boss Pets", function()
   plr.specialPetsUnlocked["Mini Ice King"].Value = true
   plr.specialPetsUnlocked["Mini Cave Creature"].Value = true
   plr.specialPetsUnlocked["Mini Maniacal Cube"].Value = true
end)

local vehicleTab = Library:CreateWindow("Vehicle")
vehicleTab:Section("Cheats")

local vehicleOwned = {}
for carInst in string.gmatch(plr.Stats.vehicles.Value, "([^,]+)") do
   table.insert(vehicleOwned, tostring(carInst))
end

local otherPlrVehicleName = {}
for i,plowInst in pairs(workspace.Vehicles:GetChildren()) do
   if plowInst.Name ~= tostring(game.Players.LocalPlayer.vehicle.Value) then
      table.insert(otherPlrVehicleName, plowInst.Name)
   end
end

vehicleTab:Section("Spawn a car that you own")
local ownedVehicleDropdown = vehicleTab:Dropdown("Spawn Owned Vehicle", {flag = "Vehicle", list = vehicleOwned}, function(selectedcar)
   remoteEvents.BuyVehicle:FireServer(tostring(selectedcar))
   plr.Character:MoveTo(Vector3.new(35.098575592041, 3.6527299880981, -190.37637329102))
end)

vehicleTab:Section("Flip any player car")
local flipVehicleDropdown = vehicleTab:Dropdown("Flip Player Car", {flag = "VehicletoFLIP", list = otherPlrVehicleName}, function(vroomvroom)
   if readfile("snowGuiConf.txt") == "0" then
      game.ReplicatedStorage.LocalEvents.SendNotification:Fire("Please don't abuse (spamming someone until the person leave)", "Don't be toxic", true)
      delfile("snowGuiConf.txt")
      writefile("snowGuiConf.txt", "1")
   end
   remoteEvents.FlipVehicle:FireServer(workspace.Vehicles[tostring(vroomvroom)])
end)

plr.Stats.vehicles.Changed:Connect(function(proprety)
   for carInstname in string.gmatch(proprety, "([^,]+)") do
      table.insert(vehicleOwned, carInstname)
   end
   ownedVehicleDropdown.Refresh(vehicleOwned)
end)

workspace.Vehicles.ChildAdded:Connect(function(child)
   if child.Name ~= tostring(game.Players.LocalPlayer.vehicle.Value) then
      otherPlrVehicleName = {}
      for i,v in pairs(workspace.Vehicles:GetChildren()) do
         table.insert(otherPlrVehicleName, v.Name)
      end
      flipVehicleDropdown.Refresh(otherPlrVehicleName)
   end
end)

workspace.Vehicles.ChildRemoved:Connect(function(child)
   if child.Name ~= tostring(game.Players.LocalPlayer.vehicle.Value) then
      otherPlrVehicleName = {}
      for i,v in pairs(workspace.Vehicles:GetChildren()) do
         table.insert(otherPlrVehicleName, v.Name)
      end
      flipVehicleDropdown.Refresh(otherPlrVehicleName)
   end
end)

vehicleTab:Button("Buy Sleigh (225K INSTEAD OF R$)", function()
   remoteEvents.BuyVehicle:FireServer("Sleigh")
end)

vehicleTab:Toggle("No Cooldown", {flag = "noCooldownVehicleState"}, function()
   _G.noCooldownVehicle = vehicleTab.flags.noCooldownVehicleState
end)

vehicleTab:Toggle("Bigger collect range", {flag = "moddedVehicleState"}, function()
   _G.moddedVehicle = vehicleTab.flags.moddedVehicleState
end)

local iceTab = Library:CreateWindow("Ice")
iceTab:Section("Cheats")

iceTab:Button("Unlock Crystal Cave Entrance", function()
   plr.hasUnlockedCave.Value = true
end)

iceTab:Button("Get Ice Spear", function()
   remoteEvents.I.BuyIceTool:FireServer("Ice Spear")
end)

local miscTab = Library:CreateWindow("Misc")
miscTab:Section("Cheats")

miscTab:Button("Get Christmas Backpack", function()
   remoteEvents.BuyBackpack:FireServer("Christmas", Color3.fromRGB(138, 171, 133))
end)

miscTab:Button("Get Gamepasses", function()
   plr.Products.Value = "124908390,125071079,126031348,124908492,127505044,124908729,332440468,124909315,134971875,942865599,124908990,124909209,126024150,126031696,126067686,126068766,127521031,128818138,131403202,131660327,134355474,134969105,815761911,124909069,"
   _G.getGmpState = true
end)

miscTab:Button("Get Cursed Items", function()
   remoteEvents.BuyShovel:FireServer("Jack O' Bomb")
   remoteEvents.BuyShovel:FireServer("Staff Of The Dead")
   if plr.leaderstats.Money.Value < 100 then
      localEvents.SendNotification:Fire("To get the coffin car you need atleast 100$ but you have " .. game.Players.LocalPlayer.leaderstats.Money.Value .. "$", "Don't be lazy its only 100$", true)
   else
      remoteEvents.BuyVehicle:FireServer("Coffin Car")
   end
end)

miscTab:Button("Get Codes Items + Pets", function()
   plr.Stats.usedCodes.Value = "tvdude,DiamondSnow,AFlyingAnt,z"
end)

miscTab:Toggle("Hide Group Invites", {flag = "hideGroupInvitesState"}, function()
   _G.hideGroupInvites = miscTab.flags.hideGroupInvitesState
end)

miscTab:Slider("WalkSpeed", {precise = true, default = 16, min = 10, max = 500}, function(value)
   plr.Character.Humanoid.WalkSpeed = value
end)

miscTab:Slider("JumpPower", {precise = true, default = 50, min = 10, max = 500}, function(value)
   plr.Character.Humanoid.JumpPower = value
end)

miscTab:Section("Performance")
miscTab:Button("Remove Lights", function()
   for i,v in pairs(workspace:GetDescendants()) do
      if v.Name == "SurfaceLight" or v.Name == "PointLight" or v.Name == "SplotLight" then
          v:Destroy()
      end
  end
end)

miscTab:Button("Remove Post Processing Effects", function()
   lighthingService.SunRays:Destroy()
   lighthingService.ColorCorrection:Destroy()
end)

miscTab:Toggle("Global Shadows", {flag = "globalShadowsState"}, function()
   lighthingService.GlobalShadows = miscTab.flags.globalShadowsState
end)
