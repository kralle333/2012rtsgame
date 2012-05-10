package gameclasses.buildmenu 
{
	import gameclasses.ships.Ship;

	public class BuildShipOption extends BuildOption
	{
		private var cost:int = 0;
		private var shipType:Class;
		public function BuildShipOption(shipType:Class,x:int,y:int,texture:Class,parent:BuildMenu) 
		{
			cost = Ship(shipType).cost;
			this.shipType = shipType;
			super(x, y, texture);
		}
		override protected function onClick():void 
		{
			if (parent.currentLevel.humanPlayer.gold > cost)
			{
				parent.setShipInProduction(shipType)
			}
		}
	}

}