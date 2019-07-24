local open = false

function GM:ShowSpare2(ply)
    ply:ConCommand("open_f4_menu")
end

function AddNoteAll(ply, msg)
    -- ply:AddNote()
end

function GM:ShowTeam(ply)
    ply:ConCommand("open_f2_menu")
end

-- concommand.Add("radial door", function())