package gameclasses.menu 
{

	public class BuyMenu extends Menu
	{
		public var cost:int = 0;
		
		public function BuyMenu(shipType:String,cost:int,shipClass:Class) 
		{
			super(shipType, "Buy");
			this.cost = cost;
			this.shipClass = shipClass;
		}
		
	}

}