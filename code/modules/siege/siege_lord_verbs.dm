/datum/antagonist/siege/siege_lord
	var/tmp/nextBattleOrder = 0
	var/BattleOrderCooldown = 5 MINUTES
	var/BattleOrderRange = 15

	var/AttackOrderSound = 'sound/magic/timestop.ogg'
	var/DefenceOrderSound = 'sound/magic/timestop.ogg'

	var/list/AttackOrderMessages = list(
		"ВСТАНЬ И ИДИ!",  "УНИЧТОЖЬТЕ ИХ!",
		"В НАСТУПЛЕНИЕ!", "В АТАКУ!",
	)
	var/list/AttackOrderPharases = list(
		"ЗА ХАРТФЕЛТ!",       "ПРИШЛО НАШЕ ВРЕМЯ!",
		"ОНИ НИЧТОЖНЫ!",      "ОНИ БУДУТ СЛОМЛЕНЫ!",
		"ИМ НЕ ВЫСТОЯТЬ!",    "ДА ПРОЛЬЁТСЯ КРОВЬ!",
		"НАСТАЛ НАШ ЧАС!",    "ОНИ БУДУТ УНИЧТОЖЕНЫ!",
		"ОБНАЖИТЬ КЛИНКИ!",   "ОКРОПИМ НАШИ МЕЧИ КРОВЬЮ!",
		"НЕ СТОЙ СТОЛБОМ!",   "ПУСКАЙ НАШИ КЛИНКИ ЗВЕНЯТ!",
		"ОЧИСТИМ ЭТИ ЗЕМЛИ!", "ПУСТЬ РАВОКС ВЕДЁТ НАШИ ДЛАНИ!",
	)
	var/list/DefenceOrderMessages = list(
		"ПОДНЯТЬ ЩИТЫ!",
		"ВСЕ КАК ОДИН!",            "ДЕРЖАТЬ СТРОЙ!",
		"НЕ ОТДАВАТЬ ИМ НИ ДЮЙМА!", "НИ ШАГУ НАЗАД!",
	)
	var/list/DefenceOrderPharases = list(
		"ДА, МИЛОРД!",       "Я ЗДЕСЬ СТОЮ, Я ЗДЕСЬ И ОСТАНУСЬ!",
		"МЫ ВЫСТОИМ!",       "РАВОКС! ДАЙ НАМ СИЛ!",
		"СТОИМ СТЕНОЙ!",     "ИМ НАС НЕ СЛОМИТЬ!",
		"НИ ШАГУ НАЗАД!",
		"ОНИ НЕ ПРОЙДУТ!",
		"ИХ УСИЛИЯ ТЩЕТНЫ!",
	)
	proc/IsAlly(mob/living/M)
		return M.mind && GetSiegeAntag(M.mind)

	proc/AddTempStatBuff(mob/living/target, stat, amt, time)
		target.change_stat(stat, amt)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, change_stat), stat, -amt), time)

	proc/applyAttackOrder(mob/living/ally)
		ally.emote("rage")
		ally.say(pick(AttackOrderPharases))
		ally.apply_status_effect(/datum/status_effect/buff/order_attack)
	proc/applyDefenceOrder(mob/living/ally)
		ally.emote("rage")
		ally.say(pick(DefenceOrderPharases))
		ally.apply_status_effect(/datum/status_effect/buff/order_defence)

	proc/ArmyAnnounce(msg, title = "УКАЗ ЛОРДА!", snd = 'sound/misc/surrender.ogg', newplayersToo = FALSE)
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			return
		var/datum/game_mode/siege/C = SSticker.mode
		msg = "<h1 class='alert'>[title]</h1><span class=style='color:#cc3333'>[msg]</span>"
		for(var/datum/mind/i in C.soldiers)
			to_chat(i.current, msg)
			i.current.playsound_local(i.current, snd, 100)
		if(newplayersToo)
			for(var/mob/dead/new_player/i in GLOB.new_player_list)
				to_chat(i, msg)
				i.playsound_local(i, snd, 100)
			for(var/mob/living/i in GLOB.setuping_adventurers)
				to_chat(i, msg)
				i.playsound_local(i, snd, 100)

