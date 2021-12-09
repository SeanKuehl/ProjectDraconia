extends Node2D

const PORT = 27015

var client : NetworkedMultiplayerENet
var my_id : int = -1
var me_created : bool = false

onready var unitClass = load("res://Game/Scenes/UnitStuff/UnitClass/UnitClass.tscn")
onready var buildingClass = load("res://Game/Scenes/BuildingStuff/BuildingClass/BuildingClass.tscn")

onready var purchaseTroopMenu = load("res://Game/Scenes/BuildingStuff/BuildingMenus/BuyTroopsMenu.tscn")

var currentTroopPurchaseMenu = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	InitClient()
	#Server.Init()
	#Client.Init()
#	$TileGrid.connect("PlayerWantsToPurchaseSomething", self, "DisplayTroopPurchaseMenu")
#
#	$TileGrid.Init(10)
#
#	#var newUnit = unitClass.instance()
#	#add_child(newUnit)
#	#var positionOfUnit = Vector2(1,1)
#	var newBuilding = buildingClass.instance()
#	add_child(newBuilding)
#	var positionOfBuilding = Vector2(1,1)
#	$TileGrid.AddBuildingToGrid(newBuilding, positionOfBuilding)
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

remote func ClientInitializeTileGrid(gridSize, randomSeed):
	$TileGrid.Init(gridSize, randomSeed)

remote func ClientSetColorAndAllegiance(options):

	var randomColorAndAllegiance = options[rng.randi_range(0,len(options)-1)]
	get_tree().get_root().get_node("World").get_node("Player").SetColorAndAllegiance(randomColorAndAllegiance[0], randomColorAndAllegiance[1])
	options.erase(randomColorAndAllegiance)
	#return what is left of options for other clients to use, potentially
	return options

func InitClient():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
#	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
#	$ui/button.connect("pressed", self, "_on_connect_pressed")

	create_map()
	client = NetworkedMultiplayerENet.new()

	client.create_client("127.0.0.1", PORT)
	get_tree().network_peer = client

func _on_connection_failed():
#	display_message("Connection failed!")
	get_tree().set_network_peer(null)

func _on_connected_to_server():

	print("I as a client connected")

#	my_id = get_tree().get_network_unique_id()
#	display_message("Connection established. Your id is " + str(my_id))
#
#	# Player
#	var player = player_scn.instance()
#	player.set_name(str(my_id))
#	world.get_node("players").add_child(player)
#	player.get_node("head/camera").current = true
#	me_created = true

func _on_server_disconnected():
	pass
#	display_message("Server disconnected.")

func _player_connected(id):

	print("player "+str(id)+" connected")


	#var game = preload("res://Game/Scenes/World/World.tscn").instance()
	var game = get_tree().get_root().get_node("World")
	game.set_network_master(get_tree().get_network_unique_id())
	#player1.set_name(str(get_tree().get_network_unique_id()))
	#player1.set_network_master(get_tree().get_network_unique_id())
	#get_tree().get_root().add_child(game)
	#Globals.player2id = id
	#var game = preload("res://Game/Scenes/World/World.tscn").instance()

	#get_tree().get_root().add_child(game)
#	if me_created:
#		var player = puppet_scn.instance()
#		player.set_name(str(id))
#		world.get_node("players").add_child(player)


#func _player_disconnected(id):
#	for n in world.get_node("players").get_children():
#		if int(n.name) == id:
#			world.get_node("players").remove_child(n)
#			n.queue_free()

#func _on_connect_pressed():
#	$ui/button.visible = false
#	display_message("Connecting...")
#	var ip = "localhost"
#	if !ip.is_valid_ip_address():
#		display_message("IP is invalid!")
#	client.create_client(ip, PORT)
#	get_tree().set_network_peer(client)

func create_map():
	# Map
#	var map = load("scenes/map.tscn").instance()
#	world.add_child(map)
	pass





