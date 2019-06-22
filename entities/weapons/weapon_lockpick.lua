AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Lockpick"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server

SWEP.Author = "DarkRP Developers"
SWEP.Instructions = "Left or right click to pick a lock"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = ""

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = -1     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false        -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

--[[-------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsLockpicking")
	self:NetworkVar("Float", 0, "LockpickStartTime")
	self:NetworkVar("Float", 1, "LockpickEndTime")
	self:NetworkVar("Float", 2, "NextSoundTime")
	self:NetworkVar("Int", 0, "TotalLockpicks")
	self:NetworkVar("Entity", 0, "LockpickEnt")
end

--[[-------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2)
	if self:GetIsLockpicking() then return end

	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()
	self:GetOwner():LagCompensation(false)
	local ent = trace.Entity

	if not IsValid(ent) then return end
	local canLockpick = hook.Call("canLockpick", nil, self:GetOwner(), ent, trace)

	if canLockpick == false then return end
	if not ent.m_tblPropertyData then
		if ent:IsPlayer() then
			if not ent:HasWeapon( "weapon_handcuffed" ) then return end
		elseif ent:IsVehicle() then
			if not ent.CarData then return end
		else
			return
		end
	end

	self:SetHoldType("pistol")

	self:SetIsLockpicking(true)
	self:SetLockpickEnt(ent)
	self:SetLockpickStartTime(CurTime())
	local endDelta = hook.Call("lockpickTime", nil, self:GetOwner(), ent) or util.SharedRandom("DarkRP_Lockpick"..self:EntIndex().."_"..self:GetTotalLockpicks(), 10, 30)
	self:SetLockpickEndTime(CurTime() + endDelta)
	self:SetTotalLockpicks(self:GetTotalLockpicks() + 1)


	-- if IsFirstTimePredicted() then
		-- hook.Call("lockpickStarted", nil, self:GetOwner(), ent, trace)
	-- end

	if CLIENT then
		self.Dots = ""
		self.NextDotsTime = CurTime() + 0.5
		return
	end

	local onFail = function(ply) if ply == self:GetOwner() then hook.Call("onLockpickCompleted", nil, ply, false, ent) end end

	-- Lockpick fails when dying or disconnecting
	-- hook.Add("PlayerDeath", self, fc{onFail, fn.Flip(fn.Const)})
	-- hook.Add("PlayerDisconnected", self, fc{onFail, fn.Flip(fn.Const)})
	-- -- Remove hooks when finished
	-- hook.Add("onLockpickCompleted", self, fc{fp{hook.Remove, "PlayerDisconnected", self}, fp{hook.Remove, "PlayerDeath", self}})
end

function SWEP:Holster()
	self:SetIsLockpicking(false)
	self:SetLockpickEnt(nil)
	return true
end

function SWEP:Succeed()
	if !self:IsValid() then return end
	
	self:SetHoldType("normal")
	
	local ent = self:GetLockpickEnt()
	self:SetIsLockpicking(false)
	self:SetLockpickEnt(nil)

	if not IsValid(ent) then return end

	local override = hook.Call("onLockpickCompleted", nil, self:GetOwner(), true, ent)

	if override then return end
	
	if ent:IsPlayer() then
		local handcuffs = ent:HasWeapon( "weapon_handcuffed" )
		if handcuffs then
			ent:GetWeapon( "weapon_handcuffed" ):Break()
			return
		end
	end

	if ent.Fire then
		GAMEMODE.Property:ForceUnlockEntity( ent )
		ent:Fire("open", "", .6)
		ent:Fire("setanimation", "open", .6)
	end
	
	if SERVER then
		if ent:IsVehicle() and ent:GetClass() == "prop_vehicle_jeep" then
			if ent.m_sndAlarm then
				ent.m_sndAlarm:Stop()
			end
			
			ent.m_sndAlarm = CreateSound( ent, "santosrp/car_alarm.wav" )
			ent.m_sndAlarm:Play()

			local snd = ent.m_sndAlarm
			timer.Simple( 60, function()
				if not IsValid( ent ) then return end
				if not ent.m_sndAlarm or ent.m_sndAlarm ~= snd then return end
				ent.m_sndAlarm:Stop()
			end )
		end

		if math.random(1,5) then
			self.Owner:AddNote( "Your lockpick broke in your hands" )
			GAMEMODE.Inv:DeletePlayerEquipItem( self.Owner, "AltWeapon" )
			self:Remove()
		end
	end
end

function SWEP:Fail()
	self:SetIsLockpicking(false)
	self:SetHoldType("normal")

	hook.Call("onLockpickCompleted", nil, self:GetOwner(), false, self:GetLockpickEnt())
	self:SetLockpickEnt(nil)
end

function SWEP:Think()
	if not self:GetIsLockpicking() or self:GetLockpickEndTime() == 0 then return end

	if CurTime() >= self:GetNextSoundTime() then
		self:SetNextSoundTime(CurTime() + 1)
		local snd = {1,3,4}
		self:EmitSound("weapons/357/357_reload".. tostring(snd[math.Round(util.SharedRandom("DarkRP_LockpickSnd"..CurTime(), 1, #snd))]) ..".wav", 50, 100)
	end
	if CLIENT and self.NextDotsTime and CurTime() >= self.NextDotsTime then
		self.NextDotsTime = CurTime() + 0.5
		self.Dots = self.Dots or ""
		local len = string.len(self.Dots)
		local dots = {[0]=".", [1]="..", [2]="...", [3]=""}
		self.Dots = dots[len]
	end

	local trace = self:GetOwner():GetEyeTrace()
	if not IsValid(trace.Entity) or trace.Entity ~= self:GetLockpickEnt() or trace.HitPos:Distance(self:GetOwner():GetShootPos()) > 100 then
		self:Fail()
	elseif self:GetLockpickEndTime() <= CurTime() then
		self:Succeed()
	end
end

function SWEP:DrawHUD()
	if not self:GetIsLockpicking() or self:GetLockpickEndTime() == 0 then return end

	self.Dots = self.Dots or ""
	local w = ScrW()
	local h = ScrH()
	local x,y,width,height = w/2-w/10, h/2-60, w/5, h/15
	draw.RoundedBox(8, x, y, width, height, Color(10,10,10,120))

	local time = self:GetLockpickEndTime() - self:GetLockpickStartTime()
	local curtime = CurTime() - self:GetLockpickStartTime()
	local status = math.Clamp(curtime/time, 0, 1)
	local BarWidth = status * (width - 16)
	local cornerRadius = math.Min(8, BarWidth/3*2 - BarWidth/3*2%2)
	draw.RoundedBox(cornerRadius, x+8, y+8, BarWidth, height-16, Color(255-(status*255), 0+(status*255), 0, 255))

	draw.SimpleText("Picking lock" .. self.Dots, "Trebuchet24", w/2, y + height/2, Color(255,255,255,255), 1, 1)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end