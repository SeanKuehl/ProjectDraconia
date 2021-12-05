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



func CheckIfCoordinatesWithinBounds(coordinates):
	#something is really wrong with these coordinates
	#tiles are uniform size
	var rectangle = $Sprite.texture.get_rect()
	print(rectangle)
#	var right = topLeft.x + (buildingPhysicalSize/2)
#	var left = topLeft.x  - (buildingPhysicalSize/2)
#	var top = topLeft.y - (buildingPhysicalSize/2)
#	var bottom = topLeft.y + (buildingPhysicalSize/2)
#
	var left = 0
	var right = 0

#	print(right)
#	print(left)
	#print(top)
	#print(bottom)



	if coordinates.x > left and coordinates.x < right:
#		if coordinates.y < bottom and coordinates.y > top:

		return true

	return false

func GetBuildingSize():
	return buildingPhysicalSize

func SetImage(image):
	pass
	#texture = load(tileImageDictionary[image])
