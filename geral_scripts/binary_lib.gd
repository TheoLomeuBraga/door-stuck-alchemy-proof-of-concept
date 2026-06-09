extends Node
class_name BinaryLib

static func binary_data_to_string(data:Array[bool]) -> String:
	var ret : String = ""
	for b : bool in data:
		if b:
			ret += "1"
		else:
			ret += "0"
	return ret

static func to_binary(no:int) -> Array[bool]:
	
	var bits_necessary : int = 1
	var max_value : int = 1
	while no > max_value:
		max_value *= 2
		bits_necessary += 1
	
	
	var ret : Array[bool]
	
	var no_2 : int = no
	for i : int in range(0,bits_necessary):
		ret.push_back(no_2 >= max_value)
		if no_2 >= max_value:
			no_2 -= max_value
		max_value /=2
	
	ret.reverse()
	if ret[ret.size()-1] == false:
		ret.pop_back()
	
	return ret

static func from_binary(data:Array[bool]) -> int:
	var ret : int = 0
	var number:int = 1
	for b : bool in data:
		if b:
			ret+=number
		number*=2
	return ret
