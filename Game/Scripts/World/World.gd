extends Node2D

onready var unitClass = load("res://Game/Scenes/UnitStuff/UnitClass/UnitClass.tscn")
onready var buildingClass = load("res://Game/Scenes/BuildingStuff/BuildingClass/BuildingClass.tscn")

onready var purchaseTroopMenu = load("res://Game/Scenes/BuildingStuff/BuildingMenus/BuyTroopsMenu.tscn")

var currentTroopPurchaseMenu = 0

func _ready():

	#Server.Init()
	#Client.Init()
	$TileGrid.connect("PlayerWantsToPurchaseSomething", self, "DisplayTroopPurchaseMenu")

	$TileGrid.Init(10)

	#var newUnit = unitClass.instance()
	#add_child(newUnit)
	#var positionOfUnit = Vector2(1,1)
	var newBuilding = buildingClass.instance()
	add_child(newBuilding)
	var positionOfBuilding = Vector2(1,1)
	$TileGrid.AddBuildingToGrid(newBuilding, positionOfBuilding)
	#$TileGrid.AddUnitToGrid(newUnit, positionOfUnit)
	#$TileGrid.MoveUnitToPos(positionOfUnit, Vector2(8,6))

func TestFunction():
	print("this worked, just so you know")

remote func Fake():
	get_tree().get_root().get_node("World").TestFunction()

func DisplayTroopPurchaseMenu():
	currentTroopPurchaseMenu = purchaseTroopMenu.instance()
	#"TroopPurchased"
	currentTroopPurchaseMenu.connect("TroopPurchased", self, "CloseTroopPurchaseMenu")

	add_child(currentTroopPurchaseMenu)

func CloseTroopPurchaseMenu():
	currentTroopPurchaseMenu.queue_free()



