/datum/advclass/siege_soldier/mage
	name = "Солдат Лорда, Маг"
	outfit = /datum/outfit/job/roguetown/adventurer/siege_mage
	price_of_additional_slots = 25
	maxchosen = 0
/datum/outfit/job/roguetown/adventurer/siege_mage/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	cloak = /obj/item/clothing/cloak/stabard/siege
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/woodstaff
	if(H.age == AGE_OLD)
		head = /obj/item/clothing/head/roguetown/wizhat/gen
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	var/datum/antagonist/siege/siege_soldier/s = new()
	s.cost_of_my_death = 5
	s.class_name = "Чародей"
	H.mind.add_antag_datum(s)

	H.change_stat("strength", -2)
	H.change_stat("intelligence", 3)
	H.change_stat("constitution", -1)
	H.change_stat("endurance", -2)
	if(H.age == AGE_OLD)
		H.change_stat("intelligence", 2)
		H.change_stat("strength", -1)

		H.mind.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, pick(0,1), TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/magic/arcane, pick(3,3,3,3,3,4,4,5), TRUE)

	if(prob(5))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater)
	#ifdef GOD_ASTRATA
	if(prob(15))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/chain)
	#endif
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)