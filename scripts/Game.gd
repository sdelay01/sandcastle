extends Node2D

var Castle = preload("res://scenes/Castle.tscn")
var Water = preload("res://scenes/Water.tscn")
var Kevin = preload("res://scenes/Kevin.tscn")
var Wave = preload("res://scenes/Wave.tscn")
var Tool = preload("res://scenes/Tool.tscn")
var Flag = preload("res://scenes/Flags.tscn")
var EndGame = preload("res://scenes/EndGame.tscn")
var Bubble = preload("res://scenes/Bubble.tscn")
var counter = 0
var menuOn = false
var endGameOn = false
var castle
var water
var kevin
var wave
var bucket
var shovel
var flag
var endGame
var bubble
var menuDisplayed = false
var endGameDisplayed = false
var tutoStep = 0
var tutoSteps = [
	["Here is Justin", 352, 260, "displayKevin"],
	["He is building a Sand Castle", 352, 260, "displayCastle"],
	["Let's help him", 352, 260, null],
	["Maintain X to use your bucket to build towers", 150, 70, "displayBucket"],
	["Maintain W to dig trenches", 150, 70, "displayShovel"],
	["The castle must worth at least 5 flags", 150, 70, "displayFlag"],
	["Next wave is indicated here", 520, 70, "displayWave"],
	["The tide is rising", 352, 260, null],
	["Make the castle last as long as you can!", 352, 260, null],
	["Ready?", 352, 260, null],
]

func _ready():
	$Title.hide()
	$Title.modulate.a = 0
	$Present.hide()
	$PressAnyKey.hide()
	displayTitle()
	# startTuto()
	# startGame()
	
func _process(delta):
	if menuOn:
		counter += delta
		if !$Jingle.playing: $Jingle.play("default")
		if counter > 2 && !$Present.visible: $Present.show()
		if counter > 3 && !$Title.visible:
			$Title.show()
		if $Title.visible and $Title.modulate.a < 1:
			$Title.modulate.a += delta
		if counter > 4.5 && !$PressAnyKey.visible:
			$PressAnyKey.show()
			menuDisplayed = true
	if endGameOn:
		counter += delta
		if counter > 2:
			endGameDisplayed = true
			endGameOn = false

func _input(event):
	if tutoStep and event is InputEventKey and event.pressed: nextTutoStep()
	if menuDisplayed and event is InputEventKey and event.pressed: startTuto()
	if endGameDisplayed and event is InputEventKey and event.pressed:
		endGame.queue_free()
		endGameDisplayed = false
		startGame()
	
		
func nextTutoStep():
	if bubble: bubble.queue_free()
	tutoStep += 1
	if tutoStep > len(tutoSteps):
		tutoStep = 0
		startGame()
		return
	var step = tutoSteps[tutoStep - 1]
	bubble = Bubble.instance().init(step[0], step[1] - int(len(step[0]) * 5 / 2.0) - 30, step[2])
	self.add_child(bubble)
	if step[3]: call(step[3])
	
func displayTitle():
	counter = 0
	menuOn = true
	
func startTuto():
	menuDisplayed = false
	menuOn = false
	# Tutorial here
	$Title.hide()
	$Present.hide()
	$Jingle.hide()
	$PressAnyKey.hide()
	nextTutoStep()
	castle = Castle.instance()
	self.add_child_below_node($Sand, castle)

func displayKevin():
	kevin = Kevin.instance()
	self.add_child(kevin)
	
func displayCastle():
	kevin.setCastle(castle)
	castle.initCastle()

func displayBucket():
	bucket = Tool.instance()
	bucket.init(Vector2(10, 0), Rect2(64, 320, 64, 64))
	self.add_child(bucket)
	kevin.setBucket(bucket)

func displayShovel():
	shovel = Tool.instance()
	shovel.init(Vector2(70, 0), Rect2(128, 320, 64, 64))
	self.add_child(shovel)
	kevin.setShovel(shovel)

func displayFlag():
	flag = Flag.instance()
	flag.position = Vector2(130, 0)
	self.add_child(flag)
	flag.setValue(9)

func displayWave():
	wave = Wave.instance()
	self.add_child(wave)

func startGame():
	water = Water.instance()
	self.add_child_below_node($DefaultWater, water)
	endGameDisplayed = false
	
	wave.setSea(water)
	wave.setCastle(castle)
	wave.start()

	wave.connect("waveStart", kevin, "blockUser")
	wave.connect("waveEnd", kevin, "unblockUser")
	wave.connect("waveEnd", flag, "checkGameOver")
	flag.connect("game_over", self, "gameOver")
	castle.connect("decrease_build", flag, "decrease")
	kevin.connect("increase_build", flag, "increase")

func gameOver():
	endGame = EndGame.instance()
	endGame.displayScore(wave.level)
	self.add_child(endGame)
	castle.queue_free()
	water.queue_free()
	kevin.blockUser()
	kevin.queue_free()
	kevin = null
	bucket.queue_free()
	shovel.queue_free()
	flag.queue_free()
	wave.queue_free()
	endGameOn = true
