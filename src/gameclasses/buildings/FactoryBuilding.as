package gameclasses.buildings 
{

	public class FactoryBuilding extends Building
	{
		[Embed(source='../../../assets/buildings/factory.png')]
		private var texture:Class;
		
		public function FactoryBuilding(x:int,y:int) 
		{
			this.x = x;
			this.y = y;
			loadGraphic(texture, true, false, 32, 32);
			addAnimation("Play", [0,1,2], 2, true);
			play("Play");
		}
		
	}

}