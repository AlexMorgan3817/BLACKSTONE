/datum/advclass/siege_soldier/craftsman/name = null

/datum/advclass/siege_soldier/craftsman/blacksmith
	name = "Ремесленник, Кузнец"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_blacksmith

/datum/outfit/job/roguetown/adventurer/siege_blacksmith/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/roguekey/blacksmith
	cloak = /obj/item/clothing/cloak/stabard/siege
	backpack_contents = list(/obj/item/flint = 1, /obj/item/rogueore/coal=1, /obj/item/rogueore/iron=1)
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	H.mind.add_antag_datum(s)
	s.class_name = "Кузнец"

	H.change_stat("strength", 2)
	H.change_stat("speed", 1)
	H.change_stat("constitution", 1)
	H.change_stat("endurance", 1)
	H.change_stat("perception", 1)

	H.mind.adjust_skillrank(/datum/skill/craft/weaponsmithing, pick(3,4,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/armorsmithing, pick(3,4,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

/datum/advclass/siege_soldier/craftsman/mason
	name = "Солдат Лорда, Каменщик"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_mason

/datum/outfit/job/roguetown/adventurer/siege_mason/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	cloak = /obj/item/clothing/cloak/stabard/siege
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/hammer/claw
	backl = /obj/item/storage/backpack/rogue/backpack
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	s.class_name = "Каменщик"
	H.mind.add_antag_datum(s)

	H.change_stat("strength", 3)
	H.change_stat("intelligence", 1)
	H.change_stat("endurance", 1)
	H.change_stat("constitution", 1)
	H.change_stat("speed", -1)

	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, rand(3,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/masonry, rand(3,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/engineering, rand(2,4), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)

/datum/advclass/siege_soldier/craftsman/carpenter
	name = "Солдат Лорда, Столяр"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_carpenter

/datum/outfit/job/roguetown/adventurer/siege_carpenter/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	cloak = /obj/item/clothing/cloak/stabard/siege
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/hammer/claw
	#ifdef GOD_ASTRATA
	backl = /obj/item/storage/backpack/rogue/backpack/alt
	#endif
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	s.class_name = "Столяр"
	H.mind.add_antag_datum(s)

	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, rand(1,3), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/carpentry, pick(3,4,4,4,4,5,5), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/masonry, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/engineering, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.change_stat("intelligence", 1)
	H.change_stat("constitution", 1)
	H.change_stat("speed", -1)

/datum/advclass/siege_soldier/craftsman/peasant
	name = "Солдат Лорда, Фермер"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_carpenter

/datum/outfit/job/roguetown/adventurer/siege_peasant/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	cloak = /obj/item/clothing/cloak/stabard/siege
	pants = /obj/item/clothing/under/roguetown/tights/random
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	belt = /obj/item/storage/belt/rogue/leather/rope
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 1
	s.class_name = "Фермер"
	H.mind.add_antag_datum(s)

	H.change_stat("strength", 2)
	H.change_stat("constitution", 1)
	H.change_stat("intelligence", -4)
	H.change_stat("speed", -2)

	H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, rand(1,2), TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/farming, pick(4,5), TRUE)
