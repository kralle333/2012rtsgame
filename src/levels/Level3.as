package levels 
{

	import gameclasses.*;
	import gameclasses.ships.*;
	import gameclasses.planets.*;
	import gameclasses.players.*;
	public class Level3 extends Level
	{
		public function Level3() 
		{
			super(800, 500, 500);
			var planets:Array = new Array(new Planet(100,200,100,"HQ"), new Planet(300,100,200,"None"), new Planet(600,200,100,"HQ"));
			var human:Player = new Player(0xFF0000, true);
			var com:ComputerPlayer = new ComputerPlayer(0x0000FF, planets);
			planets[0].setOwnership(human);
			planets[2].setOwnership(com);
			
			shipManager = new ShipManager(200, planets);
			shipManager.addShips(planets[0], 8, human, AttackerShip);
			shipManager.addShips(planets[2], 4, com, AttackerShip);
			players.push(human);
			players.push(com);
			addPlanets(planets);
			humanPlayer = human;
			introText = "Defeat Opponent";
			winningCondition = new WinningCondition(0, 0, 0, null, com);
		}
		
	}

}