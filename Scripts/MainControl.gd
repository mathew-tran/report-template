extends CanvasLayer

class_name MainControl

signal OnBugAdded(bugData)

func _on_create_ticket_button_button_up() -> void:
	$Panel.Open(null)

func OpenBug(bugData):
	$Panel.Open(bugData)
	
func CreateSection(type, title):
	var tickets = Finder.GetBugsOverview().GetTicketsOfType(type)
	if tickets.size() == 0:
		return ""
	var ticketString = "<h3>{emoticon}{title} ({amount}):</h3><br>".format({
		"emoticon" : Helper.GetEmoticonFromType(type),
		"title" : title,
		"amount" : str(tickets.size())
	})
	var index = 1
	var size = tickets.size()
	for ticket in tickets:
		var str = ""
		if type == Helper.TICKET_TYPE.BUG:
			str += Helper.PrettyPrintBugData(ticket, index, size)
			ticketString += str + "<br>"
		else:
			str += Helper.PrettyPrintFeedbackData(ticket, index, size)
			ticketString += str
		index += 1
	return ticketString
	
func CreateReport():
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
	table {
	  border-collapse: collapse;
	  width: 100%;
	  margin-bottom: 1em;
	}
	td {
	  border: 1px solid #ccc;
	  padding: 8px;
	  vertical-align: top;
	}
	tr:nth-child(even) {
	  background-color: #f9f9f9;
	}
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

func _on_create_report_button_button_up() -> void:
	CreateReport()
