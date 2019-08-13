---
description: Retorna array com todos os itens registrados e válidados pelo servidor.
---

# tbl\_RegisteredItems

## Exemplo

```lua
Munição de calibre 7.62x51mm :
                CanDrop =       true
                Cat     =       Munição
                Desc    =       Munição para armas calibre 7.62x51mm
                DropClass       =       cw_ammo_762x51
                F4      =       true
                HealthOverride  =       3000
                Model   =       models/Items/BoxMRounds.mdl
                Name    =        Munição de calibre 7.62x51mm
                Type    =       type_ammo
                Value   =       666
                Volume  =       0
                Weight  =       0.4
 Munição de calibre.32 S&W:
                CanDrop =       true
                Cat     =       Munição
                Desc    =       Munição para armas calibre .32 ACP
                DropClass       =       doi_atow_ammo_32acp
                F4      =       true
                HealthOverride  =       3000
                Model   =       models/Items/BoxSRounds.mdl
                Name    =        Munição de calibre.32 S&W
                Type    =       type_ammo
                Value   =       666
                Volume  =       0
                Weight  =       0.3
Backpack 1 (Skin 1):
                CanDrop =       true
                CanEquip        =       true
                ClothingMenuCat =       Bags
                ClothingMenuItemName    =       Backpack 1
                ClothingMenuPrice       =       1000
                Desc    =       A backpack.
                EquipBoostCarryVolume   =       150
                EquipBoostCarryWeight   =       100
                EquipSlot       =       Back
                Model   =       models/modified/backpack_1.mdl
                Name    =       Backpack 1 (Skin 1)
                PacOutfit       =       backpack1_0
                Skin    =       0
                Stats   =       +100 Inventory Weight
+150 Inventory Volume
                Type    =       type_clothing
                Volume  =       1
                Weight  =       1
Backpack 1 (Skin 2):
                CanDrop =       true
                CanEquip        =       true
                ClothingMenuCat =       Bags
                ClothingMenuItemName    =       Backpack 1
                ClothingMenuPrice       =       1000
                Desc    =       A backpack.
                EquipBoostCarryVolume   =       150
                EquipBoostCarryWeight   =       100
                EquipSlot       =       Back
                Model   =       models/modified/backpack_1.mdl
                Name    =       Backpack 1 (Skin 2)
                PacOutfit       =       backpack1_1
                Skin    =       1
                Stats   =       +100 Inventory Weight
+150 Inventory Volume
                Type    =       type_clothing
                Volume  =       1
                Weight  =       1
Backpack 1 (Skin 3):
                CanDrop =       true
                CanEquip        =       true
                ClothingMenuCat =       Bags
                ClothingMenuItemName    =       Backpack 1
                ClothingMenuPrice       =       1000
                Desc    =       A backpack.
                EquipBoostCarryVolume   =       150
                EquipBoostCarryWeight   =       100
                EquipSlot       =       Back
                Model   =       models/modified/backpack_1.mdl
                Name    =       Backpack 1 (Skin 3)
                PacOutfit       =       backpack1_2
                Skin    =       2
                Stats   =       +100 Inventory Weight
+150 Inventory Volume
                Type    =       type_clothing
                Volume  =       1
                Weight  =       1
```

{% hint style="info" %}
Evite imprimir ou enviar por network essa tabela, já que o conteúdo dela é extenso \(Todas as tabelas, de todos os itens\)
{% endhint %}

