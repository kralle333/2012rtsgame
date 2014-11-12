package gameclasses.menu.building
{
	import adobe.utils.CustomActions;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Dictionary;
	import gameclasses.planets.Planet;
	import levels.*
	import gameclasses.ships.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	public class BuildMenuManager
	{
		private var currentLevel:Level;
		private var currentPlanet:Planet;
		private var currentIcons:Array = new Array();
		private var currentType:String = "";
		private var position:FlxPoint = new FlxPoint(FlxG.width - 170, FlxG.height - 110);
		
		public var hqIcon:BuildOption;
		public var factoryIcons:FlxGroup = new FlxGroup();
		public var colonizingIcons:FlxGroup = new FlxGroup();
		public var buildTimerBar:FlxBar = new FlxBar(FlxG.width - 140, FlxG.height - 20, FlxBar.FILL_RIGHT_TO_LEFT, 120, 10);
		
		public var buildIcons:FlxGroup = new FlxGroup();
		private var buildingProgress:Array = new Array();
		
		//Factory
		[Embed(source='../../../../assets/buildoptions/minerShip.png')]
		private var minerIconTexture:Class;
		[Embed(source='../../../../assets/buildoptions/attackerShip.png')]
		private var attackerIconTexture:Class;
		[Embed(source='../../../../assets/buildoptions/colonizerShip.png')]
		private var colonizerIconTexture:Class;
		
		//Colonizing
		[Embed(source='../../../../assets/buildoptions/colonizingFactory.png')]
		private var factoryIconTexture:Class;
		
		public function BuildMenuManager(level:Level)
		{
			currentLevel = level;
			factoryIcons.add(new BuildShipOption(MinerShip, position.x, position.y, minerIconTexture));
			factoryIcons.add(new BuildShipOption(AttackerShip, position.x + 30, position.y, attackerIconTexture));
			factoryIcons.add(new BuildShipOption(ColonizerShip, position.x + 60, position.y, colonizerIconTexture));
			for (var i:int = 0; i < factoryIcons.length; i++)
			{
				factoryIcons.members[i].scrollFactor.x = factoryIcons.members[i].scrollFactor.y = 0;
			}
			hqIcon = new BuildShipOption(ColonizerShip, position.x, position.y, colonizerIconTexture);
			hqIcon.scrollFactor.x = hqIcon.scrollFactor.y = 0;
			colonizingIcons.add((new ColonizePlanetOption(position.x, position.y, factoryIconTexture, "Factory")));
			for (var j:int = 0; j < colonizingIcons.length; j++)
			{
				colonizingIcons.members[j].scrollFactor.x = factoryIcons.members[j].scrollFactor.y = 0;
			}
			buildTimerBar.exists = false;
			buildTimerBar.scrollFactor.x = buildTimerBar.scrollFactor.y = 0;
			
			for (var k:int = 0; k < 15; k += 3)
			{
				buildIcons.add(new BuildShipOption(MinerShip, position.x, position.y + 40, minerIconTexture));
				buildIcons.add(new BuildShipOption(AttackerShip, position.x + 30, position.y + 40, attackerIconTexture));
				buildIcons.add(new BuildShipOption(ColonizerShip, position.x + 60, position.y + 40, colonizerIconTexture));
				buildIcons.members[k].exists = false;
				buildIcons.members[k].scrollFactor.x = buildIcons.members[k].scrollFactor.y = 0;
				buildIcons.members[k + 1].exists = false;
				buildIcons.members[k + 1].scrollFactor.x = buildIcons.members[k + 1].scrollFactor.y = 0;
				buildIcons.members[k + 2].exists = false;
				buildIcons.members[k + 2].scrollFactor.x = buildIcons.members[k + 2].scrollFactor.y = 0;
			}
		}
		
		public function returnIconsAsFlxGroup():FlxGroup
		{
			return buildIcons;
		}
		
		public function update():void
		{
			if (FlxG.mouse.justPressed())
			{
				for (var i:int = 0; i < factoryIcons.length; i++)
				{
					if (factoryIcons.members[i].mouseOver)
					{
						iconPressed(factoryIcons.members[i]);
					}
				}
				if (hqIcon.mouseOver)
				{
					iconPressed(hqIcon);
				}
				for (var j:int = 0; j < buildingProgress.length; j++)
				{
					if (buildingProgress[j].mouseOver)
					{
						removeBuiltItem(j,true);
					}
				}
			}
			if (currentPlanet != null && (currentPlanet.type == "Factory" || currentPlanet.type == "HQ") && currentPlanet.productionQueue.buildStatus() > -1)
			{
				buildTimerBar.currentValue = currentPlanet.productionQueue.buildStatus();
			}
			else
			{
				buildTimerBar.exists = false;
			}
			if (currentPlanet != null && currentPlanet.productionQueue.shipJustBuild)
			{
				removeBuiltItem();
				currentPlanet.productionQueue.shipJustBuild = false;
			}
		}
		
		public function iconPressed(buildOption:BuildOption):void
		{
			if (buildOption is BuildShipOption && currentPlanet.productionQueue.buildItems.length < 5)
			{
				currentPlanet.productionQueue.pushShip(BuildShipOption(buildOption).shipType);
				buildTimerBar.exists = true;
				buildTimerBar.currentValue = currentPlanet.productionQueue.buildStatus();
				buildingProgress.push(getIconOfRightType(BuildShipOption(buildOption).shipType));
				if (buildingProgress.length > 1)
				{
					buildingProgress[buildingProgress.length - 1].exists = true;
				}
				if (buildingProgress.length == 1)
				{
					buildingProgress[0].x = position.x;
					buildingProgress[0].y = position.y + 80;
				}
				else
				{
					buildingProgress[buildingProgress.length - 1].x = position.x + (buildingProgress.length - 2) * 30;
					buildingProgress[buildingProgress.length - 1].y = position.y+ 50;
				}
			}
			else if (buildOption is ColonizePlanetOption)
			{
				
			}
		}
		
		private function getIconOfRightType(shipType:Class):BuildShipOption
		{
			if (shipType == MinerShip)
			{
				for (var i:int = 0; i < 5; i++)
				{
					if (!buildIcons.members[i * 3].exists)
					{
						buildIcons.members[i * 3].exists = true;
						return buildIcons.members[i * 3];
					}
				}
				
			}
			else if (shipType == AttackerShip)
			{
				for (var j:int = 0; j < 5; j++)
				{
					if (!buildIcons.members[j * 3 + 1].exists)
					{
						buildIcons.members[j * 3+1].exists = true;
						return buildIcons.members[j * 3 + 1];
					}
				}
			}
			else if (shipType == ColonizerShip)
			{
				for (var k:int = 0; k < 5; k++)
				{
					if (!buildIcons.members[k * 3 + 2].exists)
					{
						buildIcons.members[k * 3+2].exists = true;
						return buildIcons.members[k * 3 + 2];
					}
				}
			}
			return null;
		}
		private function removeBuiltItem(item:int=0,clicked:Boolean = false):void
		{
			buildingProgress[item].exists = false;
			buildingProgress[item].mouseOver = false;
			buildingProgress.splice(item, 1);
			if (buildingProgress.length > 0)
			{
				buildingProgress[0].x = position.x;
				buildingProgress[0].y = position.y + 80;
				for (var i:int = buildingProgress.length - 1; i > 0; i--)
				{
					buildingProgress[i].x = position.x + (i - 1) * 30;
					buildingProgress[i].y = position.y + 50;
				}
			}
			if (clicked)
			{
				currentPlanet.productionQueue.removeItem(item);
			}
		}
		public function handlePlanetPress(planet:Planet):void
		{
			if (planet != currentPlanet && planet.owner == currentLevel.humanPlayer)
			{
				if (planet.type == "Factory" && currentType != "Factory")
				{
					hideMenu();
					currentType = "Factory";
					showMenu();
					if (planet.productionQueue.buildStatus() > -1)
					{
						buildTimerBar.exists = true;
						buildTimerBar.currentValue = planet.productionQueue.buildStatus();
						showBuildItems();
					}
					else
					{
						buildTimerBar.exists = false;
					}
					
				}
				else if (planet.type == "HQ" && currentType != "HQ")
				{
					hideMenu();
					currentType = "HQ";
					hqIcon.exists = true;
					if (planet.productionQueue.buildStatus() > -1)
					{
						buildTimerBar.exists = true;
						buildTimerBar.currentValue = planet.productionQueue.buildStatus();
						showBuildItems();
					}
					else
					{
						buildTimerBar.exists = false;
					}
					
				}
				else if (planet.ownsShipOfType(currentLevel.humanPlayer, ColonizerShip) && currentType != "Colonizing")
				{
					hideMenu();
					currentType = "Colonizing";
					showMenu();
					buildTimerBar.exists = true;
					buildTimerBar.currentValue = planet.productionQueue.buildStatus();
					showBuildItems();
				}
				else
				{
					hideMenu();
					hideBuildItems();
					currentType = "";
					buildTimerBar.exists = false;
				}
			}
			else if (planet.owner != currentLevel.humanPlayer)
			{
				hideMenu();
				hideBuildItems();
				currentType = "";
				buildTimerBar.exists = false;
			}
			currentPlanet = planet;
		}
		
		private function showBuildItems():void
		{
			for (var j:int = 0; j < currentPlanet.productionQueue.buildItems.length; j++) 
			{
				buildingProgress[j] = getIconOfRightType(currentPlanet.productionQueue.buildItems[j]);
			}
			buildingProgress[0].exists = true;
			buildingProgress[0].x = position.x;
			buildingProgress[0].y = position.y + 80;
			for (var i:int = buildingProgress.length - 1; i > 0; i--)
			{
				buildingProgress[i].exists = true;
				buildingProgress[i].x = position.x + (i - 1) * 30;
				buildingProgress[i].y = position.y + 50;
			}
		}
		
		private function hideBuildItems():void
		{
			for (var i:int = 0; buildingProgress.length > i; i++)
			{
				buildingProgress[i].exists = false;
			}
		}
		
		private function showMenu():void
		{
			if (currentType == "Factory")
			{
				for (var i:int = 0; i < factoryIcons.length; i++)
				{
					factoryIcons.members[i].exists = true;
				}
			}
			else if (currentType == "Colonizing")
			{
				for (var j:int = 0; j < colonizingIcons.length; j++)
				{
					colonizingIcons.members[j].exists = true;
				}
			}
		}
		
		private function hideMenu():void
		{
			if (currentType == "Factory")
			{
				for (var i:int = 0; i < factoryIcons.length; i++)
				{
					factoryIcons.members[i].exists = false;
				}
			}
			else if (currentType == "Colonizing")
			{
				for (var j:int = 0; i < colonizingIcons.length; j++)
				{
					colonizingIcons.members[j].exists = false;
				}
			}
		}
	}

}