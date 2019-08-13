---
description: >-
  O Player no gamemode é identificado como um jogador que já selecionou um
  personagem (Exceto em contexto de Draw/Think)
---

# PLAYER

### Funções monetárias

#### Obter dinheiro da carteira do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
SERVER | pPlayer:GetMoney( )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Quantia | Inteiro |

#### 

#### Obter dinheiro no banco do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
CLIENT/SERVER | pPlayer:GetMoney( )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Quantia | Inteiro |

#### 

#### Adicionar dinheiro a carteira do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua" %}
```lua
SERVER | pPlayer:AddMoney( inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

#### 

#### Retirar dinheiro da carteira do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua" %}
```lua
SERVER | pPlayer:TakeMoney( inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% hint style="info" %}
Você também pode remover dinheiro utilizando um valor negativo em AddMoney\( \)
{% endhint %}

#### 

#### Adicionar dinheiro ao banco do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua" %}
```lua
SERVER | pPlayer:AddBankMoney( inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

#### 

#### Remover dinheiro do banco do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua" %}
```lua
SERVER | pPlayer:TakeBankMoney( inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

#### 

#### Verificar se o jogador pode pagar um valor \(Com dinheiro da carteira\).

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
SERVER/CLIENT | pPlayer:CanAfford( inteiro Quantidade )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| Resposta | Lógico |

#### 

## Funções de inventário.

#### Obter inventário do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
SERVER/CLIENT | pPlayer:GetInventory()
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| tbl\_Items | Tabela |

{% page-ref page="../valores/tbl\_items.md" %}

#### 

#### Substituir inventário do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua" %}
```lua
SERVER | pPlayer:SetInventory( tabela Itens )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% hint style="info" %}
Isso vai substituir o inventário do personagem completamente.  
Se seu objetivo é adicionar ou remover um item específico, verifique o Módulo de inventário.
{% endhint %}

{% page-ref page="inventory.md" %}

#### 

#### Obter equipamento do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
SERVER/CLIENT | pPlayer:GetEquipment()
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| tbl\_Equipment | Tabela |

{% page-ref page="../valores/tbl\_equipment.md" %}

#### 

## Funções de jogador.

#### Obter informações do personagem.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua" %}
```lua
SERVER | pPlayer:GetCharacter()
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Retorno | Tipo |
| :--- | :--- |
| tbl\_CharData | Tabela \(Banco de dados\) |

{% hint style="info" %}
Essa função apenas chama uma função do módulo CHARACTER usando META:
{% endhint %}

#### 

#### Obter ID do Personagem

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_player.lua" %}
```lua
SERVER/CLIENT | pPlayer:GetCharacterID()
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Resposta | Tipo |
| :--- | :--- |
| ID Personagem | Inteiro |

{% hint style="info" %}
Essa função apenas chama outra função do módulo CHARACTER usando META:
{% endhint %}

#### 

#### Chamar notificação na tela do cliente.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_hud.lua" %}
```lua
SERVER | pPlayer:AddNote( string Texto, inteiro Ícone, inteiro Tempo )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| Ícone | Tipo |
| :--- | :--- |
| 0 | Alerta |
| 1 | Erro |
| 2 | Atualização |
| 3 | Dica |
| 4 | Tesoura |
| 5 | Branco |

![Notifica&#xE7;&#xF5;es teste com seus respectivos &#xED;cones](../.gitbook/assets/code_jhur2yhews.png)

{% hint style="info" %}
Essa função também está disponível no módulo HUD, para CLIENT SIDE
{% endhint %}

{% page-ref page="hud.md" %}

