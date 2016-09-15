package gameclasses.ships 
{
	
	public class ColonizerShip extends Ship
	{
		[Embed(source='../../../assets/ships/colonizerShip.png')]
		private var texture:Class;
		static public var cost:int = 30;
		static public var buildTime:Number = 30;
		static public var name:String = "Builder";
		
		public function ColonizerShip() 
		{
			super(texture, 20);
			cost = 30;
			buildTime = 30;
		}
		override public function update():void 
		{
			super.update();
			circlePlanet();
		}
	}

}