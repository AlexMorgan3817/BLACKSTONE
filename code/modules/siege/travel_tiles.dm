/obj/structure/fluff/traveltile/siegespawn/can_go(atom/movable/AM)
	to_chat(AM, "<b>It is a dead end.</b>")
	return FALSE

/obj/structure/fluff/traveltile
	var/nutrition_cost_min = 75 // PERCENT nutrition_cost_min = 100 => 100% of nutrition
	var/nutrition_cost_max = 95 // PERCENT
	var/hydration_cost_min = 75 // PERCENT
	var/hydration_cost_max = 95 // PERCENT

/obj/structure/fluff/traveltile/travel_to(mob/living/L, obj/structure/fluff/traveltile/T)
	. = ..()
	if(istype(L.buckled, /mob/living/simple_animal/hostile/retaliate/rogue/saiga))
		return
	if(nutrition_cost_max != 0)
		var/r = rand(nutrition_cost_min, nutrition_cost_max) / 100
		L.set_nutrition(L.nutrition * r)
	if(hydration_cost_max != 0)
		L.set_hydration(L.hydration * rand(hydration_cost_min, hydration_cost_max) / 100)

/obj/structure/fluff/traveltile/siege
	nutrition_cost_min = 30
	nutrition_cost_max = 50
	hydration_cost_min = 30
	hydration_cost_max = 50

/obj/structure/fluff/traveltile/siege/can_go(atom/movable/AM)
	. = ..()
	if(!. || !isliving(AM))
		return
	var/mob/living/M = AM
	if(!M.mind)
		return FALSE
	var/datum/game_mode/siege/C = SSticker.mode
	if(istype(C))
		if(C.war_declared)
			return .
		var/datum/antagonist/siege/S = GetSiegeAntag(M.mind)
		if(S)
			if(S.can_leave_camp_before_declaration)
				return .
			to_chat(M, S_SPAN("boldnotice", "Мы не можем атаковать без надлежащей подготовки, Лорд должен объявить о своих намерениях королю, иначе это бесчестно."))
	to_chat(M, "<b>Тупик.</b>")
	return FALSE
