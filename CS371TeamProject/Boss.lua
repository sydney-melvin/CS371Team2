local Enemy = require("Enemy");
local soundTable=require("soundTable");

function createFish()
	--group where all body parts will be placed
	local fish = display.newGroup()

	--the frames or each fish body part
	local opt =
	{
		frames = {
			{ x = 22, y = 8, width = 167, height = 50}, -- 1. Body
			{ x = 207, y = 27, width = 16, height = 9}, -- 2. Snout 1
			{ x = 228, y = 27, width = 16, height = 9}, -- 3. Snout 2
			{ x = 249, y = 27, width = 16, height = 9}, -- 4. Snout 3
			{ x = 281, y = 20, width = 56, height = 26}, -- 5. Mouth 1
			{ x = 344, y = 20, width = 56, height = 26}, -- 6. Mouth 2
			{ x = 407, y = 20, width = 56, height = 26}, -- 7. Mouth 3
			{ x = 22, y = 93, width = 52, height = 37}, -- 8. Pectoral Fin 1
			{ x = 80, y = 99, width = 53, height = 31}, -- 9. Pectoral Fin 2
			{ x = 140, y = 102, width = 54, height = 28}, -- 10. Pectoral Fin 3
			{ x = 210, y = 70, width = 48, height = 92}, -- 11. Caudal Fin 1
			{ x = 267, y = 82, width = 55, height = 70}, -- 12. Caudal Fin 2
			{ x = 331, y = 89, width = 60, height = 55}, -- 13. Caudal Fin 3
			{ x = 405, y = 93, width = 60, height = 46} -- 14. Dorsal Fin
		}
	}


	--loads in sprite sheet
	local sheet = graphics.newImageSheet( "KingBayonet.png", opt);

	--sets the sequence for the fish animations 
	local sequences_fish = {
		
		{
			name = "Body",
			frames = { 1 },
			time = 800,
			loopCount = 0
		},
		
		{
			name = "Mouth",
			frames = { 5, 6, 7 },
			time = 800,
			loopCount = 0
		},
	
		{
			name = "Caudal fin",
			frames = { 11, 12,13 },
			time = 400,
			loopCount = 0
		},
		
		{
			name = "Pectoral fin",
			frames = {8, 9, 10 },
			time = 400,
			loopCount = 0
		},
		
		{
			name = "Snout",
			frames = { 2, 3, 4 },
			time = 400,
			loopCount = 0
		},
		
		
		{
			name = "Dorsal fin",
			frames = {14},
			time = 400,
			loopCount = 0
		},
		
	}

	--following code piecies the fishes body parts together 
	local body = display.newSprite(sheet, sequences_fish)

	body.x = 0
	body.y = 0

	body:setSequence("Body")

	local mouth = display.newSprite(sheet, sequences_fish)

	mouth.x = (body.x) -39
	mouth.y = (body.y) +5

	mouth:setSequence("Mouth")

	local snout = display.newSprite(sheet, sequences_fish)

	snout.x = (body.x) -90
	snout.y = (body.y) +3

	snout:setSequence("Snout")

	local caudal = display.newSprite(sheet, sequences_fish)

	caudal.x = (body.x) +100
	caudal.y = (body.y) -4

	caudal:setSequence("Caudal fin")

	local dorsal = display.newSprite(sheet, sequences_fish)

	dorsal.x = (body.x) +15
	dorsal.y = (body.y) -38

	dorsal:setSequence("Dorsal fin")

	local pectoral = display.newSprite(sheet, sequences_fish)

	pectoral.x = (body.x) +25
	pectoral.y = (body.y) +28

	pectoral:setSequence("Pectoral fin")

	--insets body parts into group
	fish:insert(body)
	fish:insert(mouth)
	fish:insert(snout)
	fish:insert(caudal)
	fish:insert(dorsal)
	fish:insert(pectoral)

	return fish
end

local Boss = Enemy:new( { HP=30 } );

function Boss:spawn()
  self.shape = createFish();
  self.shape.x = self.xPos;
  self.shape.y = self.yPos;
  self.shape.pp = self;
  self.shape.tag = "boss";
  physics.addBody(self.shape, "kinematic"); 
end

function Boss:move()
  transition.to (
    self.shape, {
        x = math.random(display.contentCenterX-450, display.contentWidth),
        y = math.random(0, display.contentHeight),
        time = 1000, 
        onComplete = function() self:move() end
    }
  )	
end

function Boss:hit () 
	self.HP = self.HP - 1;
	if (self.HP > 0) then 
		audio.play( soundTable["hitSound"] );
	else 
		audio.play( soundTable["explodeSound"] );
		
    transition.cancel( self.shape );
		
		if (self.timerRef ~= nil) then
			timer.cancel ( self.timerRef );
		end

		-- die
		self.shape:removeSelf();
		self.shape=nil;	
	end		
end

return Boss;
