/obj/item/organ/internal/ears
	name = "ears"
	icon_state = "ears"
	gender = PLURAL
	organ_tag = "ears"
	parent_organ = "head"
	slot = "ears"

	// `deaf` measures "ticks" of deafness. While > 0, the person is deaf.
	var/deaf = 0

	// `ear_damage` measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)
	var/ear_damage = 0

/obj/item/organ/internal/ears/visible //This subtype is actually rendered on the mob/head organ sprites!
	intorgan_visible = TRUE
	var/render_layer = -INTORGAN_LAYER
	var/icon/ears_icon = null
	var/ears_tone = null
	var/ears_colour = "#000000"

/obj/item/organ/internal/ears/visible/update_appearance(mob/living/carbon/human/HA, regenerate = TRUE) //Update the cached appearance properties used in icon generation.
	var/obj/item/organ/external/head/PO = ..() //Offload preflight checks and fetching of parent organ to the parent proc since its logic should be shared by most visible intorgans.
	if(istype(PO)) //If there's a parent organ present in our current host, fetch the icon and colour/tone we'll be using.
		if(!isnull(PO.s_tone))
			ears_tone = PO.s_tone
		else if(PO.s_col)
			ears_colour = PO.s_col

	if(regenerate)
		var/datum/species/new_species = null
		if(istype(PO) && dna.species.name != PO.dna.species.name)
			new_species = PO.dna.species
		generate_icon(new_species)

/obj/item/organ/internal/ears/visible/generate_icon(datum/species/species_override) //Compile the icon using the cached appearance properties we fetched in update_appearance().
	var/ears_icon_state = ..(species_override, dna.species.ears) //Offload species_fitting to the parent proc since its logic should be shared by most visible intorgans.
	ears_icon = new /icon('icons/mob/human_face.dmi', ears_icon_state)
	if(!isnull(ears_tone))
		if(ears_tone >= 0)
			ears_icon.Blend(rgb(ears_tone, ears_tone, ears_tone), ICON_ADD)
		else
			ears_icon.Blend(rgb(-ears_tone, -ears_tone, -ears_tone), ICON_SUBTRACT)
	else
		ears_icon.Blend(ears_colour, ICON_ADD)

/obj/item/organ/internal/ears/visible/can_render(mob/living/carbon/human/HA)
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	if(!H || (H.head && (H.head.flags & BLOCKHAIR)) || (H.wear_mask && (H.wear_mask.flags & BLOCKHAIR))) //Hidden in the same way as head accessories/hair/facial hair. Prevents wierd sprite parts sticking out of helmets.
		return FALSE
	return TRUE

/obj/item/organ/internal/ears/visible/render()
	. = mutable_appearance(ears_icon, layer = render_layer) //Finally return the MA using the compiled icon.

/obj/item/organ/internal/ears/on_life()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/C = owner
	// genetic deafness prevents the body from using the ears, even if healthy
	if(C.disabilities & DEAF)
		deaf = max(deaf, 1)
	else
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			if((H.l_ear && H.l_ear.flags_2 & HEALS_EARS_2) || (H.r_ear && H.r_ear.flags_2 & HEALS_EARS_2))
				deaf = max(deaf - 1, 1)
				ear_damage = max(ear_damage - 0.10, 0)
		// if higher than UNHEALING_EAR_DAMAGE, no natural healing occurs.
		if(ear_damage < UNHEALING_EAR_DAMAGE)
			ear_damage = max(ear_damage - 0.05, 0)
			deaf = max(deaf - 1, 0)

/obj/item/organ/internal/ears/proc/RestoreEars()
	deaf = 0
	ear_damage = 0

	var/mob/living/carbon/C = owner
	if(istype(C) && C.disabilities & DEAF)
		deaf = 1

/obj/item/organ/internal/ears/proc/AdjustEarDamage(ddmg, ddeaf)
	ear_damage = max(ear_damage + ddmg, 0)
	deaf = max(deaf + ddeaf, 0)

/obj/item/organ/internal/ears/proc/MinimumDeafTicks(value)
	deaf = max(deaf, value)

/obj/item/organ/internal/ears/surgeryize()
	RestoreEars()

// Mob procs
/mob/living/carbon/RestoreEars()
	var/obj/item/organ/internal/ears/ears = get_int_organ(/obj/item/organ/internal/ears)
	if(ears)
		ears.RestoreEars()

/mob/living/carbon/AdjustEarDamage(ddmg, ddeaf)
	var/obj/item/organ/internal/ears/ears = get_int_organ(/obj/item/organ/internal/ears)
	if(ears)
		ears.AdjustEarDamage(ddmg, ddeaf)

/mob/living/carbon/MinimumDeafTicks(value)
	var/obj/item/organ/internal/ears/ears = get_int_organ(/obj/item/organ/internal/ears)
	if(ears)
		ears.MinimumDeafTicks(value)
