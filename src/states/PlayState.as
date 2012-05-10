package states
{
	import flash.media.Camera;
	import flash.utils.Dictionary;
	import gameclasses.buildings.FactoryBuilding;
	import gameclasses.buildmenu.BuildMenuManager;
	import gameclasses.menu.MenuManager;
	import gameclasses.planets.Planet;
	import gameclasses.ships.*;
	import levels.Level;
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
		private var currentPlanet:Planet
		
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
		
		public var flyingDistance:FlxSprite = new FlxSprite();
		
		public var buildMenuManager:BuildMenuManager;
		public var menuManager:MenuManager = new MenuManager();
		public var miniMap:MiniMap;
		
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
			handleScreenPosition();
			if (currentLevel.winningCondition.won(currentLevel.humanPlayer))
			{
				FlxG.switchState(new ScoreScreenState(currentLevel));
			}
			goldText.text = currentLevel.humanPlayer.gold + "g";
			unitsText.text = currentLevel.humanPlayer.ships.length + " ships";
			planetsText.text = currentLevel.humanPlayer.ownedPlanets.length + " planets";
			
			miniMap.update();
			menuManager.update();
			buildMenuManager.update();
			for (var planet:String in currentLevel.planets.members)
			{
				if (currentLevel.planets.members[planet].overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y)))
				{
					currentPlanet = currentLevel.planets.members[planet];
					if (FlxG.mouse.justPressed())
					{
						planetPressed = true;
						menuManager.handlePlanetPress(currentPlanet, currentLevel.humanPlayer, currentLevel.shipManager);
						buildMenuManager.handlePlanetPress(currentPlanet);
					}
					menuManager.handleMouseOverPlanet(currentPlanet);
				}
			}
			if (!planetPressed && FlxG.mouse.justPressed() && menuManager.selecting)
			{
				menuManager.hideCurrentMenu();
			}
			planetPressed = false;
		
		}

		
		private function drawFlyingDistance(x:int, y:int):void
		{
			if (x != flyingDistance.x && y != flyingDistance.y)
			{
				var circ:Shape = new Shape();
				circ.graphics.lineStyle(0);
				circ.graphics.drawCircle(x, y, 100);
				var bitMap:BitmapData = new BitmapData(800, 600, true, 0x00FFffFF);
				bitMap.draw(circ);
				flyingDistance.pixels = bitMap;
				bitMap.dispose();
				flyingDistance.exists = true;
			}
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
			if (FlxG.mouse.screenX > FlxG.width - 30 && FlxG.mouse.screenY < FlxG.height - 118)
			{
				FlxG.camera.scroll.x += 5;
				if (FlxG.camera.scroll.x + FlxG.width <= FlxG.camera.bounds.right)
				{
					scroll.x += 5;
				}
			}
			if (FlxG.mouse.screenY > FlxG.height - 118 - 30 - 15 && FlxG.mouse.screenY < FlxG.height - 118 - 15)
			{
				FlxG.camera.scroll.y += 5;
				if (FlxG.camera.scroll.y + FlxG.height <= FlxG.camera.bounds.right)
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