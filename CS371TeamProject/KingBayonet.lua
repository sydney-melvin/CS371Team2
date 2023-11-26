-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--Keenan Coleman
--CS371-01

--hides status bar
display.setStatusBar( display.HiddenStatusBar )

--used to stop body parts from animating, if trigger is set
local mouthTrigger = false;
local snoutTrigger = false;
local caudalTrigger = false;
local dorsalTrigger = false;
local pectoralTrigger = false;

--allows then player can drag and drop fish
local canMove = true;

--scale of the fish, used when rescaling
local scaler = 1;


--loads audio for fish bosdy parts
local soundTable = {
 
    snoutSound = audio.loadSound("distinct1.wav"),
	mouthSound = audio.loadSound("distinct2.wav"),
	pectoralSound = audio.loadSound( "distinct3.wav" ),
    caudalSound = audio.loadSound( "distinct4.wav" ),
	dorsalSound = audio.loadSound( "distinct5.wav" )
}
audio.setVolume( 1 )


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

--allows for body part movements as well sound
function moveMouth(event)

	if mouthTrigger == false then
		event.target:play()
		audio.play( soundTable["mouthSound"] )
		mouthTrigger = true
	
	else
		event.target:pause()
		mouthTrigger = false
	end
	
	return true;
end

--allows for body part movements as well sound
function moveSnout(event)

	if snoutTrigger == false then
		event.target:play()
		audio.play( soundTable["snoutSound"] )
		snoutTrigger = true
	
	else
		event.target:pause()
		snoutTrigger = false
	end
	
	return true;
end

--allows for body part movements as well sound
function moveCaudal(event)

	if caudalTrigger == false then
		event.target:play()
		audio.play( soundTable["caudalSound"] )
		caudalTrigger = true
	
	else
		event.target:pause()
		caudalTrigger = false
	end
	
	return true;
end

--allows for body part movements as well sound
function moveDorsal(event)

	if dorsalTrigger == false then
		event.target:play()
		audio.play( soundTable["dorsalSound"] )
		dorsalTrigger = true
	
	else
		event.target:pause()
		dorsalTrigger = false
	end
	
	return true;
end

--allows for body part movements as well sound
function movePectoral(event)

	if pectoralTrigger == false then
		event.target:play()
		audio.play( soundTable["pectoralSound"] )
		pectoralTrigger = true
	
	else
		event.target:pause()
		pectoralTrigger = false
	end
	
	return true;
end


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

--detects touch for body part movement 
mouth:addEventListener("tap",moveMouth)
snout:addEventListener("tap",moveSnout)
caudal:addEventListener("tap",moveCaudal)
dorsal:addEventListener("tap",moveDorsal)
pectoral:addEventListener("tap",movePectoral)

--insets body parts into group
fish:insert(body)
fish:insert(mouth)
fish:insert(snout)
fish:insert(caudal)
fish:insert(dorsal)
fish:insert(pectoral)

fish.x = display.contentWidth / 2 
fish.y = display.contentWidth / 2 - 50



local widget = require( "widget" )
     
	 
-- Slider listener
local function sliderListener( event )
    local value = event.value
    print( "Slider at " .. value .. "%" )
	
	local xx = scaler + value/100;
	local yy = scaler + value/100 ;
	
	fish.xScale = xx
	fish.yScale = yy
	
	
end
 
-- Create the widget
local slider = widget.newSlider(
    {
        x = display.contentCenterX,
        y = display.contentCenterY - 100,
        width = 400,
        value = 50,  -- Start slider at 10% (optional)

		
        listener = sliderListener
    }
)


local widget = require( "widget" )
 
-- Handle press events for the checkbox
local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	canMove = switch.isOn
end
 
-- Create the widget
local onOffSwitch = widget.newSwitch(
    {
        left = display.contentCenterX,
        top = display.contentCenterY + 100,
        style = "onOff",
        id = "onOffSwitch",
        onPress = onSwitchPress
    }
)

--allows fish to be dragged and dropped 
local function drag (event)
    if event.phase == "began" and canMove == true then     
        event.target.markX = event.target.x 
        event.target.markY = event.target.y
        event.target.isFocus = true;         
    elseif event.phase == "moved" and 
	event.target.isFocus == true then 
        local x = (event.x - event.xStart) + event.target.markX;     
        local y = (event.y - event.yStart) + event.target.markY;
        event.target.x, event.target.y = x, y;
    elseif event.phase == "ended" then 
        event.target.isFocus = false;
    end
end

fish:addEventListener ("touch", drag);



--used to move fish into random locations on the screen 
function update()
	
	if(canMove == false) then
		math.randomseed(os.time())
		transition.moveTo(fish, {x = display.contentWidth / 2 + math.random(-300, 300), y = display.contentHeight / 2 + math.random(-200, 200), time = 4000})
	else
		transition.cancel(fish)
		
	end

end
timer.performWithDelay(20, update, 0)