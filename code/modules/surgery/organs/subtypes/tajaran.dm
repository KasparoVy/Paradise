/obj/item/organ/internal/liver/tajaran
	alcohol_intensity = 1.4

/obj/item/organ/internal/eyes/tajaran
	name = "tajaran eyeballs"
	colourblind_matrix = MATRIX_TAJ_CBLIND //The colour matrix and darksight parameters that the mob will recieve when they get the disability.
	replace_colours = LIST_TAJ_REPLACE
	dark_view = 8

/obj/item/organ/internal/eyes/tajaran/farwa //Being the lesser form of Tajara, Farwas have an utterly incurable version of their colourblindness.
	name = "farwa eyeballs"
	colourmatrix = MATRIX_TAJ_CBLIND
	dark_view = 8
	replace_colours = LIST_TAJ_REPLACE

/obj/item/organ/internal/ears/visible/tajaran
	name = "tajaran ears"
	desc = "Fuzzy."
	species_fit = list("Generic", "Vox", "Grey", "Drask")
	species_fit_states = list("Generic" = "taj_ears_s", "Vox" = "vox_fitted_taj_ears_s", "Grey" = "grey_fitted_taj_ears_s", "Drask" = "drask_fitted_taj_ears_s")
