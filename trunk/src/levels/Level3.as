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
			super(1000, 1000, 1000);
			var planets:Array = new Array(new GoldPlanet(200, 30, 100, 1000),new Planet(200, 200, 100,"HQ"),new Planet(30, 30, 100,"Factory"),  new Planet(100, 500, 200,"None"), new GoldPlanet(600, 500, 150, 1000), new Planet(600, 200, 200,"HQ"));
			var human:Player = new Player(0xFF0000, true);
			var com:ComputerPlayer = new ComputerPlayer(0x0000FF,planets);
			
			planets[2].setOwnership(human);
			planets[1].setOwnership(human);
			planets[5].setOwnership(com);
			planets[3].setOwnership(com);
			planets[4].setOwnership(com);
			shipManager = new ShipManager(200, planets);
			shipManager.addShips(planets[5], 6, com, MinerShip);
			shipManager.addShips(planets[5], 6, com, AttackerShip);
			shipManager.addShips(planets[1], 5, human, MinerShip);
			shipManager.addShips(planets[1], 5, human, AttackerShip);
			human.gold = 100;
			players.push(human);
			players.push(com);
			addPlanets(planets);
			humanPlayer = human;
			introText = "Defeat Opponent";
			winningCondition = new WinningCondition(0, 0, 0, null, com);
		}
		
	}

}