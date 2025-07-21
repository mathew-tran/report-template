extends Panel

@export var TicketChoice : OptionButton
@export var PriorityChoice : OptionButton
@export var TitleText : TextEdit
@export var DescriptionText : TextEdit
@export var UpdateButton : Button
@export var BugNumberText : Label
@export var ErrorText : Label

var bCanTab = true
func GetData():
	return {
		"BugNumber" : BugNumberText.text,
		"Type" : TicketChoice.selected,
		"Priority" : PriorityChoice.selected,
		"Title" : TitleText.text,
		"Desc" : DescriptionText.text
	}
	
func CanUpdate():
	return TitleText.text != "" and DescriptionText.text != ""
	
func _on_button_button_up() -> void:
	if is_visible_in_tree():
		if CanUpdate():
			print(GetData())
			Finder.GetMainControl().OnBugAdded.emit(GetData())
			visible = false
			ErrorText.text = ""
		else:
			ErrorText.text = "Title or description is empty!"

func _process(delta: float) -> void:
	if is_visible_in_tree():
		if Input.is_action_pressed("escape"):
			visible = false
	else:
		if Input.is_action_just_pressed("new_bug"):
			visible = true
		if Input.is_action_just_pressed("create_report"):
			Finder.GetMainControl().CreateReport()
func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		Reset()
		
func Reset():
	TicketChoice.select(0)
	PriorityChoice.select(0)
	TitleText.text = ""
	DescriptionText.text = ""
	ErrorText.text = ""
	TitleText.grab_focus()


func _on_back_button_button_up() -> void:
	visible = false
