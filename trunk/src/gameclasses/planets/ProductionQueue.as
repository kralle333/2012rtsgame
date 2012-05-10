package gameclasses.planets 
{
	import gameclasses.ships.Ship;
	import org.flixel.FlxTimer;

	public class ProductionQueue 
	{
		private var buildItems:Array = new Array();
		private var timer:FlxTimer = new FlxTimer();
		private var currentShip:Class;
		private var planet:Planet;
		
		public function ProductionQueue(planet:Planet) 
		{
			this.planet = planet;
		}
		public function pushShip(ship:Class):void
		{
			buildItems.push(ship);
			if (buildItems.length == 1)
			{
				timer.start(Ship(ship).buildTime);
			}
		}
		public function pushShip(ship:Class):void
		{
			buildItems.splice(ship);
			if (buildItems.length >0)
			{
				timer.start(Ship(ship).buildTime);
			}
			else
			{
				timer.finished = true;
			}
		}
		public function update():void
		{
			if (timer.finished && buildItems.length > 0)
			{
				planet.getShip(currentShip);
				buildItems.shift();
				if (buildItems.length > 0)
				{
					currentShip = buildItems[0];
					timer.start(Ship(currentShip).buildTime);
				}
			}
		}
		
	}

}