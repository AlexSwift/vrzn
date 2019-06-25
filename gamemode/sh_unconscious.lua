--[[ 
    GMOD LEGS 3.8.6
    @Valkyrie, @blackops7799
]]-- 

g_LegsLog = 
[[
    [ADD] Legs now support SubMaterial
    [ADD] cl_togglevlegs Toggles the rendering of the legs in vehicles
    [ADD] cl_refreshlegs Refresh local legs with current player model
    [ADD] cl_defaultlegs The Default that renders if a model can't be found/rendered
    [ADD][DEV FUNC][SV] PLAYER:UpdateTrueModel() Update the Gmod Legs leg model
    [ADD][DEV FUNC][SH] PLAYER:GetTrueModel() Returns the true Playermodel path
    [FIX] Playermodel not updating on spawn
]]

g_LegsVer = "3.8.6"

local LegsBool      	= CreateConVar( "cl_legs",       	"1", 									{FCVAR_ARCHIVE}, "Enable/Disable the rendering of the legs"             		)
local VLegsBool     	= CreateConVar( "cl_vehlegs",    	"1", 									{FCVAR_ARCHIVE}, "Enable/Disable the rendering of the legs in vehicles" 		)
local DefaultLegModel   = CreateConVar( "cl_defaultlegs",   "models/player/Group01/male_09.mdl", 	{FCVAR_ARCHIVE}, "The Default that renders if a model can't be found/rendered" 	)
local PLAYER 			= FindMetaTable("Player")

if (SERVER) then
	function PLAYER:GetTrueModel()
		return self:GetNWString( "GML:TruePlayerModel", DefaultLegModel:GetString() )
	end
	
	function PLAYER:UpdateTrueModel()
		if ( self:GetTrueModel() != self:GetModel() ) then
			self:SetNWString( "GML:TruePlayerModel", self:GetModel() )
		end
	end
	
	hook.Add("PlayerSpawn", "GML:TruePlayerModel:PlayerSpawn:Server", function( Player )
		Player:UpdateTrueModel()
	end)	
	
	hook.Add("PlayerTick", "GML:TruePlayerModel:PlayerTick:Server", function( Player )
		Player:UpdateTrueModel()
	end) 	
end

