/obj/item/organ/internal/liver/grey
	alcohol_intensity = 1.6

/obj/item/organ/internal/brain/grey
	icon_state = "brain-x"
	mmi_icon_state = "mmi_alien"

/obj/item/organ/internal/brain/grey/insert(var/mob/living/carbon/M, var/special = 0)
	..()
	M.add_language("Psionic Communication")

/obj/item/organ/internal/brain/grey/remove(var/mob/living/carbon/M, var/special = 0)
	. = ..()
	M.remove_language("Psionic Communication")

/obj/item/organ/internal/eyes/grey
	name = "grey eyeballs"
	dark_view = 5
	desc = "Large and unsettling, they look eerily curious even disembodied."

	species_fit = list("Generic", "Vox", "Drask", "Kidan")
	species_fit_states = list("Generic" = "generic_fitted_grey_eyes_s", "Vox" = "vox_fitted_grey_eyes_s", "Drask" = "drask_fitted_grey_eyes_s", "Kidan" = "kidan_fitted_grey_eyes_s")
