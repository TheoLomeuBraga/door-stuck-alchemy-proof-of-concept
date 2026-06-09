extends Node
class_name BuildLib

enum Ingredient {
	BLADE,
	BOW,
	CHAIN,
	GUN,
	GUN_HANDLE,
	HANDLE,
	SPIKE,
	SPHERE,
	CUBE
	
}

static func create_base_item_data() -> Dictionary[Ingredient,int]:
	return {
		Ingredient.BLADE: 0,
		Ingredient.BOW: 0,
		Ingredient.CHAIN: 0,
		Ingredient.GUN: 0,
		Ingredient.GUN_HANDLE: 0,
		Ingredient.HANDLE: 0,
		Ingredient.SPIKE: 0,
		Ingredient.SPHERE: 0,
		Ingredient.CUBE: 0,
	}

static var recipes : Array[Recipe]

static func add_recipe(requirements : Dictionary[Ingredient,int],model : PackedScene) -> void:
	var recipe : Recipe = Recipe.new()
	recipe.requirements = requirements.duplicate()
	recipe.model = model
	recipes.push_back(recipe)

static func is_recipe_suported(inventory:Dictionary[Ingredient,int],recipe:Dictionary[Ingredient,int]) -> bool:
	
	for i : Ingredient in recipe:
		if not inventory.has(i) or not recipe.has(i):
			return false
		if inventory.has(i) and recipe.has(i) and inventory[i] != recipe[i]:
			return false
	
	return true

static func clean_recipe(a:Dictionary[Ingredient,int]) -> Dictionary[Ingredient,int]:
	var ret : Dictionary[Ingredient,int]
	for i : Ingredient in a:
		if a[i] > 0:
			ret[i] = a[i]
	return ret

static func subtract_recipe(inventory:Dictionary[Ingredient,int],recipe:Dictionary[Ingredient,int]) -> Dictionary[Ingredient,int]:
	
	
	var ret : Dictionary[Ingredient,int] = inventory.duplicate()
	for i : Ingredient in recipe:
		if ret.has(i) and recipe.has(i):
			ret[i] -= recipe[i]
	return clean_recipe(ret)

static func get_compatible_recipe(recipe:Dictionary[Ingredient,int]) -> Recipe:
	for r : Recipe in recipes:
		if is_recipe_suported(recipe,r.requirements):
			print(r.model.resource_path)
			return r
	return null

static func build(part:ItemPart,recipe:Dictionary[Ingredient,int]) -> void:
	var current_recipe : Dictionary[Ingredient,int] = clean_recipe(recipe)
	var next_slots : Array[ItemPart] = [part]
	
	while true:
		var avaliable_recipe : Recipe = get_compatible_recipe(current_recipe)
		if avaliable_recipe == null:
			break
		
		current_recipe = subtract_recipe(current_recipe,avaliable_recipe.requirements)
		
		var new_next_slots : Array[ItemPart] = []
		
		for ip : ItemPart in next_slots:
			for n : Node in ip.next_slots:
				if n is Node3D:
					var item_part : ItemPart = avaliable_recipe.model.instantiate()
					new_next_slots.push_back(item_part)
					n.add_child(item_part)
		
		next_slots = new_next_slots
	
