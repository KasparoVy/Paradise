/*
This file contains the base-level procs for visible internal organs and the generation of their onmob icon generation.
These procs contain the basic functions required to render a visible internal organ and should be made as much use of
as possible when adjusting behaviours on an organ-by-organ basis.
*/
/obj/item/organ/internal
	var/intorgan_visible = FALSE //TRUE if the organ will be rendered on the owner mob.
	species_fit = null //Species to fit onmob icon to when the organs are rendered. If the species isn't here, use the generic fit.
	var/list/species_fit_states = null //Instantiated for visible intorgans.
	var/render_layer = -INTORGAN_LAYER //Will be different if eyes are shining to ensure they render above light.
	var/render_plane = null //Will only be set when eyes are shining to ensure they render above light.
	var/icon/onmob_icon = null //Holds the generated onmob icon for visible intorgans.

/obj/item/organ/internal/proc/update_appearance(mob/living/carbon/human/HA, regenerate = TRUE) //Handles updating an organ's appearance when rendered. Updates the cached appearance properties used in icon generation.
	if(!intorgan_visible)
		return
	//Here, though, we're only going to to the basic qualification & pre-flight checks that'll be shared by most visible intorgans.
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	return H.get_organ(check_zone(parent_organ)) //Preflight complete, send parent organ for further organ-specific evaluation in child procs.

/*Generate the icon based on cached properties. Handle species fitting. This proc should only be called via ..(fit_this_species, new_icon_state) from children.
new_icon_state will be different for each visible intorgan and is reliant on other properties, i.e. dna.species.eyes or dna.species.ears*/
/obj/item/organ/internal/proc/generate_icon(datum/species/fit_this_species, new_icon_state)
	if(!(intorgan_visible && new_icon_state))
		return
	var/onmob_icon_state = new_icon_state
	if(istype(fit_this_species) && fit_this_species.name != dna.species.name) //If it's a different species, fit it. If it's the same as our DNA spacies, use standard generation.
		if(!(LAZYLEN(species_fit) && LAZYLEN(species_fit_states))) //Invalid parameters. Abort, abort!
			return
		if(fit_this_species.name in species_fit)
			onmob_icon_state = species_fit_states[fit_this_species.name]
		else if("Generic" in species_fit)
			onmob_icon_state = species_fit_states["Generic"]

	var/icon/onmob_icon_file = new /icon('icons/mob/human_face.dmi')
	if(onmob_icon_state in onmob_icon_file.IconStates()) //If a valid icon state isn't detected, don't update the onmob_icon. Non-TRUE return is all the indication needed down the line.
		onmob_icon = new /icon(onmob_icon_file, onmob_icon_state)
		return TRUE

/obj/item/organ/internal/proc/can_render() //Basic conditions required for a visible internal organ to render. Should be called via ..() in child proc.
	if(intorgan_visible)
		return TRUE
	//Further validation should be done after this in the child proc unless this is all that's required (i.e. aug eyes).

/obj/item/organ/internal/proc/render(var/icon/icon_override = null) //Finally return the MA using the compiled icon. Icon override is only passed by children calling this proc after doing final adjustments in their render().
	var/mutable_appearance/MA = mutable_appearance((icon_override ? icon_override : onmob_icon), layer = render_layer)
	if(render_plane)
		MA.plane = render_plane
	. = MA

/obj/item/organ/external/proc/render_visible_intorgans() //Compile a list of overlays from rendered visible organs internal to this external organ.
	var/list/overlays_to_apply = list()
	for(var/obj/item/organ/internal/visible_intorgan in internal_organs) //Trigger onmob appearance property updates for eligible visible intorgans.
		if(visible_intorgan.intorgan_visible && visible_intorgan.can_render())
			overlays_to_apply += visible_intorgan.render()
	return overlays_to_apply
