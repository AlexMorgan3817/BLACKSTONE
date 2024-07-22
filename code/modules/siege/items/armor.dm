/obj/item/clothing/cloak/stabard/siege
	desc = "A tabard with the lord's heraldic colors."
	color = CLOTHING_RED
	detail_tag = "_spl"
	detail_color = CLOTHING_PURPLE

/obj/item/clothing/cloak/stabard/siege/Initialize()
	..()
	var/datum/game_mode/siege/S = SSticker.mode
	if(!istype(S) || S.Lord == null)
		return
	var/datum/antagonist/siege/siege_lord/lord = S.Lord.has_antag_datum(/datum/antagonist/siege)
	if(lord.color_selected)
		lordcolor(S.prime_color,S.secondary_color)
	else
		GLOB.siege_lord_color += src

/obj/item/clothing/cloak/stabard/siege/Destroy()
	GLOB.siege_lord_color -= src
	return ..()

/obj/item/clothing/cloak/stabard/siege/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		var/c = get_detail_color()
		if(c) pic.color = c
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/siege/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
