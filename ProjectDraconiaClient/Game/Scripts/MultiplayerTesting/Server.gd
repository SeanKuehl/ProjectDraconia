extends Node

const PORT = 27015
const MAX_PLAYERS = 32

onready var message = $ui/message
onready var world = $world

var spawn_points = []

#original code from
#https://github.com/blockspacer/Godot-3.2-Multiplayer-FPS


func Init():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(server)

	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

	create_map()

func _client_connected(id):
#	message.text = "Client " + str(id) + " connected."
#	var player = load("res://scenes/player/player.tscn").instance()
#	player.set_name(str(id))
#	world.get_node("players").add_child(player)
#	player.global_transform.origin = spawn_points[randi() % spawn_points.size()].global_transform.origin
	print("player "+str(id)+" connected")

	#Globals.player2id = id
	var game = preload("res://Game/Scenes/World/World.tscn").instance()
	game.set_network_master(get_tree().get_network_unique_id())
	get_tree().get_root().add_child(game)
	#rpc_id(1...) will call the server, since server is always id 1
	#get_tree().get_root().get_node(str(id)).TestFunction()
	#get_tree().get_root().get_node("World").Fake()
	game.rpc("Fake")
	print_tree_pretty()
	#rpc_id(id,"TestFunction")
	#hide()


func _client_disconnected(id):
#	message.text = "Client " + str(id) + " disconnected."
#	for p in world.get_node("players").get_children():
#		if int(p.name) == id:
#			world.get_node("players").remove_child(p)
#			p.queue_free()
	print("player "+str(id)+" disconnected")

func create_map():
	pass
#	var map = load("res://scenes/map.tscn").instance()
#	world.add_child(map)
#	spawn_points = map.get_node("spawn_points").get_children()
