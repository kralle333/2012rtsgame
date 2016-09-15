package levels
{
	import gameclasses.menu.*;
	import gameclasses.players.*;
	import gameclasses.planets.*;
	import gameclasses.players.*;
	import gameclasses.ships.*;
	
	public class WinningCondition
	{
		private var minersBuild:int = 0;
		private var attackersBuild:int = 0;
		private var goldMined:int = 0;
		private var planetCaptured:Planet;
		private var enemy:ComputerPlayer;
		
		public function WinningCondition(miners:int, attackers:int, gold:int, planet:Planet, enemyDestroyed:ComputerPlayer)
		{
			minersBuild = miners;
			attackersBuild = attackers;
			goldMined = gold;
			planetCaptured = planet;
			enemy = enemyDestroyed;
		}
		
		public function won(player:Player):Boolean
		{
			if (player.shipsOfType(MinerShip) < minersBuild)
			{
				return false;
			}
			if (player.shipsOfType(AttackerShip) < minersBuild)
			{
				return false;
			}
			if (player.gold < goldMined)
			{
				return false;
			}
			var ownsPlanet:Boolean = false;
			if (planetCaptured != null && player.ownedPlanets.length > 0)
			{
				for (var i:int = 0; i < player.ownedPlanets.length; i++)
				{
					if (player.ownedPlanets.members[i] == planetCaptured)
					{
						ownsPlanet = true;
					}
				}
			}
			else
			{
				ownsPlanet = true;
			}
			var beatEnemy:Boolean = false;
			if (enemy != null && enemy.ships.getFirstAlive() == null)
			{
				beatEnemy = true;
			}
			else if(enemy == null)
			{
				beatEnemy = true;
			}
			return ownsPlanet && beatEnemy;
		}
	}

}