--[[
	Name: sv_cars.lua
	
		
]]--

GM.Cars = {}
GM.Cars.m_tblRegister = {}
GM.Cars.m_tblRegisterByMake = {}
GM.Cars.m_tblJobRegister = {}
GM.Cars.SPAWN_ERR_NOT_IN_BBOX = 0
GM.Cars.SPAWN_ERR_NO_SPAWNS = 1

--Loads all cars from the cars folder
function GM.Cars:LoadCars()
	GM:PrintDebug( 0, "->LOADING CARS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "core/carros/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "core/carros/".. v )
		AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "core/carros/".. v )
	end

	GM:PrintDebug( 0, "->CARS LOADED" )
end

--Registers a car with the gamemode
function GM.Cars:Register( tblCar )
	self.m_tblRegister[tblCar.UID] = tblCar
	self.m_tblRegisterByMake[tblCar.Make] = self.m_tblRegisterByMake[tblCar.Make] or {}
	self.m_tblRegisterByMake[tblCar.Make][tblCar.UID] = tblCar
	--util.PrecacheModel( tblCar.Model )
end

--Registers a job car with the gamemode
function GM.Cars:RegisterJobCar( tblCar )
	self.m_tblJobRegister[tblCar.UID] = tblCar
	--util.PrecacheModel( tblCar.Model )
end

--Returns a car data table for the given uid
function GM.Cars:GetCarByUID( strCarUID )
	return self.m_tblRegister[strCarUID]
end

--Returns a table of cars by manufacturer
function GM.Cars:GetCarsByMake( strMake )
	return self.m_tblRegisterByMake[strMake]
end

--Returns all cars registered, sorted by manufacturer
function GM.Cars:GetAllCarsByMake()
	return self.m_tblRegisterByMake
end

--Returns all cars registered, sorted by uid
function GM.Cars:GetAllCarsByUID()
	return self.m_tblRegister
end

--Returns a car data table for the given uid (job cars only)
function GM.Cars:GetJobCarByUID( strCarUID )
	return self.m_tblJobRegister[strCarUID]
end

--Returns all job cars registered, sorted by uid
function GM.Cars:GetAllJobCars()
	return self.m_tblJobRegister
end

--Returns the total value of the given vehicle
function GM.Cars:CalcVehicleValue( entCar )
	local data = self:GetCarByUID( entCar.UID )
	if not data or not data.Price or data.Job then return end
	
	local ret = { BasePrice = data.Price, Value = data.Price }
	hook.Call( "GamemodeCalcVehicleValue", GAMEMODE, entCar, ret )

	return ret.Value
end

function GM.Cars:PlayerEnteredVehicle( pPlayer, entCar )
	if not entCar.UID then return end
	-- entCar:Fire( "TurnOff", "1" )
	-- self:UpdateFuelPlayerEnteredVehicle( pPlayer, entCar )
end

function GM.Cars:EntityTakeDamage( eEnt, pDamageInfo )
	if not eEnt:IsVehicle() then return end
	self:CarTakeDamage( eEnt, pDamageInfo )
end

function GM.Cars:ShouldCollide( eEnt1, eEnt2 )
	if eEnt1:IsVehicle() then
		if eEnt2.IsItem then return eEnt2.ItemData.CollidesWithCars or false end
	elseif eEnt2:IsVehicle() then
		if eEnt1.IsItem then return eEnt1.ItemData.CollidesWithCars or false end
	end

	return true
end

--[[ Vehicle Params ]]--
-- ----------------------------------------------------------------
--Grabs the un-modified vehicle params, fixes the units and stores the params for reuse
function GM.Cars:InitBaseVehicleParams( entCar )
	if not entCar.m_tblInitialParams then
		local params = entCar:GetVehicleParams() or {}
		self:FixVehicleParams( params )
		entCar.m_tblInitialParams = params
		entCar.m_tblParams = {}
	end
end

--Returns the fixed initial params for a spawned vehicle
function GM.Cars:GetBaseVehicleParams( entCar )
	return entCar.m_tblInitialParams
end

--Returns the table of applied params for the given id
function GM.Cars:GetVehicleParams( entCar, strParamID )
	return entCar.m_tblParams[strParamID]
