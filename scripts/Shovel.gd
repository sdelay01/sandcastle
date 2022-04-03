extends Node2D

signal level_up
var usagePerLevel = 5
var usage = 0
var level = 1
var maxLevel = 5
var texture = load("res://assets/ld50.png")
var lightStar = Rect2(64, 64, 16, 16)
var stars = []

func init(pos, rect):
	position = pos
	self.add_child(Singleton.createSprite(texture, Vector2(0, 0), rect))
	drawStars()

func drawStars():
	var defaultPos = Vector2(25, 45)
	var deltaX = 10
	for s in stars:
		s.queue_free()
	stars = []
	for x in range(0, level):
		var star = Singleton.createSprite(texture, Vector2(x * deltaX - deltaX * (level / 2.0 - 0.5), 0) + defaultPos, lightStar )
		self.add_child(star)
		stars.push_back(star)

func getUsagePerLevel(): return usagePerLevel + level * 2

func usedOnce():
	usage += 1
	if usage > getUsagePerLevel() and level < maxLevel:
		emit_signal("level_up")
		usage = 0

func levelUp():
	level += 1
	drawStars()
	
