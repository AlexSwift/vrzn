-- PrintTable( GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ) )
local function createFrame(classname, parent, x, y, w, h)
	frame = vgui.Create(classname, parent);
	frame:SetPos(x, y);
	frame:SetSize(w, h);

	if classname == "DFrame" then
		frame:SetTitle("");
		frame:ShowCloseButton(false);
		frame:SetDraggable(false);
	else
		frame:SetAllowNonAsciiCharacters(true);
	end

	return frame;
end



local function rem(multiply)
	if multiply == nil then
		multiply = 1;
	end
	return multiply * Vrzn.theme.rem;
end


local function init()

	local sentence;


	local sustain = 10;
	local length = 2.5;

	local w = rem(29)
	local h = rem(15)
	local x = rem()
	local y = ScrH() - h - rem(9)

	hook.Add("HUDPaint", "chatPaint", function()

		local w = rem(29)
		local h = rem(15)
		local x = rem()
		local y = ScrH() - h - rem(9)

		if Vrzn.BottomLeftHeight then
			y = ScrH() - h - Vrzn.BottomLeftHeight - rem();
		end

		customChat.window:SetPos(x, y)
		customChat.window:SetSize(w, h)

		customChat.passive:SetSize(customChat.window:GetWide() - rem(), h - rem(3.5))
		customChat.passive:SetPos(rem(.5), rem(.5))

		customChat.container:StretchToParent(0, 0, 0, 0);


		customChat.active:SetSize(customChat.window:GetWide() - rem(), h - rem(3.5))
		customChat.active:SetPos(rem(.5), rem(.5))

		customChat.textbox:SetPos(rem(.5), h - rem(2))
		customChat.textbox:SetSize(w - rem(), rem(1.5))
	end)

	if customChat then
		customChat.window:Remove()
	end

	customChat = {}

	customChat.window = createFrame("DFrame");
	customChat.window.Paint = nil;

	customChat.passive = createFrame("RichText", customChat.window);
	customChat.passive:SetVerticalScrollbarEnabled(false)
	customChat.passive.Paint = function(self, w, h)
		self:DrawTextEntryText(Vrzn.theme.txt, Vrzn.theme.txtAlternative, Vrzn.theme.txt);
		self:SetFontInternal("ChatFont");
	end

	customChat.container = createFrame("DPanel", customChat.window);
	customChat.container:SetAlpha(0);
	customChat.container.Paint = function(self, w, h)
		draw.RoundedBox(Vrzn.theme.round, 0, 0, w, h, Vrzn.theme.bg);
		draw.RoundedBoxEx(Vrzn.theme.round, 0, h - rem(2.5), w, rem(2.5), Vrzn.theme.bgAlternative, false, false, true, true)
		-- draw.RoundedBox(Vrzn.theme.round, 0, h - rem(2.5), w, rem(2.5), Vrzn.theme.bgAlternative);
	end

	customChat.active = createFrame("RichText", customChat.container);
	customChat.active.Paint = function(self, w, h)
		self:DrawTextEntryText(Vrzn.theme.txt, Vrzn.theme.txtAlternative, Vrzn.theme.txt);
		self:SetFontInternal("ChatFont");
	end

	customChat.textbox = createFrame("DTextEntry", customChat.container);
	customChat.textbox.Paint = function(self, w, h)
		self:DrawTextEntryText(Vrzn.theme.txt, Vrzn.theme.txtAlternative, Vrzn.theme.txt);
		self:SetFontInternal("ChatFont");
		if self:GetValue() == "" then
			if not sentence then
				sentence = chatQuotes[math.random(#chatQuotes)];
			end
			draw.SimpleText(sentence, "ChatFont", 3, rem(.75), Vrzn.theme.txtAlternative, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			sentence = nil;
		end
	end

	hook.Add( "PlayerBindPress", "overrideChatbind", function( ply, bind, pressed )
		
		if bind == "messagemode" then
			local bTeam = false;
		elseif bind == "messagemode2" then
			bTeam = true;
		else
			return;
		end

		customChat.openChatbox(true);

		return true 
	end )

	hook.Add( "ChatText", "serverNotifications", function(index, name, text, type)
		if type == "joinleave" or type == "none" then
			appendToChat("\n" .. text);
		end
	end)

	hook.Add( "HUDShouldDraw", "noMoreDefault", function(name)
		if name == "CHudChat" then
			return false;
		end
	end)

	function appendToChat(obj)
		if type(obj) == "table" then 
			customChat.active:InsertColorChange( obj.r, obj.g, obj.b, 255 );
			customChat.passive:InsertColorChange( obj.r, obj.g, obj.b, 255 );
		elseif type(obj) == "string" then 
			customChat.active:AppendText(obj);
			customChat.passive:AppendText(obj);
			customChat.passive:InsertFade(sustain, length);
		end
	end

	if not preventDoubleUpdateSpam then
		preventDoubleUpdateSpam = true;
		oldAddText = chat.AddText;
	end
	function chat.AddText(...)
		local args = {...} 
		

		appendToChat("\n");

		for _, obj in pairs( args ) do
			if type(obj) == "table" or type(obj) == "string" then 
				appendToChat(obj);
			elseif obj:IsPlayer() then
				local col = GAMEMODE.Jobs:GetPlayerJob( obj ).TeamColor; 
				appendToChat(serverguard.ranks.stored[obj:GetUserGroup()].color);
				appendToChat("[ ".. serverguard.ranks.stored[obj:GetUserGroup()].name .. " ] ");
				appendToChat(col);
				appendToChat(obj:Nick());
			end
		end


		oldAddText(...);
		
	end

	function autotypePlayerName( str )
	 
		local LastWord = string.match( str, "%a+$" );
	 
		if (LastWord == nil) then
			return str;
		end
	 
		playerlist = player.GetAll()
	 
		for k, v in pairs( playerlist ) do

			local nickname = v:Nick()

			if string.len(LastWord) < string.len(nickname) && string.find( string.lower(nickname), string.lower(LastWord) ) == 1 then
				str = string.sub( str, 1, (string.len(LastWord) * -1) - 1)
				str = str .. nickname
				return str
			end

		end
	 
		return str;
	 
	end

	customChat.textbox.OnKeyCodeTyped = function( self, code )
		if code == KEY_ESCAPE then

			customChat.openChatbox(false)
			gui.HideGameUI()
		elseif code == KEY_ENTER then

			if string.Trim( self:GetText() ) != "" then
				LocalPlayer():ConCommand( [[say "]] .. self:GetText() .. [["]] )
			end

			customChat.openChatbox(false)
		elseif code == KEY_TAB then

			if EvolveSuggestions and ( string.match( self:GetText(), "^[/!][^ ]*$" ) and #EvolveSuggestions > 0 ) then
				self:SetText( EvolveSuggestions[1].ChatCommand .. " " );
			else
				self:SetText( autotypePlayerName( self:GetText() ) );
			end

			timer.Simple(.002, function() self:RequestFocus() end)
		end
	end

	customChat.textbox.OnTextChanged = function( self )
		if self and self.GetText then 
			gamemode.Call("ChatTextChanged", self:GetText() or "")
		end
	end

	function customChat.openChatbox(shouldOpen)

		customChat.window:SetMouseInputEnabled(shouldOpen);
		customChat.window:SetKeyboardInputEnabled(shouldOpen);
		gui.EnableScreenClicker(shouldOpen);
		customChat.active:SetVerticalScrollbarEnabled(shouldOpen);

		if shouldOpen then

			customChat.window:MakePopup();
			customChat.textbox:RequestFocus();

			gamemode.Call("StartChat");
		
			customChat.container:AlphaTo(255, .2);
			customChat.textbox:SetAlpha(255);
		else

			gamemode.Call("FinishChat");

			gamemode.Call("ChatTextChanged", "");


			customChat.textbox:SetText("");
			customChat.active:GotoTextEnd();
			
			customChat.container:AlphaTo(0, .2);
			customChat.textbox:SetAlpha(0);
			sentence = nil;
		end
	end
end


hook.Add("Initialize", "chatInit", init)
if GAMEMODE then
	init()
end