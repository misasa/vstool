Feature: user starts app with -h

  	As a user
	I want to start an app without args
	So that I can not get an image

	Scenario: start app without args
		Given I am not yet playing
		When I start a new app without file
		Then I should see help message