if (CLIENT) then	
    local Legs = {}
    Legs.LegEnt = nil
		
	function PLAYER:GetTrueModel()
		return self:GetNWString( "GML:TruePlayerModel", DefaultLegModel:GetString() )
	end
	
    function Legs:CheckDrawVehicle()
        if ( LocalPlayer():InVehicle() ) then
			if LegsBool:GetBool() && !VLegsBool:GetBool() then
				return true
			end
			return false
        end
    end 
	
    function ShouldDrawLegs()
        if LegsBool:GetBool() then
            return  IsValid( Legs.LegEnt )                  and
                    ( LocalPlayer():Alive() or ( LocalPlayer().IsGhosted and LocalPlayer():IsGhosted() ) ) and
                    !Legs:CheckDrawVehicle() and
                    GetViewEntity() == LocalPlayer()        and
                    !LocalPlayer():ShouldDrawLocalPlayer()  and
                    !LocalPlayer():GetObserverTarget()      and
                    !LocalPlayer().ShouldDisableLegs    
        else
            return false
        end
    end
     
    function GetPlayerLegs( ply )
        return ply and ply != LocalPlayer() and ply or ( ShouldDrawLegs() and Legs.LegEnt or LocalPlayer() )
    end
            
    function Legs:SetUp()
		if ( !IsValid(self.LegEnt) ) then
			self.LegEnt = ClientsideModel( LocalPlayer():GetTrueModel(), RENDER_GROUP_OPAQUE_ENTITY )
		else	
			self.LegEnt:SetModel( LocalPlayer():GetTrueModel() )
		end
        self.LegEnt:SetNoDraw( true )
		
		for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
			local current = LocalPlayer():GetBodygroup( v.id )
			self.LegEnt:SetBodygroup( v.id,  current)
		end

		for k, v in ipairs(LocalPlayer():GetMaterials()) do
			self.LegEnt:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
		end
		
        self.LegEnt:SetSkin( LocalPlayer():GetSkin() )
        self.LegEnt:SetMaterial( LocalPlayer():GetMaterial() )
        self.LegEnt:SetColor( LocalPlayer():GetColor() )
        self.LegEnt.GetPlayerColor = function() 
            return LocalPlayer():GetPlayerColor()  
        end
		
        self.LegEnt.LastTick = 0
    end  
     
    Legs.PlaybackRate = 1
    Legs.Sequence = nil
    Legs.Velocity = 0
    Legs.OldWeapon = nil
    Legs.HoldType = nil
     
    Legs.BoneHoldTypes = 
    { 
        ["none"] = 
        {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_Neck1",
            "ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Spine2",
        },
        ["fist"] = 
        {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_Neck1",
            "ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Spine2",
        },      
        ["melee"] = 
        {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_Neck1",            
            "ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Spine2",
        },
        ["chair"] = 
        {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_Neck1",
            "ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Spine2",
            "ValveBiped.Bip01_R_Upperarm",
            "ValveBiped.Bip01_L_Upperarm",
            "ValveBiped.Bip01_R_Clavicle",
            "ValveBiped.Bip01_L_Clavicle"
        },
        ["default"] = 
        {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_L_Hand",
            "ValveBiped.Bip01_L_Forearm",
            "ValveBiped.Bip01_L_Upperarm",
            "ValveBiped.Bip01_L_Clavicle",
            "ValveBiped.Bip01_R_Hand",
            "ValveBiped.Bip01_R_Forearm",
            "ValveBiped.Bip01_R_Upperarm",
            "ValveBiped.Bip01_R_Clavicle",
            "ValveBiped.Bip01_L_Finger4",
            "ValveBiped.Bip01_L_Finger41",
            "ValveBiped.Bip01_L_Finger42",
            "ValveBiped.Bip01_L_Finger3",
            "ValveBiped.Bip01_L_Finger31",
            "ValveBiped.Bip01_L_Finger32",
            "ValveBiped.Bip01_L_Finger2",
            "ValveBiped.Bip01_L_Finger21",
            "ValveBiped.Bip01_L_Finger22",
            "ValveBiped.Bip01_L_Finger1",
            "ValveBiped.Bip01_L_Finger11",
            "ValveBiped.Bip01_L_Finger12",
            "ValveBiped.Bip01_L_Finger0",
            "ValveBiped.Bip01_L_Finger01",
            "ValveBiped.Bip01_L_Finger02",
            "ValveBiped.Bip01_R_Finger4",
            "ValveBiped.Bip01_R_Finger41",
            "ValveBiped.Bip01_R_Finger42",
            "ValveBiped.Bip01_R_Finger3",
            "ValveBiped.Bip01_R_Finger31",
            "ValveBiped.Bip01_R_Finger32",
            "ValveBiped.Bip01_R_Finger2",
            "ValveBiped.Bip01_R_Finger21",
            "ValveBiped.Bip01_R_Finger22",
            "ValveBiped.Bip01_R_Finger1",
            "ValveBiped.Bip01_R_Finger11",
            "ValveBiped.Bip01_R_Finger12",
            "ValveBiped.Bip01_R_Finger0",
            "ValveBiped.Bip01_R_Finger01",
            "ValveBiped.Bip01_R_Finger02",
            "ValveBiped.Bip01_Spine4",
            "ValveBiped.Bip01_Spine2",
        },
        ["vehicle"] = 
        {
            "ValveBiped.Bip01_Head1",
            "ValveBiped.Bip01_Neck1",
        }
    }
                     
    Legs.BonesToRemove = {}

    Legs.BoneMatrix = nil
     
    function Legs:WeaponChanged( weap )
        if IsValid( self.LegEnt ) then
            if IsValid( weap ) then
                if ( LocalPlayer():InVehicle() ) then
                    self.HoldType = "vehicle"
                else  
                    self.HoldType = weap:GetHoldType()
                end 
            else
                if ( LocalPlayer():InVehicle() ) then
                    self.HoldType = "vehicle"
                else  
                    self.HoldType = "none"
                end
            end

            for i = 0, self.LegEnt:GetBoneCount() do
                self.LegEnt:ManipulateBoneScale( i, Vector(1,1,1) )
                self.LegEnt:ManipulateBonePosition( i, vector_origin )
            end
    
            self.BonesToRemove = 
            {
                "ValveBiped.Bip01_Head1"
            }
           
           self.BonesToRemove =  self.BoneHoldTypes[ self.HoldType ] or self.BoneHoldTypes[ "default" ]
          
            for k, v in pairs(self.BonesToRemove) do
                local bone = self.LegEnt:LookupBone(v)
                if (bone) then
                    self.LegEnt:ManipulateBoneScale(bone, vector_origin)
                    self.LegEnt:ManipulateBonePosition(bone, Vector(-10,-10,0))
                end
            end
        end
    end
     
    Legs.BreathScale = 0.5
    Legs.NextBreath = 0
     
    function Legs:Think( maxseqgroundspeed )
        if not LocalPlayer():Alive() then
            Legs:SetUp()
            return
        end
        
        if IsValid( self.LegEnt ) then
            self:WeaponChanged( LocalPlayer():GetActiveWeapon() )
     
            self.Velocity = LocalPlayer():GetVelocity():Length2D()
             
            self.PlaybackRate = 1
     
            if self.Velocity > 0.5 then
                if maxseqgroundspeed < 0.001 then
                    self.PlaybackRate = 0.01
                else
                    self.PlaybackRate = self.Velocity / maxseqgroundspeed
                    self.PlaybackRate = math.Clamp( self.PlaybackRate, 0.01, 10 )
                end
            end
             
            self.LegEnt:SetPlaybackRate( self.PlaybackRate )
             
            self.Sequence = LocalPlayer():GetSequence()
             
            if ( self.LegEnt.Anim != self.Sequence ) then
                self.LegEnt.Anim = self.Sequence
                self.LegEnt:ResetSequence( self.Sequence )
            end
             
            self.LegEnt:FrameAdvance( CurTime() - self.LegEnt.LastTick )
            self.LegEnt.LastTick = CurTime()
             
            Legs.BreathScale = sharpeye and sharpeye.GetStamina and math.Clamp( math.floor( sharpeye.GetStamina() * 5 * 10 ) / 10, 0.5, 5 ) or 0.5
             
            if Legs.NextBreath <= CurTime() then
                Legs.NextBreath = CurTime() + 1.95 / Legs.BreathScale
                self.LegEnt:SetPoseParameter( "breathing", Legs.BreathScale )
            end
             
            self.LegEnt:SetPoseParameter( "move_x", ( LocalPlayer():GetPoseParameter( "move_x" ) * 2 ) - 1 ) -- Translate the walk x direction
            self.LegEnt:SetPoseParameter( "move_y", ( LocalPlayer():GetPoseParameter( "move_y" ) * 2 ) - 1 ) -- Translate the walk y direction
            self.LegEnt:SetPoseParameter( "move_yaw", ( LocalPlayer():GetPoseParameter( "move_yaw" ) * 360 ) - 180 ) -- Translate the walk direction
            self.LegEnt:SetPoseParameter( "body_yaw", ( LocalPlayer():GetPoseParameter( "body_yaw" ) * 180 ) - 90 ) -- Translate the body yaw
            self.LegEnt:SetPoseParameter( "spine_yaw",( LocalPlayer():GetPoseParameter( "spine_yaw" ) * 180 ) - 90 ) -- Translate the spine yaw

            if LocalPlayer():InVehicle() then
                self.LegEnt:SetColor( color_transparent )
                self.LegEnt:SetPoseParameter( "vehicle_steer", ( LocalPlayer():GetVehicle():GetPoseParameter( "vehicle_steer" ) * 2 ) - 1 ) -- Translate the vehicle steering
            end
        end
    end
     
    hook.Add( "UpdateAnimation", "GML:UpdateAnimation", function( ply, velocity, maxseqgroundspeed )
        if ply == LocalPlayer() then
            if IsValid( Legs.LegEnt ) then
                Legs:Think( maxseqgroundspeed )
				if ( LocalPlayer():GetTrueModel() != Legs.LegEnt:GetModel() ) then
					Legs:SetUp()
				end
            else
				Legs:SetUp()
			end
			
        end
    end )
     
    Legs.RenderAngle = nil
    Legs.BiaisAngle = nil
    Legs.RadAngle = nil
    Legs.RenderPos = nil
    Legs.RenderColor = {}
    Legs.ClipVector = vector_up * -1
    Legs.ForwardOffset = -24
     
	function Legs:DoFinalRender()
	   cam.Start3D( EyePos(), EyeAngles() )
            if ShouldDrawLegs() then
             
                self.RenderPos = LocalPlayer():GetPos()
                if LocalPlayer():InVehicle() then
                    self.RenderAngle = LocalPlayer():GetVehicle():GetAngles()
                    self.RenderAngle:RotateAroundAxis( self.RenderAngle:Up(), 90 )
                else
                    self.BiaisAngles = sharpeye_focus and sharpeye_focus.GetBiaisViewAngles and sharpeye_focus:GetBiaisViewAngles() or LocalPlayer():EyeAngles()
                    self.RenderAngle = Angle( 0, self.BiaisAngles.y, 0 )
                    self.RadAngle = math.rad( self.BiaisAngles.y )
                    self.ForwardOffset = -22
                    self.RenderPos.x = self.RenderPos.x + math.cos( self.RadAngle ) * self.ForwardOffset
                    self.RenderPos.y = self.RenderPos.y + math.sin( self.RadAngle ) * self.ForwardOffset
                     
                    if LocalPlayer():GetGroundEntity() == NULL then
                        self.RenderPos.z = self.RenderPos.z + 8
                        if LocalPlayer():KeyDown( IN_DUCK ) then
                            self.RenderPos.z = self.RenderPos.z - 28
                        end
                    end
                end
                 
                self.RenderColor = LocalPlayer():GetColor()
                 
                local bEnabled = render.EnableClipping( true )
                    render.PushCustomClipPlane( self.ClipVector, self.ClipVector:Dot( EyePos() ) ) 
                        render.SetColorModulation( self.RenderColor.r / 255, self.RenderColor.g / 255, self.RenderColor.b / 255 )
                            render.SetBlend( self.RenderColor.a / 255 )     
                                    self.LegEnt:SetRenderOrigin( self.RenderPos )
                                    self.LegEnt:SetRenderAngles( self.RenderAngle )
                                    self.LegEnt:SetupBones()
                                    self.LegEnt:DrawModel()
									self.LegEnt:SetRenderOrigin()
                                    self.LegEnt:SetRenderAngles()
                            render.SetBlend( 1 )
                        render.SetColorModulation( 1, 1, 1 )
                    render.PopCustomClipPlane()
                render.EnableClipping( bEnabled )
            end
        cam.End3D()
	end
	
	hook.Add( "PostDrawTranslucentRenderables", "GML:Render::Foot", function()
		 if ( !LocalPlayer():InVehicle() ) then
			Legs:DoFinalRender()
        end
    end )   
	
	hook.Add( "RenderScreenspaceEffects", "GML:Render::Vehicle", function()
		 if ( LocalPlayer():InVehicle() ) then
			Legs:DoFinalRender()
        end
    end )
	
    concommand.Add("cl_togglelegs", function()
        if LegsBool:GetBool() then
            RunConsoleCommand("cl_legs", "0")
        else
            RunConsoleCommand("cl_legs", "1")
        end
    end)      

	concommand.Add("cl_togglevlegs", function()
        if VLegsBool:GetBool() then
            RunConsoleCommand("cl_vehlegs", "0")
        else
            RunConsoleCommand("cl_vehlegs", "1")
        end
    end)   

	concommand.Add("cl_refreshlegs", function()
		Legs:SetUp()
    end)
end   