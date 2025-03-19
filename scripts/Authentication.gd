class_name Authentication
extends Control


@onready var login_mail: LineEdit = $Login/login_mail
@onready var login_pass: LineEdit = $Login/login_pass
@onready var register_mail: LineEdit = $Register/register_mail
@onready var register_pass: LineEdit = $Register/register_pass


signal login_success(user : SupabaseUser)
signal register_success(user : SupabaseUser)

func _ready() -> void:
	Supabase.auth.signed_in.connect(_on_signed_in)
	Supabase.auth.signed_up.connect(_on_signed_up)
	Supabase.auth.error.connect(_on_error)
	

func disabled_buttons(b: bool) -> void:
	$Login/btn_login.disabled = b
	$Register/btn_register.disabled = b


func login():
	var mail: String = login_mail.text.strip_edges()
	var pwd: String = login_pass.text.strip_edges()

	disabled_buttons(true)
	var _task = await Supabase.auth.sign_in(mail, pwd).completed
	disabled_buttons(false)

func register():
	var mail: String = register_mail.text.strip_edges()
	var pwd: String = register_pass.text.strip_edges()
	disabled_buttons(true)
	var _task = await Supabase.auth.sign_up(mail, pwd).completed
	disabled_buttons(false)


static func logout() -> void:
	Supabase.auth.sign_out()


func _on_signed_in(user : SupabaseUser):
	print("Successfully signed as ", user)
	emit_signal("login_success", user)

func _on_signed_up(user : SupabaseUser):
	print("Successfully registered as ", user)
	logout()
	emit_signal("register_success", user)
	
func _on_error(error : SupabaseAuthError):
	print("error: ", error)


func _on_btn_register_pressed() -> void:
	register()


func _on_btn_login_pressed() -> void:
	login()