end

--Returns all the registered vehicle params for a car
function GM.Cars:GetAllVehicleParams( entCar )
	return entCar.m_tblParams
end

--Applied a table of vehicle param data to a car
function GM.Cars:ApplyVehicleParams( entCar, strParamID, tblParams )
	entCar.m_tblParams[strParamID] = tblParams
	self:InvalidateVehicleParams( entCar )
end

--Removes a table of vehicle param data from a car
function GM.Cars:RemoveVehicleParams( entCar, strParamID )
	if entCar.m_tblParams[strParamID] then
		entCar.m_tblParams[strParamID] = nil
		self:InvalidateVehicleParams( entCar )
	end
end

--Called to rebuild the vehicle params for a car
function GM.Cars:InvalidateVehicleParams( entCar )
	local baseParams = table.Copy( self:GetBaseVehicleParams(entCar) )
	if not baseParams then return end
	
	for strID, params in pairs( entCar.m_tblParams ) do
		self:ApplyVehicleUpgradeParams( params, baseParams )
	end

	self:FinalizeNewVehicleParams( entCar, baseParams )
	entCar:SetVehicleParams( baseParams )
end

--Use this function to update values that rely on other values
function GM.Cars:FinalizeNewVehicleParams( entCar, tblNewParams )
	--Set the boost speed
	tblNewParams.engine.boostMaxSpeed = tblNewParams.engine.boostMaxSpeed +tblNewParams.engine.maxSpeed

	--Calc damage
	if entCar.m_intHorsepowerScalar then
		local minHP = math.min( 175, tblNewParams.engine.horsepower )
		local targetHP = -(tblNewParams.engine.horsepower -minHP)
		tblNewParams.engine.horsepower = tblNewParams.engine.horsepower -Lerp( entCar.m_intHorsepowerScalar, 0, tblNewParams.engine.horsepower -minHP )
	end
end

--Convert units from initial params to valid units for setting the params again
function GM.Cars:FixVehicleParams( tblParams )
	if not tblParams.engine then return end
	if tblParams.engine.boostMaxSpeed > 0 then
		tblParams.engine.boostMaxSpeed = tblParams.engine.boostMaxSpeed /17.6
	end

	if tblParams.engine.maxRevSpeed > 0 then
		tblParams.engine.maxRevSpeed = tblParams.engine.maxRevSpeed /17.6
	end

	if tblParams.engine.maxSpeed > 0 then
		tblParams.engine.maxSpeed = tblParams.engine.maxSpeed /17.6
	end
end

--Recursive + additive table merge
function GM.Cars:ApplyVehicleUpgradeParams( tblParams, tblApplyTo )
	for k, v in pairs( tblParams ) do
		if type( v ) == "table" then
			tblApplyTo[k] = tblApplyTo[k] or {}
			self:ApplyVehicleUpgradeParams( v, tblApplyTo[k] )
			continue
		end

		if type( v ) == "number" then
			tblApplyTo[k] = (tblApplyTo[k] or 0) +v
		else
			tblApplyTo[k] = v
		end
	end
end

--[[ Car Spawning ]]--
-- ----------------------------------------------------------------


--Checks if the player has spawned a valid car
function GM.Cars:PlayerHasCar( pPlayer )
	return IsValid( pPlayer.m_entCurrentCar )
end

--Returns the players currently spawned car (if any)
function GM.Cars:GetCurrentPlayerCar( pPlayer )
	return pPlayer.m_entCurrentCar
end

--Checks if the player's currently spawned car belongs to the provided job id
function GM.Cars:IsPlayerCarForJob( pPlayer, intJobID )
	if not self:PlayerHasCar( pPlayer ) then return false end
	return pPlayer.m_entCurrentCar.Job == intJobID
end

