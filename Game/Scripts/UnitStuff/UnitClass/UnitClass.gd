extends KinematicBody2D


onready var unitImagesDirectory = "res://Game/Assets/Images/UnitImages/"


var unitPhysicalSize = 40 #this would have to change if unit size ever changed

var health = 0
var unitName = ""
var description = ""
var allegiance = ""
var movementRange = 0

#the sprite is for testing only!
var velocity = Vector2.ZERO
var speed = 10
var moving = false
var movementDiff = []
var movementSteps = []
var movementStepIndex = 0
var movementGrid = []


signal DisplayUnitStuff(message)
signal StartedMoving(message)

func CheckIfCoordinatesWithinBounds(coordinates):
	#tiles are uniform size
	var topLeft = position
	var right = topLeft.x + (unitPhysicalSize/2)
	var left = topLeft.x  - (unitPhysicalSize/2)
	var top = topLeft.y - (unitPhysicalSize/2)
	var bottom = topLeft.y + (unitPhysicalSize/2)





	if coordinates.x > left and coordinates.x < right:
		if coordinates.y < bottom and coordinates.y > top:

			return true

	return false



func SetImage(image):
	pass
	#texture = load(tileImageDictionary[image])



func ShowMyStuff():
	#make list of positions you can move to, from the perspective of
	#this unit's current position
	#ex. [1,1] is the current pos +1x and +1y
	movementGrid = [[-1,-1], [-1,0], [-1,1], [-1,0], [1,-1], [1,0], [1,1], [0,1], [0,-1]]
	emit_signal("DisplayUnitStuff", movementGrid)
#export (int) var speed = 1200
#export (int) var jump_speed = -1800
#export (int) var gravity = 4000
#
#var velocity = Vector2.ZERO
#
#func get_input():
#    velocity.x = 0
#    if Input.is_action_pressed("walk_right"):
#        velocity.x += speed
#    if Input.is_action_pressed("walk_left"):
#        velocity.x -= speed
#
#func _physics_process(delta):
#    get_input()
#    velocity.y += gravity * delta
#    velocity = move_and_slide(velocity, Vector2.UP)
#    if Input.is_action_just_pressed("jump"):
#        if is_on_floor():
#            velocity.y = jump_speed




func _physics_process(delta):

	if moving:
#		if abs(movementDiff[0]) > abs(movementDiff[1]):
#			velocity.x = 0
#			velocity.x += speed
#			velocity = move_and_collide(velocity)
		#velocity.x = 0
		#velocity.x += speed
		#print(movementSteps[0])

		velocity = position.direction_to(movementSteps[movementStepIndex]) * speed

		#print(movementSteps[0], position)
		#movementStepIndex
		velocity = move_and_slide(velocity)

		if position.x < movementSteps[movementStepIndex].x+1 and position.x > movementSteps[movementStepIndex].x-1:
			if position.y < movementSteps[movementStepIndex].y+1 and position.y > movementSteps[movementStepIndex].y-1:

				#it's reached the location for that step, go onto the next one
				if movementStepIndex+1 < len(movementSteps)-1:

					movementStepIndex += 1
				else:
					#it's reached the destination and is done
					moving = false




		#velocity = move_toward(velocity.x+100.0, delta, delta)
		#velocity = move_and_slide(velocity)



func Move(xDiff, yDiff, tileSize, spaceBetweenTiles):

	movementSteps = []	#clear the steps for this upcoming iteration

	#the unit will move there in steps, each step is a tile in a direction

	var currentPosition = global_position



	while abs(xDiff) > 0 or abs(yDiff) > 0:
		if abs(xDiff) > abs(yDiff):

			#take step to close y gap
			if xDiff > 0:
				#move a tile forward
				movementSteps.append(Vector2(currentPosition.x+tileSize+spaceBetweenTiles, currentPosition.y))
				currentPosition = movementSteps[-1]
				xDiff -= 1
			elif xDiff < 0:

				#move a tile back
				movementSteps.append(Vector2(currentPosition.x-tileSize-spaceBetweenTiles, currentPosition.y))
				currentPosition = movementSteps[-1]
				xDiff += 1



		else:
			if yDiff > 0:
				#move a tile up
				movementSteps.append(Vector2(currentPosition.x, currentPosition.y+tileSize+spaceBetweenTiles))
				currentPosition = movementSteps[-1]
				yDiff -= 1
			elif yDiff < 0:
				#move a tile down
				movementSteps.append(Vector2(currentPosition.x, currentPosition.y-tileSize-spaceBetweenTiles))
				currentPosition = movementSteps[-1]
				yDiff += 1


	moving = true

	#it's started moving, remove visual movement grid
	emit_signal("StartedMoving", movementGrid)







