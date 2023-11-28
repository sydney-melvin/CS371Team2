-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local starfield1
local starfield2
local runtime = 0
local scrollSpeed = 1.4


local composer = require("composer")
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------


-- "scene:create()"
function scene:create(event)
    local sceneGroup = self.view
	

    local function addScrollableBg()
        local starfield = { type="image", filename="starfield.png" }
        -- Add First bg image
        starfield1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
        starfield1.fill = starfield
        starfield1.x = display.contentCenterX
        starfield1.y = display.contentCenterY

        -- Add Second bg image
        starfield2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
        starfield2.fill = starfield
        starfield2.x = display.contentCenterX  - display.actualContentWidth
        starfield2.y = display.contentCenterY
    end

    local function moveBg(dt)
        starfield1.x = starfield1.x + scrollSpeed * dt
        starfield2.x = starfield2.x + scrollSpeed * dt

        if (starfield1.x - display.contentWidth/2) > display.actualContentWidth then
            starfield1:translate(-starfield1.contentWidth * 2, 0)
        end
        if (starfield2.x - display.contentWidth/2) > display.actualContentWidth then
            starfield2:translate(-starfield2.contentWidth * 2, 0)
        end
    end

    local function getDeltaTime()
    local temp = system.getTimer()
    local dt = (temp-runtime) / (1000/60)
    runtime = temp
    return dt
    end

    local function enterFrame()
        local dt = getDeltaTime()
        moveBg(dt)
    end

    function init()
        addScrollableBg()
        Runtime:addEventListener("enterFrame", enterFrame)
    end

    init()

end

-- "scene:show()"
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then


        -- Called when the scene is still off screen (but is about to come on screen).
    elseif (phase == "did") then
		

    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    end
end

-- "scene:hide()"
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif (phase == "did") then
    -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy(event)
    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end






---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

---------------------------------------------------------------------------------

return scene
