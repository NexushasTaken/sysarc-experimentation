extends Control

@onready var leaderboard: Control = $Leaderboard
@onready var authentication: HBoxContainer = $Authentication



func _on_authentication_login_success() -> void:
	leaderboard.show()
	authentication.hide()
