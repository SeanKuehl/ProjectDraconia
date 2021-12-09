extends StaticBody2D

#has a process that gets pos of user click events(use project settings input map)

var tile = preload("res://Game/Scenes/TileStuff/Tile/Tile.tscn")
var startingX = 100
var startingY = 100

var workingX = startingX
var workingY = startingY

var spaceBetweenTiles = 0	#this is the same both vertically as well as horizontally
var tileSize = 200

var tileGrid = []

var currentSelectedTilePosition = []
var lastUnitMoveList = []


var rng = RandomNumberGenerator.new()

signal PlayerWantsToPurchaseSomething()

func _ready():
	rng.randomize()


func Init(mapSize):
	var tempRow = []
	#if mapSize is 10, then grid will be 10*10
	for y in mapSize:
		for x in mapSize:
			var newTile = tile.instance()
			newTile.global_position = Vector2(workingX, workingY)
			get_parent().add_child(newTile)
			tempRow.append(newTile)
			workingX += spaceBetweenTiles + tileSize


		workingY += spaceBetweenTiles + tileSize
		workingX = startingX
		tileGrid.append(tempRow)
		tempRow = []

	#ForrestPlacement()
	#WaterPlacement()
	#ElevationPlacement()
	#MountainPlacement()


func _process(_delta):
	if Input.is_action_just_pressed("LEFT_CLICK"):
		#take the position and map it to a tile, display this tile's values etc.
		var mousePos = get_viewport().get_mouse_position()

		var mouseX = mousePos[0] - startingX	#this makes it so this equation works regardless of where the grid starts
		var mouseY = mousePos[1] - startingY

		#floor(), round down, ciel() round up
		#this assumes pos is within grid but doesn't check
		var xTiles = stepify((mouseX / (tileSize + spaceBetweenTiles)), 1)	#stepify I believe rounds to the nearest 1
		var yTiles = stepify((mouseY / (tileSize + spaceBetweenTiles)), 1)



		if tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinBounds(mousePos) and PlayerGlobals.GetSelectingUnit() == false:

			if tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinUnitBounds(mousePos):

				PlayerGlobals.SetSelectingUnit(true)
				currentSelectedTilePosition = [int(yTiles), int(xTiles)]
				tileGrid[yTiles][xTiles].DisplayUnitInformation()
				#tell the tile to let the unit do it's selected stuff
				#like show it's movement on surrounding tiles and display it's info

			if tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinBuildingBounds(mousePos):
				#now that this works, make a menu pop up where you can buy a unit of your type
				#may have to disable the tile grid checking for clicks within it while there is a menu up
				emit_signal("PlayerWantsToPurchaseSomething")

		elif tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinBounds(mousePos) and PlayerGlobals.GetSelectingUnit() == true:


			if tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinUnitBounds(mousePos):

				PlayerGlobals.SetSelectingUnit(false)
				RemoveUnitInformationFromTileGrid(lastUnitMoveList)
			else:

				MoveUnitToPos(Vector2(currentSelectedTilePosition[1],currentSelectedTilePosition[0]), Vector2(xTiles, yTiles))
				PlayerGlobals.SetSelectingUnit(false)
			#the above works! Could be expanded to buildings as well by the same idea
			#next step: when unit clicked on, show where it can move based on movement range, maybe tileGrid does this and not unit
			#display pop up of tile



		#print(xTiles)
		#print(yTiles)
		#first make sure that the corrds are within list, then check tile
		#use the below code (y then x) to get the right tile address, the other way messes up some tiles
		#print(tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinBounds(mousePos))


