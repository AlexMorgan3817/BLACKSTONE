/datum/antagonist/siege
	var/cost_of_my_death = 1
	var/can_leave_camp_before_declaration = FALSE
	var/class_name = null
	var/traitor = FALSE
	var/sergeant = FALSE
	antag_hud_type = 26
	antag_hud_name = "hudsecurityofficerOld"
	on_gain()
		. = ..()
		owner.special_role = name
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		RegisterSignal(owner.current, COMSIG_MOB_DEATH, PROC_REF(siege_death))
		add_antag_hud(antag_hud_type, antag_hud_name, owner.current)
		addtimer(CALLBACK(src, PROC_REF(introduction)), 5 SECONDS)
		owner.current.cmode_music = 'code/modules/siege/Meltdown.ogg'

	roundend_report()
		return

	proc/introduction()
		to_chat(owner.current, "<span class='boldnotice'>Ты часть гарнизона прибывшего из Хартфелта Лорда. Он намерен завоевать эти земли и ты стал одним из его пальцев в исполнении его воли.</span>")

	proc/siege_death()
		var/datum/game_mode/siege/C = SSticker.mode
		C.loss(src, cost_of_my_death)

	proc/add_objective(datum/objective/O)
		O = new O
		O.owner = src
		objectives += O

/proc/find_adv_class(type)
	for(var/datum/advclass/A in GLOB.adv_classes)
		if(A.type == type)
			return A

/proc/find_adv_class_types(type)
	. = list()
	for(var/datum/advclass/A in GLOB.adv_classes)
		if(istype(A, type))
			. += A

/proc/ParseSiegeJobs(list/L, mob/living/carbon/human/H, ignore_agenda = FALSE)
	. = list()
	var/datum/game_mode/siege/C = SSticker.mode
	for(var/datum/advclass/siege_soldier/i in L)
		if(i.name == null)
			continue
		if(!i.can_be_equiped(H))
			continue
		if(ignore_agenda || !istype(C))
			. += i
			continue
		for(var/j in C.enforcement_agenda)
			if(istype(i, j))
				. += i
