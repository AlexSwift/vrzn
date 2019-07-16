local tag = "AFK"
afk = afk or {}
afk.AFKTime = CreateConVar("sv_afktimeout", "90", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "The time it takes for a player to become AFK while inactive.")
local PLAYER = FindMetaTable("Player")

function PLAYER:IsAFK()
  return GAMEMODE.Player:GetSharedGameVar(self, "afk", false) or self:GetNWBool("IsAFK", false)
end

function PLAYER:AFKTime()
  return self.afkTime
end

function PLAYER:AFKTimeReal()
  if not self.afkTime then return 0 end

  return math.abs(math.max(CurTime() - self.afkTime, 0))
end

PLAYER.TotalAFKTime = PLAYER.AFKTimeReal

if SERVER then
  util.AddNetworkString(tag)

  net.Receive(tag, function(_, ply)
    local is = net.ReadBool()
    --if not is and ply.isAFK2 then return end
    if ply.isAFK == is then return end
    ply.isAFK = is
    GAMEMODE.Player:SetSharedGameVar(ply, "afk", is)
    ply:SetNWBool("IsAFK", is)
    ply.afkTime = is and CurTime() - afk.AFKTime:GetInt() or nil
    hook.Run("AFK", ply, is)
    net.Start(tag)
    net.WriteUInt(ply:EntIndex(), 8)
    net.WriteBool(is)
    net.Broadcast()

    if is then
      Msg(ply:Nick() .. " [ " .. ply:RealName() .. " ] is AFK.\n")
    else
      Msg(ply:Nick() .. " [ " .. ply:RealName() .. " ] is no longer AFK.\n")
    end
  end)

  hook.Add("AFK", "AFKSound", function(ply, is)
    ply:EmitSound(not is and "replay/cameracontrolmodeentered.wav" or "replay/cameracontrolmodeexited.wav")
  end)
