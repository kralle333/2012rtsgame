package misc 
{
	import gameclasses.planets.Planet;
	import gameclasses.ships.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxMath;

	public class ShipMath 
	{
		static public var ships:Array;

		
		static public function getAngleFromShipToPlanet(ship:Ship, planet:Planet):Number
		{
			return getAngleToPlanet(new FlxPoint(ship.x + ship.width / 2, ship.y + ship.height / 2), planet);
		}
		static public function getAngleToPlanet(point:FlxPoint, planet:Planet):Number
		{
			return Math.atan2(point.y - planet.y, point.x - planet.x);
		}
		static public function getDistanceFromShipToPlanetOrigin(ship:Ship, planet:Planet):Number
		{
			return getDistanceToPlanetOrigin(new FlxPoint(ship.x + ship.width / 2, ship.y + ship.height / 2),planet);
		}
		static public function getDistanceFromOriginToOrigin(planet1:Planet, planet2:Planet):Number
		{
			return getDistanceToPlanetOrigin(new FlxPoint(planet1.x + planet1.width / 2, planet1.y + planet1.height / 2), planet2);
		}
		static public function getDistanceToPlanetOrigin(point:FlxPoint, planet:Planet):Number
		{
			return Math.sqrt(Math.pow((point.x)-(planet.x+planet.origin.x),2) + Math.pow((point.y)-(planet.y+planet.origin.y),2));
		}
		static public function getEnemyNearShip(ship:Ship):Ship
		{
			var enemy:Ship;
			var distance:int = 3000;
			for (var i:int = 0; i < ship.currentPlanet.ownedShips.length; i++) 
			{
				if (ship.currentPlanet.ownedShips.members[i] != null &&ship.currentPlanet.ownedShips.members[i].exists &&  ship.currentPlanet.ownedShips.members[i].owner != ship.owner)
				{
					var enemyDistance:int = FlxMath.vectorLength(ship.currentPlanet.ownedShips.members[i].x - ship.x, ship.currentPlanet.ownedShips.members[i].y - ship.y);
					if (enemyDistance<distance)
					{
						enemy = ship.currentPlanet.ownedShips.members[i];
						distance = enemyDistance;
					}
				}
			}
			if (enemy != null)
			{
				ship.enemy = enemy;
				return enemy;
			}
			return null;
		}
		static public function getAllyNearShip(ship:Ship):Ship
		{
			var ally:Ship;
			var distance:int = 3000;
			for (var i:int = 0; i < ship.currentPlanet.ownedShips.length; i++) 
			{
				if (ship.currentPlanet.ownedShips.members[i] != null &&ship.currentPlanet.ownedShips.members[i].exists && ship.currentPlanet.ownedShips.members[i].owner == ship.owner)
				{
					var allyDistance:int = FlxMath.vectorLength(ship.currentPlanet.ownedShips.members[i].x - ship.x, ship.currentPlanet.ownedShips.members[i].y - ship.y);
					if (allyDistance<distance)
					{
						ally = ship.currentPlanet.ownedShips.members[i];
						distance = allyDistance;
					}
				}
			}
			if (ally != null)
			{
				ship.ally = ally;
				return ally;
			}
			return null;
		}
		static public function mouseOverlapsShip(ship:Ship):Boolean
		{
			return overLapsPoint(ship,new FlxPoint(FlxG.mouse.screenX+FlxG.camera.scroll.x, FlxG.mouse.screenY+FlxG.camera.scroll.y));
		}
		static public function shipClicked(ship:Ship):Boolean
		{
			if (FlxG.mouse.justPressed())
			{
				return mouseOverlapsShip(ship);
			}
			return false;
		}

		static public function mouseOverlapsPlanet(planet:Planet):Boolean
		{
			return overLapsPoint(planet,new FlxPoint(FlxG.mouse.screenX+FlxG.camera.scroll.x, FlxG.mouse.screenY+FlxG.camera.scroll.y));
		}
		static public function planetClicked(planet:Planet):Boolean
		{			
			if (FlxG.mouse.justPressed())
			{
				return mouseOverlapsPlanet(planet);
			}
			return false;
		}


		private static function overLapsPoint(object:FlxSprite,point:FlxPoint):Boolean
		{
			return point.x > object.x && point.x < object.x + object.width && point.y > object.y && point.y < object.y + object.height;
		}
	}

}