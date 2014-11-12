package states
{
	import gameclasses.menu.building.*;
	import gameclasses.menu.PlanetInfo;
	import gameclasses.planets.Planet;
	import gameclasses.menu.*;
	import gameclasses.menu.building.*;
	import gameclasses.ships.*;
	import levels.Level;
	import gameclasses.*;
	import misc.FogOfWar;
	import misc.ShipMath;
	import org.flixel.*;
	
	public class LoadLevelState extends FlxState
	{
		private var loaded:Boolean = false;
		
		private var introText:FlxText = new FlxText(30, 30, FlxG.width, "Loading...");
		private var introTextLoaded:Boolean = false;
		private var alphaSpeed:Number = 0.01;
		private var playState:PlayState = new PlayState();
		private var currentCommand:int = 0;
		
		[Embed(source='../../assets/menu.png')]
		private var menuTexture:Class;
		private var menu:FlxSprite = new FlxSprite(0, FlxG.height - 118, menuTexture);
		
		override public function create():void
		{
			super.create();
		}
		
		public function setCurrentLevel(level:Level):void
		{
			playState.currentLevel = level;
			introText.size = 50;
			add(introText);
			introText.alpha = 0;
		
		}
		
		override public function update():void
		{
			if (introText.alpha < 1)
			{
				introText.alpha += alphaSpeed;
			}
			if (FlxG.mouse.justPressed() && loaded)
			{
				FlxG.switchState(playState);
			}
			if (!loaded && introText.alpha > 0.5)
			{
				loadPlayState();
				FlxG.bgColor = 0xff386860;
			}
		}
		
		private function loadPlayState():void
		{
			var t:FlxTimer = new FlxTimer();
			t.start(0.01);
			while (true)
			{
				switch (currentCommand)
				{
					case 0: 
						playState.add(playState.currentLevel.planets);
						break;
					case 1: 
						playState.add(playState.currentLevel.shipManager);
						break;
					case 2: 
						for (var i:int = 0; i < playState.currentLevel.shipManager.length; i++)
						{
							if (playState.currentLevel.shipManager.members[i] is MinerShip)
							{
								playState.add(playState.currentLevel.shipManager.members[i].raySprite);
							}
							playState.add(playState.currentLevel.shipManager.members[i].healthBar);
						}
						break;
					case 3: 
						for (var j:int = 0; j < playState.currentLevel.planets.length; j++)
						{
							playState.add(playState.currentLevel.planets.members[j].gradiantBorder);
						}
						break;
					case 4: 
						playState.add(playState.currentLevel.shipManager.bullets);
						break;
					case 5: 
						playState.fogOfWar = new FogOfWar(playState.currentLevel.humanPlayer, new FlxPoint(playState.currentLevel.width, playState.currentLevel.height));
						//playState.add(playState.fogOfWar);
						
						break;
					case 6: 
						playState.add(menu);
						break;
					case 7: 
						playState.planetInfo = new PlanetInfo();;
						playState.add(playState.planetInfo.returnTextAsFlxGroup());
						break;
					case 8: 
						playState.shipSelection = new ShipSelection(new FlxPoint(FlxG.width/2,FlxG.height-100));
						playState.add(playState.shipSelection.shipIcons);
						playState.add(playState.shipSelection.buttons[1]);
						playState.add(playState.shipSelection.buttons[2]);
						playState.add(playState.shipSelection.buttons[3]);
						playState.add(playState.shipSelection.flyRouting);
						playState.add(playState.shipSelection.healthBars);
						playState.add(playState.shipSelection.shipsSelectionBoxes);
						break;
					case 9: 
						
						break;
					case 10: 
						playState.add(playState.goldText);
						break;
					case 11: 
						playState.add(playState.unitsText);
						break;
					case 12: 
						playState.add(playState.planetsText);
						break;
					case 13: 
						playState.goldText.scrollFactor.x = playState.goldText.scrollFactor.y = 0;
						break;
					case 14: 
						playState.unitsText.scrollFactor.x = playState.unitsText.scrollFactor.y = 0;
						break;
					case 15: 
						playState.planetsText.scrollFactor.x = playState.planetsText.scrollFactor.y = 0;
						break;
					case 16: 
						menu.scrollFactor.x = menu.scrollFactor.y = 0;
						break;
					case 17: 
						playState.goldText.size = playState.unitsText.size = playState.planetsText.size = 10;
						break;
					case 18: 
						FlxG.worldBounds = new FlxRect(0, 0, playState.currentLevel.width, playState.currentLevel.height);
						break;
					case 19: 
						playState.miniMap = new MiniMap(4, FlxG.height - 114, playState.currentLevel.width, playState.currentLevel.height, playState.currentLevel.planets);
						break;
					case 20: 
						playState.add(playState.miniMap.map);
						break;
					case 21: 
						playState.add(playState.miniMap.screenRectangle);
						playState.buildMenuManager = new BuildMenuManager(playState.currentLevel);
						break;
					case 22: 
						playState.add(playState.add(playState.buildMenuManager.colonizingIcons));
						break;
					case 23: 
						playState.add(playState.add(playState.buildMenuManager.factoryIcons));
						playState.add(playState.add(playState.buildMenuManager.hqIcon));
						break;
					case 24: 
						playState.add(playState.buildMenuManager.buildTimerBar);
						break;
					case 25: 
						playState.add(playState.buildMenuManager.returnIconsAsFlxGroup());
						break;
					case 26:
						
						break;
					case 27:
						
						break;
					case 28: 
						introText.text = "\nClick To Play";
						loaded = true;
						break;
				}
				currentCommand++;
				t.update();
				if (t.finished)
				{
					break;
				}
			}
		}
	
	}

}