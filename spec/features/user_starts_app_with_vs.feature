Feature: user starts app with file

  	As a user
	I want to start an app with file
	So that I can get an image

	Scenario: start app with file
		Given I am not yet playing
		Given I have a empty directory "Dhofar 132"		
		Given I have a VisualStage data "Dhofar 132/BCG12-with-ID"
		Given I have started VisualStage with "Dhofar 132/BCG12-with-ID"

		Given I have a file "Dhofar 132/chitech@002.tif"
		Given I have a file "Dhofar 132/chitech@002.txt"
		Given I have a file "Dhofar 132/chitech@004.tif"
		Given I have a file "Dhofar 132/chitech@004.txt"
	
		When I start a new app with "Dhofar\ 132/chitech@002.tif Dhofar\ 132/chitech@004.tif"
		Then I should have a file "Dhofar 132/deleteme.d/@crop/chitech@002.tif"
		And I should have a file "Dhofar 132/deleteme.d/@crop/chitech@002.vs"
		And I should have a file "Dhofar 132/deleteme.d/@crop@spin/chitech@002.tif"
		And I should have a file "Dhofar 132/deleteme.d/@crop@spin/chitech@002.vs"
		Then I should have a file "Dhofar 132/deleteme.d/@crop/chitech@004.tif"
		And I should have a file "Dhofar 132/deleteme.d/@crop/chitech@004.vs"
		And I should have a file "Dhofar 132/deleteme.d/@crop@spin/chitech@004.tif"
		And I should have a file "Dhofar 132/deleteme.d/@crop@spin/chitech@004.vs"

		And I start a new app with "Dhofar\ 132/chitech@002.tif Dhofar\ 132/chitech@004.tif"
		And I start a new app with "Dhofar\ 132/chitech@002.tif Dhofar\ 132/chitech@004.tif"
		And I stop VisualStage