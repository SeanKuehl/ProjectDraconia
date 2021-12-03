extends Node2D



func _ready():

	#Server.Init()
	#Client.Init()
	print_tree_pretty()

#rpc the func from the node that owns it, that fixed my problem
#remote executes only on client, there are others that execute on server and client,
#rpc is needed to execute remote etc. funcs because of network security stuff
