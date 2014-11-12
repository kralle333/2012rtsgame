package levels 
{

	import gameclasses.*;
	import gameclasses.ships.*;
	import gameclasses.planets.*;
	import gameclasses.players.*;
	public class Level4 extends Level
	{
		public function Level4() 
		{
			super(1000, 1000, 1000);
			var planets:Array = new Array(new Planet(200,200,100,"HQ"));
			var human:Player = new Player(0xFF0000, true);
			var com:ComputerPlayer = new ComputerPlayer(0x0000FF,planets);
			shipManager = new ShipManager(200, planets);
			shipManager.addShips(planets[0], 6, com, AttackerShip);
			shipManager.addShips(planets[0], 6, human, AttackerShip);
			players.push(human);
			players.push(com);
			addPlanets(planets);
			humanPlayer = human;
			introText = "Defeat Opponent";
			winningCondition = new WinningCondition(0, 0, 0, null, com);
		}
		
	}

}