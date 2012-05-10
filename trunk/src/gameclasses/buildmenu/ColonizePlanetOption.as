package gameclasses.buildmenu 
{
	import gameclasses.planets.Planet;

	public class ColonizePlanetOption extends BuildOption
	{
		private var type:String = "";
		public function ColonizePlanetOption(x:int,y:int,texture:Class,parent:BuildMenu,type:String) 
		{
			super(x, y, texture);
			this.type = type;
		}
		override protected function onClick():void 
		{
			parent.setColonizingInProduction(type);
		}
	}

}