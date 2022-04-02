extends Node2D

signal game_over
var Digit = preload("res://scenes/Digit.tscn")
var value = 87
var unit
var deci

func _ready():
	displayDigits()

func setValue(_value):
	value = _value
	displayDigits()

func increase():
	value += 1
	displayDigits()
	
func decrease():
	value -= 1
	displayDigits()

func checkGameOver():
	if value < 5: emit_signal("game_over")

func displayDigits():
	var unitValue = value % 10
	var deciValue = (value - unitValue) / 10
	if !deci:
		deci = Digit.instance()
		deci.position = Vector2(23, 52)
		self.add_child(deci)
	if !unit:
		unit = Digit.instance()
		unit.position = Vector2(29, 52)
		self.add_child(unit)
	if deciValue == 0: deci.hide()
	else: deci.show()
	deci.play(str(deciValue))
	unit.play(str(unitValue))
