extends Control

@onready var user_name: LineEdit = $VBoxContainer/Information/Info/Name
@onready var email: LineEdit = $VBoxContainer/Information/Info/Email
@onready var score: LineEdit = $VBoxContainer/Information/Info/Score

var client: RealtimeClient
var user: SupabaseUser

signal back


func _onready():
	#client = Supabase.realtime.client()
	#client.connected.connect(_on_connected)
	#client.connect_client()
	pass
  
func _on_connected():
	#var channel : RealtimeChannel = client.channel("public", "users").insert.connect(_on_insert).subscribe()
	pass

func _on_insert(new_record : Dictionary, channel : RealtimeChannel):
	#print("New Record inserted ", json_parse(new_record), " on ", channel.topic)
	pass

func set_profile() -> void:
	if user != null:
		print(user.dict)
		#user_name.text = user.user_metadata["name"]
		email.text = user.email
		#score.text = str(user.user_metadata["score"])

func update_profile() -> void:
	var task = await Supabase.auth.update(user.email, $VBoxContainer/Information/Info/Password.text, {
		"name": $VBoxContainer/Information/Info/Name.text,
		"score": float($VBoxContainer/Information/Info/Score.text)
	}).completed
	print(task)


func _on_refresh_pressed() -> void:
	set_profile()


func _on_update_pressed() -> void:
	update_profile()


func _on_back_pressed() -> void:
	emit_signal("back")
