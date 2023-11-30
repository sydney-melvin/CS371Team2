local Enemy = require("Enemy");


local Enemy2 = Enemy:new( {HP=3, bR=360, fT=500, bT=300});

function Enemy2:spawn()
 self.shape = display.newPolygon(self.xPos, self.yPos,{-15,-15,15,-15,0,15});
 self.shape.pp = self;
 self.shape.tag = "enemy";
 self.shape:setFillColor ( 1, 0, 1);
 physics.addBody(self.shape, "kinematic",{shape={-15,-15,15,-15,0,15}}); 
end


function Enemy2:back ()
  transition.to(self.shape, {x=self.shape.x-600, 
    y=self.shape.y-self.dist, time=self.bT, rotation=self.bR, 
    onComplete= function (obj) self:forward() end } );
end

function Enemy2:side ()   
   transition.to(self.shape, {x=self.shape.x + 400, 
      time=self.sT, rotation=self.sR, 
      onComplete= function (obj) self:back () end });
end

function Enemy2:forward ()   
  self.dist = math.random (40,70) * 10;
  transition.to(self.shape, {x=-20,  
    y= 320, time= 10000, rotation=self.fR,
	onComplete= function (obj) self:offScreen() end} );
end


return Enemy2;