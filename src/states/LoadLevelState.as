package states
{
	import gameclasses.buildmenu.BuildMenuManager;
	import gameclasses.ships.*;
	import levels.Level;
	import gameclasses.menu.*;
	import gameclasses.*;
	import org.flixel.*;
	
	public class LoadLevelState extends FlxState
	{
		private var loaded:Boolean = false;
		private var planetsLoaded:Boolean = false;
		private var shipsLoaded:Boolean = false;
		private var menusLoaded:Boolean = false;
		private var minimapLoaded:Boolean = false;
		
		private var introText:FlxText = new FlxText(30, 30, FlxG.width, "Loading...");
		private var introTextLoaded:Boolean = false;
		private var alphaSpeed:Number = 0.01;
		private var playState:PlayState = new PlayState();
		private var currentCommand = 0;
		
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
						playState.add(playState.currentLevel.shipManager.bullets);
						break;
					
					case 4: 
						playState.add(menu);
						break;
					case 5: 
						playState.add(playState.menuManager.returnPlanetInfoTextAsFlxGroup());
						break;
					case 6: 
						playState.add(playState.menuManager.returnMenusAsFlxGroup());
						break;
					case 7: 
						playState.add(playState.menuManager.returnMenuTextsAsFlxGroup());
						break;
					case 8: 
						playState.add(playState.goldText);
						break;
					case 9: 
						playState.add(playState.unitsText);
						break;
					case 10: 
						playState.add(playState.planetsText);
						break;
					case 11: 
						playState.goldText.size = playState.unitsText.size = playState.planetsText.size = 10;
						break;
					case 12: 
						playState.goldText.scrollFactor.x = playState.goldText.scrollFactor.y = 0;
						break;
					case 13: 
						playState.unitsText.scrollFactor.x = playState.unitsText.scrollFactor.y = 0;
						break;
					case 14: 
						playState.planetsText.scrollFactor.x = playState.planetsText.scrollFactor.y = 0;
						break;
					case 15: 
						menu.scrollFactor.x = menu.scrollFactor.y = 0;
						break;
					case 16: 
						FlxG.bgColor = 0xff386860;
						break;
					case 17: 
						FlxG.worldBounds = new FlxRect(0, 0, playState.currentLevel.width, playState.currentLevel.height);
						break;
					case 18: 
						playState.miniMap = new MiniMap(4, FlxG.height - 114, playState.currentLevel.width, playState.currentLevel.height, playState.currentLevel.planets);
						break;
					case 19: 
						playState.add(playState.miniMap.map);
						break;
					case 20: 
						playState.add(playState.miniMap.screenRectangle);
						break;
					case 21: 
						playState.buildMenuManager = new BuildMenuManager(playState.currentLevel);
						break;
					case 22: 
						playState.add(playState.buildMenuManager.returnSpritesAsFlxGroup());
						break;
					case 23: 
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