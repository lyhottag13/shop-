class_name ItemData
extends RefCounted

const GODOT = preload("uid://clqhqtsd2nvh6")
const COTL = preload("uid://bcd5okuc6w8db")
const D_D = preload("uid://bsdofccsy45o1")
const DST = preload("uid://dig18f8j3lo6q")
const ENA = preload("uid://dit6p2c8tg2j2")
const ETG = preload("uid://bthndoo5fc4iv") 
const FALLOUT = preload("uid://1hadhc5nh548")
const HOLLOW_KNIGHT = preload("uid://b8a2qqurxtcsf")
const MINECRAFT = preload("uid://bjiwxfx6lq683")
const NEWGROUNDS = preload("uid://c7patojkmgtb8")
const PORTAL = preload("uid://l056whu88ens")
const ROBLOX = preload("uid://q5lktkebq4p")
const STARDEW_VALLEY = preload("uid://87tjoqjjgy6h")
const TBOI = preload("uid://d0ipf6sh8kiko")
const THORN_RING = preload("uid://bfigwr3617qmn")
const UNDERTALE = preload("uid://c2m5pne555rrh")
const ZOMBOID = preload("uid://bt85po1lwyedj")

static var item_data : Dictionary[String, Dictionary] = {
	godot = {
		name = "godot",
		title = "Godot",
		description = "There's something fishy about this item...",
		image = GODOT,
		dialogue = [
			{
				face = "happy",
				text = "That's an interesting-looking item.\nWhy is it here?",
			},
		]
	},
	
	undertale = {
		name = "undertale",
		title = "Human Soul",
		description = "Big, and glowy.",
		image = UNDERTALE,
		dialogue = [
			{ face = "happy", text = "I've had that lying around for a while.\nIt whispers sometimes, but that's about it." }
		]
	},

	cotl = {
		name = "cotl",
		title = "Crown",
		description = "Looks pretty neat.",
		image = COTL,
		dialogue = [
			{ face = "happy", text = "Praise the lamb!\nHeh, just a little joke." }
		]
	},

	minecraft = {
		name = "minecraft",
		title = "Cube of Creation",
		description = "",
		image = MINECRAFT,
		dialogue = [
			{ face = "happy", text = "Let's mine and craft! Let's MINECRAFT!" }
		]
	},

	etg = {
		name = "etg",
		title = "A Lost Sir",
		description = "",
		image = ETG,
		dialogue = [
			{ face = "happy", text = "A reliable ally! Make sure to get junk for him." }
		]
	},

	roblox = {
		name = "roblox",
		title = "Basic Egg",
		description = "",
		image = ROBLOX,
		dialogue = [
			{ face = "happy", text = "Bee sure to feed it lotsa treats when it hatches!" }
		]
	},

	portal = {
		name = "portal",
		title = "Companion Cube",
		description = "",
		image = PORTAL,
		dialogue = [
			{ face = "happy", text = "I felt bad just leaving them back at the lab, so I brought some!" }
		]
	},

	newgrounds = {
		name = "newgrounds",
		title = "New Tank",
		description = "",
		image = NEWGROUNDS,
		dialogue = [
			{ face = "happy", text = "Lots of things by lots of people." }
		]
	},

	fallout = {
		name = "fallout",
		title = "Nuka-Cola",
		description = "",
		image = FALLOUT,
		dialogue = [
			{ face = "happy", text = "Refreshing, straight from the quantum rivers of Nuka-WorldTM!" }
		]
	},

	dst = {
		name = "dst",
		title = "Chester's Bone",
		description = "",
		image = DST,
		dialogue = [
			{ face = "happy", text = "He'll keep your items safe...\n...at the cost of slobbering them!" }
		]
	},

	hollow_knight = {
		name = "hollow_knight",
		title = "Gathering Swarm",
		description = "",
		image = HOLLOW_KNIGHT,
		dialogue = [
			{ face = "happy", text = "Useful little bugs, they help me find cool stuff!" }
		]
	},

	stardew_valley = {
		name = "stardew_valley",
		title = "Stardrop",
		description = "",
		image = STARDEW_VALLEY,
		dialogue = [
			{ face = "happy", text = "Tastes like beautiful dreams! Try it out!" }
		]
	},

	tboi = {
		name = "tboi",
		title = "Guppy",
		description = "",
		image = TBOI,
		dialogue = [
			{ face = "happy", text = "I leave all that I own to Guppy!" }
		]
	},

	zomboid = {
		name = "zomboid",
		title = "Spiffo",
		description = "",
		image = ZOMBOID,
		dialogue = [
			{ face = "happy", text = "It looks more like my brother than a raccoon." }
		]
	},

	ena = {
		name = "ena",
		title = "Turron",
		description = "",
		image = ENA,
		dialogue = [
			{ face = "happy", text = "We humbly thank you for your patronage." }
		]
	},

	dnd = {
		name = "dnd",
		title = "Cloak of Billowing",
		description = "",
		image = D_D,
		dialogue = [
			{ face = "happy", text = "Oh! How glamorous!" }
		]
	},

	thorn_ring = {
		name = "thorn_ring",
		title = "Thorn Ring",
		description = "",
		image = THORN_RING,
		dialogue = [
			{ face = "happy", text = "" }
		]
	}
}
