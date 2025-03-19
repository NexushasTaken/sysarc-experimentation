extends Control


@onready var login_mail: LineEdit = $Login/login_mail
@onready var login_pass: LineEdit = $Login/login_pass
@onready var register_mail: LineEdit = $Register/register_mail
@onready var register_pass: LineEdit = $Register/register_pass


signal login_success
signal register_success

func _ready() -> void:
	Supabase.auth.signed_in.connect(_on_signed_in)
	Supabase.auth.signed_up.connect(_on_signed_up)
	Supabase.auth.error.connect(_on_error)


func login():
	var mail: String = login_mail.text.strip_edges()
	var pwd: String = login_pass.text.strip_edges()
	Supabase.auth.sign_in(mail, pwd)


func register():
	var mail: String = register_mail.text.strip_edges()
	var pwd: String = register_pass.text.strip_edges()
	Supabase.auth.sign_up(mail, pwd)


func _on_signed_in(user : SupabaseUser):
	print("Successfully signed as ", user)
	emit_signal("login_success")

func _on_signed_up(user : SupabaseUser):
	print("Successfully registered as ", user)
	emit_signal("register_success")
	
func _on_error(error : SupabaseAuthError):
	print(error)


func _on_btn_register_pressed() -> void:
	register()


func _on_btn_login_pressed() -> void:
	login()
