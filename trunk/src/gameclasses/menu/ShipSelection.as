package gameclasses.menu
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import gameclasses.FlyRouting;
	import gameclasses.planets.Planet;
	import gameclasses.ships.AttackerShip;
	import gameclasses.ships.ColonizerShip;
	import gameclasses.ships.MinerShip;
	import gameclasses.ships.Ship;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.*;
	
	public class ShipSelection
	{
		private var ships:Array = new Array();
		public var healthBars:FlxGroup = new FlxGroup();
		public var shipsSelectionBoxes:FlxGroup = new FlxGroup();
		public var buttons:Dictionary = new Dictionary();
		private var currentButton:int = 1;
		public var shipIcons:FlxGroup = new FlxGroup();
		
		public var flyRouting:FlyRouting = new FlyRouting();
		
		private var position:FlxPoint;
		
		[Embed(source='../../../assets/buildoptions/minerShip.png')]
		private var minerTexture:Class;
		[Embed(source='../../../assets/buildoptions/colonizerShip.png')]
		private var colonizerTexture:Class;
		[Embed(source='../../../assets/buildoptions/attackerShip.png')]
		private var attackerTexture:Class;
		
		public function ShipSelection(position:FlxPoint)
		{
			this.position = position;
			buttons[1] = new FlxButtonPlus(position.x + 180, position.y, onClick, [1], "1", 15, 20);
			buttons[2] = new FlxButtonPlus(position.x + 180, position.y + 26, onClick, [2], "2", 15, 20);
			buttons[3] = new FlxButtonPlus(position.x + 180, position.y + 52, onClick, [3], "3", 15, 20);
		}
		
		public function show(shipsToAdd:Array):void
		{
			for (var i:int = 0; i < shipsToAdd.length; i++)
			{
				addShip(shipsToAdd[i]);
			}
			flyRouting.exists = true;
			buttons[1].exists = true;
			buttons[2].exists = true;
			buttons[3].exists = true;
		}
		
		public function hide():void
		{
			flyRouting.hide();
			for (var i:int = 0; i < shipIcons.length; i++)
			{
				shipIcons.members[i].exists = false;
				healthBars.members[i].exists = false;
				shipsSelectionBoxes.members[i].exists = false;
			}
			buttons[1].exists = false;
			buttons[2].exists = false;
			buttons[3].exists = false;
			currentButton = 1;
			ships = new Array();
		}
		
		public function addShip(ship:Ship):void
		{
			if (ships.indexOf(ship) == -1)
			{
				ships.push(ship);
				flyRouting.addShip(ship);
				var selectionBox:FlxSprite = FlxSprite(shipsSelectionBoxes.getFirstAvailable());
				if (selectionBox == null)
				{
					shipsSelectionBoxes.add(new FlxSprite(ship.x, ship.y).makeGraphic(ship.width, ship.height, 0x0, true));
					selectionBox = shipsSelectionBoxes.members[shipsSelectionBoxes.length - 1];
					var rect:Shape = new Shape();
					rect.graphics.lineStyle(0, 0x00ff00);
					rect.graphics.beginFill(0x00ff00, 1);
					rect.graphics.drawRect(0, 0, ship.width, ship.height);
					rect.graphics.drawRect(0, 0, ship.width - 1, ship.height - 1);
					rect.graphics.endFill();
					var bitmapData:BitmapData = new BitmapData(ship.width, ship.height, true, 0x00FFffFF);
					bitmapData.draw(rect);
					var overlay:FlxSprite = new FlxSprite().makeGraphic(ship.width, ship.height);
					overlay.pixels = bitmapData;
					selectionBox.stamp(overlay);
				}
				selectionBox.exists = true;
				
				var icon:FlxButton = FlxButton(shipIcons.getFirstAvailable());
				if (icon == null)
				{
					shipIcons.add(new FlxButton(position.x + 26 * (shipIcons.length % 5), position.y + 26 * Math.floor(shipIcons.length / 5)));
					icon = shipIcons.members[shipIcons.length - 1];
				}
				icon.loadGraphic(getRightTexture(ship));
				icon.scrollFactor.x = icon.scrollFactor.y = 0;
				icon.exists = true;
				var healthBar:FlxBar = FlxBar(healthBars.getFirstAvailable());
				if (healthBar == null)
				{
					healthBars.add(new FlxBar(1 + position.x + 26 * (healthBars.length % 5), 1 + position.y + 26 * Math.floor(healthBars.length / 5), FlxBar.FILL_LEFT_TO_RIGHT, 22, 2, ship, "health", 0, ship.initHealth, false));
					healthBar = healthBars.members[healthBars.length - 1];
				}
				healthBar.scrollFactor.x = healthBar.scrollFactor.y = 0;
				healthBar.setParent(ship, "health");
				healthBar.setRange(0, ship.initHealth);
				healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
				healthBar.exists = true;
			}
		}
		
		public function update():void
		{
			flyRouting.update();
			for (var i:int = 0; i < ships.length; i++)
			{
				shipsSelectionBoxes.members[i].x = ships[i].x;
				shipsSelectionBoxes.members[i].y = ships[i].y;
			}
			if (FlxG.mouse.justPressed())
			{
				var shipRemoved:Boolean = false;
				for (var j:int = 0; j < shipIcons.length; j++)
				{
					if (shipIcons.members[j].exists)
					{
						if (shipIcons.members[j].overlapsPoint(new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY), true) && !shipRemoved)
						{						
							ships.splice(j, 1);
							shipRemoved = true;
						}
						if (shipRemoved && j < shipIcons.length - 1)
						{
							shipIcons.members[j] = shipIcons.members[j + 1];
							healthBars.members[j] = healthBars.members[j + 1];
							shipsSelectionBoxes.members[j]= shipsSelectionBoxes.members[j + 1];
						}
						else if (shipRemoved && j == shipIcons.length - 1)
						{
							removeShip(ships[j]);
						}
					}
				}
			}
		}
		
		public function removeShip(ship:Ship):void
		{
			if (ships.indexOf(ship) == -1)
			{
				trace("Possible Error in ShipSelection - removeShip");
			}
			shipIcons.members.splice(ships.indexOf(ship), 1);
			healthBars.members.splice(ships.indexOf(ship), 1);
			shipsSelectionBoxes.members.splice(ships.indexOf(ship), 1);
			ships.splice(ship, 1);
		
		}
		
		private function onClick(type:int):void
		{
			var buttonPressed:int = type;
			if (buttonPressed != currentButton && ships.length > 15 * (buttonPressed - 1) + 1)
			{
				showOtherGroup(buttonPressed);
			}
		}
		
		private function showOtherGroup(type:int):void
		{
			for (var i:int = currentButton - 1 * 15; i < currentButton * 15; i++)
			{
				shipIcons.members[i].exists = false;
				healthBars.members[j].exists = false;
			}
			currentButton = type;
			for (var j:int = currentButton - 1 * 15; j < currentButton * 15 - (currentButton * 15 - ships.length); j++)
			{
				shipIcons.members[j].exists = true;
				healthBars.members[j].value = ships[j].health;
			}
		}
		
		private function getRightTexture(shipType:Ship):Class
		{
			if (shipType is MinerShip)
			{
				return minerTexture;
			}
			else if (shipType is AttackerShip)
			{
				return attackerTexture;
			}
			else if (shipType is ColonizerShip)
			{
				return colonizerTexture;
			}
			return null;
		}
	}

}