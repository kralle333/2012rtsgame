package gameclasses
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import gameclasses.planets.Planet;
	import gameclasses.ships.Ship;
	import misc.ShipMath;
	import org.flixel.*;
	
	public class FlyRouting extends FlxSprite
	{
		private var planets:Array = new Array();
		private var currentPlanetIndex:int = -1;
		private var newPlanetAdded:Boolean = false;
		private var previousPoint:FlxPoint = new FlxPoint();
		private var previousLines:Array = new Array();
		private var flyingDistance:int = 1000;
		private var shipsSelected:Array = new Array();
		public var routingShown:Boolean = false;
		
		public function FlyRouting()
		{
			makeGraphic(800, 600, 0x0);
			scrollFactor.x = scrollFactor.y = 0;
		}
		
		override public function update():void
		{
			super.update();
			if (planets.length > 0 && (newPlanetAdded || (previousPoint.x != FlxG.mouse.screenX && previousPoint.y != FlxG.mouse.screenY)) && ShipMath.getDistanceToPlanetOrigin(new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY), planets[currentPlanetIndex]) < flyingDistance)
			{
				var line:Shape = new Shape();
				line.graphics.lineStyle(0, 0x0000FF);
				line.graphics.moveTo(planets[currentPlanetIndex].x + planets[currentPlanetIndex].origin.x, planets[currentPlanetIndex].y + planets[currentPlanetIndex].origin.y);
				line.graphics.lineTo(FlxG.mouse.screenX, FlxG.mouse.screenY);
				var bitMap:BitmapData = new BitmapData(800, 800, true, 0x00FFffFF);
				bitMap.draw(line);
				pixels = bitMap;
				previousPoint = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
				stampPreviousLines();
				newPlanetAdded = false;
			}
			if (currentPlanetIndex > 0 && ShipMath.planetClicked(planets[currentPlanetIndex]))
			{
				planets.shift();
				currentPlanetIndex--;
				var lastPlanet:Planet = planets[planets.length - 1];
				for (var i:int = 0; i < shipsSelected.length; i++)
				{
					shipsSelected[i].addFlyingRoute(planets);
				}
				hide();
				addPlanet(lastPlanet);
			}
		}
		
		private function stampPreviousLines():void
		{
			for (var i:int = 0; i < previousLines.length; i++)
			{
				stamp(previousLines[i]);
			}
		}
		
		public function addPlanet(planet:Planet):void
		{
			var index:int = planets.indexOf(planet);
			if (index == -1)
			{
				if (currentPlanetIndex == -1 || ShipMath.getDistanceFromOriginToOrigin(planets[currentPlanetIndex], planet) < flyingDistance)
				{
					routingShown = true;
					currentPlanetIndex++;
					planets.push(planet);
					exists = true;
					if (planets.length > 1)
					{
						var line:Shape = new Shape();
						line.graphics.lineStyle(0, 0x0000FF);
						line.graphics.moveTo(planet.x + planet.origin.x, planet.y + planet.origin.y);
						line.graphics.lineTo(planets[planets.length - 2].x + planets[planets.length - 2].origin.x, planets[planets.length - 2].y + planets[planets.length - 2].origin.y);
						var bitMap:BitmapData = new BitmapData(800, 800, true, 0x00FFffFF);
						bitMap.draw(line);
						var overlay:FlxSprite = new FlxSprite().makeGraphic(800, 800, 0x00ffffff);
						overlay.pixels = bitMap;
						previousLines.push(overlay);
						stamp(overlay);
						newPlanetAdded = true;
					}
				}
			}
			else
			{
				while (index != currentPlanetIndex)
				{
					previousLines.pop();
					planets.pop();
					currentPlanetIndex--;
				}
			}
		}
		
		public function addShips(ships:Array):void
		{
			for (var i:int = 0; i < ships.length; i++)
			{
				addShip(ships[i]);
			}
		}
		
		public function addShip(ship:Ship):void
		{
			shipsSelected.push(ship);
		}
		
		public function removeShip(ship:Ship):void
		{
			shipsSelected.splice(ship, 1);
		}
		
		public function getNumberOfShipsSelected():int
		{
			return shipsSelected.length;
		}
		
		public function shipClicked(ship:Ship):void
		{
			if (shipsSelected.indexOf(ship) == -1)
			{
				shipsSelected.push(ship);
			}
			else
			{
				shipsSelected.splice(ship, 1);
			}
		}
		
		public function hide():void
		{
			shipsSelected = new Array();
			planets.splice(0)
			previousLines.splice(0);
			previousPoint = new FlxPoint(-1, -1);
			currentPlanetIndex = -1;
			exists = false;
			routingShown = false;
		}
	}

}