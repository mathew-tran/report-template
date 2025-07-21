extends Panel

@export var TicketChoice : OptionButton
@export var PriorityChoice : OptionButton
@export var TitleText : TextEdit
@export var DescriptionText : TextEdit
@export var UpdateButton : Button
@export var BugNumberText : Label
@export var ErrorText : Label

var bCanTab = true
var bIsDeleted = false

func _ready() -> void:
	ErrorText.text = ""
func GetData():
	return {
		"BugNumber" : BugNumberText.text,
		"Type" : TicketChoice.selected,
		"Priority" : PriorityChoice.selected,
		"Title" : TitleText.text,
		"Desc" : DescriptionText.text,
		"Deleted" : bIsDeleted
	}
	
func SetData(bugData):
	BugNumberText.text = bugData["BugNumber"]
	TicketChoice.selected = bugData["Type"]
	PriorityChoice.selected = bugData["Priority"]
	TitleText.text = bugData["Title"]
	DescriptionText.text = bugData["Desc"]
	
func CanUpdate():
	return TitleText.text != "" and DescriptionText.text != ""
	
func Open(bugData):
	$DeleteButton.visible = bugData != null
	if bugData == null:
		pass
		BugNumberText.text = str(Finder.GetBugsOverview().LatestBugNumber)
		UpdateButton.text = "CREATE"
		$VBoxContainer/Label.text = "CREATE TICKET"
	else:
		SetData(bugData)
		UpdateButton.text = "UPDATE"
		$VBoxContainer/Label.text = "UPDATE TICKET"
	bIsDeleted = false
	visible = true
	
func _on_button_button_up() -> void:
	if is_visible_in_tree():
		if CanUpdate():
			print(GetData())
			Finder.GetMainControl().OnBugAdded.emit(GetData())
			visible = false
			ErrorText.text = ""
			Reset()
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
	pass
		
func Reset():
	TicketChoice.select(0)
	PriorityChoice.select(1)
	TitleText.text = ""
	DescriptionText.text = ""
	ErrorText.text = ""
	TitleText.grab_focus()


func _on_back_button_button_up() -> void:
	visible = false


func _on_reset_button_button_up() -> void:
	Reset()


func _on_delete_button_button_up() -> void:
	bIsDeleted = true
	_on_button_button_up()
	bIsDeleted = false
