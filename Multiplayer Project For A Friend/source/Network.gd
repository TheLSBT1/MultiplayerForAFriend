extends Node2D

const RPC_PORT_ = 31400
const MAX_PLAYERS_ = 2 # Not recommended to go too high (above 4000)
const TEMP_IP = "127.0.0.1"
const IS_OFFLINE_ = false

var network_id = null
var is_host = false
var peers = []

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	
func _on_player_connected(id : int) -> void:
	peers.append(id)
	create_player(id)
	if not Network.is_host:
		rpc("set_peers", peers)
		set_peers(peers)
		
func _on_player_disconnected(id : int) -> void:
	peers.erase(id)
	remove_player(id)
	if not Network.is_host:
		rpc("set_peers", peers)
		set_peers(peers)
	
func create_player(id : int) -> void:
	var player = preload("res://src/player/player.tscn").instance()
	player.initialize(id)
	add_child(player)
	
func start_server():
	is_host = true
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(RPC_PORT_, MAX_PLAYERS_) 
	get_tree().network_peer = peer
	
	# Quick Start
	quick_start()
	
# Create's a client that is used to join a server.
func create_client(server_ip : String):
	if IS_OFFLINE_:
		server_ip = TEMP_IP
		
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, RPC_PORT_)
	get_tree().network_peer = peer
	
	# Quick Start
	quick_start()
	
func quick_start() -> void:
	print("Quick Starting...")
	network_id = get_tree().get_network_unique_id()
	create_player(network_id)
	get_tree().change_scene("res://src/world/world.tscn")

# Remote Functions
remote func set_peers(new_peers : Array) -> void:
	new_peers = peers
	
remote func remove_player(id : int) -> void:
	get_node(str(id)).queue_free()
