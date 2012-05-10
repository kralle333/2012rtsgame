package levels 
{
	import gameclasses.Player;
	import gameclasses.ShipManager;
	import org.flixel.FlxGroup;
	import gameclasses.planets.*;
	import gameclasses.*;
	public class Level 
	{
		public var planets:FlxGroup = new FlxGroup();
		public var players:Array = new Array();
		public var shipManager:ShipManager;
		public var humanPlayer:Player;
		public var introText:String;
		public var winningCondition:WinningCondition;
		public var width:int = 0;
		public var height:int = 0;
		public function Level(ships:int,width:int,height:int) 
		{
			shipManager = new ShipManager(200);
			if (width < 800)
			{
				this.width = 800;
			}
			else
			{
				this.width = width;
			}
			if (height < 600)
			{
				this.height = 600;
			}
			else
			{
				this.height = height;
			}
		}
		public function addPlanets(planets:Array):void
		{
			for (var i:int = 0; i < planets.length; i++) 
			{
				this.planets.add(Planet(planets[i]));
			}
		}

	}

}