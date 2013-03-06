Feature: Create character
  As a new player
  I want to be able to create a character with a name
  So that I can start playing the game

  - Names can be anything for the moment, but they do need to be set
  - Everyone starts on Earth for now

  Scenario: Creating a character
    When I log in
    And I create a character
    Then my character should exist and start on Earth
