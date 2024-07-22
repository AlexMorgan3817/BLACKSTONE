#ifndef SPECIES_HUMEN
	#define SPECIES_HUMEN "Humen"
	#define SPECIES_AASIMAR "Aasimar"
	#define SPECIES_DARK_ELF "Dark Elf"
	#define SPECIES_ELF "Elf"
	#define SPECIES_HALF_ELF "Half-Elf"
	#define SPECIES_TIEFLING "Tiefling"
	#define SPECIES_DWARF "Dwarf"
#endif

#ifndef RTRAIT_MOOD_IGNORE_DEATH
	#define RTRAIT_MOOD_IGNORE_DEATH "Mood Ignore Death"
	#define RTRAIT_LOWTURFSLOW "Slowdown on low turfs"
#endif

#ifndef S_SPAN
	#define S_SPAN(class, x) "<span class='[class]'>[x]</span>"
#endif
GLOBAL_LIST_EMPTY(setuping_adventurers)

/datum/game_mode/siege
	name = "siege"
	config_tag = "siege"
	report_type = "siege"
	announce_span = "siege"
	announce_text = "The"
	false_report_weight = 0
	required_enemies = 0
	recommended_enemies = 0
	enemy_minimum_age = 0
	#ifdef FASTLOAD
	required_players = 0
	var/required_towners = 0
	#else
	required_players = 50
	var/required_towners = 20
	#endif
	var/LordPQReq = 5
	var/HandPQReq = 0
	var/prime_color = "#cc3333"
	var/secondary_color = "#006600"

	var/time_for_epilogue = 2 MINUTES

	var/EnigmaIsOnHerKnees = FALSE
	var/war_declared = FALSE
	var/war_declaration = null
	var/war_can_be_declared_in = 0 // Roundstart time + 30 minutes
	var/war_declaration_delay = 30 MINUTES

	var/losses = 0
	var/losses_max = 100

	var/datum/mind/Lord = null
	var/datum/mind/Hand = null
	var/datum/mind/King = null
	var/list/datum/mind/soldiers = list()

	var/list/enforcement_agenda = list() // Blyat, I meant Reinforcements
	var/list/soldiers_roles = list( // Keys list used for "НАМ НУЖНО БОЛЬШЕ ..." and "НАМ БОЛЬШЕ НЕ НУЖНЫ ..." keep in mind
		"Разведки"       = /datum/advclass/siege_soldier/scout,

		"Лёгкой пехоты"  = /datum/advclass/siege_soldier/light,
		"Средней пехоты" = /datum/advclass/siege_soldier/medium,
		"Тяжёлых воинов" = /datum/advclass/siege_soldier/heavy,

		"Ремесленников"  = /datum/advclass/siege_soldier/craftsman,
		"Лекарей"        = /datum/advclass/siege_soldier/cleric,
		"Магов"          = /datum/advclass/siege_soldier/mage,

		// "Торговца"       = /datum/advclass/siege_soldier/merchant,
	)

	var/tmp/endround_timer

	can_start()
		. = ..()
		var/towners = 0
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			if(player.ready == PLAYER_READY_TO_PLAY && player.topjob != "Adventurer")
				towners++
		if(towners < required_towners)
			to_chat(world, "Not enough players in town.")
			return 0
		return 1

	post_setup()
		war_can_be_declared_in = world.time + war_declaration_delay
		SSticker.login_music = 'Reborn.ogg'
		for(var/mob/dead/new_player/P in GLOB.new_player_list)
			if(P.client)
				P.client.playtitlemusic()
		if(SStitle.splash_turf)
			animate(SStitle.splash_turf, color = "#000000", time = 20, easing = EASE_OUT)
			// addtimer(CALLBACK(src, PROC_REF(AnimateTitleChange), SStitle.icon), 10, TIMER_CLIENT_TIME)
			spawn(20) AnimateTitleChange(new/icon(fcopy_rsc("icons/rogueworld_title.dmi")))
		. = ..()

	proc/get_end_reason()
		if(EnigmaIsOnHerKnees)
			if(considered_alive(Lord))
				return "Лорд Завоеватель поставил Энигму на колени."
			return "Лорд Завоеватель погиб, но завоевал Энигму."
		else if(losses >= losses_max)
			return "Осада Лорда захлебнулась."
		else
			return "Лорду не удалось взять Рокхилл."

	proc/loss(datum/antagonist/siege, amt)
		losses += amt
		if(losses >= losses_max && !endround_timer)
			addtimer(CALLBACK(src, PROC_REF(retreat_order)), 50, TIMER_STOPPABLE)
			addtimer(CALLBACK(src, PROC_REF(announce_end_round)), 60, TIMER_STOPPABLE)
			endround_timer = addtimer(CALLBACK(src, PROC_REF(end_round)), time_for_epilogue)

	proc/retreat_order()
		for(var/datum/mind/i in soldiers)
			to_chat(i.current, "<span style='font-size: 140%' class='boldwarning'>НАМ НЕ ВЫЙГРАТЬ ЭТУ БИТВУ! ОТСТУПАМ!</span>")
			i.current.playsound_local(i.current, 'sound/misc/surrender.ogg', 100)
			i.current.apply_status_effect(/datum/status_effect/buff/siege_lose)

	proc/lord_death()
		for(var/datum/mind/i in soldiers)
			to_chat(i.current, "<span style='font-size: 200%' class='boldwarning'>ЗИЗО! НАШ ЛОРД ПАЛ!</span>")
			i.current.playsound_local(i.current, 'sound/misc/deadbell.ogg', 100)

	proc/announce_end_round()
		to_chat(world, "Это финал истории. Новая история через [time_for_epilogue/600] минут.")

	proc/end_round()
		SSticker.force_ending = 1

	proc/AnimateTitleChange(icon/I)
		SStitle.splash_turf.icon = I
		animate(SStitle.splash_turf, color = "#ffffff", time = 40, easing = EASE_IN)

