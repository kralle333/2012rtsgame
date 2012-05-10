package gameclasses.menu
{
	import org.flixel.FlxSprite;
	import flash.display.Sprite;
	import org.flixel.FlxText;
	
	public class Menu extends FlxSprite
	{
		public var type:String;
		
		[Embed(source='../../../assets/icons/attackerShip.png')]
		private var attackerIconTexture:Class;
		[Embed(source='../../../assets/icons/minerShip.png')]
		private var minerIconTexture:Class;
		
		[Embed(source='../../../assets/icons/buyAttackShip.png')]
		private var buyAttackerIconTexture:Class;
		[Embed(source='../../../assets/icons/buyMinerShip.png')]
		private var buyMinerIconTexture:Class;
		
		public var menuText:FlxText;
		public var menuText2:FlxText;
		
		public var shipClass:Class
		
		public function Menu(shipType:String, menuType:String)
		{
			type = shipType;
			var chosenType:Class;
			if (menuType == "Move")
			{
				if (type == "Miner")
				{
					chosenType=minerIconTexture;
				}
				else if (type == "Attacker")
				{
					chosenType=attackerIconTexture;	
				}
			}
			else if (menuType == "Buy")
			{
				if (type == "Miner")
				{
					chosenType=buyMinerIconTexture;
				}
				else if (type == "Attacker")
				{
					chosenType=buyAttackerIconTexture;
				}
			}
			super(0, 0, chosenType);
			menuText = new FlxText(0, 0,400,"");
			menuText2 = new FlxText(0, 0, 400, "");
			menuText.exists = false;
			menuText2.exists = false;
			exists = false;		
		}
		public function show():void
		{
			exists = true;
			menuText.exists = true;
			menuText2.exists = true;
		}
		public function hide():void
		{
			exists = false;
			menuText.exists = false;
			menuText2.exists = false;
		}
	}
}