Feature: user starts app with file

  	As a user
	I want to start an app with file
	So that I can get an image

	Scenario: start app with file
		Given I am not yet playing
		Given I have a empty directory "Dhofar 132"
		Given I have a file 'Dhofar 132/chitech@002.tif'
		Given I have a file 'Dhofar 132/chitech@002.vs'
	
		When I start a new app with "Dhofar\ 132/chitech@002.tif"
		Then I should have a file "Dhofar 132/deleteme.d/@crop/chitech@002.tif"
		And I should have a file "Dhofar 132/deleteme.d/@crop/chitech@002.vs"
		And I should have a file "Dhofar 132/deleteme.d/@crop@spin/chitech@002.tif"
		And I should have a file "Dhofar 132/deleteme.d/@crop@spin/chitech@002.vs"

