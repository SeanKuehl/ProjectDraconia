extends Node2D

onready var unitClass = load("res://Game/Scenes/UnitStuff/UnitClass/UnitClass.tscn")

func _ready():

	#Server.Init()
	#Client.Init()

	$TileGrid.Init(10)

	var newUnit = unitClass.instance()
	add_child(newUnit)
	var positionOfUnit = Vector2(1,1)
	$TileGrid.AddUnitToGrid(newUnit, positionOfUnit)
	#$TileGrid.MoveUnitToPos(positionOfUnit, Vector2(8,6))

func TestFunction():
	print("this worked, just so you know")

remote func Fake():
	get_tree().get_root().get_node("World").TestFunction()


