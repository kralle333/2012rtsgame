package levels 
{
	import gameclasses.*;
	import gameclasses.ships.*;
	import gameclasses.planets.*;
	public class Level1 extends Level
	{
		public function Level1() 
		{
			super(100,800,600);
			var p1:Planet = new Planet(30,30,80,"HQ");
			var p2:Planet = new Planet(200, 40, 80,"None");
			var human:Player = new Player(0xFF0000, true);
			human.gold = 0;
			planets.add(p1);
			planets.add(p2);
			p1.setOwnership(human);
			shipManager.addShips(p1, 8, human, AttackerShip);
			players.push(human);
			humanPlayer = human;
			introText = "Capture the neutral planet";
			winningCondition = new WinningCondition(0, 0, 0, p2, null);
		}
		
	}

}