/mob/living/carbon/human/proc/AttackOrder()
	set name = "ПРИКАЗ: В АТАКУ!"
	set category = "LORD"

	if(stat)
		return

	var/datum/antagonist/siege/siege_lord/lord = mind.has_antag_datum(/datum/antagonist/siege/siege_lord)
	if(!lord || lord.nextBattleOrder > world.time)
		return
	lord.nextBattleOrder = world.time + lord.BattleOrderCooldown
	playsound(get_turf(src), lord.AttackOrderSound, 200, FALSE, extrarange = 7, soundping = TRUE, ignore_walls = TRUE)
	emote("rage")
	audible_message(\
		"<span style='font-size: 140%; font-weight: bold; color: #cc3333'>✠-- [pick(lord.AttackOrderMessages)] --✠</span>",\
		"Кажется пришло время наступать!", lord.BattleOrderRange)
	for(var/mob/living/i in oview(lord.BattleOrderRange))
		if(lord.IsAlly(i))
			addtimer(CALLBACK(lord, TYPE_PROC_REF(/datum/antagonist/siege/siege_lord, applyAttackOrder), i), rand(1, 10))

/mob/living/carbon/human/proc/DefenceOrder()
	set name = "ПРИКАЗ: ДЕРЖАТЬ СТРОЙ!"
	set category = "LORD"

	if(stat)
		return

	var/datum/antagonist/siege/siege_lord/lord = mind.has_antag_datum(/datum/antagonist/siege/siege_lord)
	if(!lord || lord.nextBattleOrder > world.time)
		return
	lord.nextBattleOrder = world.time + lord.BattleOrderCooldown
	playsound(get_turf(src), lord.DefenceOrderSound, 200, FALSE, extrarange = 7, soundping = TRUE, ignore_walls = TRUE)
	audible_message(\
		"<span style='font-size: 140%; font-weight: bold; color: #cc3333'>✠-- [pick(lord.DefenceOrderMessages)] --✠</span>",\
		"Пришло время отступить и держать оборону.", lord.BattleOrderRange)
	for(var/mob/living/i in oview(lord.BattleOrderRange))
		if(lord.IsAlly(i))
			addtimer(CALLBACK(lord, TYPE_PROC_REF(/datum/antagonist/siege/siege_lord, applyDefenceOrder), i), rand(1, 10))

/mob/living/carbon/human/proc/DeclareEnforcementAgenda()
	set name     = "Нам нужны..."
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
	for(var/i in C.soldiers_roles)
		if(C.soldiers_roles[i] in C.enforcement_agenda)
			sel["** [i] **"] = i
			continue
		sel["[i]"] = i
	var/inp = input(src, "Нам бы...", "ПОДКРЕПЛЕНИЕ") as null|anything in sel
	if(!inp)
		return
	var/j = C.soldiers_roles[sel[inp]]
	if(j in C.enforcement_agenda)
		C.enforcement_agenda.RemoveAll(j)
		lord.ArmyAnnounce("Нам уже хватает [lowertext(sel[inp])]!", newplayersToo = TRUE)
	else
		C.enforcement_agenda.Add(j)
		lord.ArmyAnnounce("НАМ НЕ ХВАТАЕТ [uppertext(sel[inp])]!", newplayersToo = TRUE)

	for(var/mob/living/carbon/human/H in GLOB.setuping_adventurers)
		#ifdef GOD_ASTRATA
		if(CheckDonation(H.key, "Adventurer"))
			H.possibleclass = ParseSiegeJobs(classes, H, ignore_agenda = TRUE)
			return
		#endif
		if(C.enforcement_agenda.len == 0)
			continue
		H.possibleclass = ParseSiegeJobs(GLOB.adv_classes, H)

