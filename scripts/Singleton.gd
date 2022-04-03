extends Node

func createSprite(texture, position, region):
	var sprite = Sprite.new()
	sprite.region_enabled = true
	sprite.texture = texture
	sprite.region_rect = region
	sprite.position = position
	sprite.centered = false
	return sprite

func randTrigoPosition(diameter):
	randomize()
	var angle = rand_range(0, 2 * PI)
	return diameter * Vector2(cos(angle), sin(angle))
