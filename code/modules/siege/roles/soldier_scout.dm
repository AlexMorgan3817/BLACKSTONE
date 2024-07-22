/datum/advclass/siege_soldier/scout
	name = "Солдат Лорда, Разведчик"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_scout
	price_of_additional_slots = 10
	maxchosen = 0
/datum/outfit/job/roguetown/adventurer/siege_scout/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	gloves = /obj/item/clothing/gloves/roguetown/leather
	if(prob(30))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltl = /obj/item/quiver/bolts
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	s.can_leave_camp_before_declaration = TRUE
	s.class_name = "Разведчик"
	H.mind.add_antag_datum(s)

	H.mind.adjust_skillrank(/datum/skill/combat/swords, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/crossbows, pick(2,3,3), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, rand(3,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, rand(3,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, rand(3,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, rand(3,6), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/traps, rand(2,4), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sneaking, pick(4,4,4,5,5,6), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/stealing, rand(3,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/riding, pick(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)

	H.change_stat("strength", -1)
	H.change_stat("perception", 2)
	H.change_stat("speed", 3)
	H.change_stat("intelligence", 2)

	ADD_TRAIT(H, RTRAIT_LOWTURFSLOW, TRAIT_GENERIC)