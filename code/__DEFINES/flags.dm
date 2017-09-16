//FLAGS BITMASK
#define STOPSPRESSUREDMAGE 		1		//This flag is used on the flags variable for SUIT and HEAD items which stop pressure damage. Note that the flag 1 was previous used as ONBACK, so it is possible for some code to use (flags & 1) when checking if something can be put on your back. Replace this code with (inv_flags & SLOT_BACK) if you see it anywhere To successfully stop you taking all pressure damage you must have both a suit and head item with this flag.
#define NODROP					2		// This flag makes it so that an item literally cannot be removed at all, or at least that's how it should be. Only deleted.
#define NOBLUDGEON  			4		// when an item has this it produces no "X has been hit by Y with Z" message with the default handler
#define AIRTIGHT				8		// mask allows internals
#define HANDSLOW        		16		// If an item has this flag, it will slow you to carry it
#define CONDUCT					32		// conducts electricity (metal etc.)
#define ABSTRACT				64		// for all things that are technically items but used for various different stuff, made it 128 because it could conflict with other flags other way
#define ON_BORDER				128		// item has priority to check when entering or leaving

#define EARBANGPROTECT			1024

#define NOSLIP					1024 	//prevents from slipping on wet floors, in space etc

#define HEADBANGPROTECT			4096

#define OPENCONTAINER			4096	// is an open container for chemistry purposes

#define BLOCK_GAS_SMOKE_EFFECT	8192	// blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY!
#define THICKMATERIAL 			8192	//prevents syringes, parapens and hypos if the external suit or helmet (if targeting head) has this flag. Example: space suits, biosuit, bombsuits, thick suits that cover your body. (NOTE: flag shared with BLOCK_GAS_SMOKE_EFFECT)

//Reagent flags
#define REAGENT_NOREACT			1

//Species clothing flags
#define HAS_UNDERWEAR 	1
#define HAS_UNDERSHIRT 	2
#define HAS_SOCKS		4

//Species Body Flags
#define HAS_HEAD_ACCESSORY	1
#define HAS_SKIN_TONE 		2
#define HAS_ICON_SKIN_TONE	4
#define HAS_SKIN_COLOR		8
#define HAS_HEAD_MARKINGS	16
#define HAS_BODY_MARKINGS	32
#define HAS_TAIL_MARKINGS	64
#define HAS_MARKINGS		HAS_HEAD_MARKINGS|HAS_BODY_MARKINGS|HAS_TAIL_MARKINGS
#define NO_EYES				128
#define ALL_RPARTS			256

//Species Diet Flags
#define DIET_CARN		1
#define DIET_OMNI		2
#define DIET_HERB		4


//bitflags for door switches.
#define OPEN	1
#define IDSCAN	2
#define BOLTS	4
#define SHOCK	8
#define SAFE	16

//flags for pass_flags
#define PASSTABLE		1
#define PASSGLASS		2
#define PASSGRILLE		4
#define PASSBLOB		8
#define PASSMOB			16
#define LETPASSTHROW	32

//turf-only flags
#define NOJAUNT		1

//ITEM INVENTORY SLOT BITMASKS
#define SLOT_OCLOTHING 1
#define SLOT_ICLOTHING 2
#define SLOT_GLOVES 4
#define SLOT_EYES 8
#define SLOT_EARS 16
#define SLOT_MASK 32
#define SLOT_HEAD 64
#define SLOT_FEET 128
#define SLOT_ID 256
#define SLOT_BELT 512
#define SLOT_BACK 1024
#define SLOT_POCKET 2048		//this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET 4096	//this is to deny items with a w_class of 2 or 1 to fit in pockets.
#define SLOT_TWOEARS 8192
#define SLOT_PDA 16384
#define SLOT_TIE 32768

//ORGAN TYPE FLAGS
#define AFFECT_ROBOTIC_ORGAN	1
#define AFFECT_ORGANIC_ORGAN	2
#define AFFECT_ALL_ORGANS		3
