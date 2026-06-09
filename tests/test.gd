extends Node3D

@onready var model : ItemPart = $model

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
		BuildLib.Ingredient.GUN_HANDLE: 1,
		BuildLib.Ingredient.HANDLE: 0,
		BuildLib.Ingredient.SPIKE: 0,
		BuildLib.Ingredient.SPHERE: 0,
		BuildLib.Ingredient.CUBE: 0,
	}

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
	
	BuildLib.recipes = recipes
	
	BuildLib.build(model,test_recipe)
	

func _process(delta: float) -> void:
	model.rotation.y += delta * 2.0
