extends KinematicBody2D

signal increase_build
var currentDirection
var userBlocked = false
var positionGrid = Vector2(0, 0)
var cellSize = 64
var Loader = preload("res://scenes/Loader.tscn")
var loader
var castle
var buildPossible = true
var digPossible = true

var shovel
var bucket

const TOWER1 = 9
const TOWER2 = 8
const TOWER3 = 7
const HOLE1 = 10


func _ready():
	positionGrid = Vector2(5, 3)
	position = positionGrid * cellSize

func setCastle(_castle): castle = _castle
func setShovel(_shovel): shovel = _shovel
func setBucket(_bucket): bucket = _bucket

func _physics_process(_delta):
	if userBlocked: return
	if Input.is_action_just_pressed("ui_right"):
		move(Vector2(1, 0))
	elif Input.is_action_just_pressed("ui_left"):
		move(Vector2(-1, 0))
	elif Input.is_action_just_pressed("ui_down"):
		move(Vector2(0, 1))
	elif Input.is_action_just_pressed("ui_up"):
		move(Vector2(0, -1))

func move(delta):
	if loader: loader.queue_free()
	var _n = move_and_collide(delta * cellSize)
	var currentCellPosition = castle.world_to_map(position)
	var object = castle.get_cellv(currentCellPosition)
	buildPossible = object == TOWER1 || object == TOWER2 || object == -1
	digPossible = object == -1

func _input(event):
	if event.is_action_pressed("ui_x"): build()
	if event.is_action_released("ui_x"):
		if loader: loader.queue_free()
	if event.is_action_pressed("ui_w"): dig()
	if event.is_action_released("ui_w"):
		if loader: loader.queue_free()

func unblockUser(): userBlocked = false
func blockUser(): userBlocked = true

func speedEquation(lvl): return 5 + lvl * 2

func build():
	if loader: loader.queue_free()
	if !buildPossible: return
	loader = Loader.instance()
	var speed = 1
	if bucket: speed = bucket.level
	loader.setSpeed(speedEquation(speed))
	loader.connect("done", self, "built")
	self.add_child(loader)

func built():
	if loader: loader.queue_free()
	var currentCellPosition = castle.world_to_map(position)
	var object = castle.get_cellv(currentCellPosition)
	digPossible = false
	if object == -1 : 
		castle.set_cellv(currentCellPosition, TOWER1)
		bucket.usedOnce()
		emit_signal("increase_build")
	if object == TOWER1:
		castle.set_cellv(currentCellPosition, TOWER2)
		bucket.usedOnce()
		emit_signal("increase_build")
	elif object == TOWER2:
		castle.set_cellv(currentCellPosition, TOWER3)
		bucket.usedOnce()
		emit_signal("increase_build")
		buildPossible = false

func dig():
	if loader: loader.queue_free()
	if !digPossible: return
	loader = Loader.instance()
	var speed = 1
	if shovel : speed = shovel.level
	loader.setSpeed(speedEquation(speed))
	loader.connect("done", self, "dug")
	self.add_child(loader)

func dug():
	if loader: loader.queue_free()
	var currentCellPosition = castle.world_to_map(position)
	castle.set_cellv(currentCellPosition, HOLE1)
	shovel.usedOnce()
	emit_signal("increase_build")
	digPossible = false
	buildPossible = false