--Spawns a car from the given car data table and sets the owner to the provided player
--funcPostCreated: callback run after the car is initialized but before PlayerSpawnedVehicle is run
function GM.Cars:SpawnPlayerVehicle( pOwner, tblCarData, vecPos, vecAngs, funcPostCreated )
	local car = ents.Create( "prop_vehicle_jeep" ) 
	car:SetModel( tblCarData.Model ) 
	car:SetKeyValue( "vehiclescript", tblCarData.Script )
	car:DrawShadow( false )
	car:SetPos( vecPos )
	car:SetAngles( vecAngs )

	car.AdminPhysGun = true
	car.CarData = tblCarData
	car.UID = tblCarData.UID
	car.Job = tblCarData.Job and _G[tblCarData.Job] or nil
	car.VehicleTable = tblCarData.VehicleTable and list.Get( "Vehicles" )[tblCarData.VehicleTable] or nil

	car:Spawn()
	car:Activate()
	car:SetCustomCollisionCheck( true )
	car:SetPlayerOwner( pOwner )
	self:InitBaseVehicleParams( car )

	if funcPostCreated then
		funcPostCreated( pOwner, car, tblCarData )
	end

	if IsValid( pOwner ) then
		-- self:SetupCarStats( car, self:GetPlayerCarData(pOwner, tblCarData.UID) )
		hook.Call( "PlayerSpawnedVehicle", GAMEMODE, pOwner, car )
	end
	
	timer.Simple( 0, function() --fucking vcmod
		car.IsLocked = true
		car.IsTrunkLocked = true
		car.VC_Locked = true
		car:Fire( "Lock" )
		for k, v in pairs( car.VC_SeatTable or {} ) do
			v.IsLocked = true
			v.VC_Locked = true
			v:Fire( "Lock" )
		end
	end )

	car:SetNWString( "UID", tblCarData.UID )

	return car
end

--Called when a player spawns a car they own from the garage
function GM.Cars:PlayerSpawnCar( pPlayer, strCarUID )
	local newCar = self:GetCarByUID( strCarUID )
	if not newCar then return false end
	if not self:PlayerOwnsCar( pPlayer, strCarUID ) then return false end

	if hook.Call( "GamemodePlayerCanSpawnCar", GAMEMODE, pPlayer, strCarUID ) == false then
		return
	end
	
	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if IsValid( curCar ) then
		if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), GAMEMODE.Config.CarGarageBBox.Min, GAMEMODE.Config.CarGarageBBox.Max ) then
			pPlayer:AddNote( "Seu carro não está no estacionamento!" )
			return false
		else
			self:SaveCarStats( pPlayer, curCar )
			curCar:Remove()
		end
	end

	local spawnPos, spawnAngs = GAMEMODE.Util:FindSpawnPoint( GAMEMODE.Config.CarSpawns, 80 )
	if not spawnPos then
		pPlayer:AddNote( "Estacionamento lotado?" )
		pPlayer:AddNote( "Espere liberarem as vagas." )
		return false
	end
	
	local car = self:SpawnPlayerVehicle( pPlayer, newCar, spawnPos, spawnAngs, function( pOwner, entCar, tblData )
		pOwner.m_entCurrentCar = entCar
		pOwner:SetNWEntity( "CurrentCar", entCar )
		pOwner:AddNote( "Você spawnou seu carro!" )
	end )

	return true
end

--Called when a player spawns a car tied to a specific job (ex: police car/firetruck)
function GM.Cars:PlayerSpawnJobCar( pPlayer, strJobCarID, tblSpawnPoints, tblStowBox )
	local newCar = self:GetJobCarByUID( strJobCarID )
	if not newCar then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, _G[newCar.Job] ) then return false end

	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if IsValid( curCar ) then
		if tblStowBox then
			if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), tblStowBox.Min, tblStowBox.Max ) then
				pPlayer:AddNote( "Seu carro não está no estacionamento!" )
				return false, self.SPAWN_ERR_NOT_IN_BBOX
			else
				self:SaveCarStats( pPlayer, curCar )
				curCar:Remove()
			end
		else
			self:SaveCarStats( pPlayer, curCar )
			curCar:Remove()
		end
	end

	local spawnPos, spawnAngs = GAMEMODE.Util:FindSpawnPoint( tblSpawnPoints, 80 )
	if not spawnPos then
		pPlayer:AddNote( "Estacionamento lotado?." )
		pPlayer:AddNote( "Espere liberarem uma vaga." )
		return false, self.SPAWN_ERR_NO_SPAWNS
	end

	local car = self:SpawnPlayerVehicle( pPlayer, newCar, spawnPos, spawnAngs, function( pOwner, entCar, tblData )
		pOwner.m_entCurrentCar = entCar
		pOwner:SetNWEntity( "CurrentCar", entCar )
	end )

	return car
