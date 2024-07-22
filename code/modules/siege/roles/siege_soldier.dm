/datum/antagonist/siege/siege_soldier
	name = "Солдат Лорда"
	roundend_category = "Siege"
	antagpanel_category = "Siege"
	job_rank = ROLE_SIEGESOLDER
	antag_hud_name = "hudsecurityofficer"
	confess_lines = list(
		"СЛАВА ЛОРДУ ХАРТФЕЛТА!",
		"ВАШЕ КОРОЛЕВСТВО СГОРИТ!",
		"СКАЛОХОЛМСК ПАДЁТ!",
	)
	cost_of_my_death = 1
	silent = TRUE
	class_name = "Солдат Лорда"

	on_gain()
		. = ..()
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		var/datum/game_mode/siege/C = SSticker.mode
		C.soldiers += owner

		add_objective(/datum/objective/siege_lord_conquer/soldier)
		add_objective(/datum/objective/siege_lord_must_survive)
		ADD_TRAIT(owner.current, RTRAIT_MOOD_IGNORE_DEATH, TRAIT_GENERIC)

	introduction()
		to_chat(owner.current, "<span class='notice'>Ты часть гарнизона Лорда прибывшего из Хартфелта. \
			Король Энигмы посмел оскорбить твоего господина и теперь он поплатится. \
			Лорд намерен завоевать эти земли и ты стал одним из его солдат, он надеется на ваше благоразумие, честь и доблесть в бою. \
			Всё же вы не какие-то там разбойники.</span>")
	examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
		if(istype(examined_datum, /datum/antagonist/siege/siege_lord))
			return "<span class='boldnotice'>Это же [examined.gender == MALE ? "наш Лорд" : "наша госпожа"]! Я должен преклонить колени!</span>"
		if(istype(examined_datum, /datum/antagonist/siege/siege_hand))
			return "<span class='boldnotice'>Это же правая рука моего господина! Нужно слушать внимательно!</span>"
		if(istype(examined_datum, /datum/antagonist/siege/siege_soldier))
			var/datum/antagonist/siege/s = examined_datum
			if(s.traitor)
				return "<span class='boldnotice'>ОН ПРЕДАЛ НАШЕГО ГОСПОДИНА!</span>"
			return "<span class='boldnotice'>Он тоже служит моему господину! Он [lowertext(s.class_name)]!</span>"

/datum/advclass/siege_soldier
	name = null
	tutorial = "Король Энигмы нанёс нашему господину смертельное оскорбление. Теперь его земли станут нашими!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		SPECIES_HUMEN,
		SPECIES_AASIMAR,
		SPECIES_DARK_ELF,
		SPECIES_ELF,
		SPECIES_HALF_ELF,
		SPECIES_TIEFLING,
		SPECIES_DWARF
	)
	issiege = TRUE
	var/price_of_additional_slots = -1
	maxchosen = -1
