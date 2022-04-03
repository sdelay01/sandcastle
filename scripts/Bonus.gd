extends Sprite

signal reach_target

var textureGame = load("res://assets/ld50.png")
var speed = 2
var counter = 0
var firstTarget
var secondTarget
var around = 10
var step = 0

func init(_secondTarget, _region):
	self.add_child(Singleton.createSprite(textureGame, Vector2(0, 0), _region))
	firstTarget = position + Singleton.randTrigoPosition(100)
	secondTarget = _secondTarget

func isAround(_target):
	return abs((_target - position).x) < around && abs((_target - position).y) < around

func _process(delta):
	if step == 1:
		position = position + (secondTarget - position) * delta * speed
		if isAround(secondTarget):
			emit_signal("reach_target")
			self.queue_free()
	if step == 0:
		position = position + (firstTarget - position) * delta * speed
		if isAround(firstTarget):
			step = 1