/mob/living/carbon/human/proc/InitiateNewSoldier()
	set name     = "Принять присягу"
	set category = "LORD"
	set waitfor  = 0

	if(stat)
		return

	var/datum/antagonist/siege/siege_lord/lord = mind.has_antag_datum(/datum/antagonist/siege/siege_lord)
	if(!lord)
		return

	if(!istype(SSticker.mode, /datum/game_mode/siege))
		to_chat(src, "Эх... незачем...")
		return
	var/datum/game_mode/siege/C = SSticker.mode

	var/turf/T = get_step(get_turf(src), dir)
	var/mob/living/target
	for(var/mob/living/i in T)
		if(target)
			to_chat(src, "Пусть они разойдутся, здесь слишком людно для этого!")
			return
		target = i
	if(!target)
		to_chat(src, "Но здесь же никого нет!")
		return
	if(!target.client || !target.mind)
		to_chat(src, "Он же безмозглый!")
		return
	if(target.mind in C.soldiers)
		to_chat(src, "Но он же уже мне верен!")
		return
	to_chat(src, "Пусть он произнесёт клятву!")
	var/oath = input(target, "Ваша клятва Лорду:", "OATH") as null|text
	if(!oath)
		alert(src, "Ваше предложение было отвергнуто.", "OATH", "Зизо!")
		return
	if(!target.client || !target.mind)
		to_chat(src, "Он же безмозглый!")
		return
	target.say(oath)
	switch(alert(src, oath, "OATH", "Достойно", "Отвергнуть"))
		if("Достойно")
			lord.ArmyAnnounce("Приветствуйте вашего нового соратника: [target.real_name]!", "КЛЯТВА ВЕРНОСТИ")
			target.mind.add_antag_datum(/datum/antagonist/siege/siege_soldier)
			to_chat(target, "<span class='boldnotice'>Вы приняты в почётные войса Лорда Хартфелта.</span>")
		if("Отвергнуть")
			to_chat(target, "Ваша клятва была отвергнута.")

/mob/living/carbon/human/proc/InitiateNewSergeant()
	set name     = "Назначить сержанта"
	set category = "LORD"
	set waitfor  = 0

	if(stat)
		return

	var/datum/antagonist/siege/siege_lord/lord = mind.has_antag_datum(/datum/antagonist/siege/siege_lord)
	if(!lord)
		return

	if(!istype(SSticker.mode, /datum/game_mode/siege))
		to_chat(src, "Эх... незачем...")
		return

	var/turf/T = get_step(get_turf(src), dir)
	var/mob/living/target
	for(var/mob/living/i in T)
		if(target)
			to_chat(src, S_SPAN("warning", "Пусть они разойдутся, здесь слишком людно для этого!"))
			return
		target = i
	if(!target)
		to_chat(src, S_SPAN("warning", "Но здесь же никого нет!"))
		return
	if(!target.client || !target.mind)
		to_chat(src, S_SPAN("warning", "Он же безмозглый!"))
		return
	var/datum/antagonist/siege/siege_soldier/S = target.mind.has_antag_datum(/datum/antagonist/siege/siege_soldier)
	if(!S)
		to_chat(src, S_SPAN("danger","Он должен быть моим солдатом!"))
		return
	to_chat(src, S_SPAN("boldnotice", "Пусть он произнесёт клятву!"))
	if(alert(src, "Вы уверены что хотите сделать [target.real_name] сержантом?", "OATH", "Да", "Нет") == "Нет")
		return
	if(alert(target, "Вы согласны стать одним из сержантов Лорда?", "OATH", "Да", "Нет") == "Нет")
		to_chat(src, S_SPAN("warning", "Отказ."))
		return
	to_chat(target, S_SPAN("boldnotice", "Теперь вы можете ответить голосам в кольце."))
	S.sergeant = TRUE

/mob/living/carbon/human/proc/DeclareATraitor()
	set name     = "Объявить предателя"
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
	var/inp = input(src, "Огласите имя солдата: ", "DEATH") as null|text
	if(!inp)
		to_chat(src, "Отмена.")
		return
	var/Statement = input(src, "Дополните притчей в назидание остальным. Поставьте точку в его службе.", "TRAITOR") as null|text
	var/mob/living/target
	for(var/datum/mind/i in C.soldiers)
		if(i.current.real_name == inp)
			target = i.current
		break
	if(!target)
		to_chat(src, "Тебе не знаком этот солдат.")
		return

	var/datum/antagonist/siege/s = target.mind.has_antag_datum(/datum/antagonist/siege/siege_soldier)
	if(!s)
		to_chat(src, "Что-то не так... Кажется это даже не мой солдат...")
		return
	s.traitor = TRUE

	if(Statement)
		lord.ArmyAnnounce("[target.real_name] был объявлен предателем.<br>[sanitize(Statement)]", "ПОЗОР")
	else
		lord.ArmyAnnounce("[target.real_name] был объявлен предателем.", "ПОЗОР")
	target.adjust_triumphs(-5)
