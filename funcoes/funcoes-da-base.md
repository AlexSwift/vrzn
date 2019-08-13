---
description: Funções úteis da base do gamemode.
---

# Funções da base

## Definindo variáveis \(SharedGameVars\)

> GameVar's devem ser registradas no cliente e no servidor utilizando a hook GamemodeDefinedGameVars  
> Os valores do registro devem ser iguais para funcionar;  
> Não defina variáveis em arquivos Shared;

{% code-tabs %}
{% code-tabs-item title="sv/cl\_player.lua + sv/cl\_character.lua" %}
```lua
CLIENT/SERVER | GM.Player:DefineGameVar( str NomeDaVariável, qualquer Valor, string Tipo )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% hint style="warning" %}
A definição da varável segue os padrões da biblioteca Net.  
"UInt{x}" Onde X é a contagem de bits.  
"String"  
"Table"  
"Float"
{% endhint %}

> Depois de registrada, GameVar's podem ser chamadas e editadas em qualquer Reino.

#### Exemplo:

{% code-tabs %}
{% code-tabs-item title="sv\_character.lua + cl\_character.lua" %}
```lua
hook.Add( "GamemodeDefineGameVars", "CustomName", function()
    GAMEMODE.Player:DefineGameVar( "money_wallet", 0, "UInt32" )
end)
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% page-ref page="../hooks/gamemode.md" %}

## Obtendo e alterando valor de variáveis \(SharedGameVars\)

#### Obtendo valor.

```lua
SHARED | GAMEMODE.Player:GetSharedGameVar( pPlayer, string NomeDaVarável, qualquer Fallback )
```

{% hint style="info" %}
Fallback é o valor que será definido pra variável caso ela retorne 0 ou nulo.
{% endhint %}

#### 

#### Obtendo tipo do valor.

```lua
SHARED | GAMEMODE.Player:GetSharedGameVarType( string NomeDaVariável )
```

| Retorno | Tipo |
| :--- | :--- |
| Classificação da variável | String |

#### 

#### Defnindo um valor/Alterando valor existente.

```lua
SHARED | GAMEMODE.Player:SetSharedGameVar( pPlayer, string Variável, string Tipo )
```

