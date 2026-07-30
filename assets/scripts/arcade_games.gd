class_name ArcadeGames extends RefCounted

const PICKAXE_ICON = preload("uid://creh0088lm2mg")
const SHOP_ICON = preload("uid://bt33682oq8alp")

static var games: Array[Dictionary] = [
	{
		name = "cave_explorer",
		title = "Cave Explorer",
		image = PICKAXE_ICON,
		link = "https://lyhottag13.github.io/cave-explorer",
	},
	{
		name = "shop",
		title = "Shop!",
		image = SHOP_ICON,
		link = "https://lyhottag13.github.io/shop-",
	}
]
