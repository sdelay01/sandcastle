extends Node2D

signal done
var texture = load("res://assets/circle.png")
var asp = AnimatedSprite.new()

func _ready():
	var sf = SpriteFrames.new()
	for i in range(0, 68):
		var at = AtlasTexture.new()
		at.atlas = texture
		at.region = Rect2(32 * i, 0, 32, 32)
		sf.add_frame("default", at)

	asp.frames = sf
	#asp.scale = Vector2(2, 2)
	asp.position = Vector2(32, 32)
	asp.play("default")
	asp.connect("animation_finished", self, "emit_signal", ["done"])
	self.add_child(asp)

func setSpeed(speed):
	asp.speed_scale = speed

