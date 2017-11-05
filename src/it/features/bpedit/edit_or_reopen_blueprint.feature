Feature: Edit_Or_Reopen_Blueprint

Scenario: Shows error if nothing editing or editable
    Given Player is not editing a blueprint 
    And Player has nothing in his hand
    And Player has nothing in mouseover selection
    
    When Player presses N 
    
    Then Error is returned to player

Scenario: Edit blueprint from hand
    Given Player is not editing a blueprint
    And Player has nothing in mouseover selection
    But Player has a blueprint in his hand
    
    When Player presses N
    
    Then Player is now editing a blueprint
