class_name PetraBoard

# Subtypes
enum StoneState
{
	FREE = 0,
	PLAYER1 = 1,
	PLAYER2 = 2,
	PLAYER1_STONE = 3,
	PLAYER2_STONE = 4,
	
	ERROR = 5
}

class PatternSearchResult:
	var pos:Vector2i
	var pattern:Pattern
	var rotation:int
	var triggeringPos:Vector2i

# Consts
const patternMaxDimension := 5
const boardToCacheDeltaPos := Vector2i(patternMaxDimension - 1, patternMaxDimension - 1)

# Fields
var width:int
var height:int

var stones:Array[StoneState]

var player1PatternCache:Array[int]
var player2PatternCache:Array[int]

# Signals
signal onBoardChanged(pos:Vector2i, before:StoneState, after:StoneState)

# Methods
#===================================
func _init(w:int, h:int) -> void:
	width = w
	height = h
	
	for i in range(0, width * height):
		stones.append(StoneState.FREE)
		
	for i in range(-(patternMaxDimension - 1) * (patternMaxDimension - 1), width * height):
		player1PatternCache.append(0)
		player2PatternCache.append(0)

#===================================
func set_stone(pos:Vector2i, state:StoneState) -> void:
	if pos.x < 0 or pos.y < 0 or pos.x >= width or pos.y >= height:
		return
	
	var before:StoneState = stones[pos.x + pos.y * width]
	
	if before == state:
		return
		
	stones[pos.x + pos.y * width] = state
	
	# Update des caches
	var cache1bitstate:bool = state == StoneState.PLAYER1
	var cache2bitstate:bool = state == StoneState.PLAYER2
	
	# Plutôt que d'itérer de ]-5:0], on itère de [0:5[ pour plus facilement construire la valeur de bitShift et on soustraie 4 lors du calcul de la position dans le cache
	for patternX in range(0, patternMaxDimension):
		for patternY in range(0, patternMaxDimension):
			var bitShift:int = patternX + patternY * patternMaxDimension
			var cacheX:int = pos.x + patternX - (patternMaxDimension - 1)
			var cacheY:int = pos.y + patternY - (patternMaxDimension - 1)
			var cacheIndex:int = cacheX + cacheY * (width + patternMaxDimension - 1)
			
			if cache1bitstate:
				player1PatternCache[cacheIndex] |= 1 << bitShift
			else:
				player1PatternCache[cacheIndex] &= ~(1 << bitShift)
				
			if cache2bitstate:
				player2PatternCache[cacheIndex] |= 1 << bitShift
			else:
				player2PatternCache[cacheIndex] &= ~(1 << bitShift)
	
	onBoardChanged.emit(pos, before, state)

#===================================
func get_stone(pos:Vector2i) -> StoneState:
	if pos.x < 0 or pos.y < 0 or pos.x >= width or pos.y >= height:
		return StoneState.ERROR
	else:
		return stones[pos.x + pos.y * width]

#===================================
func search_pattern(pattern:Pattern, triggering_positions:Array[Vector2i], for_player1:bool) -> Array[PatternSearchResult]:
	var toReturn:Array[PatternSearchResult]
	
	var searchCachePos:Array[Vector2i]
	
	for tp in triggering_positions:
		if tp.x >= 0 and tp.y >= 0 and tp.x < width and tp.y < height:
			for dx in range(0, patternMaxDimension):
				for dy in range(0, patternMaxDimension):
					var sPos:Vector2i = tp - Vector2i(dx, dy)
					
					if searchCachePos.find(sPos) == -1:
						searchCachePos.append(sPos)
	
	var cache:Array[int] = player1PatternCache if for_player1 else player2PatternCache
	
	for sPos in searchCachePos:
		PRIVATE_search_pattern(pattern, sPos, triggering_positions, cache, toReturn)
	
	return toReturn

#===================================
func PRIVATE_search_pattern(pattern:Pattern, searching_cache_position:Vector2i, triggering_board_positions:Array[Vector2i], cache:Array[int], ref_result:Array[PatternSearchResult]) -> bool:
	var cacheIndex:int = searching_cache_position.x + searching_cache_position.y * (width + patternMaxDimension - 1)
	var cachePattern:int = cache[cacheIndex]
		
	for i in range(0, 4):
		var subPattern:int = pattern.rotations[i]
		
		if subPattern & cachePattern == subPattern:
			# il faut vérifier que l'une des positions de déclenchement appartient bien au pattern
			for tp in triggering_board_positions:
				var cacheLocalPos:Vector2i = tp + boardToCacheDeltaPos - searching_cache_position
				var triggerBit:int = 1 << (cacheLocalPos.x + cacheLocalPos.y * patternMaxDimension)
				
				if triggerBit | subPattern == triggerBit:
					var res:PatternSearchResult
					res.pos = searching_cache_position - boardToCacheDeltaPos
					res.pattern = pattern
					res.rotation = i
					res.triggeringPos = tp
					
					return true
	
	return false
	
	
	
	
	
	
