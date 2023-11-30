
local physics = require("physics");
local soundTable=require("soundTable");

local Enemy = {tag="enemy", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500, red=1, green=1, blue=0};

function Enemy:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function Enemy:spawn()
 self.shape=display.newCircle(self.xPos, self.yPos,15);
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “enemy”
 self.shape:setFillColor (self.red,self.green,self.blue);
 physics.addBody(self.shape, "kinematic"); 
end


function Enemy:back ()
  transition.to(self.shape, {x=self.shape.x, y=150,  
  time=self.fB, rotation=self.bR, 
  onComplete=function (obj) self:forward() end} );
end

function Enemy:side ()   
   transition.to(self.shape, {x=self.shape.x, 
   time=self.fS, rotation=self.sR, 
   onComplete=function (obj) self:back() end } );
end

function Enemy:forward ()   
   transition.to(self.shape, {x=self.shape.x, y=800, 
   time=self.fT, rotation=self.fR } );
end

function Enemy:move ()	
	self:forward();
end

function Enemy:hit () 
	self.HP = self.HP - 1;
	if (self.HP > 0) then 
		audio.play( soundTable["hitSound"] );
		self.shape:setFillColor(0.5,0.5,0.5);
	
	else 
		audio.play( soundTable["explodeSound"] );
		
    transition.cancel( self.shape );
		
		if (self.timerRef ~= nil) then
			timer.cancel ( self.timerRef );
		end

		-- die
		self.shape:removeSelf();
		self.shape=nil;	

		--self = nil;  
	end		
end

function Enemy:getHealth () 
	return self.HP;
end



function Enemy:offScreen()
	self.shape:removeSelf();
	self.shape=nil;	

end

return Enemy