func WaterPlacement():

	#pick a random position
	var gridSize = len(tileGrid)-1	#-1 because range is inclusive, gridSize because grid is of uniform size
	var directions = [[0,1], [1,0], [0,-1], [-1,0]]
	var numberOfTunnels = 15

	while numberOfTunnels > 0:


		var randomXPosition = rng.randi_range(0, gridSize)	#this range is inclusive
		var randomYPosition = rng.randi_range(0, gridSize)

		#pick a random length
		var minLength = 5
		var maxLength = 15
		var randomLength = rng.randi_range(minLength, maxLength)

		#pick a random direction
		var randomDirection = directions[rng.randi_range(0,3)]

		#make tunnel of that size from that position in that direction
		#but first convert the first spot if the first spot is valid
		if (CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition))):
			tileGrid[randomYPosition][randomXPosition].SetTerrain(0, "water")


		while randomLength > 0:
			randomXPosition += randomDirection[0]
			randomYPosition += randomDirection[1]

			if (CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition))):
				tileGrid[randomYPosition][randomXPosition].SetTerrain(0, "water")

			randomLength -= 1

		numberOfTunnels -= 1

func ElevationPlacement():
	var minElevation = 1	#water has lower elevation, but it's a special case
	var maxElevation = 5

	var elevationGrid = []


	var gridSize = len(tileGrid)

	for i in gridSize+1:


		var line = []

		for x in gridSize+1:
			line.append(rng.randi_range(minElevation, maxElevation))



		line = AdjacentMin(line)

		elevationGrid.append(line)

	#now assign the elevation to the actual tiles
	#print(tileGrid[0][0].SetTerrain(1, "land"))
	#there are +1's elsewhere but here because elevationGrid was always one size too small
	#but now that it's made right it's the right size
	for y in gridSize:
		for x in gridSize:
			tileGrid[y][x].SetTerrain(elevationGrid[y][x], "")

func AdjacentMin(noise):
	var output = []
	for i in range(len(noise) - 1):
	  #for more valleys than hills,  use min.
	  #more hills use max
	  #for a mix of both use average
		output.append(min(noise[i], noise[i+1]))

	return output

func MountainPlacement():
	#pick a random position
	var gridSize = len(tileGrid)-1	#-1 because range is inclusive, gridSize because grid is of uniform size
	var directions = [[0,1], [1,0], [0,-1], [-1,0]]

	var terrainFeature = "land"

	var randomXPosition = rng.randi_range(0, gridSize)	#this range is inclusive
	var randomYPosition = rng.randi_range(0, gridSize)
	#var randomXPosition = 4
	#var randomYPosition = 4

	var originalX = randomXPosition
	var originalY = randomYPosition

	var randomPlacementDirection = directions[rng.randi_range(0,3)]
	var randomDispersalDirection = [randomPlacementDirection[1], randomPlacementDirection[0]]	#the placement direction but flipped

	var randomPlacementLength = rng.randi_range(2,5)
	#var randomPlacementLength = 4
	var randomDispersalLength = rng.randi_range(2, 10)


	var tempDLength = randomDispersalLength
	var tempPLength = randomPlacementLength



	while tempPLength > 0:

		originalX = randomXPosition
		originalY = randomYPosition

		#place the first point
		if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
			tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

		while (tempDLength-1) > 0:


			randomXPosition += randomDispersalDirection[0]
			randomYPosition += randomDispersalDirection[1]


			if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
				tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

			tempDLength -= 1

		randomXPosition = originalX
		randomYPosition = originalY

		randomXPosition += randomPlacementDirection[0]
		randomYPosition += randomPlacementDirection[1]

		tempPLength -= 1
		tempDLength = rng.randi_range(2, 10)



