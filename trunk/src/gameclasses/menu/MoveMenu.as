package gameclasses.menu 
{

	public class MoveMenu extends Menu
	{
		
		public function MoveMenu(shipType:String,shipClass:Class) 
		{
			super(shipType, "Move");
			this.shipClass = shipClass;
		}
		
	}

}