/datum/advclass/siege_soldier/medium
	name = "Солдат Лорда, Средняя пехота"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_medium
	price_of_additional_slots = 5
	maxchosen = 0
/datum/outfit/job/roguetown/adventurer/siege_medium/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	shoes = /obj/item/clothing/shoes/roguetown/boots
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/wood
	beltl = /obj/item/rogueweapon/huntingknife
	if(prob(50))
		beltr = /obj/item/rogueweapon/sword/iron
	else
		beltr = /obj/item/rogueweapon/sword/sabre
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return
	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1.5
	s.class_name = "Средний пехотинец"
	H.mind.add_antag_datum(s)

	H.change_stat("strength", 3)
	H.change_stat("perception", 2) 
	H.change_stat("constitution", 1)
	H.change_stat("endurance", 3)
	H.change_stat("speed", 1)

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

	ADD_TRAIT(H, RTRAIT_MEDIUMARMOR, TRAIT_GENERIC)	
	ADD_TRAIT(H, RTRAIT_HEAVYARMOR, TRAIT_GENERIC)



