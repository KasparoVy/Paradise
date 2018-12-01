//DRASK ORGAN
/obj/item/organ/internal/drask
	name = "drask organ"
	icon = 'icons/obj/surgery_drask.dmi'
	icon_state = "innards"
	desc = "A greenish, slightly translucent organ. It is extremely cold."

/obj/item/organ/internal/heart/drask
	name = "drask heart"
	icon = 'icons/obj/surgery_drask.dmi'
	parent_organ = "head"

/obj/item/organ/internal/liver/drask
	name = "metabolic strainer"
	icon = 'icons/obj/surgery_drask.dmi'
	icon_state = "kidneys"
	alcohol_intensity = 0.8

/obj/item/organ/internal/brain/drask
	icon = 'icons/obj/surgery_drask.dmi'
	icon_state = "brain2"
	mmi_icon = 'icons/obj/surgery_drask.dmi'
	mmi_icon_state = "mmi_full"

/obj/item/organ/internal/eyes/drask
	name = "drask eyeballs"
	icon = 'icons/obj/surgery_drask.dmi'
	desc = "Drask eyes. They look even stranger disembodied."
	dark_view = 5

	species_fit = list("Generic", "Vox", "Grey")
	species_fit_states = list("Generic" = "generic_fitted_drask_eyes_s", "Vox" = "vox_fitted_drask_eyes_s", "Grey" = "grey_fitted_drask_eyes_s")
