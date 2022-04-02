extends Node2D

var DigitTypo = preload("res://scenes/DigitTypo.tscn")
var unit
var deci


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func displayScore(value):
	var unitValue = value % 10
	var deciValue = (value - unitValue) / 10
	if !deci:
		deci = DigitTypo.instance()
		deci.position = Vector2(344, 350)
		self.add_child(deci)
	if !unit:
		unit = DigitTypo.instance()
		unit.position = Vector2(354, 350)
		self.add_child(unit)
	if deciValue == 0: deci.hide()
	else: deci.show()
	deci.play(str(deciValue))
	unit.play(str(unitValue))
