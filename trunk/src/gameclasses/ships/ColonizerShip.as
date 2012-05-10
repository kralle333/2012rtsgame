package gameclasses.ships 
{
	
	public class ColonizerShip extends Ship
	{
		[Embed(source='../../../assets/ships/colonizerShip.png')]
		private var texture:Class;
		public function ColonizerShip() 
		{
			super(texture, 20);
			cost = 30;
			buildTime = 30;
		}
		
	}

}