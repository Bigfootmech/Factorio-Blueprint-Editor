Feature: Edit_Or_Reopen_Blueprint

Scenario: Shows error if nothing editing or editable
    Given Player one is not editing a blueprint 
    And Player one does not have anything in his hand
    And Player one does not have anything in mouseover selection
    
    When Player one presses N 
    
    Then Error is returned to player

Scenario: Edit blueprint from hand
    Given Player one is not editing a blueprint
    And Player one does not have anything in mouseover selection
    But Player one has a blueprint in his hand
    
    When Player one presses N
    
    Then Player one is editing a blueprint
