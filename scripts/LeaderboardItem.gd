class_name LeaderboardItem
extends HBoxContainer

const item: PackedScene = preload("res://scenes/Leaderboards/LeaderboardItem.tscn")
@onready var label_name: Label = $Name
@onready var label_score: Label = $Score


static func new_item(name: String, score: float) -> LeaderboardItem:
	var new_item = item.instantiate()
	new_item.get_node("Name").text = name
	new_item.get_node("Score").text = str(score)
	return new_item
