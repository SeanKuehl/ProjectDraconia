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


var rng = RandomNumberGenerator.new()

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

	ForrestPlacement()
	#WaterPlacement()


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

		if tileGrid[yTiles][xTiles].CheckIfCoordinatesWithinBounds(mousePos):
			#display pop up of tile
			pass

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
