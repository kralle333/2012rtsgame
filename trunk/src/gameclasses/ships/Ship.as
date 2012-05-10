package gameclasses.ships
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import gameclasses.*;
	import gameclasses.planets.*;
	import flash.geom.ColorTransform;
	
	public class Ship extends FlxSprite
	{
		public var planet:Planet = null;
		public var planetFlyingTo:Planet = null;
		private var exitAngle:Number = 0;
		private var exitPosition:FlxPoint;
		public var canShoot:Boolean = true;
		public var owner:Player;
		private var shootTimer:FlxTimer;
		private var showHealthBarTimer:FlxTimer;
		private var maneuverTimer:FlxTimer;
		
		private var shootingRange:int = 5;
		public var angleToPlanet:Number = 0;
		public var healthBar:FlxBar;
		protected var speed:Number = 0.01;
		
		protected var shipHeight:Number = 0;
		static public var flyingDistance:int = 50;
		public var enemy:Ship = null;
		
		public var cost:int = 0;
		public var buildTime:Number = 0;
		
		public function Ship(texture:Class, shipHealth:int)
		{
			loadGraphic(texture, false, false, 0, 0, true);
			shootTimer = new FlxTimer();
			shootTimer.finished = true;
			healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 8, 1, this, "health", 0, shipHealth, false);
			healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
			healthBar.trackParent(0, -4);
			healthBar.exists = false;
			showHealthBarTimer = new FlxTimer();
			showHealthBarTimer.finished = true;
		}
				
		public function changeColor(changeColor:uint):void
		{
			var bit:BitmapData = pixels;
			for (var x:int = 0; x < pixels.width; x++) 
			{
				for (var y:int = 0; y <pixels.height ; y++) 
				{
					if (bit.getPixel(x, y) == 0xFFFFFF)
					{
						bit.setPixel(x, y, changeColor);
					}
				}
			}
			pixels = bit;
		}
		public function sendToPlanet(newPlanet:Planet):void
		{
			planetFlyingTo = newPlanet;
			if (Math.abs(planet.y - newPlanet.y) > Math.abs(planet.x - newPlanet.x))
			{
				if (newPlanet.y < planet.y)
				{
					exitAngle = Math.PI;
				}
				else
				{
					exitAngle = 0;
				}
				
			}
			else
			{
				if (newPlanet.x < planet.x)
				{
					exitAngle = Math.PI / 2;
				}
				else
				{
					exitAngle = (3 * Math.PI / 2);
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			if (shootTimer.finished)
			{
				canShoot = true;
			}
			if (showHealthBarTimer.finished)
			{
				healthBar.exists = false;
			}
			if (planet != null)
			{
				circlePlanet();
				if (planetFlyingTo != null && Math.abs(exitAngle - angleToPlanet) < 0.02)
				{
					//Flying from old planet
					leavePlanet();
					
				}
			}
			else if (planetFlyingTo != null)
			{
				if (planetFlyingTo.distanceToShipFromOrigin(this) - planetFlyingTo.width / 2 - shipHeight < 23)
				{
					landOnNewPlanet();
				}
			}
		}
		
		public function damage(amount:int):void
		{
			health -= amount;
			healthBar.exists = true;
			if (health <= 0)
			{
				exists = false;
				healthBar.exists = false;
				planet.removeShip(this);
			}
			showHealthBarTimer.start(4);
		}
		
		public function justShot():void
		{
			canShoot = false;
			shootTimer.start(5);
		}
		
		private function circlePlanet():void
		{
			x = -width / 2 + planet.origin.x + planet.x + (planet.width / 2 + flyingDistance + shipHeight) * Math.cos(angleToPlanet);
			y = -height / 2 + planet.origin.y + planet.y + (planet.height / 2 + flyingDistance + shipHeight) * Math.sin(angleToPlanet);
			angleToPlanet += speed;
			angle = angleToPlanet * 57.2957;
			if (angleToPlanet >= Math.PI * 2)
			{
				angleToPlanet = 0;
			}
		}
		
		private function leavePlanet():void
		{
			var flyAngle:Number = Math.atan2((y+origin.y) - (planetFlyingTo.y+planetFlyingTo.origin.y), (x+origin.x) - (planetFlyingTo.x+planetFlyingTo.origin.x));
			var extraSpeed:int = 0;
			flyAngle += Math.PI;
			if (planet.owner == this.owner && planetFlyingTo.owner == this.owner)
			{
				extraSpeed = 10;
			}
			velocity.x = (extraSpeed + 50) * Math.cos(flyAngle);
			velocity.y = (extraSpeed + 50) * Math.sin(flyAngle);
			planet.removeShip(this);
			planet = null;
		}
		
		private function landOnNewPlanet():void
		{
			//Landing at new planet
			
			angleToPlanet = Math.abs((Math.PI + Math.atan2(-(y + height / 2) + planetFlyingTo.origin.y + planetFlyingTo.y, -(x + width / 2) + planetFlyingTo.origin.x + planetFlyingTo.x)));
			velocity.x = velocity.y = 0;
			planetFlyingTo.getShip(this);
			planet = planetFlyingTo;
			planetFlyingTo = null;
		
		}
	}

}