package gameclasses.menu
{
	import flash.utils.Dictionary;
	import gameclasses.planets.*;
	import gameclasses.Player;
	import gameclasses.ShipManager;
	import org.flixel.*;
	import misc.*;
	import gameclasses.ships.*;
	
	public class MenuManager
	{
		private var menus:Dictionary = new Dictionary();
		private var currentMenu:Menu;
		private var currentPlanet:Planet;
		private var wantToBuy:int = 0;
		private var typeSelected:Class = null;
		
		public var selecting:Boolean = false;
		
		private var planetInfoText:Dictionary = new Dictionary();
		private var ownedShipsShown:int = 0;
		private var planetInfoPlanet:Planet;
		
		
		[Embed(source='../../../assets/buildoptions/attackerShip.png')]
		private var attackerOptionTexture:Class;
		[Embed(source='../../../assets/buildoptions/colonizerShip.png')]
		private var colonizerOptionTexture:Class;
		[Embed(source='../../../assets/buildoptions/minerShip.png')]
		private var minerOptionTexture:Class;
		private var planetBuyOptions:Dictionary = new Dictionary();
		
		public function MenuManager()
		{
			menus["MoveMiner"] = new MoveMenu("Miner", MinerShip);
			menus["MoveAttacker"] = new MoveMenu("Attacker", AttackerShip);
			menus["BuyMiner"] = new BuyMenu("Miner", 10, MinerShip);
			menus["BuyAttacker"] = new BuyMenu("Attacker", 20, AttackerShip);
			initPlanetInfoText();		
			initPlanetOptions();
		}
		
		public function returnMenusAsFlxGroup():FlxGroup
		{
			var g:FlxGroup = new FlxGroup();
			g.add(menus["MoveMiner"]);
			g.add(menus["MoveAttacker"]);
			g.add(menus["BuyMiner"]);
			g.add(menus["BuyAttacker"]);
			return g;
		}
		
		public function returnMenuTextsAsFlxGroup():FlxGroup
		{
			var g:FlxGroup = new FlxGroup();
			
			for (var k:String in menus)
			{
				var key:String = String(k);
				var value:Menu = Menu(menus[k]);
				g.add(value.menuText);
				g.add(value.menuText2);
			}
			return g;
		}
		public function returnPlanetInfoTextAsFlxGroup():FlxGroup
		{
			var g:FlxGroup = new FlxGroup();
			
			for (var k:String in planetInfoText)
			{
				var key:String = String(k);
				var value:FlxText = FlxText(planetInfoText[k]);
				g.add(value);
			}
			return g;
		}
		public function returnPlanetOptionsAsFlxGroup():FlxGroup
		{
			var g:FlxGroup = new FlxGroup();
			
			for (var k:String in planetBuyOptions)
			{
				var key:String = String(k);
				var value:FlxSprite = FlxSprite(planetBuyOptions[k]);
				g.add(value);
			}
			return g;
		}
		private function initPlanetOptions():void
		{
			planetBuyOptions["Attacker"] = new FlxSprite(0, 0, attackerOptionTexture)
			planetBuyOptions["Colonizer"] = new FlxSprite(0, 0, colonizerOptionTexture);
			planetBuyOptions["Miner"] = new FlxSprite(0, 0, minerOptionTexture);
			for (var k:String in planetBuyOptions)
			{
				var key:String = String(k);
				var value:FlxSprite = FlxSprite(planetBuyOptions[k]);
				value.exists = false;
			}
		}
		private function initPlanetInfoText():void
		{
			planetInfoText["Name"] = new FlxText(0, 0, 300, ""); 
			planetInfoText["Owner"]=new FlxText(0, 0, 300, ""); 
			planetInfoText["Type"]=new FlxText(0, 0, 300, ""); 
			planetInfoText["Ships"]=new FlxText(0, 0, 300, ""); 
			for (var k:String in planetInfoText)
			{
				var key:String = String(k);
				var value:FlxText = FlxText(planetInfoText[k]);
				value.exists = false;
				value.x = 120;
				value.scrollFactor.x = 0;
				value.scrollFactor.y = 0;
			}
			planetInfoText["Name"].y = 500;
			planetInfoText["Owner"].y = 520;
			planetInfoText["Type"].y = 540;
			planetInfoText["Ships"].y = 560;
		}
		public function update():void
		{
			updateShowHide();
		}
		
		private function updateShowHide():void
		{
			if (!selecting)
			{
				if ((FlxG.keys.Q || FlxG.keys.W || FlxG.keys.A || FlxG.keys.S))
				{
					if (currentMenu != null)
					{
						currentMenu.hide();
					}
					
					if (FlxG.keys.Q)
					{
						currentMenu = menus["MoveMiner"];
					}
					else if (FlxG.keys.W)
					{
						currentMenu = menus["MoveAttacker"];
					}
					else if (FlxG.keys.A)
					{
						currentMenu = menus["BuyMiner"];
						
						currentMenu.menuText2.text = "0g";
					}
					else if (FlxG.keys.S)
					{
						currentMenu = menus["BuyAttacker"];
						currentMenu.menuText2.text = "0g";
					}
					updateMenuPosition();
					currentMenu.menuText.text = "0";
					currentMenu.show();
				}
				else if (currentMenu != null)
				{
					currentMenu.hide();
				}
				
			}
			else
			{
				updateMenuPosition();
			}
		}
		
		public function updateMenuPosition():void
		{
			currentMenu.x = FlxG.mouse.x + 20;
			currentMenu.y = FlxG.mouse.y;
			currentMenu.menuText.x = FlxG.mouse.x + 22;
			currentMenu.menuText.y = FlxG.mouse.y;
			if (currentMenu is BuyMenu)
			{
				currentMenu.menuText2.x = FlxG.mouse.x + 28;
				currentMenu.menuText2.y = FlxG.mouse.y + 8;
			}
		}
		public function hideCurrentMenu():void
		{
			currentMenu.hide();
			wantToBuy = 0;
			if (currentPlanet != null)
			{
				currentPlanet.shipsSelected = 0;
				currentPlanet = null;
			}
			selecting = false;
		}
		public function handleMouseOverPlanet(planet:Planet):void
		{
			if (currentPlanet != null)
			{
				if (planet == currentPlanet && wantToBuy>0)
				{
					FlxG.mouse.load(Cursor.dollarCursor);
				}
				else if (planet != currentPlanet && currentPlanet.shipsSelected > 0)
				{
					if (currentMenu.shipClass == MinerShip && planet is GoldPlanet && GoldPlanet(planet).goldLeft>0)
					{
						FlxG.mouse.load(Cursor.mineCursor);
					}
					else
					{
						FlxG.mouse.load(Cursor.moveCursor);
					}
				}
				else
				{
					FlxG.mouse.load(Cursor.normalCursor);
				}
			}
			drawPlanetInfo(planet);
		}
		public function handlePlanetPress(planet:Planet, humanPlayer:Player, shipManager:ShipManager):void
		{
			if (currentPlanet == null && (FlxG.keys.Q || FlxG.keys.W || FlxG.keys.A || FlxG.keys.S))
			{
				currentPlanet = planet;
			}
			if (planet == currentPlanet)
			{
				//Ships selected gets incremented
				if (currentMenu is MoveMenu && planet.getNumberOfShipsOfTypeOwnedByPlayer(humanPlayer, currentMenu.shipClass) > (planet.shipsSelected ))
				{
					selecting = true;
					planet.shipsSelected++;
					currentMenu.menuText.text = planet.shipsSelected.toString();
				}
				//Checks if the player is trying to buy more ships
				else if (currentMenu is BuyMenu && 
					((currentMenu.shipClass == MinerShip && FlxG.keys.A) || 
					(currentMenu.shipClass == AttackerShip && FlxG.keys.S)))
				{
					if (humanPlayer.gold >= BuyMenu(currentMenu).cost * (wantToBuy + 1))
					{
						wantToBuy++;
						selecting = true;
						currentMenu.menuText.text = wantToBuy.toString();
						currentMenu.menuText2.text = wantToBuy * BuyMenu(currentMenu).cost + "g";
					}
				}
				//The player clicked the planet is now buying the ships
				else if (wantToBuy > 0)
				{
					humanPlayer.gold -= wantToBuy * BuyMenu(currentMenu).cost;
					shipManager.addShips(currentPlanet, wantToBuy, humanPlayer, currentMenu.shipClass);
					currentMenu.menuText.text = "";
					currentMenu.menuText2.text = "";
					currentMenu.hide();
					currentPlanet = null;
					selecting = false;
					wantToBuy = 0;
				}
			}
			else if(currentPlanet != null)
			{
				if (currentPlanet.shipsSelected > 0)
				{
					currentPlanet.sendShipsOfType(planet, humanPlayer, currentMenu.shipClass);
					currentMenu.menuText.text = "";
					currentMenu.menuText2.text = "";
					currentMenu.hide();
					selecting = false;
					currentPlanet = null;
				}
				else if (currentPlanet.shipsSelected == 0 && wantToBuy == 0)
				{
					currentPlanet = null;
					selecting = false;
				}
			}
		}
		private function drawPlanetInfo(planet:Planet):void
		{
			if (planetInfoPlanet != planet)
			{
				planetInfoText["Name"].exists = true;
				planetInfoText["Owner"].exists = true;
				planetInfoText["Type"].exists = true;
				planetInfoText["Ships"].exists = true;
				
				planetInfoText["Name"].text = "Name: HELLO";
				if (planet.owner == null)
				{
					planetInfoText["Owner"].text = "Owner: None";
				}
				else
				{
					planetInfoText["Owner"].text = "Owner: "+planet.owner;
				}
				planetInfoText["Type"].text = "Type: " + planet.type;
				planetInfoText["Ships"].text = "Ships: " + planet.ownedShips.length;
				ownedShipsShown = planet.ownedShips.length;
				planetInfoPlanet = planet;
			}
			else if (ownedShipsShown != planet.ownedShips.length)
			{
				planetInfoText["Ships"].text = "Ships: " + planet.ownedShips.length;
			}
		}
	}

}