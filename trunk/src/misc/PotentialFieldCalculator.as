package misc
{
	import gameclasses.planets.Planet;
	import gameclasses.ships.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	public class PotentialFieldCalculator
	{
		static private var enemyDistanceConstant:int = 1000;
		static private var allyDistanceConstant:int = 2000;
		static private var planetDistanceFarConstant:int = 100;
		static private var planetDistanceCloseConstant:int = 50;
		static private var healthConstant:int = 3;
		static private var nextCornerDistanceConstant:int = 100;
		
		static private var enemyWeight:int = 1;
		static private var shootingRangeWeight:int = 1;
		static private var allyWeight:int = 1;
		static private var healthWeight:int = 1;
		static private var cooldownWeight:int = 1;
		static private var planetWeight:int = 1;
		static private var nextCornerWeight:int = 1;
		
		static private var enemyPotential:int = 0;
		static private var coolDownPotential:int = 0;
		static private var healthPotential:int = 0;
		static private var allyPotential:int = 0;
		static private var planetPotential:int = 0;
		static private var totalPotential:int = 0;
		static private var nextCornerPotential:int = 0;
		
		static private var speedMultiply:int = 30;
		
		static private var enemyDistanceVariable:int = 0;
		static private var allyDistanceVariable:int = 0;
		static private var nextCornerVariable:int = 0;
		
		static private var nextCornerPoint:FlxPoint = new FlxPoint();
		
		public function PotentialFieldCalculator()
		{
		
		}
		
		static public function getPotentialSpeed(ship:Ship):FlxPoint
		{
			var speed:FlxPoint = new FlxPoint();
			var currentPotential:int = -50000;
			nextCornerPoint = getNextPlanetCorner(ship, ship.planet);
			for (var x:int = -1; x < 2; x++)
			{
				for (var y:int = -1; y < 2; y++)
				{
					enemyDistanceVariable = FlxMath.vectorLength((ship.x + x * speedMultiply) - ship.enemy.x, (ship.y + y * speedMultiply) - ship.enemy.y)
					if (enemyDistanceConstant > enemyDistanceVariable)
					{
						if (ship.enemy is AttackerShip)
						{
							enemyPotential = enemyWeight * (enemyDistanceConstant / enemyDistanceVariable);
						}
						else
						{
							enemyPotential = 10 * (enemyDistanceConstant / enemyDistanceVariable);
						}
					}
					else
					{
						enemyPotential = 0;
					}
					if (ship.ally != null)
					{
						allyDistanceVariable = FlxMath.vectorLength((ship.x + x * speedMultiply) - ship.ally.x, (ship.y + y * speedMultiply) - ship.ally.y);
						if (allyDistanceConstant > allyDistanceVariable)
						{
							allyPotential = allyWeight * (allyDistanceConstant / allyDistanceVariable);
						}
					}
					
					else
					{
						allyPotential = 0;
					}
					
					if (!ship.canShoot)
					{
						coolDownPotential = cooldownWeight * 1 / enemyDistanceVariable;
					}
					else
					{
						coolDownPotential = 0;
					}
					
					if (ship.health < healthConstant)
					{
						healthPotential = healthWeight;
					}
					else
					{
						healthPotential = 0;
					}
					var planetDistance:int = FlxMath.vectorLength((ship.x + x * speedMultiply) - (ship.planet.x + ship.planet.origin.x), (ship.y + y * speedMultiply) - (ship.planet.y + ship.planet.origin.y));
					if (planetDistanceFarConstant < planetDistance)
					{
						planetPotential = -100 * (planetDistance / planetDistanceFarConstant);
					}
					else if (planetDistanceCloseConstant > planetDistance)
					{
						planetPotential = -planetWeight * (planetDistanceCloseConstant / planetDistance);
					}
					else
					{
						planetPotential = 0;
					}
					nextCornerVariable = FlxMath.vectorLength((ship.x + x * speedMultiply)-nextCornerPoint.x, (ship.y + y * speedMultiply)-nextCornerPoint.y);
					if (nextCornerDistanceConstant < nextCornerVariable)
					{
						nextCornerPotential = -nextCornerWeight * (nextCornerVariable / nextCornerDistanceConstant);
						//trace("NEXT CORNER: ", nextCornerPotential,nextCornerPoint.x,nextCornerPoint.y);
					}
					else
					{
						nextCornerPotential = 0;
					}
					totalPotential = allyPotential + coolDownPotential + enemyPotential + healthPotential + planetPotential + nextCornerPotential;
					//trace(enemyPotential,allyPotential,coolDownPotential,healthPotential);
					if (totalPotential > currentPotential)
					{
						speed = new FlxPoint(x * speedMultiply, y * speedMultiply);
						currentPotential = totalPotential;
					}
					 
				}
			}
			//trace(currentPotential);
			//trace("SPEED: ", speed.x,speed.y);
			return speed;
		}
		
		static private function getNextPlanetCorner(ship:Ship, planet:Planet):FlxPoint
		{
			if (ship.angleToPlanet <= 3*Math.PI/2+1 && ship.angleToPlanet>Math.PI)
			{
				return new FlxPoint(0, planet.height / 2);
			}
			else if(ship.angleToPlanet <= Math.PI+1 && ship.angleToPlanet>Math.PI/2)
			{
				return new FlxPoint(planet.width/2,0);
			}
			else if (ship.angleToPlanet <= Math.PI/2+1 && ship.angleToPlanet>0)
			{
				return new FlxPoint(planet.width/2, planet.height / 2);
			}
			else
			{
				return new FlxPoint(planet.width/2, planet.height);
			}
			return null;
		}
	}

}