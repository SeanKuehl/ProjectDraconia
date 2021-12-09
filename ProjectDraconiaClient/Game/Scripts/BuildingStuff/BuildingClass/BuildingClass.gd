extends StaticBody2D

var health = 0
var buildingName = ""
var buildingDescription = ""

var timeToBuild = 0
var costToBuild = 0

var concealmentBoost = 0
var rangeBoost = 0	#elevation of terrain plays a role in range and accuracy boost
var accuracyBoost = 0
var protection = 0	#how much an opponent trying to hit you has their accuracy decreased
var sightBoost = 0
var sightRangeBoost = 0

var buildingImagesDirectory = "res://Game/Assets/Images/BuildingImages/"
var buildingPhysicalSize = 85
var buildingPosition = 0


func CheckIfCoordinatesWithinBounds(coordinates):




	#it is consistently the bottom left of the tile to the right,
	#to correct it x-100, y+100 and it should be about the center of the building
	#also the coordinates seem to have had 100 added to atleast the x when passed to this func
	#don't know why


	var realXCoord = coordinates.x - 100
	var realYCoord = coordinates.y + 100

	var left = buildingPosition.x - 100	- (buildingPhysicalSize/2)
	var right = buildingPosition.x - 100 + (buildingPhysicalSize/2)

	var top = buildingPosition.y + 100 + (buildingPhysicalSize/2)
	var bottom = buildingPosition.y + 100 - (buildingPhysicalSize/2)





	if realXCoord > left and realXCoord < right:
		if realYCoord > bottom and realYCoord < top:

			return true

	return false

func SetBuildingPosition(newPos):
	buildingPosition = newPos


func GetBuildingSize():
	return buildingPhysicalSize

func SetImage(image):
	pass
	#texture = load(tileImageDictionary[image])
