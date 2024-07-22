/datum/advclass/siege_soldier/heavy
	name = "Солдат Лорда, Тяжёлая пехота"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_medium
	price_of_additional_slots = 10
	maxchosen = 0
/datum/outfit/job/roguetown/adventurer/siege_heavy/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	cloak = /obj/item/clothing/cloak/stabard/siege
	#ifdef GOD_ASTRATA
	neck = /obj/item/clothing/neck/roguetown/coif/chain
	#else
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	#endif
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	if(prob(30))
		backl = /obj/item/rogueweapon/shield/tower
	else
		backl = /obj/item/rogueweapon/shield/wood
	if(prob(10))
		r_hand = /obj/item/rogueweapon/mace/goden/steel
	else
		beltr =/obj/item/rogueweapon/stoneaxe/battle
	if(visualsOnly)
		return
	id = /obj/item/scomstone/siege

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 2
	s.class_name = "Тяжёлый пехотинец"
	H.mind.add_antag_datum(s)

	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE) 
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

	H.change_stat("strength", 4)
	H.change_stat("perception", 1) 
	H.change_stat("constitution", 3)
	H.change_stat("endurance", 4)
	H.change_stat("speed", 1)

	ADD_TRAIT(H, RTRAIT_HEAVYARMOR, TRAIT_GENERIC)
