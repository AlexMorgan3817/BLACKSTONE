/datum/advclass/siege_soldier/light
	name = "Солдат Лорда, Лёгкая пехота"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_soldier

/datum/outfit/job/roguetown/adventurer/siege_soldier/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle
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
	#ifdef GOD_ASTRATA
	beltr = /obj/item/rogueweapon/sword/short
	#endif
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	s.class_name = "Лёгкий пехотинец"
	H.mind.add_antag_datum(s)

	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, rand(2,3), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, pick(3,3,3,3,4,4,4,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, rand(1,3), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)

	H.change_stat("strength", 3)
	H.change_stat("perception", 2)
	H.change_stat("constitution", 2)
	H.change_stat("endurance", 2)
	H.change_stat("speed", 2)
