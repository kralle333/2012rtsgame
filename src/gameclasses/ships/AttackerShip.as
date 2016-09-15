package gameclasses.ships
{
	import misc.PotentialFieldCalculator;
	import misc.ShipMath;
	import org.flixel.*;
	import gameclasses.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class AttackerShip extends Ship
	{
		
		[Embed(source='../../../assets/ships/attackerShip.png')]
		private var texture:Class;
		
		private var heightTimer:FlxTimer = new FlxTimer();
		
		private var inPlanetRing:Boolean = true;
		private var flyingToCircle:Boolean = false;
		public var enemyNear:Boolean;

		private var maneuverTimer:FlxTimer = new FlxTimer();
		private var newEnemyTimer:FlxTimer = new FlxTimer();
		

		
		static public var cost:int = 10;
		static public var buildTime:Number = 20;
		static public var name:String = "Fighter";
		
		public function AttackerShip()
		{
			super(texture, 10);
			speed = 0.015;
			heightTimer.finished = true;
			flyingDistance = 40;
			maneuverTimer.finished = true;
		}
		
		public override function update():void
		{
			super.update();
			moveShip();
		}
		
		public override function changeColor(changeColor:uint):void
		{
			super.changeColor(changeColor);
		}
		
		protected override function leavePlanet():void
		{
			enemy = null;
			ally = null;
			super.leavePlanet();
		}
		
		private function moveShip():void
		{
			if (enemy != null && planetFlyingTo == null)
			{
				controlAttacking();
				inPlanetRing = false;
			}
			else if (currentPlanet != null && !inPlanetRing)
			{
				if (ShipMath.getDistanceFromShipToPlanetOrigin(this, currentPlanet) >= currentPlanet.size / 2+shipHeight)
				{
					inPlanetRing = true;
					angleToPlanet = ShipMath.getAngleFromShipToPlanet(this, currentPlanet);
				}
				else if(!flyingToCircle)
				{
					velocity.x = 30;
					velocity.y = 30;
					angle = Math.atan2(velocity.y, velocity.x) * 180 / Math.PI - 90;
					flyingToCircle = true;
				}
			}
			else if (currentPlanet != null && inPlanetRing)
			{
				circlePlanet();
				if (heightTimer.finished)
				{
					enemy = ShipMath.getEnemyNearShip(this);
					newEnemyTimer.start(3);
					shipHeight += Math.random() * 2 - 1;
					if (shipHeight < -5)
					{
						shipHeight = -5;
					}
					else if (shipHeight > 10)
					{
						shipHeight = 10;
					}
					heightTimer.start(Math.random());
				}
			}
		
		}
		
		private function controlAttacking():void
		{
			if (enemy.exists && maneuverTimer.finished)
			{
				var speed:FlxPoint = PotentialFieldCalculator.getPotentialSpeed(this);
				velocity.x = speed.x;
				velocity.y = speed.y;
				maneuverTimer.start(Math.random() * 2 + 1);
				angle = Math.atan2(velocity.y, velocity.x) * (180 / Math.PI) - 90;
				directionAngle = angle;
				if (ally == null)
				{
					ally = ShipMath.getAllyNearShip(this);
				}
				if (newEnemyTimer.finished)
				{
					enemy = ShipMath.getEnemyNearShip(this);
					newEnemyTimer.start(2);
				}
			}
			else if (!enemy.exists)
			{
				enemy = ShipMath.getEnemyNearShip(this);
				newEnemyTimer.start(2);
			}
		}
	}

}