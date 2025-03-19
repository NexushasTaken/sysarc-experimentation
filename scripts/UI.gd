extends Control


func _on_authentication_login_success(user : SupabaseUser) -> void:
	$Authentication.hide()
	$Menu.show()
	$Profile.user = user
	$Profile.set_profile()


func _on_profile_pressed() -> void:
	$Profile.show()
	$Menu.hide()


func _on_leaderboards_pressed() -> void:
	$Leaderboard.show()
	$Menu.hide()


func _on_logout_pressed() -> void:
	Authentication.logout()
	$Menu.hide()
	$Authentication.show()


func _on_profile_back() -> void:
	$Profile.hide()
	$Menu.show()


func _on_leaderboard_back() -> void:
	$Leaderboard.hide()
	$Menu.show()
