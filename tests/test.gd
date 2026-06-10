extends Node3D

@onready var base : Node3D = $model
var base_part : ItemPart

func print_to_binary(i:int) -> void:
	print(i," ",BinaryLib.binary_data_to_string(BinaryLib.to_binary(i)))

func print_from_binary(data:Array[bool]) -> void:
	print(BinaryLib.from_binary(data))

func test_conversion(i:int) -> void:
	print(BinaryLib.from_binary(BinaryLib.to_binary(i)))

@export var recipes : Array[Recipe]

@export var test_recipe : Dictionary[BuildLib.Ingredient,int] = {
		BuildLib.Ingredient.BLADE: 0,
		BuildLib.Ingredient.BOW: 0,
		BuildLib.Ingredient.CHAIN: 0,
		BuildLib.Ingredient.GUN: 0,
		BuildLib.Ingredient.GUN_HANDLE: 0,
		BuildLib.Ingredient.HANDLE: 0,
		BuildLib.Ingredient.SPIKE: 0,
		BuildLib.Ingredient.SPHERE: 0,
		BuildLib.Ingredient.CUBE: 0,
	}

const max_values : Dictionary[BuildLib.Ingredient,int] = {
	BuildLib.Ingredient.BLADE: 3,
	BuildLib.Ingredient.BOW: 1,
	BuildLib.Ingredient.CHAIN: 1,
	BuildLib.Ingredient.GUN: 1,
	BuildLib.Ingredient.GUN_HANDLE: 3,
	BuildLib.Ingredient.HANDLE: 3,
	BuildLib.Ingredient.SPIKE: 3,
	BuildLib.Ingredient.SPHERE: 1,
	BuildLib.Ingredient.CUBE: 1,
}
const prop_names : Dictionary[BuildLib.Ingredient,String] = {
	BuildLib.Ingredient.BLADE: "blade",
	BuildLib.Ingredient.BOW: "bow",
	BuildLib.Ingredient.CHAIN: "chain",
	BuildLib.Ingredient.GUN: "gun",
	BuildLib.Ingredient.GUN_HANDLE: "gun handle",
	BuildLib.Ingredient.HANDLE: "handle",
	BuildLib.Ingredient.SPIKE: "spike",
	BuildLib.Ingredient.SPHERE: "sphere",
	BuildLib.Ingredient.CUBE: "cube",
}

func create_base_part() -> void:
	if base_part != null:
		base_part.queue_free()
		base_part = null
	
	base_part = ItemPart.new()
	base_part.next_slots.push_back(base_part)
	base.add_child(base_part)

func set_test_recipe_prop(value:float,prop:BuildLib.Ingredient) -> void:
	create_base_part()
	test_recipe[prop] = int(value)
	print(test_recipe[prop])
	BuildLib.build(base_part,test_recipe)

func mount_ui() -> void:
	var base : Control = $Control/Panel/HBoxContainer/ScrollContainer/VBoxContainer
	var template : Control = $Control/Panel/HBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer
	base.remove_child(template)
	
	for i : BuildLib.Ingredient in max_values:
		var node : Control = template.duplicate()
		var signal_call : Callable = set_test_recipe_prop.bind(i)
		node.get_node("HSlider").value_changed.connect(signal_call)
		node.get_node("HSlider").max_value = max_values[i]
		node.get_node("Label").text = prop_names[i]
		base.add_child(node)
	

func _ready() -> void:
	for i : int in range(0,10):
		print_to_binary(i)
	
	print("")
	
	print_from_binary([false])
	print_from_binary([true])
	print_from_binary([false,true])
	print_from_binary([true,true])
	
	print("")
	
	for i : int in range(0,10):
		test_conversion(i)
	
	create_base_part()
	
	BuildLib.recipes = recipes
	
	BuildLib.build(base_part,test_recipe)
	
	mount_ui()

func _process(delta: float) -> void:
	base.rotation.y += delta * 2.0
