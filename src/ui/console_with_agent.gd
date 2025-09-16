class_name ConsoleWithAgent
extends Console

func _ready() -> void:
	super()
	
	edit.text_submitted.connect(text_subm)

@export var agent: Player2AINPC:
	set(value):
		var old_agent = agent
		
		if old_agent and old_agent.chat_received.is_connected(connect_agent):
			old_agent.chat_received.disconnect(connect_agent)
			old_agent.tool_called.disconnect(tool_called)
			#agent.thinking_began.disconnect(busy)

		agent = value

		if agent and not agent.chat_received.is_connected(connect_agent):
			agent.chat_received.connect(connect_agent)
			agent.tool_called.connect(tool_called)
			#agent.thinking_began.connect(busy)
			print_history()
			

func connect_agent(m: String):
	push_text(agent.character_name + shell_prompt, m)

func tool_called(func_name:String,args:Dictionary):
	await get_tree().process_frame
	match func_name:
		"set_user_name":
			shell_prompt_label.text = G.data.user_name + self.shell_prompt
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
					push_text(speaker + shell_prompt, msg)
		elif m.role == "assistant":
			push_text(agent.character_name + shell_prompt, m.message)

func text_subm(text:String):
	agent.chat(text, G.data.user_name)
