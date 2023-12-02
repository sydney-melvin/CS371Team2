-----------------------------------------------------------------------------------------
--
-- sceneGame.lua
--
-----------------------------------------------------------------------------------------
-- Set up physics
local physics = require("physics");
physics.start();
physics.setGravity(0,0);

-- Load sound
local soundTable=require("soundTable");

-- Set up composer scene
local composer = require("composer")
local scene = composer.newScene()

local starfield1
local starfield2
local runtime = 0
local scrollSpeed = 1.4
local hud = nil
local delay = 4000

score = 0 -- score counter
health = 5 -- health counter

-- Score display
textNum = display.newText(score, 400, 70, native.systemFont, 36)
textScore = display.newText("Score: ", 300, 70, native.systemFont, 36)

-- Health display
textNum2 = display.newText(health, 380, 120, native.systemFont, 36)
textHealth = display.newText("HP: ", 300, 120, native.systemFont, 36)

local sceneGroup = display.newGroup()
sceneGroup:insert(textNum)
sceneGroup:insert(textScore)
sceneGroup:insert(textNum2)
sceneGroup:insert(textHealth)

-- "scene:create()"
function scene:create(event)
	

	-- Create the control Bar for the player character
	local controlBar = display.newRect(0, 320, 140, display.contentHeight);
	controlBar:setFillColor(1,1,1,0.5);
	sceneGroup:insert(controlBar)

	-- Create the player character
	local player = display.newCircle(display.contentCenterX-450, display.contentHeight/2, 15);
	physics.addBody(player, "dynamic");
	sceneGroup:insert(player)

	-- Function to move the player character using the control bar
	local function move ( event )
		if event.phase == "began" then		
			player.markY = player.y
		elseif event.phase == "moved" then	 	
			local y = (event.y - event.yStart) + player.markY
			
			if (y <= 20 + player.height/2) then
				player.y = 20+player.height/2;
			elseif (y >= display.contentHeight-20-player.height/2) then
				player.y = display.contentHeight-20-player.height/2;
			else
				player.y = y;		
			end
		end
	end

	-- Add event listener to the control bar to move the player character
	controlBar:addEventListener("touch", move);
	
	-- Function to spawn projectiles from the player character when the screen is tapped
	local function fire (event) 
		local projectile = display.newCircle (player.x + 25, player.y, 5);
		projectile.anchorY = 1;
		projectile:setFillColor(0,1,0);
		physics.addBody (projectile, "dynamic", {radius=5} );
		projectile:applyForce(2,0, projectile.x, projectile.y);	

		audio.play( soundTable["shootSound"] );
		projectile.parent = player

		local function removeProjectile (event)
			if (event.phase=="began") then
				event.target:removeSelf();
				event.target=nil;
				if (event.other.tag == "enemy") then
					event.other.pp:hit();
					if(event.other.pp:getHealth() <= 0) then
						score = score + 100;
						textNum.text = score
					end
				elseif (event.other.tag == "boss") then
					event.other.pp:hit();
					if(event.other.pp:getHealth() <= 0) then
						score = score + 10000;
						textNum.text = score
					end
				end
			end
		end
		projectile:addEventListener("collision", removeProjectile);
	end

	-- Add event listener to the screen to spawn projectiles
	Runtime:addEventListener("tap", fire)
	
	--Enemy
	local Enemy1 = require ("Enemy1");
	local Enemy2 = require ("Enemy2");
	local Boss = require ("Boss");

	local bossLevelDuration = 120 -- 2 minutes in seconds
	local elapsedTime = 0
	local bossSpawned = false
	local enemies = {}

	function spawner()
		elapsedTime = elapsedTime + 4

		-- Check if the elapsed time has reached the boss level duration
		if elapsedTime > bossLevelDuration and not bossSpawned then
			bossSpawned = true

			local boss = Boss:new({xPos=1200, yPos=math.random(1, 640)});
			--sceneGroup:insert(boss)
			boss:spawn();
			boss:move();
			boss:shoot();

			-- loop over all items in the enemies array
			for i = #enemies, 1, -1 do
				local enemy = enemies[i]
				enemy:offScreen()
			end
		elseif not bossSpawned then
			--Square
			en1 = Enemy1:new({xPos=1200, yPos= math.random(1, 640)});
			--sceneGroup:insert(en1)
			en1:spawn();
			en1:move();
			table.insert(enemies, en1)

			--Triangle
			en2 = Enemy2:new({xPos=1200, yPos=math.random(1, 640)});
			--sceneGroup:insert(en2)
			en2:spawn();
			en2:move();
			table.insert(enemies, en2)
		end
	end
	
	local spawnEnemies = timer.performWithDelay(delay, spawner, 100)

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
	
	local function restartGame()
		Runtime:removeEventListener("tap", restartGame)
		composer.gotoScene(
            "sceneTitle",
            {
                effect = "slideRight",
            }
        )
	end

	--True if player won, False if player lost
	local function gameOver(playerWon)
		local gameOverString = playerWon and "You Won!" or "You lost! Game Over."
		gameOverText = display.newText(gameOverString, display.contentCenterX, display.contentCenterY, native.systemFont, 100)
		sceneGroup:insert(gameOverText)
		Runtime:removeEventListener("tap", fire)
		Runtime:addEventListener("tap", restartGame)
	end

	-- Function to handle collisions between the player character and other objects
	local function playerHit(event)
		if event.phase == "began" then
			health = health - 1;
			textNum2.text = health
			if(health <= 0) then
				--Player Lost
				gameOver(false)
			end
			if (event.other.tag == "enemy" or event.other.tag == "boss") then
				event.other.pp:offScreen();
			end
		end
	end

	player:addEventListener("collision", playerHit); 
end

-- "scene:show()"
function scene:show(event)
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
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
		starfield1.isVisible = false
		starfield2.isVisible = false
		for i = sceneGroup.numChildren, 1, -1 do
            local child = sceneGroup[i]
            display.remove(child)
        end
    elseif (phase == "did") then
    -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy(event)
	local sceneGroup = self.view
   	sceneGroup:removeSelf()
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
