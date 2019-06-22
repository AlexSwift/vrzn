--[[
	Name: map_props.lua
	For: Project UnrealRP
	By: AndrewTech	
]]--

local MapProp = {}
MapProp.ID = "electronics_store"
MapProp.m_tblSpawn = {
	{ mdl = 'Model', pos = Vector('Pos'), ang = Angle('Angle'), },
    { mdl = 'models/props_phx/rt_screen.mdl', pos = Vector('9431.5186 10107.126 68.0018'), ang = Angle('-0 -180 -0'), },
    { mdl = 'models/props_phx/rt_screen.mdl', pos = Vector('9431.5186 10022.1631 68.0018'), ang = Angle('-0 180 0'), },
    { mdl = 'models/props_phx/rt_screen.mdl', pos = Vector('9431.5186 9937.2002 68.0018'), ang = Angle('-0 -180 -0'), },
    { mdl = 'models/props_phx/rt_screen.mdl', pos = Vector('9431.5186 9852.2373 68.0018'), ang = Angle('-0 -180 0'), },
    { mdl = 'models/props/cs_office/vending_machine.mdl', pos = Vector('9413.6406 9684.7275 8.4495'), ang = Angle('0.1206 -89.8346 0.0005'), },
    { mdl = 'models/props/cs_office/plant01.mdl', pos = Vector('9008.9805 9639.1992 7.7086'), ang = Angle('-0.063 61.0935 -0.0659'), },
    { mdl = 'models/props_c17/furnituretable003a.mdl', pos = Vector('9016.6328 9736.5439 18.9033'), ang = Angle('-0 0.0001 -0'), },
    { mdl = 'models/props_lab/monitor01a.mdl', pos = Vector('9010.6758 9735.8799 42.8419'), ang = Angle('-0.1141 1.1831 -0.0071'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9011.9961 9839.4648 26.6429'), ang = Angle('-0.0745 0.0368 -0.0031'), },
    { mdl = 'models/props_lab/monitor02.mdl', pos = Vector('9017.8584 9839.3555 45.6527'), ang = Angle('-0.7366 -1.0281 -0.5698'), },
    { mdl = 'models/props_c17/furnituretable003a.mdl', pos = Vector('9017.1348 9948.0684 18.9425'), ang = Angle('0.0292 -0.2597 -0.0033'), },
    { mdl = 'models/props_lab/monitor01b.mdl', pos = Vector('9019.5918 9947.4238 35.5257'), ang = Angle('-7.3053 -1.6821 -0.1967'), },
    { mdl = 'models/props/cs_office/computer_mouse.mdl', pos = Vector('9018.8135 9855.9766 45.783'), ang = Angle('-0.0519 1.1534 -0.0058'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9195.2227 9946.5098 12.8815'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9195.1309 9913.9434 12.8815'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9195.0391 9881.377 12.8815'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9194.9473 9848.8105 12.8815'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9194.8555 9816.2441 12.8815'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9227.4219 9816.1523 12.8839'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9227.5137 9848.7188 12.8839'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9227.6055 9881.2852 12.8839'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9227.6973 9913.8516 12.8839'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/freeman/ventfan.mdl', pos = Vector('9227.7891 9946.418 12.8839'), ang = Angle('-89.9956 179.8388 180'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9228.1641 9940.1563 26.5271'), ang = Angle('0 180 -0'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9228.1641 9877.4844 26.5271'), ang = Angle('0 180 0'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9228.1641 9814.8125 26.5271'), ang = Angle('0 180 -0'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9193.5879 9814.8125 26.5271'), ang = Angle('0 180 0'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9193.5879 9877.4844 26.5271'), ang = Angle('0 180 -0'), },
    { mdl = 'models/props_c17/furnituretable002a.mdl', pos = Vector('9193.5879 9940.1563 26.5271'), ang = Angle('0 180 0'), },
    { mdl = 'models/props/cs_office/computer.mdl', pos = Vector('9197.3164 9934.2217 45.6513'), ang = Angle('-0.4191 -176.514 0.0769'), },
    { mdl = 'models/props/cs_office/computer_case.mdl', pos = Vector('9192.6152 9957.3125 45.6352'), ang = Angle('-0 -179.1946 -0.3767'), },
    { mdl = 'models/props_lab/citizenradio.mdl', pos = Vector('9231.3574 9935.5049 45.5663'), ang = Angle('0.0308 -0.8714 0.1521'), },
    { mdl = 'models/props_lab/huladoll.mdl', pos = Vector('9204.6113 9913.7754 45.5553'), ang = Angle('-0.0844 166.4977 -0.1184'), },
    { mdl = 'models/props/cs_office/radio.mdl', pos = Vector('9229.2744 9880.667 45.5941'), ang = Angle('-0.0001 0.0001 0'), },
    { mdl = 'models/props_lab/desklamp01.mdl', pos = Vector('9230.8662 9815.998 54.3669'), ang = Angle('0.4568 -0.5897 0.0173'), },
    { mdl = 'models/props_c17/light_decklight01_off.mdl', pos = Vector('9198.2334 9816.2617 55.2737'), ang = Angle('0 -179.9385 -90'), },
    { mdl = 'models/tdmcars/nissan_gtr.mdl', pos = Vector('6505.0327 13309.2793 2.7547'), ang = Angle('-0 -89.868 0'), },
    { mdl = 'models/tdmcars/mitsu_evox.mdl', pos = Vector('6499.333 13168.5518 -3.2897'), ang = Angle('-0.012 -89.1843 -0.0322'), },
    { mdl = 'models/tdmcars/sl65amg.mdl', pos = Vector('6502.3862 13028.9141 4.9638'), ang = Angle('-0 -90 -0'), },
    { mdl = 'models/tdmcars/mas_ghibli.mdl', pos = Vector('6456.252 12483.1729 4.8304'), ang = Angle('0 -1.0296 -0.0435'), },
    { mdl = 'models/tdmcars/lex_isf.mdl', pos = Vector('6277.3472 12470.6768 6.3058'), ang = Angle('-0 -0.9243 0'), },
    { mdl = 'models/tdmcars/lambo_murcielagosv.mdl', pos = Vector('6045.5928 12425.2559 4.7139'), ang = Angle('-0 -45 -0'), },
    { mdl = 'models/tdmcars/gt05.mdl', pos = Vector('5847.4673 12439.7588 2.7442'), ang = Angle('-0 -45 0'), },
    { mdl = 'models/tdmcars/mclaren_p1.mdl', pos = Vector('6297.5166 13607.4531 4.4097'), ang = Angle('-0.4108 -148.8035 -0.1815'), },
    { mdl = 'models/tdmcars/fer_lafer.mdl', pos = Vector('5876.0688 13709.2559 5.2997'), ang = Angle('0 -135 0'), },
    { mdl = 'models/tdmcars/fer_458spid.mdl', pos = Vector('5741.9492 13450.7617 4.479'), ang = Angle('0 -90 -0'), },
    { mdl = 'models/props/cs_office/paperbox_pile_01.mdl', pos = Vector('10168.9258 7003.6074 8.5059'), ang = Angle('-0.0081 -89.9825 -0.0325'), },
    { mdl = 'models/props/cs_assault/dryer_box.mdl', pos = Vector('10062.2139 7009.1299 8.3714'), ang = Angle('0.0067 -89.365 0.0238'), },
    { mdl = 'models/props/de_nuke/nuclearcontainerboxclosed.mdl', pos = Vector('10097.8193 7017.3467 28.3251'), ang = Angle('0.1716 -89.7191 0.0881'), },
    { mdl = 'models/props_junk/cardboard_box003a.mdl', pos = Vector('10096.8428 7026.3989 58.2548'), ang = Angle('0.1615 -89.6718 0.0826'), },
    { mdl = 'models/props_junk/cardboard_box004a.mdl', pos = Vector('10089.0518 7025.7515 66.8958'), ang = Angle('0.1277 -89.9325 -0.1485'), },
    { mdl = 'models/props/de_inferno/potted_plant2.mdl', pos = Vector('10210.0645 6820.2646 8.3329'), ang = Angle('-0.0779 177.6534 0.093'), },
    { mdl = 'models/props_interiors/furniture_chair03a.mdl', pos = Vector('10138.4561 4497.9097 27.5635'), ang = Angle('-0.0293 89.9853 0.0122'), },
    { mdl = 'models/props_interiors/furniture_chair03a.mdl', pos = Vector('10103.4609 4497.7188 27.6506'), ang = Angle('-0.6765 90.1021 -0.0412'), },
    { mdl = 'models/props/cs_office/plant01.mdl', pos = Vector('10215.1982 4514.2085 7.591'), ang = Angle('0.4402 170.6637 -0.0159'), },
    { mdl = 'models/props/cs_office/vending_machine.mdl', pos = Vector('10185.0928 4709.5986 8.3408'), ang = Angle('-0.0293 -0.3057 -0.0442'), },
    { mdl = 'models/props/de_nuke/clock.mdl', pos = Vector('9936.374 4727.4946 78.129'), ang = Angle('0.0001 -90.2287 0.0006'), },
    { mdl = 'models/props/cs_office/vending_machine.mdl', pos = Vector('11915.6172 7781.5815 8.4399'), ang = Angle('0.0799 -0.0799 0.0073'), },
    { mdl = 'models/nova/chair_plastic01.mdl', pos = Vector('11914.5215 7571.0732 8.3136'), ang = Angle('0.0371 0.1378 1.8765'), },
    { mdl = 'models/nova/chair_plastic01.mdl', pos = Vector('11892.0566 7571.0557 8.5427'), ang = Angle('0.0255 -0.1828 2.7455'), },
    { mdl = 'models/nova/chair_plastic01.mdl', pos = Vector('11869.4219 7571.0693 8.5476'), ang = Angle('0.0103 0.1666 2.7588'), },
    { mdl = 'models/nova/chair_plastic01.mdl', pos = Vector('11845.832 7571.0806 8.5164'), ang = Angle('-0.1435 0.0938 2.7223'), },
    { mdl = 'models/props/cs_office/vending_machine.mdl', pos = Vector('11817.748 4634.377 8.5594'), ang = Angle('0.1628 179.8925 0.0273'), },
    { mdl = 'models/chairs/armchair.mdl', pos = Vector('11994.1133 4637.3999 -3.2448'), ang = Angle('0.8031 90.0234 -0.0418'), },
    { mdl = 'models/chairs/armchair.mdl', pos = Vector('12059.8613 4637.4272 -3.1968'), ang = Angle('0.8031 90.0234 -0.0418'), },
    { mdl = 'models/chairs/armchair.mdl', pos = Vector('12125.6094 4637.4546 -3.1489'), ang = Angle('0.8031 90.0234 -0.0418'), },
    { mdl = 'models/props/cs_office/bookshelf1.mdl', pos = Vector('11863.3799 4848.8418 8.4045'), ang = Angle('0 -90 -0.0647'), },
    { mdl = 'models/props/cs_office/bookshelf1.mdl', pos = Vector('11810.709 4848.8418 8.4639'), ang = Angle('0 -90 -0.0647'), },
    { mdl = 'models/maxofs2d/gm_painting.mdl', pos = Vector('11977.0566 4854.2969 78.8016'), ang = Angle('-0.0001 -90.0839 -0.0894'), },
    { mdl = 'models/props/cs_militia/fertilizer.mdl', pos = Vector('11400.5938 9684.3398 8.6714'), ang = Angle('0.1765 -0.2517 0.3096'), },
    { mdl = 'models/props/cs_militia/fertilizer.mdl', pos = Vector('11401.0313 9783.5176 9.2073'), ang = Angle('0.1765 -0.2517 0.3096'), },
    { mdl = 'models/props/cs_militia/fertilizer.mdl', pos = Vector('11401.4688 9882.6953 9.7431'), ang = Angle('0.1765 -0.2517 0.3096'), },
    { mdl = 'models/props_junk/pushcart01a.mdl', pos = Vector('11537.1162 9864.8008 42.2529'), ang = Angle('-0.0003 -43.2551 -0.2712'), },
    { mdl = 'models/props/cs_office/paperbox_pile_01.mdl', pos = Vector('11491.4531 9974.8281 8.4443'), ang = Angle('0.0127 179.9661 0.0769'), },
    { mdl = 'models/props_vehicles/carparts_wheel01a.mdl', pos = Vector('11464.04 10022.4736 25.4742'), ang = Angle('53.317 16.4974 1.2009'), },
    { mdl = 'models/props_junk/plasticbucket001a.mdl', pos = Vector('11425.4561 10025.0205 14.886'), ang = Angle('1.3808 -62.7433 -0.2135'), },
    { mdl = 'models/props_junk/plasticbucket001a.mdl', pos = Vector('11439.875 10025.1045 14.7205'), ang = Angle('0.8862 -115.3766 -0.5288'), },
    { mdl = 'models/props_junk/plasticbucket001a.mdl', pos = Vector('11432.7959 10025.0234 35.7967'), ang = Angle('1.2906 -67.5412 -0.1575'), },
    { mdl = 'models/props_junk/propanecanister001a.mdl', pos = Vector('11550.0771 9899.2676 19.3714'), ang = Angle('0 180 -0'), },
    { mdl = 'models/props_junk/propane_tank001a.mdl', pos = Vector('11561.5586 9907.3809 26.0709'), ang = Angle('0.1987 -106.1488 0.6287'), },
    { mdl = 'models/props/cs_militia/paintbucket01.mdl', pos = Vector('11662.6475 9884.6152 8.3873'), ang = Angle('0.0336 -91.5634 0.0361'), },
    { mdl = 'models/props/cs_militia/paintbucket01.mdl', pos = Vector('11682.252 9885.0889 8.473'), ang = Angle('0.2484 -95.4629 0.4911'), },
    { mdl = 'models/props/cs_militia/paintbucket01.mdl', pos = Vector('11662.6602 9902.416 8.3506'), ang = Angle('-0.2037 -89.661 0.0459'), },
    { mdl = 'models/props/cs_militia/paintbucket01.mdl', pos = Vector('11681.083 9903.3662 8.4387'), ang = Angle('0.8489 -46.0259 0.2433'), },
    { mdl = 'models/props/cs_militia/paintbucket01.mdl', pos = Vector('11661.4404 9901.7324 30.6917'), ang = Angle('0.032 -41.4184 -0.1787'), },
    { mdl = 'models/props/cs_militia/paintbucket01.mdl', pos = Vector('11680.2441 9903.3467 30.8651'), ang = Angle('0.7723 -90.2322 0.0876'), },
    { mdl = 'models/props_junk/cardboard_box001a.mdl', pos = Vector('11711.8779 9895.4805 44.6989'), ang = Angle('0.2219 -90.0798 0.284'), },
    { mdl = 'models/props_junk/cardboard_box001a.mdl', pos = Vector('11711.8906 9895.3174 20.4191'), ang = Angle('0.0609 -89.9003 0.4347'), },
    { mdl = 'models/props_junk/cardboard_box003a.mdl', pos = Vector('11745.3076 9906.2969 18.1462'), ang = Angle('-0.0692 -89.9606 0.0951'), },
    { mdl = 'models/props_junk/cardboard_box004a.mdl', pos = Vector('11736.8252 9905.5498 26.9525'), ang = Angle('-0.3086 -89.9914 0.298'), },
    { mdl = 'models/props_junk/plasticbucket001a.mdl', pos = Vector('11864.377 9904.7119 92.2114'), ang = Angle('0.9955 -98.5583 -0.3295'), },
    { mdl = 'models/props_junk/plasticbucket001a.mdl', pos = Vector('11884.3154 9904.7217 92.236'), ang = Angle('1.2312 -82.8342 -0.682'), },
    { mdl = 'models/props_c17/furnitureshelf002a.mdl', pos = Vector('11876.2363 9903.9121 77.138'), ang = Angle('-0.3786 -89.9938 -0.013'), },
    { mdl = 'models/props_c17/furnitureshelf002a.mdl', pos = Vector('11914.041 9903.916 77.1294'), ang = Angle('-0.3786 -89.9938 -0.013'), },
    { mdl = 'models/props_junk/garbage_bag001a.mdl', pos = Vector('11911.7451 9903.5811 94.8432'), ang = Angle('87.0832 48.2311 -176.5933'), },
    { mdl = 'models/props_junk/garbage_bag001a.mdl', pos = Vector('11923.5596 9903.9824 95.5922'), ang = Angle('60.4682 -16.1531 -5.7949'), },
    { mdl = 'models/props_junk/garbage_plasticbottle001a.mdl', pos = Vector('12144.0303 9806.8242 18.8369'), ang = Angle('0.1222 21.0527 -0.0186'), },
    { mdl = 'models/props_junk/garbage_plasticbottle001a.mdl', pos = Vector('12154.8672 9806.8975 19.0312'), ang = Angle('-0.5471 -157.6268 0.2081'), },
    { mdl = 'models/props_junk/wheebarrow01a.mdl', pos = Vector('12108.8467 9644.5029 24.7387'), ang = Angle('0.8083 -120.8747 -0.4699'), },
    { mdl = 'models/props_junk/cinderblock01a.mdl', pos = Vector('12116.5615 9620.3164 20.5378'), ang = Angle('0.0263 -142.0086 -13.2916'), },
    { mdl = 'models/props_junk/cinderblock01a.mdl', pos = Vector('12123.21 9608.9678 19.7149'), ang = Angle('0.2184 -142.0892 -2.0567'), },
    { mdl = 'models/props_c17/oildrum001.mdl', pos = Vector('12135.6895 9627.5127 8.6933'), ang = Angle('-1.5464 -156.3112 0.6393'), },
    { mdl = 'models/props_c17/oildrum001.mdl', pos = Vector('12145.8301 9601.3223 8.4413'), ang = Angle('0.0444 -169.9785 -0.2513'), },
    { mdl = 'models/props/cs_militia/boxes_frontroom.mdl', pos = Vector('12091.376 9419.5234 8.359'), ang = Angle('-0.004 -136.2481 -0.0033'), }
}

GAMEMODE.Map:RegisterMapProp( MapProp )