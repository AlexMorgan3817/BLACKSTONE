/datum/game_mode/siege
	var/list/mob/dead/new_player/enforcement_queue = list()
	var/list/mob/dead/new_player/siege_win_lookers = list()
	var/enforcement_queue_size = 5
	var/enforcement_queue_min = 5
	var/enforcement_time = 100 SECONDS
	#ifdef FASTLOAD
	enforcement_queue_min = 1
	enforcement_time = 5 SECONDS
	#endif
	var/enforcement_timer_id
	var/enforcement_next_cycle = 0
	post_setup()
		. = ..()
		CycleReleaseQueue()
	proc/CycleReleaseQueue()
		enforcement_timer_id = addtimer(CALLBACK(src, PROC_REF(CycleReleaseQueue)), enforcement_time)
		enforcement_next_cycle = world.time + enforcement_time
		if(length(enforcement_queue) == 0)
			return
		if(length(enforcement_queue) >= enforcement_queue_min)
			for(var/mob/dead/new_player/i in enforcement_queue)
				close_siege_win(i)
				unqueue_player(i, TRUE)
				i.AttemptLateSpawn("Pilgrim")
			post_siege_win_update()

	proc/collect_enforcement_data(mob/dead/new_player/np)
		var/names = ""
		for(var/mob/dead/new_player/n in enforcement_queue)
			if(!n.client?.prefs)
				continue
			names += "✠ [n.client.prefs.real_name] ✠<br>"
		var/t = ceil((enforcement_next_cycle - world.time) / 10)
		return {"<style>
		html{box-shadow: inset 0 0 16px 2px #aa0000; height: 100%;}
		.uiTitleWrapper{box-shadow: 0 0px 128px 1px #600;border-top: 2px solid #600;border-left: 2px solid #600;border-right: 2px solid #600;}
		a{position: absolute; left: 0; right:0; background: transparent !important; border: none !important}
		</style>
		<div style="margin: 32px 1px; white-space: nowrap; text-align: center">
			<span id='nextwave'>[t]</span><br>
			<a href='byond://?src=[REF(np)];SiegeSpawn=1' style='top: 48px'>ПРИСОЕДИНИТЬСЯ ([enforcement_queue.len] / [enforcement_queue_size])</a>
			[names]
			<a href='byond://?src=[REF(np)];SiegeSpawn=-1' style='bottom: 16px'>ПОКИНУТЬ</a>
		</div>
		<script>var time = [t];var nextwave = document.getElementById("nextwave");setInterval(function(){--time; if(time <= 0) time = [enforcement_time/10];
			nextwave.innerHTML = time;}, 1000);
		</script>"}

	proc/update_siege_win(mob/dead/new_player/np)
		siege_win_lookers |= np
		if(!np.siege_window)
			np.siege_window = new(np, "siege_window", "SIEGE", 300, enforcement_queue_size * 100)
			np.siege_window.set_window_options("can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0;")
		np.siege_window.set_content(collect_enforcement_data(np))
		np.siege_window.open()

	proc/close_siege_win(mob/dead/new_player/np)
		if(!np.siege_window)
			return
		np.siege_window.close()

	proc/post_siege_win_update()
		for(var/i in siege_win_lookers)
			update_siege_win(i)
	proc/queue_player(mob/dead/new_player/np)
		siege_win_lookers |= np
		if(enforcement_queue.len >= enforcement_queue_size && !(ckey(np.key) in GLOB.admin_datums))
			update_siege_win(np)
			return FALSE
		else
			enforcement_queue |= np
			post_siege_win_update()
			return TRUE

	proc/unqueue_player(mob/dead/new_player/np, silent = FALSE)
		enforcement_queue -= np
		if(!silent)
			post_siege_win_update()
		return TRUE

/mob/dead/new_player/var/datum/browser/noclose/siege_window

/mob/dead/new_player/Logout()
	. = ..()
	if(!istype(SSticker.mode, /datum/game_mode/siege))
		return
	var/datum/game_mode/siege/S = SSticker.mode
	if(src in S.enforcement_queue)
		S.unqueue_player(src)
	if(src in S.siege_win_lookers)
		S.siege_win_lookers -= src

/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr || !client)
		return 0
	if(href_list["SiegeSpawn"] == "-1")
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			to_chat(src, S_SPAN("danger", "Чего?"))
			return
		var/datum/game_mode/siege/S = SSticker.mode
		if(S.unqueue_player(src))
			to_chat(src, S_SPAN("notice", "Лорд больше не ждёт вас. ([S.enforcement_queue.len] / [S.enforcement_queue_size])"))
			return
		return
	if(href_list["SiegeSpawn"] == "1")
		if(!SSticker?.IsRoundInProgress())
			to_chat(src, S_SPAN("danger", "Раунд или не начат или уже закончен..."))
			return
		if(!GLOB.enter_allowed)
			to_chat(src, S_SPAN("notice", "Сейчас вход в игру заблокирован."))
			return
		if(!istype(SSticker.mode, /datum/game_mode/siege))
			to_chat(src, S_SPAN("danger", "Чего?"))
			return
		var/datum/game_mode/siege/S = SSticker.mode
		var/pq = get_playerquality(ckey, FALSE)
		if(!S.Lord && pq >= S.LordPQReq)
			AttemptLateSpawn("Adventurer")
			return
		#ifndef FASTLOAD
		if(!S.Hand && pq >= S.HandPQReq)
			AttemptLateSpawn("Adventurer")
			return
		#endif
		// #ifndef GOD_ASTRATA
		// if(S.Lord && S.Hand && S.enforcement_agenda.len == 0)
		// #else
		// if(S.Lord && S.Hand && S.enforcement_agenda.len == 0 && !CheckDonation(key, "Adventurer"))
		// #endif
		// 	to_chat(src, S_SPAN("danger", "Лорд ещё не выбрал кто ему нужен."))
		// 	return
		if(S.queue_player(src))
			to_chat(src, S_SPAN("boldnotice", "Скоро придёт ваше время. ([S.enforcement_queue.len] / [S.enforcement_queue_size])"))
		else
			to_chat(src, S_SPAN("warning", "Потерпи, время ещё придёт... ([S.enforcement_queue.len] / [S.enforcement_queue_size])"))
		return
	return ..()