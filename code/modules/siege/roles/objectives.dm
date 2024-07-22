/datum/objective/siege_lord_must_survive
	name = "Сохранить Лорда"
	explanation_text = "Лорд Хартфелта должен дожить до конца."
	triumph_count = 1

/datum/objective/siege_lord_must_survive/check_completion()
	if(!istype(SSticker.mode, /datum/game_mode/siege))
		return FALSE
	var/datum/game_mode/siege/C = SSticker.mode
	if(considered_alive(C.Lord))
		return TRUE

/datum/objective/siege_lord_conquer
	name = "Завоевать Энигму"
	explanation_text = "Я должен сесть на трон Рокхилла и издать манифест о моей коронации указом."
	triumph_count = 4

/datum/objective/siege_lord_conquer/check_completion()
	if(!istype(SSticker.mode, /datum/game_mode/siege))
		return FALSE
	var/datum/game_mode/siege/C = SSticker.mode
	if(C.EnigmaIsOnHerKnees)
		return TRUE

/datum/objective/siege_lord_conquer/soldier
	explanation_text = "Мой Лорд должен сесть на трон Рокхилла и огласить манифест своего правления указом."
	triumph_count = 1
/datum/objective/siege_lord_conquer/soldier/check_completion()
	var/datum/antagonist/siege/siege_soldier/S = owner.has_antag_datum(/datum/antagonist/siege/siege_soldier)
	return ..() && !S.traitor

/datum/objective/siege_lord_conquer/soldier/hand
	explanation_text = "Мой Лорд должен сесть на трон Рокхилла и огласить манифест своего правления указом."
	triumph_count = 3