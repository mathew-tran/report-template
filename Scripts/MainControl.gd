extends CanvasLayer

class_name MainControl

signal OnBugAdded(bugData)

func _on_create_ticket_button_button_up() -> void:
	$Panel.visible = true

func CreateSection(type, title):
	var tickets = Finder.GetBugsOverview().GetTicketsOfType(type)
	if tickets.size() == 0:
		return ""
	var ticketString = "<h1>{title} ({amount}):</h1><br>".format({
		"title" : title,
		"amount" : str(tickets.size())
	})
	var index = 1
	for ticket in tickets:
		var str = ""
		str += Helper.PrettyPrintBugData(ticket, index)
		ticketString += str + "<br>"
		index += 1
	return ticketString
	
func _on_create_report_button_button_up() -> void:
	var tickets = str(Finder.GetBugsOverview().GetTicketAmount())
	var bugString = CreateSection(Helper.TICKET_TYPE.BUG, "BUGS")
	var feedbackString = CreateSection(Helper.TICKET_TYPE.FEEDBACK, "FEEDBACK")
	var suggestionString = CreateSection(Helper.TICKET_TYPE.SUGGESTION, "SUGGESTIONS")
	var file = FileAccess.open("user://example.html", FileAccess.WRITE)
	if file:
		var html = "
		<style>
	.HIGH { color: red; }
	.MEDIUM { color: orange; }
	.LOW { color: green; }
	</style>
		<html>
		<head><title>REPORT</title></head>
		<body>
			<h2>Definitions</h2>
			<h3 class='HIGH'>High</h3> <p>- A big issue, such as a crash or stall</p>
			<h3 class='MEDIUM'>Medium</h3> <p>- Missing assets / images, but does not break the game entirely</p>
			<h3 class='LOW'>Low</h3> <p>- A minor issue like a grammatical error</p>
			<br><br>
			
			{Bugs}
			{Feedback}
			{Suggestions}
		</body>
		</html>
		".format({
			"Bugs" : bugString,
			"Feedback" : feedbackString,
			"Suggestions" : suggestionString
		})
		file.store_string(html)
		file.close()
	OS.shell_open(ProjectSettings.globalize_path("user://example.html"))
