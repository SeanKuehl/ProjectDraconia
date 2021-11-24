extends Camera2D

var cameraMoveAmount = 25






func get_input():




	if Input.is_action_pressed("CAM_RIGHT"):
		position += transform.x * cameraMoveAmount

	if Input.is_action_pressed("CAM_LEFT"):
		position -= transform.x * cameraMoveAmount

	if Input.is_action_pressed("CAM_UP"):
		position -= transform.y * cameraMoveAmount

	if Input.is_action_pressed("CAM_DOWN"):
		position += transform.y * cameraMoveAmount







func _physics_process(_delta):
	#it has zoom property, setting to a vector2(1,1)
	#values larger than 1,1 zoom out and smaller zoom in

	#this will keep the camera within a certain range



	get_input()
