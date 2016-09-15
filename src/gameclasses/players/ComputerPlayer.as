package gameclasses.players
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import gameclasses.ships.AttackerShip;
	import gameclasses.ships.ColonizerShip;
	import gameclasses.ships.MinerShip;
	import gameclasses.ships.Ship;
	import org.flixel.*;
	import gameclasses.planets.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class ComputerPlayer extends Player
	{
		public var planets:Array;
		public var goldPlanets:Array = new Array();
		public var shipsDict:Dictionary = new Dictionary();
		public var goldPlanet:Planet;
		private var dropoffPlanet:Planet;
		
		public function ComputerPlayer(color:uint, planets:Array)
		{
			super(color, false);
			shipsDict["Miner"] = new Array();
			shipsDict["Attacker"] = new Array();
			shipsDict["Colonizer"]= new Array();
			this.planets = planets;
			for (var i:int = 0; i < planets.length; i++)
			{
				if (planets[i] is GoldPlanet)
				{
					goldPlanets.push(planets[i]);
				}
			}
		}
		
		override public function onBuild(ship:Ship):void
		{
			super.onBuild(ship);
			if (ship is MinerShip)
			{
				shipsDict["Miner"].push(ship);
			}
			else if (ship is AttackerShip)
			{
				shipsDict["Attacker"].push(ship);
			}
			else if (ship is ColonizerShip)
			{
				shipsDict["Colonizer"].push(ship);
			}
		}
		
		public function update():void
		{
			if (goldPlanet == null || GoldPlanet(goldPlanet).goldLeft == 0 && ownedPlanets.length > 0)
			{
				findAndSetNearestGoldPlanet();
			}
			else if (goldPlanet != null)
			{
				for (var i:int = 0; i < shipsDict["Miner"].length; i++)
				{
					if (shipsDict["Miner"][i].returnHome == false && shipsDict["Miner"][i].currentPlanet != goldPlanet && shipsDict["Miner"][i].planetFlyingTo == null)
					{
						shipsDict["Miner"][i].sendToPlanet(goldPlanet);
					}
				}
			}
		}
		
		private function findAndSetNearestGoldPlanet():void
		{
			var distance:int = 300;
			var dPlanet:Planet;
			var gPlanet:Planet;
			
			for (var i:int = 0; i < goldPlanets.length; i++)
			{
				for (var j:int = 0; j < ownedPlanets.length; j++)
				{
					if (FlxMath.vectorLength(goldPlanets[i].x - ownedPlanets.members[j].x, goldPlanets[i].y - ownedPlanets.members[j].y) < distance)
					{
						gPlanet = goldPlanets[i];
						dPlanet = ownedPlanets.members[j];
						distance = FlxMath.vectorLength(goldPlanets[i].x - ownedPlanets.members[j].x, goldPlanets[i].y - ownedPlanets.members[j].y);
					}
				}
			}
			goldPlanet = gPlanet;
			dropoffPlanet = dPlanet;
		}
	}
}