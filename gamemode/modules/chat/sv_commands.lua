
-- local function ChatDropMoney( ply, text )
--     -- //// Do /commands privatly, !commands publicly //
--     --     local _cmd = "dropmoney";
--     --     local _bSlash = string.StartWith( text, "/" .. _cmd )
--     --     local _bExclaim = string.StartWith( text, "!" .. _cmd )
--     --     local _argstbl = string.Explode( " ", text )
    
--     --     if ( _bSlash || _bExclaim ) then
--     --         // Heres where you can call your data.
--     --         local _arg = _argstbl[2];
            
--     --         local money = tonumber(_arg, 10)
--     --         GM.Inv:PlayerDropMoney( ply, money, true )
    
--     --         return"";
--     --     end
--     end
--     hook.Add("PlayerSay", "vrzn.ChatCommands", ChatMakeWanted )