package gameclasses.players 
{
	import gameclasses.ships.MinerShip;
	import gameclasses.ships.Ship;
	import org.flixel.FlxGroup;
	public class Player
	{
		public var ships:FlxGroup = new FlxGroup();
		public var ownedPlanets:FlxGroup = new FlxGroup();
		public var color:uint;
		public var isHuman:Boolean;
		public var number:int;
		public var gold:int = 0;
		
		public function Player(color:uint,isHuman:Boolean) 
		{
			this.color = color;
			this.isHuman = isHuman;
		}
		
		//Called when a new ship is build
		public function onBuild(ship:Ship):void
		{
			ships.add(ship);
		}
		public function shipsOfType(type:Class):int
		{
			var count:int = 0;
			for (var i:int = 0; i < ships.length; i++) 
			{
				if (ships.members[i] is type)
				{
					count++;
				}
			}
			return count;
		}
	}

}