package gameclasses.ships
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import misc.PotentialFieldCalculator;
	import misc.ShipMath;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import gameclasses.*;
	import gameclasses.planets.*;
	import gameclasses.players.*;
	import flash.geom.ColorTransform;
	
	public class Ship extends FlxSprite
	{
		private var planetRoute:Array = new Array();
		public var currentPlanet:Planet = null;
		public var planetFlyingTo:Planet = null;
		public var canShoot:Boolean = true;
		public var owner:Player;
		private var shootTimer:FlxTimer;
		private var showHealthBarTimer:FlxTimer;
		
		private var shootingRange:int = 5;
		public var angleToPlanet:Number = 0;
		public var healthBar:FlxBar;
		protected var speed:Number = 0.01;
		protected var directionAngle:Number = -1;
		public var smoothChangeAngle:Number = -1;
		private var smoothCounter:int = 0;
		public var initHealth:int = 0;
		
		protected var shipHeight:Number = 0;
		static public var flyingDistance:int = 50;
		public var enemy:Ship = null;
		public var ally:Ship = null;
		protected var flightPath:Array = new Array();		
		
		static public var cost:int = 0;
		static public var buildTime:Number = 0;
		static public var name:String = "";
		

		public var name:String;
		
		public function Ship(texture:Class, shipHealth:int)
		{
			initHealth = shipHealth;
			health = shipHealth;
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
				for (var y:int = 0; y < pixels.height; y++)
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
		}
		
		public override function update():void
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
			if (currentPlanet != null)
			{
				if (smoothChangeAngle != -1)
				{
					smoothCounter++;
					angle = smoothChangeAngle;
					if (smoothCounter >= 50)
					{
						smoothCounter = 0;
						smoothChangeAngle = -1;
						angle = directionAngle;
					}
				}
				if (planetFlyingTo != null && shouldLeavePlanet() )
				{
					//Flying from old planet
					leavePlanet();
				}
			}
			else if (planetFlyingTo != null)
			{
				if (ShipMath.getDistanceFromShipToPlanetOrigin(this,planetFlyingTo) - planetFlyingTo.width / 2 - shipHeight < 23)
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
				if (currentPlanet != null)
				{
					currentPlanet.removeShip(this);
				}
			}
			showHealthBarTimer.start(4);
		}
		
		public function justShot():void
		{
			canShoot = false;
			shootTimer.start(3);
		}
		private function shouldLeavePlanet():Boolean
		{
			//if the distance from the ship to the new planet is shorter than the distance from the old planet to the new planet, then yes!
			return FlxMath.vectorLength(this.x - (planetFlyingTo.x + planetFlyingTo.origin.x), this.y - (planetFlyingTo.y + planetFlyingTo.origin.y)) < FlxMath.vectorLength((currentPlanet.x + currentPlanet.origin.x) - (planetFlyingTo.x + planetFlyingTo.origin.x), (currentPlanet.y + currentPlanet.origin.y) - (planetFlyingTo.y + planetFlyingTo.origin.y));
		}
		protected function circlePlanet():void
		{
			x = -width / 2 + currentPlanet.origin.x + currentPlanet.x + (currentPlanet.width / 2 + flyingDistance + shipHeight) * Math.cos(angleToPlanet);
			y = -height / 2 + currentPlanet.origin.y + currentPlanet.y + (currentPlanet.height / 2 + flyingDistance + shipHeight) * Math.sin(angleToPlanet);
			angleToPlanet += speed;
			angle = angleToPlanet * 57.2957;
			if (angleToPlanet >= Math.PI * 2)
			{
				angleToPlanet = 0;
			}
		}
		
		protected function leavePlanet():void
		{
			var flyAngle:Number = Math.atan2((y + origin.y) - (planetFlyingTo.y + planetFlyingTo.origin.y), (x + origin.x) - (planetFlyingTo.x + planetFlyingTo.origin.x));
			var extraSpeed:int = 0;
			flyAngle += Math.PI;
			
			if (currentPlanet.owner == this.owner && planetFlyingTo.owner == this.owner)
			{
				extraSpeed = 10;
			}
			velocity.x = (extraSpeed + 50) * Math.cos(flyAngle);
			velocity.y = (extraSpeed + 50) * Math.sin(flyAngle);
			angle = Math.atan2(velocity.y,velocity.x)*180/Math.PI-90
			currentPlanet.removeShip(this);
			currentPlanet = null;
		}
		public function addFlyingRoute(planets:Array):void
		{
			for (var i:int = 0; i < planets.length; i++) 
			{
				planetRoute.push(planets[i]);
			}
			planetFlyingTo = planetRoute[0];
			planetRoute.shift();
		}
		private function landOnNewPlanet():void
		{
			//Landing at new planet
			
			angleToPlanet = Math.abs((Math.PI + Math.atan2(-(y + height / 2) + planetFlyingTo.origin.y + planetFlyingTo.y, -(x + width / 2) + planetFlyingTo.origin.x + planetFlyingTo.x)));
			velocity.x = velocity.y = 0;
			planetFlyingTo.getShip(this);
			currentPlanet = planetFlyingTo;
			planetFlyingTo = null;
			if (planetRoute.length > 0)
			{
				planetFlyingTo = planetRoute[0];
				planetRoute.shift();
			}
		
		}
	}

}