elseif CLIENT then
  afk.Mouse = {
    x = 0,
    y = 0
  }

  afk.Focus = system.HasFocus()
  afk.Is = false
  afk.Network = true

  hook.Add("Initialize", tag, function()
    afk.Start = true
  end)

  local lastsent

  local function Input()
    if not afk.When or not afk.Start then return end
    if lastsent and lastsent >= CurTime() then return end
    lastsent = CurTime() + 5
    afk.When = CurTime() + afk.AFKTime:GetInt()

    if afk.Is and afk.Network then
      chat.AddText(Color(100, 255, 100, 255), "Welcome back", Color(50, 200, 50, 255), "!", Color(255, 255, 255, 255), " You were away for ", Color(200, 200, 255, 255), string.NiceTime(_G.MYAFKTIME or 0), Color(100, 255, 100, 255), ".")
      net.Start(tag)
      net.WriteBool(false)
      net.SendToServer()
    end
    --afk.Is = false
  end

  hook.Add("StartCommand", tag, function(ply, cmd)
    if ply ~= LocalPlayer() or not afk.When or not afk.Start then return end
    local mouseMoved = (system.HasFocus() and (afk.Mouse.x ~= gui.MouseX() or afk.Mouse.y ~= gui.MouseY()) or false)

    if mouseMoved or cmd:GetMouseX() ~= 0 or cmd:GetMouseY() ~= 0 or cmd:GetButtons() ~= 0 or (afk.Focus == false and afk.Focus ~= system.HasFocus()) then
      Input()
    end

    if afk.When < CurTime() and not afk.Is then
      afk.Is = true

      if afk.Network then
        net.Start(tag)
        net.WriteBool(true)
        net.SendToServer()
      end
    end
  end, -2)

  hook.Add("KeyPress", tag, function()
    if not IsFirstTimePredicted() then return end
    Input()
  end, -2)

  hook.Add("KeyRelease", tag, function()
    if not IsFirstTimePredicted() then return end
    Input()
  end, -2)

  hook.Add("PlayerBindPress", tag, function()
    if not IsFirstTimePredicted() then return end
    Input()
  end, -2)

  local function getAFKtime()
    return math.abs(math.max(CurTime() - afk.When, 0))
  end

  net.Receive(tag, function()
    if not afk.Network then return end
    local ply = Entity(net.ReadUInt(8))
    local is = net.ReadBool()

    if IsValid(ply) and ply == LocalPlayer() then
      afk.Is = is
      afk.When = is and CurTime() - afk.AFKTime:GetInt() or nil
    else
      ply.isAFK = is
      ply.afkTime = is and CurTime() - afk.AFKTime:GetInt() or nil
    end

    hook.Run("AFK", ply, is)
  end)

  surface.CreateFont(tag, {
    font = "Roboto Condensed",
    size = 36,
    italic = true,
    weight = 800
  })

  surface.CreateFont(tag .. "Normal", {
    font = "Roboto Bk",
    size = 48,
    italic = false,
    weight = 800
  })

  local function plural(num)
    return ((num > 1 or num == 0) and "s" or "")
  end

  local function DrawTranslucentText(txt, x, y, a, col)
    surface.SetTextPos(x + 2, y + 2)
    surface.SetTextColor(Color(0, 0, 0, 127 * (a / 255)))
    surface.DrawText(txt)
    surface.SetTextPos(x, y)

    if col then
      surface.SetTextColor(Color(col.r, col.g, col.b, 190 * (a / 255)))
    else
      surface.SetTextColor(Color(255, 255, 255, 190 * (a / 255)))
    end

    surface.DrawText(txt)
  end

  local a = 0
  _G.MYAFKTIME = 0
  afk.Draw = CreateConVar("cl_afk_hud_draw", "1", {FCVAR_ARCHIVE}, "Should we draw the AFK HUD?")

  hook.Add("HUDPaint", tag, function()
    if not afk.Draw:GetBool() then return end

    if not afk.When then
      afk.When = CurTime() + afk.AFKTime:GetInt()
    end

    afk.Focus = system.HasFocus()

    if not afk.Is then
      a = 0

      return
    end

    a = math.Clamp(a + FrameTime() * 120, 0, 255)
    local AFKTime = getAFKtime()
    if AFKTime == 0 then return end
    --[[
        local h = math.floor(AFKTime / 60 / 60)
        local m = math.floor(AFKTime / 60 - h * 60)
        local s = math.floor(AFKTime - m * 60 - h * 60 * 60)

        local timeString = ""
        if h > 0 then
            timeString = timeString .. h .. " hour" .. plural(h) .. ", "
        end
        if m > 0 then
            timeString = timeString .. m .. " minute" .. plural(m) .. ", "
        end
        timeString = timeString .. s .. " second" .. plural(s)
        ]]
    _G.MYAFKTIME = AFKTime
    local timeString = string.NiceTime(AFKTime)
    surface.SetFont(tag)
    local txt = "You've been away for"
    local txtW, txtH = surface.GetTextSize(txt)
    surface.SetFont(tag .. "Normal")
    local timeW, timeH = surface.GetTextSize(timeString)
    local wH = txtH + timeH
    surface.SetDrawColor(Color(0, 0, 0, 127 * (a / 255)))
    surface.DrawRect(0, ScrH() * 0.5 * 0.5 - wH * 0.5 - txtH * 0.33, ScrW(), wH + txtH * 0.33 * 2 - 3)
    surface.SetFont(tag)
    DrawTranslucentText(txt, ScrW() / 2 - txtW / 2, ScrH() / 2 / 2 - wH / 2, a * 0.5)
    surface.SetFont(tag .. "Normal")
    DrawTranslucentText(timeString, ScrW() / 2 - timeW / 2, ScrH() / 2 / 2 - wH / 2 + txtH, a, Color(197, 167, 255))
  end)

  local afkrings_convar = CreateClientConVar("afkrings", "1")
  -- Uncomment for development
  local font_name = "afkrings_font" -- ..os.time()
  local rt_name = "afkrings_rt" -- ..os.time()

  surface.CreateFont(font_name, {
    font = "Roboto Thin",
    size = 55,
    weight = 800
  })

  --------------------------------------------------------------------------------
  -- MESH GENERATORS                                                            --
  --------------------------------------------------------------------------------
  local function generate_mesh_cylinder(sides, radius, height, offset, angle, flip)
    local offset = offset or Vector()
    local angle = angle or Angle()
    local points = {}

    for i = 1, sides do
      local normal = Vector(math.cos((i + 0.5) * (2 * math.pi / sides)), math.sin((i + 0.5) * (2 * math.pi / sides)), 0)

      if flip then
        normal = normal * -1
      end

      normal:Rotate(angle)
      local l_u = (i - 1) / (sides / 5)
      local r_u = (i) / (sides / 5)

      points[#points + 1] = {
        pos = Vector(math.cos(i * (2 * math.pi / sides)) * radius, math.sin(i * (2 * math.pi / sides)) * radius, 0),
        normal = normal,
        u = l_u,
        v = 1
      }

      points[#points + 1] = {
        pos = Vector(math.cos(i * (2 * math.pi / sides)) * radius, math.sin(i * (2 * math.pi / sides)) * radius, height),
        normal = normal,
        u = l_u,
        v = 0
      }

      points[#points + 1] = {
        pos = Vector(math.cos((i + 1) * (2 * math.pi / sides)) * radius, math.sin((i + 1) * (2 * math.pi / sides)) * radius, height),
        normal = normal,
        u = r_u,
        v = 0
      }

      points[#points + 1] = {
        pos = Vector(math.cos((i + 1) * (2 * math.pi / sides)) * radius, math.sin((i + 1) * (2 * math.pi / sides)) * radius, height),
        normal = normal,
        u = r_u,
        v = 0
      }

      points[#points + 1] = {
        pos = Vector(math.cos((i + 1) * (2 * math.pi / sides)) * radius, math.sin((i + 1) * (2 * math.pi / sides)) * radius, 0),
        normal = normal,
        u = r_u,
        v = 1
      }

      points[#points + 1] = {
        pos = Vector(math.cos(i * (2 * math.pi / sides)) * radius, math.sin(i * (2 * math.pi / sides)) * radius, 0),
        normal = normal,
        u = l_u,
        v = 1
      }
    end

    for k, v in pairs(points) do
      v.pos:Rotate(angle)
      v.pos = v.pos + offset
    end

    if flip then
      local tmp = points
      points = {}

      for i = #tmp, 1, -1 do
        points[#points + 1] = tmp[i]
      end
    end

    return points
  end

  local function generate_mesh_hollow_circle(sides, radius_inner, radius_outer, offset, angle)
    local offset = offset or Vector()
    local angle = angle or Angle()
    local points = {}

    for i = 1, sides do
      local normal = Vector(math.cos((i + 0.5) * (2 * math.pi / sides)), math.sin((i + 0.5) * (2 * math.pi / sides)), 0)
      normal:Rotate(angle)
      local l_u = (i - 1) / sides
      local r_u = (i) / sides

      points[#points + 1] = {
        pos = Vector(math.cos(i * (2 * math.pi / sides)) * radius_outer, math.sin(i * (2 * math.pi / sides)) * radius_outer, 0),
        normal = normal,
        u = l_u,
        v = 1
      }

      points[#points + 1] = {
        pos = Vector(math.cos(i * (2 * math.pi / sides)) * radius_inner, math.sin(i * (2 * math.pi / sides)) * radius_inner, 0),
        normal = normal,
        u = l_u,
        v = 0
      }

      points[#points + 1] = {
        pos = Vector(math.cos((i + 1) * (2 * math.pi / sides)) * radius_inner, math.sin((i + 1) * (2 * math.pi / sides)) * radius_inner, 0),
        normal = normal,
        u = r_u,
        v = 0
      }

      points[#points + 1] = {
        pos = Vector(math.cos((i + 1) * (2 * math.pi / sides)) * radius_inner, math.sin((i + 1) * (2 * math.pi / sides)) * radius_inner, 0),
        normal = normal,
        u = r_u,
        v = 0
      }

      points[#points + 1] = {
        pos = Vector(math.cos((i + 1) * (2 * math.pi / sides)) * radius_outer, math.sin((i + 1) * (2 * math.pi / sides)) * radius_outer, 0),
        normal = normal,
        u = r_u,
        v = 1
      }

      points[#points + 1] = {
        pos = Vector(math.cos(i * (2 * math.pi / sides)) * radius_outer, math.sin(i * (2 * math.pi / sides)) * radius_outer, 0),
        normal = normal,
        u = l_u,
        v = 1
      }
    end

    for k, v in pairs(points) do
      v.pos:Rotate(angle)
      v.pos = v.pos + offset
    end

    return points
  end

  function generate_mesh_ring(sides, radius_inner, radius_outer, height, offset, angle)
    local points = {}
    local offset = offset or Vector()
    local angle = angle or Angle()
    table.Add(points, generate_mesh_cylinder(sides, radius_inner, height, offset, angle, true))
    table.Add(points, generate_mesh_cylinder(sides, radius_outer, height, offset, angle))
    table.Add(points, generate_mesh_hollow_circle(sides, radius_inner, radius_outer, offset, Angle(0, 0, 180) + angle))
    table.Add(points, generate_mesh_hollow_circle(sides, radius_inner, radius_outer, offset + Vector(0, 0, height), angle))

    return points
  end

  --------------------------------------------------------------------------------
  -- Render Target                                                              --
  --------------------------------------------------------------------------------
  local rt_mat = CreateMaterial(rt_name, "UnlitGeneric", {
    ["$vertexalpha"] = 1
  })

  ------- Render AFK TEXT --------------------------------------------------------
  hook.Add("DrawMonitors", "AFKRings", function()
    hook.Remove("DrawMonitors", "AFKRings")
    local rt_tex = GetRenderTarget(rt_name, 256, 64, true)
    rt_mat:SetTexture("$basetexture", rt_tex)
    render.PushRenderTarget(rt_tex)
    render.SetViewPort(0, 0, 256, 64)
    render.OverrideAlphaWriteEnable(true, true)
    cam.Start2D()
    render.Clear(0, 0, 0, 150)
    surface.SetFont(font_name)
    surface.SetTextColor(Color(255, 255, 255))
    surface.SetTextPos(30, -1)
    surface.DrawText("AFK")
    cam.End2D()
    render.OverrideAlphaWriteEnable(false)
    render.PopRenderTarget()
  end)

  --------------------------------------------------------------------------------
  -- AFK RING RENDER                                                            --
  --------------------------------------------------------------------------------
  ------- Generate Meshes --------------------------------------------------------
  local mesh_rings = Mesh()
  local mesh_text = Mesh()
  local mesh_points = {}
  -- Rings
  table.Add(mesh_points, generate_mesh_ring(25, 34, 35, 1, Vector(0, 0, -5)))
  table.Add(mesh_points, generate_mesh_ring(25, 34, 35, 1, Vector(0, 0, 5)))
  mesh_rings:BuildFromTriangles(mesh_points)
  mesh_points = {}
  -- Text Cylinder
  table.Add(mesh_points, generate_mesh_cylinder(40, 34.5, 10, Vector(0, 0, -5), nil, true))
  table.Add(mesh_points, generate_mesh_cylinder(40, 34.5, 10, Vector(0, 0, -5)))
  mesh_text:BuildFromTriangles(mesh_points)
  ------- Render The AFK Rings ---------------------------------------------------
  local afk_players = {}

  timer.Create("AFKRings_Update", 1, 0, function()
    afk_players = {}
    if afkrings_convar:GetInt() == 0 then return end
    -- -- hide if we're watching something
    if MediaPlayer and MediaPlayer.GetAll and #MediaPlayer.GetAll() > 0 then return end

    if PlayX then
      for _, instance in pairs(PlayX.GetInstances()) do
        if instance.IsPlaying then return end
      end
    end

    for _, ply in pairs(player.GetAll()) do
      if not ply:IsAFK() then continue end
      -- print("AFK")
      afk_players[#afk_players + 1] = ply
    end
  end)

  local convar_distance = CreateClientConVar("afkrings_distance", "256")
  local ring_mat = Material("color")

  hook.Add("PostDrawOpaqueRenderables", "AFKRings", function()
    if #afk_players == 0 then return end
    local distance = convar_distance:GetInt()
    local loc_pos = LocalPlayer():EyePos()
    local m_rings = Matrix()
    local ppos = LocalPlayer():GetPos()
    render.OverrideDepthEnable(true, true)

    for _, ply in ipairs(afk_players) do
      if not ply:IsValid() then continue end
      local ply_pos = ply:GetPos()
      if (ply_pos:Distance(ppos) > distance and ply ~= LocalPlayer()) or ply:IsDormant() or not ply:IsAFK() or ply:IsUncon() or ply:GetColor().a < 255 or IsValid(ply:GetVehicle()) or (HnS and HnS.InGame and HnS.InGame(ply)) or (ply_pos:DistToSqr(loc_pos) > (2000) ^ 2) then continue end
      local bounds_min, bounds_max = ply:WorldSpaceAABB()
      local bounds_scale = bounds_max - bounds_min
      local ring_pos = ply_pos + Vector(0, 0, (bounds_scale.z) / math.Clamp(2 - math.abs(math.sin((RealTime()) * 0.65)), 1.5, 2))

      if not ply:Alive() then
        local rag = ply:GetRagdollEntity()
        if not IsValid(rag) then continue end
        ring_pos = rag:GetPos() + Vector(0, 0, (bounds_scale.z) / math.Clamp(2 - math.abs(math.sin((RealTime()) * 0.65)), 1.5, 2))
      end

      m_rings:Identity()
      m_rings:Translate(ring_pos)
      -- Rings
      cam.PushModelMatrix(m_rings)
      render.SetMaterial(ring_mat)
      mesh_rings:Draw()
      cam.PopModelMatrix()
      m_rings:Rotate(Angle(0, -RealTime() * 30, 0))
      -- Text Cylinder
      cam.PushModelMatrix(m_rings)
      render.SetMaterial(rt_mat)
      mesh_text:Draw()
      cam.PopModelMatrix()
    end

    render.OverrideDepthEnable(false)
  end)
end