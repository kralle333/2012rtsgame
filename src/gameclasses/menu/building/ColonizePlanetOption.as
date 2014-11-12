package gameclasses.menu.building 
{
	import gameclasses.planets.Planet;

	public class ColonizePlanetOption extends BuildOption
	{
		private var type:String = "";
		public function ColonizePlanetOption(x:int,y:int,texture:Class,type:String) 
		{
			super(x, y, texture);
			this.type = type;
		}
	}

}