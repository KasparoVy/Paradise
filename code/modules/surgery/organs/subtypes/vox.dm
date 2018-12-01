/obj/item/organ/internal/liver/vox
	alcohol_intensity = 1.6

/obj/item/organ/internal/stack
	name = "cortical stack"
	icon_state = "cortical-stack"
	parent_organ = "head"
	organ_tag = "stack"
	slot = "vox_stack"
	status = ORGAN_ROBOT
	vital = TRUE
	var/stackdamaged = FALSE

/obj/item/organ/internal/stack/on_life()
	if(damage < 1 && stackdamaged)
		owner.mutations.Remove(SCRAMBLED)
		owner.dna.SetSEState(SCRAMBLEBLOCK,0)
		genemutcheck(owner,SCRAMBLEBLOCK,null,MUTCHK_FORCED)
		stackdamaged = FALSE
	..()

/obj/item/organ/internal/stack/emp_act(severity)
	if(owner)
		owner.mutations.Add(SCRAMBLED)
		owner.dna.SetSEState(SCRAMBLEBLOCK,1,1)
		genemutcheck(owner,SCRAMBLEBLOCK,null,MUTCHK_FORCED)
		owner.AdjustConfused(4)
		if(!stackdamaged)
			stackdamaged = TRUE
	..()

/obj/item/organ/internal/eyes/vox
	name = "vox eyeballs"
	desc = "Suitable for unprotected forays into the void."

	species_fit = list("Generic", "Grey", "Drask", "Kidan")
	species_fit_states = list("Generic" = "eyes_s", "Grey" = "grey_fitted_eyes_s", "Drask" = "drask_fitted_eyes_s", "Kidan" = "kidan_fitted_eyes")
