local Enemy = require("Enemy");

local Enemy1 = Enemy:new( {HP=2, fR=720, fT=700, 
				  bT=700} );

function Enemy1:spawn()
  self.shape = display.newRect (self.xPos, 
    	 	 			  self.yPos, 30, 30); 
  self.shape.pp = self;
  self.shape.tag = "enemy";
  self.shape:setFillColor ( 0, 1, 1);
  physics.addBody(self.shape, "kinematic"); 
end

function Enemy1:back ()   
   transition.to(self.shape, {x=self.shape.x-1163, time=self.bT, rotation=self.sR});
end

function Enemy1:forward ()	
	transition.to(self.shape, {x=-20,time=10000, rotation=self.fR,
	onComplete= function (obj) self:offScreen() end});
end

return Enemy1;
