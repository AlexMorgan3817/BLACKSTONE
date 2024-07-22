/obj/item/scomstone
	var/channel = "generic"

/obj/item/scomstone/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	var/input_text = input(user, "Enter your message:", "Message")
	if(input_text)
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src)
		for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src)

/obj/item/scomstone/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(istype(A, /obj/item/scomstone))
		var/obj/item/scomstone/s = A
		if(s.channel != channel)
			return
	if(istype(A, /obj/structure/roguemachine/scomm))
		var/obj/structure/roguemachine/scomm/s = A
		if(s.channel != channel)
			return
	return ..()

/obj/structure/roguemachine/scomm
	var/channel = "generic"
/obj/structure/roguemachine/scomm/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(istype(A, /obj/item/scomstone))
		var/obj/item/scomstone/s = A
		if(s.channel != channel)
			return
	if(istype(A, /obj/structure/roguemachine/scomm))
		var/obj/structure/roguemachine/scomm/s = A
		if(s.channel != channel)
			return
	return ..()
/obj/item/scomstone/siege
	name = "бронзовое кольцо"
	desc = "Бронзовое кольцо с глубоко чёрным камнем, отливающим на свете Солнца. Кажется будто внутри него бегают маленькие искорки."
	icon_state = "ring_onyx"
	sellprice = 10
	channel = "siege"
	listening = FALSE

/obj/item/scomstone/siege/attack_right(mob/user)
	var/datum/antagonist/siege/s = GetSiegeAntag(user.mind)
	if(!s || !s.sergeant)
		return
	return ..()	

/obj/item/scomstone/siege/MiddleClick(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	if(user.mind)
		var/datum/antagonist/siege/s = GetSiegeAntag(user.mind)
		if(s)
			var/r = alert(user, "Чего ты хочешь?", "TALKSTONE",\
				"[speaking ? "Заглушить" : "Услышать"]",\
				"Отмена",
				"[listening ? "Исчезнуть" : "Быть услышанным"]")
			if(r == "Отмена")
				return
			if(r == "Заглушить" || r == "Услышать")
				speaking = !speaking
			else if(r == "Быть услышанным")
				if(s.sergeant)
					listening = !listening
				else
					to_chat(user, S_SPAN("warning", "Ты не достоин."))
			else
				listening = FALSE
		else
			to_chat(user, S_SPAN("info", "Кажется оно не слушает меня."))
		update_icon()

/obj/item/scomstone/siege/lord
	name = "платиновое кольцо"
	desc = "Платиновое кольцо с чистым сапфиром."
	sellprice = 50
	icon_state = "ring_sapphire"
