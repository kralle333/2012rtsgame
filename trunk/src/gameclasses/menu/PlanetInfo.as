package gameclasses.menu
{
	import flash.utils.Dictionary;
	import gameclasses.planets.Planet;
	import org.flixel.*;
	
	public class PlanetInfo
	{
		private var planetInfoPlanet:Planet;
		public var planetInfoText:Dictionary = new Dictionary();
		private var ownedShipsShown:int = 0;
		
		public function PlanetInfo()
		{
			initPlanetInfoText();
		}
		
		public function returnTextAsFlxGroup():FlxGroup
		{
			var g:FlxGroup = new FlxGroup();
			for (var k:String in planetInfoText)
			{
				var key:String = String(k);
				var value:FlxText = FlxText(planetInfoText[key]);
				g.add(value);
			}
			return g;
		}
		
		public function initPlanetInfoText():void
		{
			planetInfoText["Name"] = new FlxText(0, 0, 300, "");
			planetInfoText["Owner"] = new FlxText(0, 0, 300, "");
			planetInfoText["Type"] = new FlxText(0, 0, 300, "");
			planetInfoText["Ships"] = new FlxText(0, 0, 300, "");
			for (var k:String in planetInfoText)
			{
				var key:String = String(k);
				var value:FlxText = FlxText(planetInfoText[k]);
				value.exists = false;
				value.x = 120;
				value.scrollFactor.x = 0;
				value.scrollFactor.y = 0;
			}
			planetInfoText["Name"].y = 500;
			planetInfoText["Owner"].y = 520;
			planetInfoText["Type"].y = 540;
			planetInfoText["Ships"].y = 560;
		}
		
		public function drawPlanetInfo(planet:Planet):void
		{
			
			if (planetInfoPlanet != planet)
			{
				planetInfoText["Name"].exists = true;
				planetInfoText["Owner"].exists = true;
				planetInfoText["Type"].exists = true;
				planetInfoText["Ships"].exists = true;
				
				planetInfoText["Name"].text = "Name: HELLO";
				if (planet.owner == null)
				{
					planetInfoText["Owner"].text = "Owner: None";
				}
				else
				{
					planetInfoText["Owner"].text = "Owner: " + planet.owner;
				}
				planetInfoText["Type"].text = "Type: " + planet.type;
				planetInfoText["Ships"].text = "Ships: " + planet.ownedShips.length;
				ownedShipsShown = planet.ownedShips.length;
				planetInfoPlanet = planet;
			}
			else if (ownedShipsShown != planet.ownedShips.length)
			{
				planetInfoText["Ships"].text = "Ships: " + planet.ownedShips.length;
			}
		}
	}

}