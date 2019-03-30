/datum/scream //Global list is referred to by GLOB.all_screams["scream_name_here"] or ... in GLOB.all_screams.
	var/name					= null	//Should be appropriate.
	var/sound_male				= 'sound/effects/mob_effects/malescream1.ogg' 	//Sound filepath. Scream defaults to this if gender is anything but female.
	var/sound_female			= 'sound/effects/mob_effects/femalescream1.ogg'	//These vars have defaults in the event that a scream is added without a gender counterpart.
	var/volume					= 80	//Number from 0-100.
	var/list/species_restricted	= list("Vox", "Drask", "Machine", "Monkey", "Farwa", "Wolpin", "Neara", "Stok", "Abductor")	//If initialized, make sure this species can't pick this scream.
	var/list/species_allowed	= null	//If initialized, make sure only these species can pick this scream.
	var/verb_override			= null	//If initialized, override the scream verb from species with this.

/datum/scream/default //The Goon Special.
	name						= "Default"

/datum/scream/classic //Timeless and earsplitting. Does anyone remember?
	name						= "Classic"
	sound_male					= 'sound/voice/scream2.ogg'
	sound_female				= 'sound/voice/scream2.ogg'

/datum/scream/alt_1
	name						= "Alt. 1"
	sound_male					= 'sound/effects/mob_effects/malescream2.ogg'
	sound_female				= 'sound/effects/mob_effects/femalescream2.ogg'

/datum/scream/alt_2
	name						= "Alt. 2"
	sound_male					= 'sound/effects/mob_effects/malescream3.ogg'
	sound_female				= 'sound/effects/mob_effects/femalescream3.ogg'

/datum/scream/alt_3
	name						= "Alt. 3"
	sound_male					= 'sound/effects/mob_effects/malescream4.ogg'
	sound_female				= 'sound/effects/mob_effects/femalescream4.ogg'

/datum/scream/alt_4
	name						= "Alt. 4"
	sound_male					= 'sound/effects/mob_effects/malescream5.ogg'
	sound_female				= 'sound/effects/mob_effects/femalescream5.ogg'

/datum/scream/alt_5
	name						= "Alt. 5"
	sound_male					= 'sound/effects/mob_effects/malescream6.ogg'
	sound_female				= 'sound/effects/mob_effects/femalescream6.ogg'

/datum/scream/vox //SCREE!
	name						= "Shriek"
	sound_male					= 'sound/voice/shriek1.ogg'
	sound_female				= 'sound/voice/shriek1.ogg'
	species_restricted			= null
	species_allowed				= list("Vox")

/datum/scream/drask //Whale.
	name						= "Drone"
	sound_male					= 'sound/voice/drasktalk2.ogg'
	sound_female				= 'sound/voice/drasktalk2.ogg'
	species_restricted			= null
	species_allowed				= list("Drask")

/datum/scream/yelp //Yep, that's a fox.
	name						= "Yelp"
	sound_male					= 'sound/voice/vulp_yelp.ogg'
	sound_female				= 'sound/voice/vulp_yelp.ogg'
	species_allowed				= list("Vulpkanin")

/datum/scream/chimp //Bananas man.
	name						= "Chimp"
	sound_male					= 'sound/goonstation/voice/monkey_scream.ogg'
	sound_female				= 'sound/goonstation/voice/monkey_scream.ogg'
	species_restricted			= null
	species_allowed				= list("Monkey", "Farwa", "Wolpin", "Neara", "Stok")

/datum/scream/abductor //Unisex, only male.
	name						= "Abductor"
	sound_female				= 'sound/effects/mob_effects/malescream1.ogg'
	species_restricted			= null
	species_allowed				= list("Abductor")

/datum/scream/robot //I have speakers with which I shall scream.
	name						= "Robot"
	sound_male					= 'sound/goonstation/voice/robot_scream.ogg'
	sound_female				= 'sound/goonstation/voice/robot_scream.ogg'
	species_restricted			= null
	species_allowed				= list("Machine")

/mob/living/carbon/human/proc/reset_scream()
	dna.species.scream_voice = (dna.species.default_scream in GLOB.all_screams) ? dna.species.default_scream : "Default"
	update_dna()

/mob/living/carbon/human/proc/change_scream(var/new_scream, var/update_dna = TRUE)
	dna.species.scream_voice = new_scream
	if(update_dna)
		update_dna()
	return TRUE

/mob/living/carbon/human/proc/get_scream()
	if(!(dna.species.scream_voice in GLOB.all_screams)) //Invalid scream? Return species or global default.
		reset_scream()
	return GLOB.all_screams[dna.species.scream_voice]

/datum/species/proc/get_valid_screams(var/index_by_name = FALSE) //Returns a list of screams members of the species can use.
	var/list/valid_screams = list()
	for(var/S in GLOB.all_screams)
		var/datum/scream/aieee = GLOB.all_screams[S]
		if(!aieee || !aieee.name)
			continue
		if(LAZYLEN(aieee.species_restricted) && (name in aieee.species_restricted))
			continue
		if(LAZYLEN(aieee.species_allowed) && !(name in aieee.species_allowed))
			continue

		if(index_by_name)
			valid_screams[aieee.name] += aieee
		else
			valid_screams += aieee

	return valid_screams

/datum/scream/proc/get_sound(var/gender) //Fetch the sound, considering gender.
	return gender == FEMALE ? sound_female : sound_male

/datum/scream/proc/test(var/atom/play_to, var/gender, var/age)
	var/sound/aaa = sound(get_sound(gender), wait = 0, channel = 0 || open_sound_channel(), volume = volume)
	aaa.frequency = 1.0 + ((0.5 * (30 - age)) * 0.0125) // * 0.0125 is the same as dividing by 80, but we don't do that cuz wierd difference in performance.
	SEND_SOUND(play_to, aaa) //For the individual player's ears only. Don't want everyone hearing you scream before getting on station
