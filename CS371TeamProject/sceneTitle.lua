-----------------------------------------------------------------------------------------
--
-- scene1.lua
--
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
    local sceneGroup = self.view
 
    -- Display names of group members
    local names = display.newText( 
        "Sydney Melvin, Keenan Coleman, Mickey Stephenson, Quinton Pouncy", 
        0, 
        0, 
        native.systemFont, 
        40 
    )
    names.x = 20 ; names.y = display.contentCenterY - 200
    names:setFillColor( 1, 1, 1 )
    names.anchorX = 0

    -- Create start button to initiate game
    startButton = widget.newButton(
        {
            x = display.contentCenterX,
            y = display.contentCenterY,
            id = "startButton",
            label = "START",
            labelColor = { 
                default={ 0, 0, 1 }, 
                over={ 0, 1, 1, } 
            },
            shape = "roundedRect",
            width = 120,
            height = 80
        }
    )

	    selectedCharacter = ""

    --Use tap to transition to game scene
    function startButton:tap(event)
        --if event.phase == "began" then
        composer.gotoScene(
            "sceneGame",
            {
                effect = "slideLeft",
                params = {
                    character = selectedCharacter
                }
            }
        )
        return true
        --end
    end
    startButton:addEventListener("tap", tap)











    -- Add names and start button to scene group
    sceneGroup:insert( names )
    sceneGroup:insert( startButton )
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene