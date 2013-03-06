Feature: Moving around
  As Chaz the character
  I want to be able to move from Earth to Earth Orbit
  So that I can explore the galaxy and make money

  - Need to have enough fuel

  Background:
    Given I am playing Chaz
    And I am on Earth

  Scenario:
    Given I have enough fuel to travel to Earth Orbit
    When I travel to Earth Orbit
    And enough time passes
    Then I should be in orbit

  Scenario: Not enough fuel
    When I travel to Earth Orbit
    Then I should be told that I don't have enough fuel
