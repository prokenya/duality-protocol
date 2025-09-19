extends Node

##sets user_name
func set_user_name(uname:String) -> void:
	G.data.user_name = uname
	G.data.save()

###checks check dualty ptrotocol status
#func check_dualty_ptrotocol() -> bool:
	#return G.main.duality_protocol_status

#OS alert
func alert(text:String) -> void:
	OS.alert(text)

## use it if you want to notify user 
func pop_up_text(text: String, duration: int):
	G.main.ui.pop_up_text(text, duration)
