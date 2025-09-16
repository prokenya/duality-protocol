extends Node

##sets user_name
func set_user_name(uname:String) -> void:
	G.data.user_name = uname
	G.data.save()

##checks check dualty ptrotocol status
func check_dualty_ptrotocol() -> bool:
	return G.main.duality_protocol_status
