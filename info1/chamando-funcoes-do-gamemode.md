---
description: Funções bases do gamemode
---

# Chamando funções do gamemode

## Chamando funções do gamemode em diferentes reinos.

Funções da base do gamemode são armazenadas na tabela do gamemode \(veja na wiki: GM Structure\)  
Portanto, funções podem pertencer a reinos específicos ou shared, mas obedecem a mesma regra na hora de se chamadas:

```lua
-- Registrando a função module.function :
GM.Module:Function()

-- Chamando a função module.function: 
GAMEMODE.Module:Function()
```

{% hint style="info" %}
 Se você está chamando uma função base dentro de outra função base, duas novas opções são abertas:
{% endhint %}

```lua
-- "self:" Caso você esteja chamando uma função do mesmo módulo
self:Function()
-- ex: Obtendo o peso do inventário de um jogador (módulo inventário)
self:GetCurWeight( pPlayer )

-- "GM.Module" Caso você esteja chamando uma função do mesmo reino, em um arquivo que contenha ( GM = GM or GAMEMODE or {} ) 
GM.Module:Function()
-- ex: Obtendo o peso do inventário de um jogador (módulo inventário)
GM.Inv:GetCurWeight( pPlayer )
```



