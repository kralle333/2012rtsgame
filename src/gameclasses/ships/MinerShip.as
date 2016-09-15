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
		
		private var mineTimer:FlxTimer;
		private var rayTimer:FlxTimer;
		
		private var miningPlanet:GoldPlanet;
		
		static public var cost:int = 30;
		static public var buildTime:Number = 20;
		static public var name:String = "Miner";
		
		public function MinerShip()
		{
			super(texture, 5);
			mineTimer = new FlxTimer();
			mineTimer.finished = true;
			rayTimer = new FlxTimer();
			flyingDistance = 20;
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
		override public function damage(amount:int):void 
		{
			super.damage(amount);
			if (health <= 0)
			{
				raySprite.exists = false;
			}
		}
		
		override public function update():void
		{
			super.update();
			if (currentPlanet != null)
			{
				circlePlanet();
			}

			if (!mining)
			{
				 if (goldHolding < capacity && currentPlanet != null && currentPlanet is GoldPlanet && GoldPlanet(currentPlanet).goldLeft > 0)
				{
					mining = true;
					miningPlanet = GoldPlanet(currentPlanet);
					speed -= 0.005;
				}
			}
			else if (mining)
			{
				angle += 270;
				raySprite.angle = angle;
				raySprite.x = -raySprite.width / 2 + currentPlanet.origin.x + currentPlanet.x + (5 + currentPlanet.size / 2) * Math.cos(angleToPlanet);
				raySprite.y = -raySprite.height / 2 + currentPlanet.origin.y + currentPlanet.y + (5 + currentPlanet.size / 2) * Math.sin(angleToPlanet);
				if (mineTimer.finished)
				{
					miningPlanet.goldLeft--;
					goldHolding++;
					updateCurrentSprite();
					mineTimer.start(1);
					rayTimer.start(0.5);
					raySprite.exists = true;
				}
				if (rayTimer.finished)
				{
					raySprite.exists = false;
				}
				if (goldHolding >= capacity || miningPlanet.goldLeft <= 0)
				{
					speed = 0.01;
					mining = false;
					raySprite.exists = false;		
				}
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
					currentPlanet.ownedShips.remove(this, true);
				}
			}
			else if (currentPlanet != null && homeRoute[homeRoute.length - 1] == currentPlanet)
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
		override public function addFlyingRoute(planets:Array):void 
		{
			if (planets[0] is GoldPlanet && planets[planets.length - 1].type == "HQ")
			{
				
			}
			super.addFlyingRoute(planets);
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