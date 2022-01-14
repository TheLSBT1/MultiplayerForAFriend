extends Control

onready var ip_label = $host/your_ip
onready var connection_screen_label = $ColorRect/Label
onready var join_button = $join
onready var server_ip = $join/server_ip

func _ready() -> void:
	# 3 for windows
	# 7 for mac
	# idk for liux
	
	ip_label.text = "Your IP : " + str(IP.get_local_addresses()[3])
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	
func _on_host_pressed() -> void:
	Network.start_server()
	
	connection_screen_label.get_parent().show()
	connection_screen_label.text = "Waiting For Max Players"


func _on_join_pressed() -> void:
	Network.create_client(server_ip.text)
	
	connection_screen_label.get_parent().show()
	connection_screen_label.text = "Joining Server"

func _on_server_ip_text_changed(new_text: String) -> void:
	if server_ip.text.is_valid_ip_address():
		join_button.disabled = false
	else:
		join_button.disabled = true
