extends Node2D

signal level_up
var usagePerLevel = 2
var usage = 0
var level = 1
var maxLevel = 5
var texture = load("res://assets/ld50.png")
var lightStar = Rect2(64, 80, 16, 16)
var darkStar = Rect2(80, 80, 16, 16)
var lightHeart = Rect2(64, 64, 16, 16)
var darkHeart = Rect2(80, 64, 16, 16)

func init(pos, rect):
	position = pos
	self.add_child(Singleton.createSprite(texture, Vector2(0, 0), rect))
	drawStars()

func drawStars():
	var deltaX = 0
	var deltaY = 45
	for x in range(1, maxLevel + 1):
		if x <= level:
			self.add_child(Singleton.createSprite(texture, Vector2(deltaX + x * 8, deltaY), lightHeart ))
		else :
			self.add_child(Singleton.createSprite(texture, Vector2(deltaX + x * 8, deltaY), darkHeart ))
	
func usedOnce():
	usage += 1
	if usage > usagePerLevel and level < maxLevel:
		emit_signal("level_up")
		usage = 0

func levelUp():
	level += 1
	drawStars()
	
