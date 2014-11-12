package gameclasses.ships
{
	import adobe.utils.CustomActions;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import gameclasses.*;
	import gameclasses.planets.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class MinerShip extends Ship
	{
		
		[Embed(source='../../../assets/ships/minerShip.png')]
		private var texture:Class;
		[Embed(source='../../../assets/ships/mineray.png')]
		public var rayTexture:Class;
		public var raySprite:FlxSprite;
		
		public var goldHolding:int = 0;
		public var capacity:int = 10;
		public var returnHome:Boolean = false;
		public var mining:Boolean = false;
		public var currentState:int = 1;
		
		private var homeRoute:Array = new Array();
		private var addedCurrentPlanet:Boolean = false;
		
		private var mineTimer:FlxTimer;
		private var rayTimer:FlxTimer;
		
		private var miningPlanet:Planet;
		
		static public var cost:int = 10;
		static public var buildTime:Number = 10;
		
		public function MinerShip()
		{
			super(texture, 5);
			mineTimer = new FlxTimer();
			mineTimer.finished = true;
			rayTimer = new FlxTimer();
			health = 5;
			flyingDistance = 20;
			cost = 10;
			buildTime = 10;
		}
		
		override public function changeColor(color:uint):void
		{
			
			raySprite = new FlxSprite(0, 0, rayTexture);
			raySprite.exists = false;
			super.changeColor(color);
			width = frameWidth = 8
			height = frameHeight = 8;
			resetHelpers();
			addAnimation("goldNone", [0], 0, false);
			addAnimation("goldLow", [1], 0, false);
			addAnimation("goldMed", [2], 0, false);
			addAnimation("goldFull", [3], 0, false);
			play("goldNone");
		}
		
		override public function update():void
		{
			super.update();
			if (planet != null)
			{
				circlePlanet();
			}
			if (!addedCurrentPlanet && planetFlyingTo != null && planet != null)
			{
				if (planet.owner == owner)
				{
					homeRoute.push(planet);
					addedCurrentPlanet = true;
				}
			}
			
			if (planet != null && mining)
			{
				angle += 270;
				raySprite.angle = angle;
				raySprite.x = -raySprite.width / 2 + planet.origin.x + planet.x + (5 + planet.size / 2) * Math.cos(angleToPlanet);
				raySprite.y = -raySprite.height / 2 + planet.origin.y + planet.y + (5 + planet.size / 2) * Math.sin(angleToPlanet);
				if (mineTimer.finished)
				{
					GoldPlanet(planet).goldLeft--;
					goldHolding++;
					updateCurrentSprite();
					mineTimer.start(1);
					rayTimer.start(0.5);
					raySprite.exists = true;
				}
			}
			else if (goldHolding < capacity && planet != null && planet is GoldPlanet && GoldPlanet(planet).goldLeft > 0)
			{
				mining = true;
				miningPlanet = planet;
				speed -= 0.005;
			}
			else
			{
				speed = 0.01;
				mining = false;
				raySprite.exists = false;		
			}
			
			if (rayTimer.finished)
			{
				raySprite.exists = false;
			}
			if (returnHome == false && goldHolding >= capacity)
			{
				speed = 0.01;
				returnHome = true;
				goldHolding = capacity;
				mining = false;
				raySprite.exists = false;
				if (homeRoute.length > 0)
				{
					sendToPlanet(homeRoute[homeRoute.length - 1]);
					planet.ownedShips.remove(this, true);
				}
			}
			if (planet != null && homeRoute[homeRoute.length - 1] == planet)
			{
				owner.gold += goldHolding;
				goldHolding = 0;
				play("goldNone");
				mineTimer.finished = true;
				returnHome = false;
				if (miningPlanet != null)
				{
					sendToPlanet(miningPlanet);
				}
			}
		}
		
		private function updateCurrentSprite():void
		{
			if (goldHolding >= 2 && goldHolding < 6)
			{
				play("goldLow");
			}
			else if (goldHolding >= 6 && goldHolding < 10)
			{
				play("goldMed");
			}
			else  if (goldHolding ==10)
			{
				play("goldFull");
			}
		}
	}

}