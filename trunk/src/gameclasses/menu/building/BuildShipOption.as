package gameclasses.menu.building 
{
	import gameclasses.ships.Ship;

	public class BuildShipOption extends BuildOption
	{
		private var cost:int = 0;
		public var shipType:Class;
		
		public function BuildShipOption(shipType:Class,x:int,y:int,texture:Class) 
		{
			this.shipType = shipType;
			super(x, y, texture);
		}

	}

}