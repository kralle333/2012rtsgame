package gameclasses.planets
{
	import flash.display.*;
	import flash.utils.Dictionary;
	import flash.geom.*;
	import gameclasses.ships.*;
	import gameclasses.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Planet extends FlxSprite
	{
		public var owner:Player;
		public var ownedShips:FlxGroup = new FlxGroup();
		public var shipsSelected:int = 0;
		public var shipsNeededToOwn:int = 0;
		public var shipsOfPlayers:Dictionary = new Dictionary();
		public var size:int = 0;
		
		protected var planetOverlay:PlanetBackgroundCreator;
		protected var background:FlxSprite;
		private var naturalColor:uint = 0x0;
		public var productionQueue:ProductionQueue = new ProductionQueue(this);
		public var type:String;
		
		public function Planet(x:int, y:int,size:int,type:String)
		{
			this.x = x;
			this.y = y;
			this.type = type;
			this.makeGraphic(size, size, 0x00000000,true);
			shipsNeededToOwn = size/10;
			this.size = size;
			planetOverlay = new PlanetBackgroundCreator(this);
			createOverlay();
		}
		protected function createOverlay():void
		{
			if (type == "Factory")
			{
				background = planetOverlay.createBackground("Grass");
				background = planetOverlay.addToBackground("Factory");
				stamp(background);
			}
			else if (type == "HQ")
			{
				background = planetOverlay.createBackground("Grass");
				background = planetOverlay.addToBackground("HQ");
				stamp(background);
			}
			else if(type == "Gold")
			{
				background = planetOverlay.createBackground("Gold");
				stamp(background);
			}
			else if(type == "None")
			{
				background = planetOverlay.createBackground("None");
				stamp(background);
			}
		}
		public function getShip(ship:Ship):void
		{
			ownedShips.add(ship);
			ship.planet = this;
			if (( isNaN(shipsOfPlayers[ship.owner]) || shipsOfPlayers[ship.owner] == null ))
			{
				shipsOfPlayers[ship.owner] = 0;
			}
			shipsOfPlayers[ship.owner]++;
			if (ship.owner != owner)
			{
				checkOwnership();
			}
		}
		public function setOwnership(player:Player):void
		{
			owner = player;
			player.ownedPlanets.add(this);
			drawOwnership(player.color, player.color, 0);
		}
		private function checkOwnership():void
		{
			var firstPlayer:Player;
			var secondPlayer:Player;
			var firstPlayerShips:int = shipsOfPlayers[firstPlayer];
			var secondPlayerShips:int = shipsOfPlayers[secondPlayer];
			for (var k in shipsOfPlayers)
			{
				var key:Player = Player(k);
				var value:int = int(shipsOfPlayers[k]);
				if (firstPlayer == null)
				{
					firstPlayer = key;
					firstPlayerShips = value;
				}
				else
				{
					secondPlayer = key;
					secondPlayerShips = value;
				}
			}
			if (firstPlayerShips > secondPlayerShips && firstPlayerShips != 0)
			{
				if ((firstPlayer == owner || shipsNeededToOwn <= firstPlayerShips) && secondPlayerShips==0)
				{
					if (owner != firstPlayer)
					{
						owner = firstPlayer;
						firstPlayer.ownedPlanets.add(this);
						drawOwnership(firstPlayer.color, firstPlayer.color, 0);
					}
				}
				else if (secondPlayerShips == 0)
				{
					if (owner == null)
					{
						drawOwnership(firstPlayer.color, naturalColor, (firstPlayerShips/shipsNeededToOwn)*225);
					}
					else if (owner != firstPlayer)
					{
						drawOwnership(firstPlayer.color, secondPlayer.color, (firstPlayerShips/shipsNeededToOwn)*225);
					}
				}
				else
				{
					drawOwnership(secondPlayer.color,firstPlayer.color,  ((secondPlayerShips / firstPlayerShips) * 122));
				}
			}
			else if (firstPlayerShips < secondPlayerShips)
			{
				if (shipsNeededToOwn <= secondPlayerShips && firstPlayerShips==0)
				{
					if (owner != secondPlayer)
					{
						owner = secondPlayer;
						drawOwnership(secondPlayer.color,secondPlayer.color, 0);
						secondPlayer.ownedPlanets.add(this);
					}
				}
				else if (firstPlayerShips == 0)
				{
					if (owner == null)
					{
						drawOwnership(secondPlayer.color, naturalColor, (secondPlayerShips/shipsNeededToOwn)*225);
					}
					else if(owner != secondPlayer)
					{
						drawOwnership(firstPlayer.color, secondPlayer.color, (secondPlayerShips/shipsNeededToOwn)*225);
					}
				}
				else
				{
					drawOwnership(firstPlayer.color, secondPlayer.color, ((firstPlayerShips/secondPlayerShips) * 122));
				}
			}
			else if (firstPlayer != null && secondPlayer != null && firstPlayerShips == secondPlayerShips)
			{
				drawOwnership(firstPlayer.color, secondPlayer.color, 122);
			}
			else if(owner == null)
			{
				drawOwnership(naturalColor,naturalColor,  0);
			}
			else 
			{
				drawOwnership(owner.color, owner.color, 255);
			}
		}
		public function ownsShipOfType(player:Player, type:Class)
		{
			for (var i:int = 0; i < ownedShips.length; i++)
			{
				if (ownedShips.members[i].owner == player && ownedShips.members[i] is type)
				{
					return true;
				}
			}
			return false;
		}
		public function getNumberOfShipsOfTypeOwnedByPlayer(player:Player, type:Class):int
		{
			var count:int = 0;
			for (var i:int = 0; i < ownedShips.length; i++)
			{
				if (ownedShips.members[i].owner == player && ownedShips.members[i] is type)
				{
					count++;
				}
			}
			return count;
		}
		
		public function sendShips(newPlanet:Planet, fromPlayer:Player):void
		{
			var shipsToRemove:FlxGroup = new FlxGroup();
			for (var ship:String in ownedShips.members)
			{
				if (shipsSelected > 0 && ownedShips.members[ship].owner == fromPlayer)
				{
					ownedShips.members[ship].sendToPlanet(newPlanet);
					shipsToRemove.add(ownedShips.members[ship]);
					shipsSelected--;
				}
			}
			for (var s:String in shipsToRemove.members)
			{
				ownedShips.remove(shipsToRemove.members[s], true);
			}
		}
		public function removeShip(ship:Ship):void
		{
			shipsOfPlayers[ship.owner]--;
			ownedShips.remove(ship, true);
			checkOwnership();
		}
		public function sendShipsOfType(newPlanet:Planet, fromPlayer:Player, type:Class):void
		{
			var shipsToRemove:FlxGroup = new FlxGroup();
			for (var ship:String in ownedShips.members)
			{
				if (shipsSelected > 0 && ownedShips.members[ship].owner == fromPlayer && ownedShips.members[ship] is type)
				{
					ownedShips.members[ship].sendToPlanet(newPlanet);
					shipsToRemove.add(ownedShips.members[ship]);
					shipsSelected--;
				}
			}
			for (var s:String in shipsToRemove.members)
			{
				ownedShips.remove(shipsToRemove.members[s], true);
			}
		}
		
		public function ownsUnits(player:Player):Boolean
		{
			for (var i:int = 0; i < ownedShips.length; i++)
			{
				if (ownedShips.members[i].color == player.color)
				{
					return true;
				}
			}
			return false;
		}
		
		private function drawOwnership(color1:uint, color2:uint, color1Ratio:int):void
		{
			var mat:Matrix = new Matrix()
			var colors:Array = [color1, color2];
			var alphas:Array = [0.5, 0.5]
			var ratios:Array = [color1Ratio, 255];
			var circ:Shape = new Shape();
			if (color2 == 0x0)
			{
				alphas[1] = 0;
			}
			if (color1 != color2)
			{
				mat.createGradientBox(width, height, 0,0, 0);
				circ.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mat,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				circ.graphics.drawCircle(width/2, width/2,height/2-1);
				circ.graphics.endFill();
			}
			else
			{
				if (color1 != color2)
				{
					circ.graphics.lineStyle(1,0x0);
				}
				else
				{
					circ.graphics.lineStyle(1,color1);
				}
				
				circ.graphics.drawCircle(width / 2, width / 2, height / 2 - 1);
			}
			
			var bitMap:BitmapData = new BitmapData(width, height, true,0x00FFffFF);
			bitMap.draw(circ);
			
			var overlay:FlxSprite = new FlxSprite().makeGraphic(width, height);
			overlay.pixels = bitMap;
			bitMap.dispose();
			if (background != null)
			{
				stamp(background);
			}
			stamp(overlay);
		}
		public function distanceToShipFromOrigin(ship:Ship):Number
		{
			return Math.sqrt(Math.pow((ship.x+ship.width/2)-(x+origin.x),2) + Math.pow((ship.y+ship.height/2)-(y+origin.y),2));
		}
	}

}