end

--[[ Car ownership ]]--
-- ----------------------------------------------------------------
--Checks if a player owns the provided car uid
function GM.Cars:PlayerOwnsCar( pPlayer, strCarUID )
	return pPlayer:GetCharacter().Vehicles[strCarUID] and true or false
end

--Returns the meta-data for a saved car a player owns (if any)
function GM.Cars:GetPlayerCarData( pPlayer, strCarUID )
	return pPlayer:GetCharacter().Vehicles[strCarUID]
end

--Called when a player tries to buy a new car
function GM.Cars:PlayerBuyCar( pPlayer, strCarUID, intCarColor )
	local car = self:GetCarByUID( strCarUID )
	if not car then return false end
	if car.VIP and not pPlayer:CheckGroup( "vip" ) then return false end

	local colCarColor = Color( 255, 255, 255, 255 )
	local idx = 0
	for k, v in pairs( GAMEMODE.Config.StockCarColors ) do
		idx = idx +1
		if idx == intCarColor then
			colCarColor = v
		end
	end
	
	if self:PlayerOwnsCar( pPlayer, strCarUID ) then return false end
	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", car.Price )

	if not pPlayer:CanAfford( price ) then
		pPlayer:AddNote( "Você é pobre demais pra isso!" )
		return false
	end

	pPlayer:TakeMoney( price )
	pPlayer:GetCharacter().Vehicles[strCarUID] = {
		color = colCarColor or Color( 255, 255, 255, 255 ),
	}
	GAMEMODE.Player:SetGameVar( pPlayer, "vehicles", pPlayer:GetCharacter().Vehicles )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )

	pPlayer:AddNote( "Você comprou um novo carro!" )
	pPlayer:AddNote( "Você pode spawnar ele comigo sempre que quiser." )
end

--Called when a player tries to sell a car they own
function GM.Cars:PlayerSellCar( pPlayer, strCarUID )
	local car = self:GetCarByUID( strCarUID )
	if not car then return false end
	if not self:PlayerOwnsCar( pPlayer, strCarUID ) then return false end

	local price = car.Price *(pPlayer:CheckGroup("vip") and 0.75 or 0.6)
	pPlayer:AddMoney( price )
	pPlayer:GetCharacter().Vehicles[strCarUID] = nil
	GAMEMODE.Player:SetGameVar( pPlayer, "vehicles", pPlayer:GetCharacter().Vehicles )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )

	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if IsValid( curCar ) and curCar.UID == strCarUID then
		curCar:Remove()
	end

	pPlayer:AddNote( "Você vendeu o carro por  R$".. string.Comma(price).. "!" )
end

--Called when a player wants to store their car in the garage
function GM.Cars:PlayerStowCar( pPlayer )
	if not self:PlayerHasCar( pPlayer ) then return false end

	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if not IsValid( curCar ) then return false end
	if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), GAMEMODE.Config.CarGarageBBox.Min, GAMEMODE.Config.CarGarageBBox.Max ) then
		pPlayer:AddNote( "Seu carro não está no estacionamento!" )
		return false, self.SPAWN_ERR_NOT_IN_BBOX
	else
		curCar:Remove()
	end	

	pPlayer:AddNote( "Seu carro agora está na garagem." )
end

--Called when a player wants to return a job vehicle
function GM.Cars:PlayerStowJobCar( pPlayer, tblStowBox )
	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if not IsValid( curCar ) then return false end
	if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), tblStowBox.Min, tblStowBox.Max ) then
		pPlayer:AddNote( "O carro precisa estar no estacionamento!" )
		return false, self.SPAWN_ERR_NOT_IN_BBOX
	else
		curCar:Remove()
	end

	pPlayer:AddNote( "Você guardou seu carro ativo.." )
end