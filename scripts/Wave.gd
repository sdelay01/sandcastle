extends Node2D

signal waveStart
signal waveEnd
signal waveMove

# Loader variables
var WaveLoader = preload("res://scenes/WaveLoader.tscn")
var loaders = []
var counter = 0
var firstPos = Vector2(646, 59)
var barLength = 54

var cellSize = 64

var blocked = true

var waveFrequency = 15.0

# Wave variables
var sea
var castle
var level = 2
var waveSpeed = 0.4
var currentMaxAmplitude
var maxAmplitude = 9
var animationLevel = 0
var deltaAnimationLevel = 1
var waveHitting = false
var currentSeas = []
var columnHit = []

# Wave number
var Digit = preload("res://scenes/Digit.tscn")
var unit
var deci

# Water Tilemap cells
const WATER1 = 1
const WATER2 = 2
const WATER3 = 3
const WATER4 = 4
const WATER5 = 11

func _ready():
	if false: # Test mode
		waveFrequency = 3.0
		waveSpeed = 0.4
		level = 9
	displayDigits()

func prepareWave():
	currentSeas = []
	columnHit = []
	for x in range(0, 11):
		currentSeas.push_back([])
		columnHit.push_back('none')
		for _y in range(0, 10):
			currentSeas[x].push_back( -1 )
	emit_signal("waveStart") # to block user
	counter = 1
	for l in loaders:
		if l: l.queue_free()
	loaders = []
	level += 1
	displayDigits()
	currentMaxAmplitude = level
	if currentMaxAmplitude >= maxAmplitude:
		currentMaxAmplitude = maxAmplitude
		waveFrequency -= 0.8
		if waveFrequency < 2:
			waveFrequency = 2
	waveHitting = true
	
func start(): blocked = false

func addOneWaveLoader(deltaX):
	var w = WaveLoader.instance()
	w.position = Vector2(deltaX, 59)
	self.add_child(w)
	loaders.push_back(w)

func _process(delta):
	if blocked: return
	counter += delta
	if waveHitting:
		if counter > waveSpeed:
			counter = 0
			animationLevel += deltaAnimationLevel
			if animationLevel == currentMaxAmplitude: deltaAnimationLevel = -1 # Reach maximum amplitude
			if animationLevel == 3 && deltaAnimationLevel < 0: emit_signal("waveEnd")
			if animationLevel == 0: # End of wave
				waveHitting = false
				deltaAnimationLevel = 1
				emit_signal("waveEnd")
				return
			drawNewLevel()
		return

	var pct = 100 * counter / waveFrequency
	if int(round(pct)) % 2 == 0:
		addOneWaveLoader( pct * (barLength / 100.0)  )
	if pct >= 100 :
		prepareWave()

func lvlToTile(lvl):
	if lvl == 0: return WATER1
	if lvl == 1: return WATER2
	if lvl == 2: return WATER3
	if lvl == 3: return WATER4
	if lvl >  3: return WATER5
	return -1
	
func drawNewLevel():
	for x in range(0, 11):
		var higherRow = false
		if columnHit[x] == 'todo':
			columnHit[x] = 'done'
			continue
		for y in range(9, 1, -1):
			if higherRow: continue
			var cur = currentSeas[x][y]
			if cur == -1: higherRow = true
			if cur == -1 && deltaAnimationLevel > 0:
				if waveHitCastle(Vector2(x, y)):
					if columnHit[x] != 'todo': columnHit[x] = 'todo'
					castle.lowerBuilding(Vector2(x, y))
			cur += deltaAnimationLevel
			if cur < -1 : cur = -1
			currentSeas[x][y] = cur
			sea.set_cellv(Vector2(x, y), lvlToTile(currentSeas[x][y]))
	emit_signal("waveMove")

func waveHitCastle(cell):
	var currentCellPosition = castle.world_to_map(cell * cellSize)
	return castle.get_cellv(currentCellPosition) != -1

func setSea(_sea): sea = _sea
func setCastle(_castle): castle = _castle

func displayDigits():
	var unitValue = level % 10
	var deciValue = (level - unitValue) / 10
	if !deci:
		deci = Digit.instance()
		deci.position = Vector2(45, 10)
		self.add_child(deci)
	if !unit:
		unit = Digit.instance()
		unit.position = Vector2(52, 10)
		self.add_child(unit)
	if deciValue == 0: deci.hide()
	else: deci.show()
	deci.play(str(deciValue))
	unit.play(str(unitValue))
