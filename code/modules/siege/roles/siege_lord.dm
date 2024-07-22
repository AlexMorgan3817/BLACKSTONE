GLOBAL_LIST_EMPTY(siege_lord_color)

/datum/antagonist/siege/siege_lord
	name = "Лорд Завоеватель"
	class_name = "Лорд Завоеватель"
	roundend_category = "Осада"
	antagpanel_category = "Осада"
	job_rank = ROLE_SIEGELORD
	antag_hud_name = "hudcaptain"
	confess_lines = list(
		"ВАШ ЛОРД ВАМ ЛЖЁТ.",
		"МЕНЯ НЕ СЛОМИТЬ!.",
		"ХАРТФЕЛТ! МОЯ РОДИНА!"
	)
	cost_of_my_death = 100
	can_leave_camp_before_declaration = TRUE
	sergeant = TRUE
	var/color_selected = FALSE

	examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
		if(istype(examined_datum, /datum/antagonist/siege/siege_hand))
			return "<span class='boldnotice'>Это же [examined.gender == MALE ? "мой дорогой" : "моя дорогая"] [examined.real_name], моя десница!</span>"

		if(istype(examined_datum, /datum/antagonist/siege/siege_soldier))
			var/datum/antagonist/siege/s = examined_datum
			if(s.traitor)
				return "<span class='boldnotice'>Это что, тот предатель?</span>"
			return "<span class='boldnotice'>Один из моих солдат. Кажется он [lowertext(s.class_name)].</span>"

	on_gain()
		. = ..()
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		var/datum/game_mode/siege/C = SSticker.mode
		C.Lord = owner
		C.soldiers += owner
		// var/msg = "<span class='boldnotice'>Глупец что правит этими проклятыми землями нанёс тебе смертельное оскорбление.\
		// 	Не смотря на легенды о Зизо и другой тьме живущей на Энигме, ты организовал завоевательный поход.\
		// 	До сих пор Равокс благоволил вам и победа шагала за вами. И сейчас вы на пороге Рокхилла. Столицы этого королевства.\
		// 	Сегодня решится судьба Хартфелта и Энигмы и ты не допустишь их победы.</span>"
		// addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), owner.current, msg), 5 SECONDS)
		add_objective(/datum/objective/siege_lord_must_survive)
		add_objective(/datum/objective/siege_lord_conquer)

		owner.current.verbs |= /mob/living/carbon/human/proc/AttackOrder
		owner.current.verbs |= /mob/living/carbon/human/proc/DefenceOrder
		owner.current.verbs |= /mob/living/carbon/human/proc/DeclareEnforcementAgenda
		owner.current.verbs |= /mob/living/carbon/human/proc/OpenEnforcementSlots
		owner.current.verbs |= /mob/living/carbon/human/proc/InitiateNewSoldier
		owner.current.verbs |= /mob/living/carbon/human/proc/DeclareATraitor
		owner.current.verbs |= /mob/living/carbon/human/proc/InitiateNewSergeant

		addtimer(CALLBACK(src, PROC_REF(lord_color_choice)), 200)
		C.RegisterSignal(owner.current, COMSIG_MOB_DEATH, TYPE_PROC_REF(/datum/game_mode/siege, lord_death))
	introduction()
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		var/datum/game_mode/siege/C = SSticker.mode
		var/msg = "Глупец что правит этими проклятыми землями нанёс тебе смертельное оскорбление. \
		 	Не смотря на легенды о Зизо и другой тьме живущей на Энигме, ты организовал завоевательный поход. \
		 	До сих пор Равокс благоволил вам и победа шагала за вами. И сейчас вы на пороге Рокхилла. Столицы этого королевства. \
		 	Сегодня решится судьба Хартфелта и Энигмы и ты не допустишь их победы."

		to_chat(owner.current, "<span class='notice'>[msg]</span>")
		owner.store_memory(msg)
		owner.store_memory("Его зовут: [C.King.name].")

	roundend_report()
		var/datum/game_mode/siege/C = SSticker.mode
		if(!istype(C))
			return
		if(length(C.war_declaration) != 0)
			var/dat = "<style type=\"text/css\">body{background:url('book.png') repeat; color: #000000; font-size: 20px;}</style>"
			dat += C.war_declaration
			for(var/client/player in GLOB.clients)
				player << browse_rsc('html/book.png')
				var/datum/browser/popup = new(player, "lordsletter", "Декларация Лорда", 400, 600)
				popup.set_content(dat)
				popup.open()
		var/soldiers_report = ""
		var/l = length(C.soldiers)
		if(l != 0)
			var/datum/mind/M
			for(var/i in 1 to l-1)
				M = C.soldiers[i]
				if(!M.current)
					continue
				var/datum/antagonist/siege/s = GetSiegeAntag(M)
				if(!s || s == src)
					continue
				for(var/datum/objective/objective in s.objectives)
					if(!objective.check_completion())
						continue
					M.adjust_triumphs(objective.triumph_count)
				soldiers_report += M.current.real_name + "([s.class_name]), "
			M = C.soldiers[l]
			if(M.current)
				var/datum/antagonist/siege/s = GetSiegeAntag(M)
				if(s)
					for(var/datum/objective/objective in s.objectives)
						if(!objective.check_completion())
							continue
						M.adjust_triumphs(objective.triumph_count)
					soldiers_report += M.current.real_name + "([s.class_name])."
		to_chat(world, "<hr>")
		to_chat(world, "<span style='font-size: 140%; font-weight: bold; color: #eebb00'>Лордом Завоевателем был [owner.name ? owner.name : owner.current.real_name].</span>")
		if(C.Hand && C.Hand.current)
			to_chat(world, "Десницей был [C.Hand.current.real_name].")
		if(length(soldiers_report) != 0)
			to_chat(world, "Солдаты лорда:")
			to_chat(world, soldiers_report)
		if(considered_alive(C.Lord))
			to_chat(world, "<span class='warning'>Потери: [C.losses] / [C.losses_max]</span>")
		else
			to_chat(world, "<span class='warning'>Потери: [C.losses-100] / [C.losses_max]</span>")
		to_chat(world, "<hr>")
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			var/o = objective.check_completion()
			if(o)
				owner.adjust_triumphs(objective.triumph_count)
			to_chat(world, "<B>Цель #[objective_count]</B>: [objective.explanation_text] <span class='[o ? "greentext" : "redtext"]'>[o ? "УСПЕХ!" : "НЕУДАЧА..."]</span>")
			objective_count++
		to_chat(world, "<hr>")

	proc/lord_color_choice()
		if(!owner.current.client)
			addtimer(CALLBACK(src, PROC_REF(lord_color_choice)), 200)
			return
		var/list/lordcolors = list(
			"PURPLE"="#865c9c", "RED"="#933030",
			"BLACK"="#2f352f",  "BROWN"="#685542",
			"GREEN"="#79763f",  "BLUE"="#395480",
			"YELLOW"="#b5b004", "TEAL"="#249589",
			"WHITE"="#ffffff",  "ORANGE"="#b86f0c",
			"MAJENTA"="#962e5c"
		)
		for(var/i in lordcolors)
			if(lordcolors[i] in GLOB.lordcolor)
				lordcolors -= i
		var/prim
		var/sec
		var/choice = input(owner.current, "Choose a Primary Color", "ROGUETOWN") as anything in lordcolors
		if(choice)
			prim = lordcolors[choice]
			lordcolors -= choice
		choice = input(owner.current, "Choose a Secondary Color", "ROGUETOWN") as anything in lordcolors
		if(choice)
			sec = lordcolors[choice]

		var/datum/game_mode/siege/S = SSticker.mode
		if(istype(S))
			if(!prim || !sec)
				return
			S.prime_color = prim
			S.prime_color = sec
			for(var/obj/O in GLOB.siege_lord_color)
				O.lordcolor(prim, sec)
				GLOB.siege_lord_color -= O
			for(var/turf/O in GLOB.siege_lord_color)
				O.lordcolor(prim, sec)
				GLOB.siege_lord_color -= O
		color_selected = TRUE

