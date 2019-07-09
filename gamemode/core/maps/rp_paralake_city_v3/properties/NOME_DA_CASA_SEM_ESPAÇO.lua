local Prop = {}
Prop.Name = "NOME DA CASA"
Prop.Cat = "House"
Prop.Price = 340 -- preço pode deixar esse mesmo, depois a gente muda.
Prop.Doors = {
	Vector( 10675, -4170, 149 ), -- COLA AQUI O BAGULHO QUE SAI NO CONSOLE (APAGA ESSE EXEMPLO ANTES)
}

GM.Property:Register( Prop )