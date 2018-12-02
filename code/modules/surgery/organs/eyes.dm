/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = "eyes"
	parent_organ = "head"
	slot = "eyes"

	var/eye_colour = "#000000"
	var/render_layer = -INTORGAN_LAYER //Will be different if eyes are shining to ensure they render above light.
	var/render_plane = null //Will only be set when eyes are shining to ensure they render above light.
	var/icon/eyecon = null

	species_fit = list("Vox", "Grey", "Drask", "Kidan")
	species_fit_states = list("Vox" = "vox_eyes_s", "Grey" = "grey_fitted_eyes_s", "Drask" = "drask_fitted_eyes_s", "Kidan" = "kidan_fitted_eyes")

	var/list/colourmatrix = null
	var/list/colourblind_matrix = MATRIX_GREYSCALE //Special colourblindness parameters. By default, it's black-and-white.
	var/list/replace_colours = LIST_GREYSCALE_REPLACE

	var/dependent_disabilities = null //Gets set by eye-dependent disabilities such as colourblindness so the eyes can transfer the disability during transplantation.
	var/dark_view = 2 //Default dark_view for Humans.
	var/weld_proof = null //If set, the eyes will not take damage during welding. eg. IPC optical sensors do not take damage when they weld things while all other eyes will.

/obj/item/organ/internal/eyes/update_appearance(mob/living/carbon/human/HA, regenerate = TRUE) //Update the cached appearance properties used in icon generation.
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	dna.write_eyes_attributes(src) //Writes eye colour to eye_colour from the DNA. Eye colour changes are traditionally done against the DNA, which is why this works.
	if(regenerate)
		var/obj/item/organ/external/head/PO = H.get_organ(check_zone(parent_organ))
		var/datum/species/new_species = null
		if(dna.species.name != PO.dna.species.name)
			new_species = PO.dna.species
		generate_icon(new_species)

/obj/item/organ/internal/eyes/generate_icon(datum/species/species_override)
	var/eyecon_state = dna.species.eyes
	if(istype(species_override) && species_override.name != dna.species.name) //If it's a different species, fit it. If it's the same as our DNA spacies, use standard generation.
		if(species_override.name in species_fit)
			eyecon_state = species_fit_states[species_override.name]
		else if("Generic" in species_fit)
			eyecon_state = species_fit_states["Generic"]

	eyecon = new /icon('icons/mob/human_face.dmi', eyecon_state) //Fit the eyes to the species. They maintain their characteristics but are rendered with more appropriate sprites.
	eyecon.Blend(eye_colour, ICON_ADD)

/obj/item/organ/internal/eyes/can_render(mob/living/carbon/human/HA)
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	var/obj/item/organ/internal/cyberimp/eyes/eye_implant = H.get_int_organ(/obj/item/organ/internal/cyberimp/eyes)
	if(istype(eye_implant)) //Only render our special eyes and hide our less specail ones.
		return FALSE
	return TRUE

/obj/item/organ/internal/eyes/proc/get_colourmatrix() //Returns a special colour matrix if the eyes are organic and the mob is colourblind, otherwise it uses the current one.
	if(!is_robotic() && owner.disabilities & COLOURBLIND)
		return colourblind_matrix
	else
		return colourmatrix

/obj/item/organ/internal/eyes/proc/get_dark_view() //Returns dark_view (if the eyes are organic) for see_invisible handling in species.dm to be autoprocessed by life().
	return dark_view

/obj/item/organ/internal/eyes/proc/can_shine(mob/living/carbon/human/HA) //Used to determine whether we adjust layers/planes when rendering.
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	if(!get_location_accessible(H, "eyes"))
		return FALSE
	if(is_robotic() || (dark_view > EYE_SHINE_THRESHOLD) || (XRAY in H.mutations)) //Eyes shine if they are synth, great at darksight, or if the host has XRAY vision.
		return TRUE

/obj/item/organ/internal/eyes/render(mob/living/carbon/human/HA)
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner

	var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_full_list[H.get_organ(check_zone(parent_organ)).h_style]
	var/icon/hair = new /icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")

	var/will_shine = can_shine(H)
	var/L = will_shine ? (LIGHTING_LAYER + 1) : render_layer //If the eyes will shine, render using a different layer.
	var/mutable_appearance/MA = mutable_appearance(get_icon_difference(eyecon, hair), layer = L) //Use the above hair business to 'cut' the hair pixels out of the eye icon. This has the effect of the hair hiding the eyes, even when they shine.
	if(will_shine)
		MA.plane = LIGHTING_PLANE
	. = MA //Finally return the MA using the compiled icon.

/obj/item/organ/internal/eyes/insert(mob/living/carbon/human/M, special = 0) //Species-fitting eyes before rendering is handled here.
	..()
	if(istype(M) && eye_colour)
		var/obj/item/organ/external/head/PO = M.get_organ(check_zone(parent_organ)) //Fetch the head, we're checking the species!
		if(istype(PO) && PO.dna)
			generate_icon(PO.dna.species) //Species-fit the eyecon for less janky frankensteins.
		M.update_body() //Apply our eye colour to the target.

	if(!(M.disabilities & COLOURBLIND) && (dependent_disabilities & COLOURBLIND)) //If the eyes are colourblind and we're not, carry over the gene.
		dependent_disabilities &= ~COLOURBLIND
		M.dna.SetSEState(COLOURBLINDBLOCK,1)
		genemutcheck(M,COLOURBLINDBLOCK,null,MUTCHK_FORCED)
	else
		M.update_client_colour() //If we're here, that means the mob acquired the colourblindness gene while they didn't have eyes. Better handle it.

/obj/item/organ/internal/eyes/remove(mob/living/carbon/human/M, special = 0)
	if(!special && (M.disabilities & COLOURBLIND)) //If special is set, that means these eyes are getting deleted (i.e. during set_species())
		if(!(dependent_disabilities & COLOURBLIND)) //We only want to change COLOURBLINDBLOCK and such it the eyes are being surgically removed.
			dependent_disabilities |= COLOURBLIND
		M.dna.SetSEState(COLOURBLINDBLOCK,0)
		genemutcheck(M,COLOURBLINDBLOCK,null,MUTCHK_FORCED)
	. = ..()
	M.update_body() //Render bloody sockets.

/obj/item/organ/internal/eyes/surgeryize()
	if(!owner)
		return
	owner.CureNearsighted()
	owner.CureBlind()
	owner.SetEyeBlurry(0)
	owner.SetEyeBlind(0)

/obj/item/organ/internal/eyes/robotize()
	colourmatrix = null
	..() //Make sure the organ's got the robotic status indicators before updating the client colour.
	if(owner)
		if(eye_colour)
			owner.update_body() //Apply our eye colour to the target.
		owner.update_client_colour(0) //Since mechanical eyes give dark_view of 2 and full colour vision atm, just having this here is fine.

/obj/item/organ/internal/eyes/cybernetic
	name = "cybernetic eyes"
	icon_state = "eyes-prosthetic"
	desc = "An electronic device designed to mimic the functions of a pair of human eyes. It has no benefits over organic eyes, but is easy to produce."
	origin_tech = "biotech=4"
	status = ORGAN_ROBOT