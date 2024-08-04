extends Resource
class_name Pattern

@export var bits:int = 0

var rotate90:int = 0
var rotate180:int = 0
var rotate270:int = 0

func get_bit_at(x:int, y:int) -> bool:
	return get_bit_ati(x + y * 5)
	
func get_bit_ati(index:int) -> bool:
	return bits & 1 << index == 1 << index

func compute_rotations():
	
	rotate90 = 0
	rotate180 = 0
	rotate270 = 0
	
	for x in range(0, 5):
		for y in range(0, 5):
			if get_bit_at(x, y):
				var x90:int = 4 - y
				var y90:int = x
				var i90:int = x90 + y90 * 5
				rotate90 |= 1 << i90
			
				var x180:int = 4 - x
				var y180:int = 4 - y
				var i180:int = x180 + y180 * 5
				rotate180 |= 1 << i180
			
				var x270:int = y
				var y270:int = 4 - x
				var i270:int = x270 + y270 * 5
				rotate270 |= 1 << i270
