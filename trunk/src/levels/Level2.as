package levels 
{

	import gameclasses.*;
	import gameclasses.ships.*;
	import gameclasses.planets.*;
	import gameclasses.players.*;
	public class Level2 extends Level
	{
		public function Level2() 
		{
			super(100,1000,1000);
			var p1:Planet = new Planet(300,30,200,"HQ");
			var p2:GoldPlanet = new GoldPlanet(100, 100, 100, 1000);
			var human:Player = new Player(0xFF0000, true);
			shipManager = new ShipManager(200, [p1,p2]);
			p1.setOwnership(human);
			planets.add(p1);
			planets.add(p2);
			p1.setOwnership(human);
			shipManager.addShips(p1, 5, human,MinerShip);
			players.push(human);
			humanPlayer = human;
			introText = "Mine 50 gold";
			winningCondition = new WinningCondition(0, 0, 50, null, null);
		}
		
	}

}