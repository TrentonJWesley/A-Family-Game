extends HSlider

# Your custom array of specific values
@export var custom_values: Array[float] = [.5, 1, 2, 4, 8, 30]

func _ready() -> void:
	# Configure the slider to match your array
	min_value = 0
	max_value = custom_values.size()
	tick_count = custom_values.size() + 1
	custom_values.push_front(0)
	step = 0.01
	print("max_value: ", max_value)
	print("tick_count: ", tick_count)
	

func change_value(slider_value: float) -> void:
	# Find the two closest indices
	var indices: Array[int] = get_bounding_indices(custom_values, slider_value)
	
	# Determine the exact value based on how close the slider is to an integer
	var low_value = custom_values[indices[0]]
	var high_value = custom_values[indices[1]]
	if low_value == high_value:
		value = low_value
	else:
		var lerp_weight = (slider_value - low_value) / (high_value - low_value)
		value = lerp(indices[0], indices[1], lerp_weight)
	
	print(value)
	



func get_bounding_indices(arr: Array, x: float) -> Array[int]:
	var idx = arr.bsearch(x)
	
	# Exact match found
	if idx < arr.size() and arr[idx] == x:
		return [idx, idx]
		
	# x is smaller than the first element
	if idx == 0:
		return [0, 0]
		
	# x is larger than the last element
	if idx == arr.size():
		var last_idx = arr.size() - 1
		return [last_idx, last_idx]
		
	# x is strictly between two values
	return [idx - 1, idx]
