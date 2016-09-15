package states
{
	import flash.media.Camera;
	import flash.utils.Dictionary;
	import gameclasses.buildings.FactoryBuilding;
	import gameclasses.menu.*;
	import gameclasses.planets.Planet;
	import gameclasses.ships.*;
	import gameclasses.menu.building.*;
	import gameclasses.players.*;
	import levels.Level;
	import misc.*;
	import org.flixel.*;
	import gameclasses.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.display.*;
	import misc.Cursor;
	
	public class PlayState extends FlxState
	{
		
		public var currentLevel:Level;
		private var cameraSet:Boolean = false;
		private var planetPressed:Boolean = false;
		private var planetIterator:Planet
		private var pressedPlanet:Planet;
		
		public var shipSelection:ShipSelection;
		private var currentHumanShip:Ship;
		
		//Text
		public var goldText:FlxText = new FlxText(5, 5, 300, "0 g");
		public var unitsText:FlxText = new FlxText(5, 25, 300, "0 units");
		public var planetsText:FlxText = new FlxText(5, 50, 300, "0 planets");
		
		//Intro variables
		private var alphaSpeed:Number = 0.001;
		private var introSeen:Boolean = false;
		private var introText:FlxText = new FlxText(30, 30, FlxG.width, "");
		private var introTextLoaded:Boolean = false;
		
		[Embed(source='../../assets/menu.png')]
		private var menuTexture:Class;
		private var menu:FlxSprite;
		
		[Embed(source='../../assets/sound.mp3')]
		private var music:Class;
		
		public var fogOfWar:FogOfWar;
		public var buildMenuManager:BuildMenuManager;
		public var miniMap:MiniMap;
		public var planetInfo:PlanetInfo;
		
		public var controlGroups:Dictionary = new Dictionary();
		
		override public function create():void
		{
			super.create();
		}
		
		override public function update():void
		{
			super.update();
			if (!cameraSet)
			{
				FlxG.camera.bounds = FlxG.worldBounds;
				cameraSet = true;
			}
			for (var i:int = 0; i < currentLevel.players.length; i++)
			{
				if (currentLevel.players[i] is ComputerPlayer)
				{
					currentLevel.players[i].update();
				}
			}
			
			if (currentLevel.winningCondition.won(currentLevel.humanPlayer))
			{
				FlxG.switchState(new ScoreScreenState(currentLevel));
			}
			goldText.text = currentLevel.humanPlayer.gold + "g";
			unitsText.text = currentLevel.humanPlayer.ships.length + " ships";
			planetsText.text = currentLevel.humanPlayer.ownedPlanets.length + " planets";
			
			if (pressedPlanet != null)
			{
				planetInfo.drawPlanetInfo(pressedPlanet);
			}
			miniMap.update();
			shipSelection.update();
			buildMenuManager.update();
			handleShips();
			handlePlanets();
			if (FlxG.mouse.justPressed() && FlxG.mouse.y< FlxG.height-118 && planetPressed == false)
			{
				shipSelection.hide();
			}
			planetPressed = false;
			handleScreenPosition();
		}
		
		private function handleShips():Boolean
		{
			for (var ship:String in currentLevel.humanPlayer.ships)
			{
				currentHumanShip = currentLevel.humanPlayer.ships[ship];
				if (ShipMath.mouseOverlapsShip(currentHumanShip))
				{
					shipSelection.addShip(currentHumanShip);
					return true;
				}
			}
			return false;
		}
		
		private function handlePlanets():Boolean
		{
			for (var planet:String in currentLevel.planets.members)
			{
				planetIterator = currentLevel.planets.members[planet];
				if (ShipMath.mouseOverlapsPlanet(planetIterator))
				{
					if (shipSelection.flyRouting.routingShown)
					{
						shipSelection.flyRouting.addPlanet(planetIterator);
					}
					if (FlxG.mouse.justPressed())
					{
						pressedPlanet = planetIterator;
						var onlyChecked:Boolean = onlyChecksOrSelectingShips();
						planetPressed = true;
						if (onlyChecked)
						{							
							buildMenuManager.handlePlanetPress(planetIterator);
						}
						
					}
				}
				if (planetIterator.shipsToBeAdded.length > 0)
				{
					for (var j:int = 0; j < planetIterator.shipsToBeAdded.length; j++)
					{
						currentLevel.shipManager.addShips(planetIterator, 1, planetIterator.owner, planetIterator.shipsToBeAdded[j]);
					}
					planetIterator.shipsToBeAdded = new Array();
				}
				planetIterator.productionQueue.update();
			}
			return planetPressed;
		}
		
		private function onlyChecksOrSelectingShips():Boolean
		{
			if (FlxG.keys.Z || FlxG.keys.A || FlxG.keys.S || FlxG.keys.D)
			{
				var ships:Array = new Array();
				if (FlxG.keys.Z)
				{
					ships = pressedPlanet.getShipsOfTypeOfPlayer(currentLevel.humanPlayer);
				}
				else if (FlxG.keys.A)
				{
					ships = pressedPlanet.getShipsOfTypeOfPlayer(currentLevel.humanPlayer, MinerShip);
				}
				else if (FlxG.keys.S)
				{
					ships = pressedPlanet.getShipsOfTypeOfPlayer(currentLevel.humanPlayer, AttackerShip);
				}
				else if (FlxG.keys.D)
				{
					ships = pressedPlanet.getShipsOfTypeOfPlayer(currentLevel.humanPlayer, ColonizerShip);
				}
				if (ships != null && ships.length > 0)
				{
					shipSelection.flyRouting.addPlanet(planetIterator);
					shipSelection.show(ships);
				}
				return false;
			}
			return true;
		}
		
		private function handleScreenPosition():void
		{
			var scroll:FlxPoint = new FlxPoint();
			if (FlxG.mouse.screenX < 30 && FlxG.mouse.screenY < FlxG.height - 118)
			{
				FlxG.camera.scroll.x -= 5;
				if (FlxG.camera.scroll.x > FlxG.camera.bounds.left)
				{
					scroll.x -= 5;
				}
			}
			if (FlxG.mouse.screenY < 30)
			{
				FlxG.camera.scroll.y -= 5;
				if (FlxG.camera.scroll.y > FlxG.camera.bounds.top)
				{
					scroll.y -= 5;
				}
			}
			if (FlxG.mouse.screenX > FlxG.width - 30)
			{
				FlxG.camera.scroll.x += 5;
				if (FlxG.camera.scroll.x + FlxG.width <= FlxG.camera.bounds.right)
				{
					scroll.x += 5;
				}
			}
			if (FlxG.mouse.screenY > FlxG.height - 30)
			{
				FlxG.camera.scroll.y += 5;
				if (FlxG.camera.scroll.y + FlxG.height <= FlxG.camera.bounds.bottom)
				{
					scroll.y += 5;
				}
			}
			
			if (scroll.x != 0 || scroll.y != 0)
			{
				miniMap.updatePosition(scroll.x, scroll.y, true);
				switch (scroll.x)
				{
					case 0: 
						switch (scroll.y)
					{
						case-5: 
							FlxG.mouse.load(Cursor.upScroll);
							break;
						case 5: 
							FlxG.mouse.load(Cursor.downScroll);
							break;
					}
						break;
					case 5: 
						switch (scroll.y)
					{
						case-5: 
							FlxG.mouse.load(Cursor.upScroll);
							break;
						case 0: 
							FlxG.mouse.load(Cursor.rightScroll);
							break;
						case 5: 
							FlxG.mouse.load(Cursor.downScroll);
							break;
					}
						break;
					case-5: 
						switch (scroll.y)
					{
						case-5: 
							FlxG.mouse.load(Cursor.upScroll);
							break;
						case 0: 
							FlxG.mouse.load(Cursor.leftScroll);
							break;
						case 5: 
							FlxG.mouse.load(Cursor.downScroll);
							break;
					}
						break;
				}
			}
			else
			{
				FlxG.mouse.load(Cursor.normalCursor);
			}
		
		}
	}

}