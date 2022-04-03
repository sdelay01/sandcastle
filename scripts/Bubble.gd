extends Node2D

var texture = load("res://assets/ld50.png")
var textureAlphabet = load("res://assets/alphabet.png")
const CHAR_HEIGHT = 20
var ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz,'êéèà.!?[]5"
var PIXELSIN = "44444444344455445445457554443334333133354433353455333224444114334"

func init(word, deltaX, deltaY):
	# Bubble left-side
	self.add_child(Singleton.createSprite(texture, Vector2(deltaX, deltaY), Rect2(64, 384, 8, 32)))

	# Letters and Background
	var pixels = 8
	for character in word:
		var t = createLetterSprite(character, pixels, deltaX, deltaY)
		pixels = pixels + t

	# Bubble right-side
	self.add_child(Singleton.createSprite(texture, Vector2(deltaX + pixels, deltaY), Rect2(88, 384, 8, 32)))

	return self

func createLetterSprite(letter, pixels, deltaX, deltaY):
	var index = ALPHABET.find(letter)
	var newPixels = int(PIXELSIN[index]) * 2
	var pictureDeltaX = 0
	for i in range(0, index):
		pictureDeltaX += (int(PIXELSIN[i]) + 1) * 2

	self.add_child(Singleton.createSprite(texture, Vector2(pixels + deltaX, deltaY),  Rect2(72, 384, newPixels + 2, 32) )) # Bubble
	self.add_child(Singleton.createSprite(textureAlphabet, Vector2(pixels + deltaX, deltaY + 4), Rect2(pictureDeltaX, 0, newPixels + 2, CHAR_HEIGHT))) # Letter
	return (newPixels + 1)
