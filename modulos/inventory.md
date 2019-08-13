---
description: Módulo de itens e inventário.
---

# INVENTORY

{% hint style="warning" %}
Item públicos são itens que mesmo possuindo um dono, podem ser pegos por outros jogadores.
{% endhint %}

## Funções do jogador.

#### Obter tabela de um item.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua + scl\_inventory.lua" %}
```lua
SERVER/CLIENT | GAMEMODE.Inv:GetItem( string NomeDoItem )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| tbl\_Item | Tabela |

{% page-ref page="../valores/tbl\_item.md" %}

#### 

#### Validar Itens de job.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua" %}
```lua
SERVER | GAMEMODE.Inv:ValidateJobItems( pPlayer )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% hint style="danger" %}
Essa função vai remover qualquer item ou arma equipada do personagem caso não pertençam ao job atual do jogador.
{% endhint %}

#### 

#### Verificar se o jogador possui um item.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
SERVER/CLIENT | GAMEMODE.Inv:PlayerHasItem( string NomeDoItem, inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Existência do item | Lógico |

#### 

#### Obter quantas unidades de um item o jogador possui.

{% code-tabs %}
{% code-tabs-item title="cl\_inventory.lua + sv\_inventory.lua" %}
```lua
SERVER/CLIENT | GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, string NomeDoItem )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Quantidade | Inteiro |

#### 

#### Dar item a um jogador.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua " %}
```lua
SERVER | GAMEMODE.Inv:GivePlayerItem( pPlayer, string NomeDoItem, inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% hint style="warning" %}
Essa função já possui um verificador de requisitos.
{% endhint %}

| Retorno | Tipo |
| :--- | :--- |
| Inventário cheio/Persongem morto | Lógico Falso |
| Inventário livre, item entregue | Lógico Verdadeiro |

> A função só retornará falso caso o inventário esteja cheio, ou o personagem esteja morto.  
> Se por algum motivo quiser fazer um verificador fora desta função, temos aqui um exemplo de verificador.

> ```lua
> if not pPlayer:Alive() then return false end
> local inv = pPlayer:GetInventory()
> if not inv then return false end
>
> local itemData = self:GetItem( string NomeDoItem )
> if not itemData then return false end
>
> intAmount = intAmount or 1
> local curWeight = self:ComputeWeightAndVolume( inv )
> local addWeight = itemData.Weight *intAmount
> local maxWeight = self:ComputePlayerInventorySize( pPlayer )
>
> if curWeight + addWeight > maxWeight then
>     pPlayer:AddNote( "Você já está carregando o seu limite de itens!" )
>     return false
> end
> ```

#### 

#### Remover item do jogador.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua" %}
```lua
SERVER | GAMEMODE.Inv:TakePlayerItem( pPlayer, string NomeDoItem, inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Item não possuído/não removido | Lógico Falso |
| Item Removido | Lógico Verdadeiro |

#### Forçar jogador a dropar um item.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua" %}
```lua
SERVER | GAMEMODE.Inv:PlayerDropItem( pPlayer, string NomeDoItem, inteiro Quantidade
, lógico ItemPublico? )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Item não possuído/não removido | Lógico Falso |
| Item dropado | Lógico Verdadeiro |

{% hint style="success" %}
Essa função já possui verificador de requisitos.  
O jogador não pode estar dentro de um carro.  
O jogador precisa ter o item  
O jogador precisa estar com o limite de itens dropados livre
{% endhint %}

#### 

#### Remover itens ilegais do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua" %}
```lua
SERVER | GAMEMODE.Inv:RemoveIllegalItems( pPlayer )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

## Funções do servidor.

#### Obter todos os itens registrados no servidor.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua + cl\_inventory.lua" %}
```lua
SERVER/CLIENT | GAMEMODE.Inv:GetItems()
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| tbl\_RegisteredItems | Tabela |

{% hint style="danger" %}
Não passe essa tabela para o jogador através de network sob nenhuma hipótese, já que a tabela é imensa isso faria o cliente travar.
{% endhint %}

{% page-ref page="../valores/tbl\_registereditems.md" %}

#### 

#### Verificar validade de um item.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua + cl\_inventory.lua" %}
```lua
GAMEMODE.Inv:ValidItem( string NomeDoItem )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Validade do item | Lógico |

#### 

#### Dropar um item no mapa.

{% code-tabs %}
{% code-tabs-item title="sv\_inventory.lua" %}
```lua
SERVER | GAMEMODE.Inv:MakeItemDrop( pPlayer Dono, string NomeDoItem, inteiro Quantidade, ItemPublico? )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Possível dropar | Lógico |

{% hint style="info" %}
A diferença entra MakeItemDrop e a função de drop do player, é que aqui o jogador não precisa ter o item para que ele spawne.  
Essa função já possui um verificador interno.  
O lugar precisa estar vazio.  
O Dono do item precisa estar vivo.
{% endhint %}



