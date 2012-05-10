package gameclasses.buildmenu
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import gameclasses.planets.Planet;
	import levels.*
	import gameclasses.ships.*;
	import org.flixel.FlxGroup;
	
	public class BuildMenuManager
	{
		private var currentLevel:Level;
		private var currentPlanet:Planet;
		private var currentIcons:Array = new Array();
		private var currentType:String = "";

		private var factoryIcons:FlxGroup = new FlxGroup();
		private var colonizingIcons:FlxGroup = new FlxGroup();
		
		//Factory
		[Embed(source='../../../assets/buildoptions/minerShip.png')]
		private var minerIconTexture:Class;
		[Embed(source='../../../assets/buildoptions/attackerShip.png')]
		private var attackerIconTexture:Class;
		[Embed(source='../../../assets/buildoptions/colonizerShip.png')]
		private var colonizerIconTexture:Class;
		
		//Colonizing
		[Embed(source='../../../assets/buildoptions/colonizingFactory.png')]
		private var factoryIconTexture:Class;
		
		public function BuildMenuManager(level:Level)
		{
			currentLevel = level;
			
			factoryIcons.add(new BuildShipOption(MinerShip,position.x, position.y, minerIconTexture,this));
			factoryIcons.add(new BuildShipOption(AttackerShip,position.x+30, position.y, attackerIconTexture,this));
			factoryIcons.add(new BuildShipOption(ColonizerShip, position.x + 60, position.y, colonizerIconTexture, this));
			
			colonizingIcons.add(options.add(new ColonizePlanetOption(position.x, position.y, factoryIconTexture, this, "Factory")));
		}
		public function returnSpritesAsFlxGroup():FlxGroup
		{
			var g:FlxGroup = new FlxGroup();
			g.members.push(factoryIcons.members);
			g.members.push(colonizingIcons.members);
			return g;
		}

		public function handlePlanetPress(planet:Planet)
		{
			if (planet != currentPlanet && planet.owner == currentLevel.humanPlayer)
			{
				if (planet.type == "Factory" && currentType != "Factory")
				{
					hideMenu(currentIcons);
					showMenu(factoryIcons);
					currentIcons = factoryIcons;
					currentType = "Factory";
				}
				else if (planet.ownsShipOfType(currentLevel.humanPlayer, ColonizerShip)&& currentType != "Colonizing")
				{
					hideMenu(currentIcons);
					showMenu(colonizingIcons);
					currentIcons = colonizingIcons;
					currentType = "Colonizing";
				}
				currentPlanet = planet;
			}
		}
		private function showMenu(array:Array):void
		{
			
		}
		private function hideMenu(array:Array):void
		{
			
		}
	}

}