var/const/ROLE_SIEGELORD = "Lord the Conqueror"
var/const/ROLE_SIEGEHAND = "Hand of the Lord"
var/const/ROLE_SIEGESOLDER = "Soldier of the Lord"

/datum/job/roguetown/lord/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(!istype(SSticker.mode, /datum/game_mode/siege))
		return
	var/datum/game_mode/siege/C = SSticker.mode
	C.King = L.mind

/obj/structure/roguemachine/titan/make_decree(mob/living/user, raw_message)
	. = ..()
	var/datum/game_mode/siege/C = SSticker.mode
	if(!istype(C) || C.EnigmaIsOnHerKnees)
		return
	if(!user.mind || !user.mind.has_antag_datum(/datum/antagonist/siege/siege_lord) || !istype(SSticker.mode, /datum/game_mode/siege))
		return
	C.EnigmaIsOnHerKnees = TRUE
	addtimer(CALLBACK(C, TYPE_PROC_REF(/datum/game_mode/siege, announce_end_round)), 50, TIMER_STOPPABLE)
	C.endround_timer = addtimer(CALLBACK(C, TYPE_PROC_REF(/datum/game_mode/siege, end_round)), C.time_for_epilogue)

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Stats"))
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		var/datum/game_mode/siege/C = SSticker.mode
		if(C.Lord == mind || C.Hand == mind)
			stat("LOSSES: [C.losses] / [C.losses_max]")
			stat("REINF: [C.enforcement_points] / [C.enforcement_points_max]")

/proc/GetSiegeAntag(datum/mind/M)
	. = M.has_antag_datum(/datum/antagonist/siege/siege_soldier)
	if(!.)
		. = M.has_antag_datum(/datum/antagonist/siege/siege_hand)
		if(!.)
			. = M.has_antag_datum(/datum/antagonist/siege/siege_lord)
