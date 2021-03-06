/datum/targetable/spell/doppelganger
	name = "Doppelganger"
	desc = "Creates a clone of you while temporarily making you undetectable. The clone keeps moving in whatever direction you were facing when you cast the spell."
	icon_state = "doppelganger"
	targeted = 0
	cooldown = 300
	requires_robes = 1
	restricted_area_check = 1

	cast()
		if(!holder)
			return
		var/the_dir = holder.owner.dir
		var/ground = 0

		if (!isturf(holder.owner.loc))
			return 1

		ground = holder.owner.lying

		var/obj/overlay/P = new/obj/overlay()
		P.name = holder.owner.name
		P.icon = holder.owner.icon
		P.icon_state = holder.owner.icon_state
		P.set_density(1)
		P.desc = "Wait ... that's not [P.name]!!!"

		var/obj/dummy/spell_doppel/D = new/obj/dummy/spell_doppel()

		for(var/X in holder.owner.overlays)
			var/image/I = X
			P.overlays += I

		holder.owner.say("GIN EMUS") // ^-- No speech bubble.
		var/mob/living/carbon/human/O = holder.owner
		if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
			playsound(holder.owner.loc, "sound/voice/wizard/DopplegangerGrim.ogg", 50, 0, -1)
		else if(holder.owner.gender == "female")
			playsound(holder.owner.loc, "sound/voice/wizard/DopplegangerFem.ogg", 50, 0, -1)
		else
			playsound(holder.owner.loc, "sound/voice/wizard/DopplegangerLoud.ogg", 50, 0, -1)

		var/turf/curr_turf = get_turf(holder.owner)

		P.dir = the_dir
		P.set_loc(curr_turf)
		D.set_loc(curr_turf)
		holder.owner.set_loc(D)

		if(!ground)
			SPAWN_DBG(0)
				while(P)
					step(P, the_dir)
					sleep(2)

		SPAWN_DBG(100)
			holder.owner.set_loc(D.loc)
			qdel(D)
			qdel(P)

/obj/dummy/spell_doppel
	name = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	invisibility = 100
	var/can_move = 1
	mouse_opacity = 0
	density = 0
	anchored = 1

/obj/dummy/spell_doppel/relaymove(var/mob/user, direction)
	if (!src.can_move) return

	var/turf/newloc = get_step(src, direction)
	if (newloc.density) return

	switch(direction)
		if(NORTH)
			src.y++
		if(SOUTH)
			src.y--
		if(EAST)
			src.x++
		if(WEST)
			src.x--
		if(NORTHEAST)
			src.y++
			src.x++
		if(NORTHWEST)
			src.y++
			src.x--
		if(SOUTHEAST)
			src.y--
			src.x++
		if(SOUTHWEST)
			src.y--
			src.x--

	src.can_move = 0
	SPAWN_DBG(2) src.can_move = 1
