extends Sprite

var storedUnit = 0
var storedBuilding = 0


var concealmentBoost = 0
var rangeBoost = 0	#elevation of terrain plays a role in range and accuracy boost
var accuracyBoost = 0
var protection = 0	#how much an opponent trying to hit you has their accuracy decreased
var sightBoost = 0
var sightRangeBoost = 0

#these are for help with map generation
var elevation = -1
var terrainFeature = ""
var locked = false	#if it's water for instance, don't overwrite it

var tileImageDirectory = "res://Game/Assets/Images/TIleImages/"
var tileImageDictionary = {"water": tileImageDirectory+"icon.png", "land": tileImageDirectory+"land.png", "trees": tileImageDirectory+"trees.png"}	#will have images for "water", "grass" etc.

func _ready():
	$Tile.texture = load(tileImageDictionary["water"])

func GetConcealmentBoost():
	return concealmentBoost

func SetConcealmentBoost(newVal):
	concealmentBoost = newVal

func GetRangeBoost():
	return rangeBoost

func SetRangeBoost(newVal):
	rangeBoost = newVal

func GetAccuracyBoost():
	return accuracyBoost

func SetAccuracyBoost(newVal):
	accuracyBoost = newVal

func GetProtection():
	return protection

func SetProtection(newVal):
	protection = newVal

func GetSightBoost():
	return sightBoost

func SetSightBoost(newVal):
	sightBoost = newVal

func GetSightRangeBoost():
	return sightRangeBoost

func SetSightRangeBoost(newVal):
	sightRangeBoost = newVal


#func GetCenter():
#	return global_position

func CheckIfCoordinatesWithinBounds(coordinates):
	#tiles are uniform size
	var topLeft = global_position
	var right = topLeft.x + (texture.get_width()/2)
	var left = topLeft.x  - (texture.get_width()/2)
	var top = topLeft.y - (texture.get_width()/2)
	var bottom = topLeft.y + (texture.get_width()/2)





	if coordinates.x > left and coordinates.x < right:
		if coordinates.y < bottom and coordinates.y > top:



			return true

	return false



func SetImage(image):
	$Tile.texture = load(tileImageDictionary[image])

func SetTerrain(newElevation, newFeature):
	#some features will lock it, they cannot be changed once assigned like water
	if locked:
		pass
	elif newFeature == "":
		elevation = newElevation
	else:
		texture = load(tileImageDictionary[newFeature])	#this is temporary
		elevation = newElevation
		terrainFeature = newFeature

		if terrainFeature == "water":
			locked = true

#typeof(playerOneMonster) == TYPE_OBJECT
func AddUnitToTile(unit):
	unit.global_position = global_position	#set it to the centre of the current tile
	storedUnit = unit	#sore a reference to the unit


func CheckIfCoordinatesWithinUnitBounds(coordinates):
	#tiles are uniform size

	if typeof(storedUnit) == TYPE_OBJECT:

		return storedUnit.CheckIfCoordinatesWithinBounds(coordinates)

	else:
		return false


func MoveUnitToPos(firstPosition, secondPosition, tileSize, spaceBetweenTiles):
	if typeof(storedUnit) == TYPE_OBJECT:
		#get the difference between the positions, how the unit will have to move
		#tile by tile to reach the other position
		var xDiff = secondPosition.x - 	firstPosition.x
		var yDiff = secondPosition.y - firstPosition.y

		storedUnit.Move(xDiff, yDiff, tileSize, spaceBetweenTiles)
