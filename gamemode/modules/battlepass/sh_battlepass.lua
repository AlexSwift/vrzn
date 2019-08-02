PrecacheParticleSystem("bday_confetti")
function Confettis( ply )
	local HeadIndex = ply:LookupBone( "ValveBiped.Bip01_Head1" )  
        local HeadPos, HeadAng = ply:GetBonePosition( HeadIndex )
        local effectdata = EffectData()
        effectdata:SetOrigin( HeadPos )
        effectdata:SetAngles( HeadAng )
        -- util.Effect( "HelicopterMegaBomb", effectdata, true )
        -- ParticleEffect("HelicopterMegaBomb",HeadPos,HeadAng,nil)
        -- ply:EmitSound("misc/happy_birthday.wav")
end
        
hook.Add("ScalePlayerDamage","Confettis",Confettis)

concommand.Add("confeti", Confettis )








BattlePass = {}
BattlePass.Config = {}
BattlePass.Season = {}
BattlePass.Reward = {}
BattlePass.Achievement = {}
BattlePass.AchievementList = {}

BattlePass.RarityColor = {}
BattlePass.RarityColor["Normal"] = Color(255,255,255,200)
BattlePass.RarityColor["Raro"] = Color(67,204,248,200)
BattlePass.RarityColor["Épico"] = Color(175,91,216,200)
BattlePass.RarityColor["Lendário"] = Color(238,176,0,200)
BattlePass.RarityColor["Limitado"] = Color(182,42,49,200)

BattlePass.Config["icon"] = Material("materials/vgui/sp/season.png");
BattlePass.Config["MaxLevel"] = 7;
BattlePass.Config["VipRanks"] = {
        founder = true,
        superadmin = true,
        topazio = true, 
        safira = true,
        ruby = true
}
BattlePass.Season.Number = 1
BattlePass.Season[1] = "Aprendizes de Gugaep";
BattlePass.Season[2] = "Evento do Tartaruga";
BattlePass.Season[3] = "Questão de ética";

        
               
        
BattlePass.Reward[1] = {
       Vip = { ID = 1, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/backpack1-adidas-blue.png") },
       Free = { ID = 2, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/backpack.png")  }
}

BattlePass.Reward[2] = {
        Vip = { ID = 3, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/bone-adidas-blue.png") },
 }

 BattlePass.Reward[3] = {
        Vip = { ID = 4, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/backpack1-adidas-white.png") },
        Free = { ID = 5, Name = "Barra de Ferro", Rarity = "Raro" ,  Image = Material("materials/awesome/battlepass/backpack1-2.png")  }
}

 BattlePass.Reward[4] = {
        Vip = { ID = 6, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/bone-adidas-white.png") },
        Free = { ID = 7, Name = "Barra de Ferro", Rarity = "Raro" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }

 }

 BattlePass.Reward[5] = {
        Vip = { ID = 8, Name = "Barra de Ferro", Rarity = "Limitado" ,  Image = Material("materials/awesome/battlepass/backpack1-ahegao.png") },
 }

 BattlePass.Reward[6] = {
        Vip = { ID = 9, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
 }
 
 BattlePass.Reward[7] = {
        Vip = { ID = 10, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
        Free = { ID = 11, Name = "Barra de Ferro", Rarity = "Raro" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
 }

 BattlePass.Reward[8] = {
       Vip = { ID = 12, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
}

BattlePass.Reward[9] = {
       Vip = { ID = 13, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 14, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}
 

BattlePass.Reward[10] = {
       Vip = { ID = 15, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 16, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[11] = {
       Vip = { ID = 17, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 18, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[12] = {
       Vip = { ID = 19, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 20, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[13] = {
       Vip = { ID = 21, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 22, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[14] = {
       Vip = { ID = 23, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 24, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[15] = {
       Vip = { ID = 25, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 26, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[16] = {
       Vip = { ID = 27, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 28, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[17] = {
       Vip = { ID = 29, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 30, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[18] = {
       Vip = { ID = 31, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 32, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[19] = {
       Vip = { ID = 33, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 34, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}

BattlePass.Reward[20] = {
       Vip = { ID = 35, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png") },
       Free = { ID = 36, Name = "Barra de Ferro", Rarity = "Normal" ,  Image = Material("materials/awesome/battlepass/barra-de-ouro.png")  }
}



