/datum/advclass/siege_lord
	name = "Лорд Завоеватель"
	allowed_sexes = list(MALE)
	allowed_races = list(
		"Humen",
	)
	outfit = /datum/outfit/job/roguetown/adventurer/siege_lord
	maxchosen = 1
	pickprob = 100
	isvillager = FALSE
	tutorial = "Король Энигмы нанёс моей семье смертельное оскорбление. Теперь его земли станут моими!"
	issiege = TRUE

/datum/outfit/job/roguetown/adventurer/siege_lord/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/heartfelt
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/lord
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/rogueweapon/sword/long/marlin
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/siege/lord
	if(visualsOnly)
		return

	H.mind.add_antag_datum(new/datum/antagonist/siege/siege_lord())

	H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/polearms,  2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/bows,      3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed,   2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords,    6, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives,    2, TRUE)

	H.mind.adjust_skillrank(/datum/skill/misc/swimming,    1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing,    2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics,   3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading,     4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sneaking,    2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine,    1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/riding,      3, TRUE)

	H.change_stat("strength",     4)
	H.change_stat("intelligence", 2)
	H.change_stat("endurance",    6)
	H.change_stat("perception",   3)
	H.change_stat("fortune",      5)
	H.change_stat("speed",        1)

	ADD_TRAIT(H, RTRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, RTRAIT_NOSEGRAB, TRAIT_GENERIC)
	ADD_TRAIT(H, RTRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, RTRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.advjob = "Лорд Хартфелта"