func ForrestPlacement():

	var gridSize = len(tileGrid)-1
	var right = [1,0]
	var left = [-1,0]
	var up = [0,-1]
	var down = [0,1]

	var terrainFeature = "land"

	var randomXPosition = rng.randi_range(0, gridSize)
	var randomYPosition = rng.randi_range(0, gridSize)



	var originalXPosition = randomXPosition
	var originalYPosition = randomYPosition

	var randomSize = rng.randi_range(1,3)

	var sideLength = 0
	var tempSideLength = 0

	#do the center coordinate
	if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
		tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

	#go sideLength tiles right from top left, and so on for the four corners of the new size
	while randomSize > 0:
		randomXPosition = originalXPosition
		randomYPosition = originalYPosition

		sideLength = ((randomSize-1) * 2) + 3
		tempSideLength = sideLength
		#go to top left and go right
		randomXPosition = originalXPosition - randomSize
		randomYPosition = originalYPosition - randomSize
		if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
			tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)	#don't assign elevation, that's another algorithm's job

		while (tempSideLength-1) > 0:
			#minus one because we already did the first spot above
			randomXPosition += right[0]
			randomYPosition += right[1]

			if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
				tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

			tempSideLength -= 1

		#go to top right and go down
		tempSideLength = sideLength

		randomXPosition = originalXPosition + randomSize
		randomYPosition = originalYPosition - randomSize
		if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
			tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)


		while (tempSideLength-1) > 0:
			#minus one because we already did the first spot above
			randomXPosition += down[0]
			randomYPosition += down[1]

			if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
				tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

			tempSideLength -= 1

		#go left from bottom right
		tempSideLength = sideLength

		randomXPosition = originalXPosition + randomSize
		randomYPosition = originalYPosition + randomSize

		if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
			tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)


		while (tempSideLength-1) > 0:
			#minus one because we already did the first spot above
			randomXPosition += left[0]
			randomYPosition += left[1]

			if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
				tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

			tempSideLength -= 1


		#go up from bottom left
		tempSideLength = sideLength

		randomXPosition = originalXPosition - randomSize
		randomYPosition = originalYPosition + randomSize

		if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
			tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)


		while (tempSideLength-1) > 0:
			#minus one because we already did the first spot above
			randomXPosition += up[0]
			randomYPosition += up[1]

			if CoordinateWithinGridBounds(Vector2(randomXPosition, randomYPosition)):
				tileGrid[randomYPosition][randomXPosition].SetTerrain(0, terrainFeature)

			tempSideLength -= 1


		#now that all the loops are done
		randomSize -= 1

#forrest placement, mountain placement, hill/elevation placement


func CoordinateWithinGridBounds(coordinate):
	if coordinate.x >= 0 and coordinate.x <= (len(tileGrid)-1):
		if coordinate.y >= 0 and coordinate.y <= (len(tileGrid)-1):
			return true
	return false



#unit should be a unit class or a derivative
#unitPosition should be a vector2
func AddUnitToGrid(unit, unitPosition):

	unit.connect("DisplayUnitStuff", self, "DisplayUnitInformationOnTileGrid")
	unit.connect("StartedMoving", self, "RemoveUnitInformationFromTileGrid")

	if CoordinateWithinGridBounds(unitPosition):
		tileGrid[unitPosition.y][unitPosition.x].AddUnitToTile(unit)


func AddBuildingToGrid(building, buildingPosition):

	if CoordinateWithinGridBounds(buildingPosition):
		tileGrid[buildingPosition.y][buildingPosition.x].AddBuildingToTile(building)

#attempt to move a unit at one position to another
#unitPosition should be a vector2
func MoveUnitToPos(firstPosition, secondPosition):

	if CoordinateWithinGridBounds(firstPosition) and CoordinateWithinGridBounds(secondPosition):

		tileGrid[firstPosition.y][firstPosition.x].MoveUnitToPos(firstPosition, secondPosition, tileSize, spaceBetweenTiles)
		var unitReference = tileGrid[firstPosition.y][firstPosition.x].GetAndRemoveUnitReference()

		tileGrid[secondPosition.y][secondPosition.x].SetUnitReference(unitReference)

func DisplayUnitInformationOnTileGrid(movePos):

	lastUnitMoveList = movePos

	for coordinate in movePos:
		tileGrid[currentSelectedTilePosition[0]+coordinate[1]][currentSelectedTilePosition[1]+coordinate[0]].SetBorderImage("Yellow")

	#var placeYouCanMove = Vector2(int(currentSelectedTilePosition[0])+movePos[0], int(currentSelectedTilePosition[1])+movePos[1])
	#tileGrid[placeYouCanMove.y][placeYouCanMove.x].SetBorderImage("Yellow")
	#print(message)

func RemoveUnitInformationFromTileGrid(movePos):



	for coordinate in movePos:
		tileGrid[currentSelectedTilePosition[0]+coordinate[1]][currentSelectedTilePosition[1]+coordinate[0]].RestoreLastBorderImage()

