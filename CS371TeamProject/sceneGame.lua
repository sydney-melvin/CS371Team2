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

local Score = 0
local Health = 3


textNum = display.newText( Score, 380, 70, native.systemFont, 36)
textScore = display.newText("Score: ", 300, 70, native.systemFont, 36)

textNum2 = display.newText( Health, 380, 120, native.systemFont, 36)
textHealth = display.newText("HP: ", 300, 120, native.systemFont, 36)





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
	
	
	--player character
	local physics = require("physics");
	physics.start();
	physics.setGravity(0,0);
	local soundTable=require("soundTable");
	
	local controlBar = display.newRect (0, 320, 140, display.contentHeight);
	controlBar:setFillColor(1,1,1,0.5);

	---- Main Player
	local cube = display.newCircle (display.contentCenterX-450, display.contentHeight-150, 15);
	physics.addBody (cube, "kinematic");

	local function move ( event )
		if event.phase == "began" then		
			cube.markY = cube.y
		elseif event.phase == "moved" then	 	
			local y = (event.y - event.yStart) + cube.markY
			
			if (y <= 20 + cube.height/2) then
			cube.y = 20+cube.height/2;
			elseif (y >= display.contentHeight-20-cube.height/2) then
			cube.y = display.contentHeight-20-cube.height/2;
			else
			cube.y = y;		
			end

		end
	end
controlBar:addEventListener("touch", move);

	-- Projectile 
	local cnt = 0;
	local function fire (event) 
	if (cnt < 3) then
		cnt = cnt+1;
		local p = display.newCircle (cube.x, cube.y-16, 5);
		p.anchorY = 1;
		p:setFillColor(0,1,0);
		physics.addBody (p, "dynamic", {radius=5} );
		p:applyForce(2,0, p.x, p.y);

		audio.play( soundTable["shootSound"] );

		local function removeProjectile (event)
		if (event.phase=="began") then
			event.target:removeSelf();
			event.target=nil;
			cnt = cnt - 1;

			if (event.other.tag == "enemy") then

				event.other.pp:hit();
         	
			end
		end
		end
		p:addEventListener("collision", removeProjectile);
	end
	end

	Runtime:addEventListener("tap", fire)
	
	--Enemy
	local Enemy = require ("Enemy");
	
	local Square = Enemy:new( {HP=2, fR=720, fT=700, 
				  bT=700} );

	function Square:spawn()
	self.shape = display.newRect (self.xPos, 
    	 	 			  self.yPos, 30, 30); 
	self.shape.pp = self;
	self.shape.tag = "enemy";
	self.shape:setFillColor ( 0, 1, 1);
	physics.addBody(self.shape, "kinematic"); 
	end



	sq = Square:new({xPos=100, yPos=200});
	sq:spawn();
	sq:back();


	sq2 = Square:new({xPos=150, yPos=200})
	sq2:spawn();
	--sq:move();



	function Square:back ()   
		transition.to(self.shape, {x=self.shape.x-400, 
				time=self.bT, rotation=self.sR, 
		onComplete=function (obj) self:forward() end});
	end

	function Square:forward ()	
		transition.to(self.shape, {x=self.shape.x+400, 
				time=self.fT, rotation=self.fR, 
		onComplete= function (obj) self:back() end });
	end




	------------Triangle
	local Triangle = Enemy:new( {HP=3, bR=360, fT=500, 
				     bT=300});

	function Triangle:spawn()
	self.shape = display.newPolygon(self.xPos, self.yPos, 
			             {-15,-15,15,-15,0,15});
  
	self.shape.pp = self;
	self.shape.tag = "enemy";
	self.shape:setFillColor ( 1, 0, 1);
	physics.addBody(self.shape, "kinematic", 
		     {shape={-15,-15,15,-15,0,15}}); 
	end


	function Triangle:back ()	
	transition.to(self.shape, {x=self.shape.x-600, 
		y=self.shape.y-self.dist, time=self.bT, rotation=self.bR, 
		onComplete= function (obj) self:forward() end } );
	end

	function Triangle:side ()	
	transition.to(self.shape, {x=self.shape.x + 400, 
      time=self.sT, rotation=self.sR, 
      onComplete= function (obj) self:back () end });	
	end

	function Triangle:forward ()	
	self.dist = math.random (40,70) * 10;
	transition.to(self.shape, {x=self.shape.x+200,  
		y=self.shape.y+self.dist, time=self.fT, rotation=self.fR, 
		onComplete= function (obj) self:side() end } );
	end

	tr = Triangle:new({xPos=150, yPos=200});
	tr:spawn();
	tr:forward();



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