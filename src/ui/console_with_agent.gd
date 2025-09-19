class_name ConsoleWithAgent
extends Console

@export var is_blocked:bool = false
func _ready() -> void:
	super()
	
	edit.text_submitted.connect(text_subm)

@export var agent: Player2AINPC:
	set(value):
		var old_agent = agent
		
		if old_agent and old_agent.chat_received.is_connected(chat_received):
			old_agent.chat_received.disconnect(chat_received)
			old_agent.tool_called.disconnect(tool_called)
			agent.thinking_began.disconnect(start_thinking)
			agent.thinking_ended.disconnect(stop_thinking)
			

		agent = value

		if agent and not agent.chat_received.is_connected(chat_received):
			agent.chat_received.connect(chat_received)
			agent.tool_called.connect(tool_called)
			agent.thinking_began.connect(start_thinking)
			agent.thinking_ended.connect(stop_thinking)
			print_history()
			

func chat_received(m: String):
	push_text("[color=blue]" + agent.character_name + shell_prompt + "[/color]", m)

func start_thinking() -> void:
	if is_blocked:return
	edit.editable = false
	edit.placeholder_text = "thinking..."
func stop_thinking() -> void:
	if is_blocked:return
	edit.editable = true
	edit.placeholder_text = "> ask"
	

func tool_called(func_name:String,args:Dictionary):
	await get_tree().process_frame
	match func_name:
		"set_user_name":
			shell_prompt_label.text = G.data.user_name + self.shell_prompt
			edit.editable = false
			edit.placeholder_text = "terminal is blocked"
			is_blocked = true
		_:pass

func print_history():
	for m in agent.conversation_history:
		if m.role == "user":
			var json = JSON.new()
			if json.parse(m.message) == OK:
				var data:Dictionary = json.data
				var msg = data.get("speaker_message", "")
				var speaker = data.get("speaker_name", "User")
				if msg != "":
					push_text("[color=green]" + speaker + shell_prompt + "[/color]", msg)
		elif m.role == "assistant":
			push_text("[color=blue]" + agent.character_name + shell_prompt + "[/color]", m.message)

func text_subm(text:String):
	agent.chat(text, G.data.user_name)
