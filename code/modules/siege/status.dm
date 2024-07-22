/datum/status_effect/buff/order_attack
	id = "order_attack"
	alert_type = /atom/movable/screen/alert/status_effect/buff/siege/AttackOrder
	effectedstats = list("speed" = 4, "strength" = 2)
	duration = 2 MINUTES

/datum/status_effect/buff/order_defence
	id = "order_defend"
	alert_type = /atom/movable/screen/alert/status_effect/buff/siege/DefenceOrder
	effectedstats = list("endurance" = 4, "constitution" = 4)
	duration = 2 MINUTES

/datum/status_effect/buff/siege_lose
	id = "siege_lose"
	alert_type = /atom/movable/screen/alert/status_effect/buff/siege/siege_lose
	effectedstats = list("strength" = -2, "speed" = -2, "endurance" = -2)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/siege
	icon = 'status.dmi'
	icon_state = "buff"
	var/overlay_state
	Initialize()
		. = ..()
		if(overlay_state)
			overlays += overlay_state

/atom/movable/screen/alert/status_effect/buff/siege/AttackOrder
	name = "В наступление!"
	desc = "Лорд приказал наступать!"
	overlay_state = "attack"

/atom/movable/screen/alert/status_effect/buff/siege/DefenceOrder
	name = "Держать оборону!"
	desc = "Лорд приказал держать строй!"
	overlay_state = "defend"

/atom/movable/screen/alert/status_effect/buff/siege/siege_lose
	name = "Поражение"
	desc = "Мы проиграли... Это конец..."
	icon_state = "debuff"
	overlay_state = "lose"

