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
	var ticketString = "<div class ='section {title}'><h3>{emoticon}{title} ({amount})</h3>".format({
		"emoticon" : Helper.GetEmoticonFromType(type),
		"title" : title,
		"amount" : str(tickets.size())
	})
	var highs = 0
	var lows = 0
	var meds = 0
	
	for ticket in tickets:
		if ticket["Priority"] == Helper.PRIORITY.HIGH:
			highs += 1
		elif ticket["Priority"] == Helper.PRIORITY.MEDIUM:
			meds += 1
		elif ticket["Priority"] == Helper.PRIORITY.LOW:
			lows += 1
	var index = 1
	var size = tickets.size()
	
	if type == Helper.TICKET_TYPE.BUG:
		var str = " "
		str += str(highs) + Helper.GetPriorityHTMLString("b", Helper.PRIORITY.HIGH) + "| "
		str += str(meds) + Helper.GetPriorityHTMLString("b", Helper.PRIORITY.MEDIUM) + "| "
		str += str(lows) + Helper.GetPriorityHTMLString("b", Helper.PRIORITY.LOW)
		str += "<br>"
		ticketString += str
	for ticket in tickets:
		var str = ""
		if type == Helper.TICKET_TYPE.BUG:
			str += Helper.PrettyPrintBugData(ticket, index, size)
			ticketString += str + "<br>"
		else:
			str += Helper.PrettyPrintFeedbackData(ticket, index, size)
			ticketString += str
		index += 1
	ticketString += "</div>"
	return ticketString
	
func CreateReport():
	var tickets = str(Finder.GetBugsOverview().GetTicketAmount())
	var bugString = CreateSection(Helper.TICKET_TYPE.BUG, "Bugs")
	var feedbackString = CreateSection(Helper.TICKET_TYPE.FEEDBACK, "Feedback")
	var suggestionString = CreateSection(Helper.TICKET_TYPE.SUGGESTION, "Suggestions")
	
	var file = FileAccess.open("user://example.html", FileAccess.WRITE)
	if file:
		var html = "
<style>
  body {
	background-color: #1e1e1e;
	color: #ffffff;
	font-family: sans-serif;
  }

  .HIGH { color: #ff5c5c; }     /* red tone */
  .MEDIUM { color: #ffa500; }   /* orange tone */
  .LOW { color: #90ee90; }      /* light green */

/* Container for each section */
.section {
  padding: 12px 20px;
  margin-bottom: 20px;
  border-radius: 6px;
}

/* Different backgrounds per section */
.bugs {
  background-color: #2f2f3f;  /* dark blue-gray */
  border: 1px solid #444466;
}

.feedback {
  background-color: #2f3f2f;  /* dark green-gray */
  border: 1px solid #446644;
}

.suggestions {
  background-color: #3f2f3f;  /* dark purple-gray */
  border: 1px solid #664466;
}
  table {
	border-collapse: collapse;
	width: 100%;
	margin-bottom: 1em;
	background-color: #2c2c2c;
	color: #ffffff;
  }

  td {
	border: 1px solid #444;
	padding: 8px;
	vertical-align: top;
  }

  tr:nth-child(even) {
	background-color: #333333;
  }
</style>
		<html>
		<head><title>REPORT</title></head>
		<body>
			<h2>Definitions</h2>
			<p class='HIGH'>{HIGH}</p> <p>- A big issue, such as a crash or stall</p>
			<p class='MEDIUM'>{MEDIUM}</p> <p>- Missing assets / images, but does not break the game entirely</p>
			<p class='LOW'>{LOW}</p> <p>- A minor issue like a grammatical error</p>
			<br><br>
			{Bugs}
			{Feedback}
			{Suggestions}
		</body>
		</html>
		".format({
			"HIGH" : Helper.GetTicketTypeHTMLString(Helper.PRIORITY.HIGH),
			"MEDIUM" : Helper.GetTicketTypeHTMLString(Helper.PRIORITY.MEDIUM),
			"LOW" : Helper.GetTicketTypeHTMLString(Helper.PRIORITY.LOW),
			"Bugs" : bugString,
			"Feedback" : feedbackString,
			"Suggestions" : suggestionString
		})
		file.store_string(html)
		file.close()
	OS.shell_open(ProjectSettings.globalize_path("user://example.html"))

func _on_create_report_button_button_up() -> void:
	CreateReport()
