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
| Resposta | boleano |

#### 

#### Chamar notificação na tela do cliente.

{% code-tabs %}
{% code-tabs-item title="sv\_player.lua + cl\_hud.lua" %}
```lua
SERVER | pPlayer:AddNote( string Texto, inteiro Ícone, inteiro Tempo )
```
{% endcode-tabs-item %}
{% endcode-tabs %}

| ID | Tipo |
| :--- | :--- |
| 0 | Sem ícone |
| 1 | Alerta |
| 2 | Sucesso |
| 3 | Erro |
| 4 | Tesoura |
| 5 | Atualização |

