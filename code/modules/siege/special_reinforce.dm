/datum/game_mode/siege
	var/enforcement_points = 0
	var/enforcement_points_max = 50
	var/enforcement_points_per_tick = 1

	var/enforcement_tick_time = 1 MINUTES
	var/tmp/enforcement_points_timer_id

/datum/game_mode/siege/post_setup()
	. = ..()
	enforcement_points = enforcement_points_max
	enforcement_tick()
/datum/game_mode/siege/proc/enforcement_tick()
	enforcement_points_timer_id = addtimer(CALLBACK(src, PROC_REF(enforcement_tick)), enforcement_tick_time, TIMER_STOPPABLE)
	if(enforcement_points >= enforcement_points_max)
		return
	enforcement_points += enforcement_points_per_tick

/mob/living/carbon/human/proc/OpenEnforcementSlots()
	set name     = "Эх, а вот бы!"
	set category = "LORD"
	if(stat)
		return
	var/datum/antagonist/siege/siege_lord/lord = mind.has_antag_datum(/datum/antagonist/siege/siege_lord)
	if(!lord)
		return

	if(!istype(SSticker.mode, /datum/game_mode/siege))
		to_chat(src, "Эх... незачем...")
		return
	var/datum/game_mode/siege/C = SSticker.mode
	var/list/sel = list()
	var/list/roles = find_adv_class_types(/datum/advclass/siege_soldier)
	for(var/datum/advclass/siege_soldier/i in roles)
		if(i.price_of_additional_slots == -1 || i.maxchosen == -1 || i.name == null)
			continue
		sel["([i.price_of_additional_slots]P) ([i.amtchosen]/[i.maxchosen]) [i.name]"] = i
	var/inp = input(src, "Нам бы...", "ОСОБОЕ ПОДКРЕПЛЕНИЕ") as null|anything in sel
	if(!inp)
		return
	var/datum/advclass/siege_soldier/i = sel[inp]
	inp = input(src, "Вот бы штук...", "КОЛИЧЕСТВО", 1) as null|num
	inp = floor(inp)
	if(!inp || inp < 0)
		return
	if(C.enforcement_points - inp * i.price_of_additional_slots < 0)
		to_chat(src, S_SPAN("warning", "Эх, не хватает..."))
		return
	i.maxchosen += inp
	C.enforcement_points -= i.price_of_additional_slots * inp
	to_chat(src, S_SPAN("boldnotice", "Ожидайте, [inp] \"[i.name]\" в пути."))
	lord.ArmyAnnounce("Ждите усиленное подкрепление!", title = "УКРЕПЛЕНИЕ ГАРНИЗОНА", newplayersToo = TRUE)
	for(var/mob/living/carbon/human/H in GLOB.setuping_adventurers)
		#ifdef GOD_ASTRATA
		if(CheckDonation(H.key, "Adventurer"))
			H.possibleclass = ParseSiegeJobs(classes, H, ignore_agenda = TRUE)
			return
		#endif
		if(C.enforcement_agenda.len == 0)
			continue
		H.possibleclass = ParseSiegeJobs(GLOB.adv_classes, H)
