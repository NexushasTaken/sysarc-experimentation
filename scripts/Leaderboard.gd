extends Control

@onready var list: VBoxContainer = $VBoxContainer/ScrollContainer/PlayerList

enum Labels {
	LOAD_FROM_DISK,
	LOAD_FROM_DATABASE,
	SAVE_TO_DISK,
	CLEAR,
}

func _ready() -> void:
	Supabase.database.selected.connect(_on_selected)

func _on_refresh_pressed() -> void:
	select()

func select():
	var public_users = SupabaseQuery.new().from("users").select(["*"]).order("score", SupabaseQuery.Directions.Descending)
	var task: BaseTask = await Supabase.database.query(public_users).completed
	if task.error != null:
		load_from_disk()
	else:
		clear()
		add(task.data)
		change_label(Labels.LOAD_FROM_DATABASE)

func save_to_disk() -> void:
	var saves = []
	for child in list.get_children():
		var save_dict = {
			"name": child.get_node("Name").text,
			"score": child.get_node("Score").text,
		}
		saves.append(save_dict)
	var save_file = FileAccess.open("user://leaderboard.save", FileAccess.WRITE)
	var json_str = JSON.stringify(saves)
	save_file.store_string(json_str)
	save_file.close()

	change_label(Labels.SAVE_TO_DISK)

func load_from_disk() -> bool:
	if not FileAccess.file_exists("user://leaderboard.save"):
		return false
	var save_file = FileAccess.open("user://leaderboard.save", FileAccess.READ)
	var json_str = save_file.get_as_text()
	var json = JSON.parse_string(json_str)

	if typeof(json) == TYPE_ARRAY:
		if len(json) == 0:
			return false

		clear()
		add(json)
		change_label(Labels.LOAD_FROM_DISK)
	return true

func _on_selected(result: Array):
	pass

func clear() -> void:
	for child in list.get_children():
		child.queue_free()
	change_label(Labels.CLEAR)

func add(users: Array) -> void:
	for user in users:
		var item = LeaderboardItem.new_item(user["name"], float(user["score"]))
		list.add_child(item)

func change_label(l: Labels) -> void:
	$VBoxContainer/LoadedFromDisk.hide()
	$VBoxContainer/LoadedFromDatabase.hide()
	$VBoxContainer/SaveToDisk.hide()
	$VBoxContainer/Clear.hide()
	match l:
		Labels.LOAD_FROM_DISK:
			$VBoxContainer/LoadedFromDisk.show()
		Labels.LOAD_FROM_DATABASE:
			$VBoxContainer/LoadedFromDatabase.show()
		Labels.SAVE_TO_DISK:
			$VBoxContainer/SaveToDisk.show()
		Labels.CLEAR:
			$VBoxContainer/Clear.show()


func _on_save_to_disk_pressed() -> void:
	save_to_disk()


func _on_load_from_disk_pressed() -> void:
	load_from_disk()


func _on_clear_pressed() -> void:
	clear()
