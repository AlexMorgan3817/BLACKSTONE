/datum/advclass/siege_soldier/cleric
	name = "Солдат Лорда, Целитель"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_cleric
	price_of_additional_slots = 15
	maxchosen = 0
/datum/outfit/job/roguetown/adventurer/siege_cleric/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	#ifdef GOD_ASTRATA
	switch(H.PATRON)
		if(GOD_ASTRATA)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(GOD_DENDOR)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(GOD_NECRA)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
		if(GOD_PESTRA)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(GOD_NOC)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
	neck = /obj/item/clothing/neck/roguetown/coif/chain
	#else
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	#endif
	cloak = /obj/item/clothing/cloak/stabard/siege
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/mace
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	backpack_contents = list(/obj/item/rogueweapon/huntingknife)
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return
	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 3
	s.class_name = "Целитель"
	s.antag_hud_name = "hudmedicaldoctor"
	H.mind.add_antag_datum(s)

	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/magic/holy, rand(2,4), TRUE)
	H.change_stat("intelligence", 3)
	H.change_stat("perception", 1)
	H.change_stat("strength", 1)
	H.change_stat("constitution", 3)
	H.change_stat("endurance", 3)
	H.mind.AddSpell(/obj/effect/proc_holder/spell/invoked/sacred_flame_rogue)
	H.mind.AddSpell(/obj/effect/proc_holder/spell/invoked/lesser_heal)
	H.mind.AddSpell(/obj/effect/proc_holder/spell/invoked/heal)

	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron)
	C.holder_mob = H
	C.update_devotion(50, 50)
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	C.grant_spells(H)

	ADD_TRAIT(H, RTRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, RTRAIT_MEDIUMARMOR, TRAIT_GENERIC)

