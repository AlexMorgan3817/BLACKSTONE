/datum/advclass/siege_soldier/merchant
	name = "Солдат Лорда, Торговец"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_merchant
	maxchosen = 0

/datum/outfit/job/roguetown/adventurer/siege_merchant/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	head = /obj/item/clothing/head/roguetown/chaperon
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		pants = /obj/item/clothing/under/roguetown/tights/sailor
		if(H.dna?.species)
			if(H.dna.species.id == "humen")
				H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	else
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		pants = /obj/item/clothing/under/roguetown/tights/sailor
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	s.class_name = "Торговец"
	H.mind.add_antag_datum(s)

	H.change_stat("intelligence", 2)
	H.change_stat("perception", 3)
	H.change_stat("strength", -1)

	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/mathematics, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)

	ADD_TRAIT(H, RTRAIT_SEEPRICES, type)