extends Node2D

onready var unitClass = load("res://Game/Scenes/UnitStuff/UnitClass/UnitClass.tscn")

func _ready():



	$TileGrid.Init(10)

	var newUnit = unitClass.instance()
	add_child(newUnit)
	var positionOfUnit = Vector2(0,0)
	$TileGrid.AddUnitToGrid(newUnit, positionOfUnit)
	#$TileGrid.MoveUnitToPos(positionOfUnit, Vector2(5,0))


