package gameclasses.planets
{
	import gameclasses.ships.*;
	import gameclasses.*;
	import org.flixel.FlxTimer;
	
	public class ProductionQueue
	{
		public var buildItems:Array = new Array();
		public var shipJustBuild:Boolean = false;
		private var timer:FlxTimer = new FlxTimer();
		private var currentShip:Class;
		private var planet:Planet;
		
		public function ProductionQueue(planet:Planet)
		{
			this.planet = planet;
		}
		
		public function buildStatus():int
		{
			if (buildItems.length > 0)
			{
				return (timer.timeLeft / timer.time) * 100;
			}
			return -1;
		}
		
		public function pushShip(ship:Class):void
		{
			buildItems.push(ship);
			if (buildItems.length == 1)
			{
				switch (ship)
				{
					case MinerShip: 
						timer.stop();
						timer.start(MinerShip.buildTime);
						break;
					case AttackerShip: 
						timer.stop();
						timer.start(AttackerShip.buildTime);
						break;
					case ColonizerShip: 
						timer.stop();
						timer.start(ColonizerShip.buildTime);
						break;
				}
				currentShip = ship;
			}
		}
		
		public function removeItem(index:int):void
		{
			if (index == 0)
			{
				if (buildItems.length > 1)
				{
					currentShip = buildItems[1];
					timer.start(currentShip.buildTime);
				}
				else
				{
					timer.finished = true;
				}
			}
			buildItems.splice(index, 1);
		}
		public function update():void
		{
			if (timer.finished && buildItems.length > 0)
			{
				planet.shipsToBeAdded.push(currentShip);
				shipJustBuild = true;
				buildItems.shift();
				if (buildItems.length > 0)
				{
					currentShip = buildItems[0];
					timer.start(currentShip.buildTime);
				}
			}
		}
	
	}

}