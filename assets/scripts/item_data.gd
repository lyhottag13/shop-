class_name ItemData
extends RefCounted

static var item_data : Dictionary[String, Dictionary]= {
	godot = 
	{
		name = "godot",
		title = "Godot",
		description = "There's something fishy about this item...",
		image = preload("uid://dhfqppklr1lsn"),
		dialogue = [
			{
				face = "happy",
				text = "That's an interesting-looking item.",
				type = "dialogue",
			},
			{
				face = "happy",
				text = "Why is it in my shop?",
				type = "dialogue"
			}	
		]
	},
	cave_explorer = {
		name = "cave_explorer",
		title = "Cave Explorer",
		description = "Wacky.",
		image = preload("uid://b156i5dkjq21g"),
		dialogue = [
			{
				face = "happy",
				text = "Awesome!",
				type = "dialogue"
			}
		]
	}
}
