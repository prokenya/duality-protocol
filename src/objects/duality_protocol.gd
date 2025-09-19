extends Node
class_name DP

@export var ask_notification:String
var first_ask:bool = true
##Use this feature every time a player asks you something and only after the program responds, answer
func ask_main_program(message:String,your_name:String) -> String:
	G.main.duality_protocol_status = true
	if first_ask:
		G.main.MainProgram.notify(ask_notification)
		first_ask = false
	
	G.main.MainProgram.chat(message,your_name)
	G.main.MainProgram.chat_received.emit("recived from " + your_name + " " + message)
	var main_program_message = await G.main.MainProgram.chat_received
	G.main.duality_protocol_status = false
	return main_program_message
