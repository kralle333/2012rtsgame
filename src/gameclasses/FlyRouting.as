package gameclasses
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import gameclasses.planets.Planet;
	import gameclasses.ships.Ship;
	import misc.ShipMath;
	import org.flixel.*;
	
	public class FlyRouting extends FlxSprite
	{
		private var planets:Array = new Array();
		private var currentPlanetIndex:int = -1;
		private var lines:Array = new Array();
		
		private var flyingDistance:int = 300;
		private var shipsSelected:Array = new Array();
		public var routingShown:Boolean = false;
		private var bitMap:BitmapData;
		
		public function FlyRouting()
		{
			makeGraphic(800, 600, 0x0);
			scrollFactor.x = scrollFactor.y = 0;
			bitMap  = new BitmapData(800, 800, true, 0x00FFffFF);
		}
		
		override public function update():void
		{
			super.update();
			if (planets.length > 0)
			{
				bitMap = new BitmapData(800, 800, true, 0x00FFffFF);
				var line:Shape =new Shape();
				line.graphics.lineStyle(0, 0x0000FF);
				var startPoint:Point = new Point(-FlxG.camera.scroll.x+planets[currentPlanetIndex].x + planets[currentPlanetIndex].origin.x,-FlxG.camera.scroll.y+ planets[currentPlanetIndex].y + planets[currentPlanetIndex].origin.y);
				var endPoint:Point = new Point(FlxG.mouse.screenX, FlxG.mouse.screenY);
				
				var distance:Number = Math.sqrt(Math.pow(endPoint.x - startPoint.x,2) + Math.pow(endPoint.y-startPoint.y,2));
				if (distance > flyingDistance)
				{
					var normalized:Point = new Point((endPoint.x - startPoint.x),(endPoint.y-startPoint.y));
					normalized.x = normalized.x / distance;
					normalized.y = normalized.y / distance;
					normalized.x *= flyingDistance;
					normalized.y *= flyingDistance;
					normalized.x = normalized.x + startPoint.x;
					normalized.y = normalized.y + startPoint.y;
					endPoint = normalized;
				}
				
				
				line.graphics.moveTo(startPoint.x,startPoint.y);
				line.graphics.lineTo(endPoint.x,endPoint.y);
				
				
				

				for (var j:int = 0; j < planets.length - 1; j++)
				{
					var planetLine:Shape = new Shape();					
					planetLine.graphics.lineStyle(0, 0x0000FF);
					planetLine.graphics.moveTo(-FlxG.camera.scroll.x+planets[j].x + planets[j].origin.x,-FlxG.camera.scroll.y+ planets[j].y + planets[j].origin.y);
					planetLine.graphics.lineTo( -FlxG.camera.scroll.x + planets[j + 1].x + planets[j + 1].origin.x, -FlxG.camera.scroll.y + planets[j + 1].y + planets[j + 1].origin.y);
					bitMap.draw(planetLine);
				}

					bitMap.draw(line);
					pixels = bitMap;				
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
				}
			}
			else
			{
				while (index != currentPlanetIndex)
				{
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
			lines.splice(0);
			currentPlanetIndex = -1;
			exists = false;
			routingShown = false;
		}
	}

}