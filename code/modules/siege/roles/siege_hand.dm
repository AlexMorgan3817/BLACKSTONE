/datum/antagonist/siege/siege_hand
	name = "Десница Лорда"
	roundend_category = "Siege"
	antagpanel_category = "Siege"
	job_rank = ROLE_SIEGEHAND
	antag_hud_name = "hudsecurityofficerOld"
	confess_lines = list(
		"СЛАВА ЛОРДУ ХАРТФЕЛТА!",
		"ВАШЕ КОРОЛЕВСТВО СГОРИТ!",
		"СКАЛОХОЛМСК ОХВАТИТ ПЛАМЯ ВОЙНЫ!",
	)
	cost_of_my_death = 5
	class_name = "Десница"
	can_leave_camp_before_declaration = TRUE
	sergeant = TRUE

	examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
		if(istype(examined_datum, /datum/antagonist/siege/siege_lord))
			return "<span class='boldnotice'>Это же [examined.gender == MALE ? "мой господин" : "моя госпожа"]!</span>"

		if(istype(examined_datum, /datum/antagonist/siege/siege_soldier))
			var/datum/antagonist/siege/s = examined_datum
			if(s.traitor)
				return "<span class='boldnotice'>Он предел моего господина, значит и меня.</span>"
			return "<span class='boldnotice'>Один из солдат лорда. Кажется он [lowertext(s.class_name)].</span>"

	on_gain()
		. = ..()

		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		var/datum/game_mode/siege/C = SSticker.mode
		C.Hand = owner
		C.soldiers += owner

		add_objective(/datum/objective/siege_lord_conquer/soldier/hand)
		add_objective(/datum/objective/siege_lord_must_survive)

	introduction()
		to_chat(owner.current, "<span class='notice'>Твой лорд мудр. Ты пошёл за ним и заслужил его доверие. \
		Теперь он желает присвоить эти земли себе и ты ему с этим поможешь, как верная десница его.</span>")

/datum/advclass/siege_hand
	name = "Десница Лорда"
	allowed_sexes = list(MALE)
	allowed_races = list(
		"Humen",
	)
	outfit = /datum/outfit/job/roguetown/adventurer/siege_hand
	maxchosen = 1
	pickprob = 100
	isvillager = FALSE
	tutorial = "Король Энигмы нанёс моему господину смертельное оскорбление. Теперь его земли станут нашими!"
	issiege = TRUE

/datum/outfit/job/roguetown/adventurer/siege_hand/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	gloves =/obj/item/clothing/gloves/roguetown/angle
	beltl = /obj/item/rogueweapon/sword/sabre/dec
	beltr = /obj/item/rogueweapon/huntingknife
	backr = /obj/item/storage/backpack/rogue/satchel/heartfelt
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	id = /obj/item/scomstone/siege
	if(visualsOnly)
		return

	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("perception", 3)
	H.change_stat("intelligence", 3)
	ADD_TRAIT(H, RTRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, RTRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, RTRAIT_NOBLE, TRAIT_GENERIC)

	H.mind.add_antag_datum(new/datum/antagonist/siege/siege_hand())


