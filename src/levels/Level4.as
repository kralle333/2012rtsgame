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
			super(1000, 0, 800);
			
			var planets:Array = new Array();
			
			planets.push(new GoldPlanet(100, 100, 80, 1000));
			planets.push(new Planet(200, 300, 100, "HQ"));
			
			planets.push(new GoldPlanet(600, 100, 80, 1000));
			planets.push(new Planet(500, 300, 100, "HQ"));
			
			planets.push(new Planet(300, 500, 120, "Factory"));
			
			
			var human:Player = new Player(0xFF0000, true);
			var com:ComputerPlayer = new ComputerPlayer(0x0000FF,planets);
			
			planets[0].setOwnership(human);
			planets[1].setOwnership(human);
			planets[2].setOwnership(com);
			planets[3].setOwnership(com);
			shipManager = new ShipManager(200, planets);
			
			shipManager.addShips(planets[1], 3, human, MinerShip);
			shipManager.addShips(planets[1], 5, human, AttackerShip);
			human.gold = 100;
			shipManager.addShips(planets[3], 3, com, MinerShip);
			shipManager.addShips(planets[3], 5, com, AttackerShip);
			com.gold = 100;
			players.push(human);
			players.push(com);
			addPlanets(planets);
			humanPlayer = human;
			introText = "Defeat Opponent";
			winningCondition = new WinningCondition(0, 0, 0, null, com);
		}
		
	}

}