package gameclasses.buildmenu 
{
	import org.flixel.*;

	public class BuildOption extends FlxButton
	{
		protected var parent:BuildMenu;
		public function BuildOption(x:int,y:int,texture:Class) 
		{
			this.parent = parent;
			super(x, y, null, onClick, onOver, onOut);
			loadGraphic(texture);
		}
		
		private function onOver():void
		{
			color = 0xFF00FF;
		}
		private function onOut():void
		{
			color = 0xFFFFFF;
		}
		protected function onClick():void
		{
			
		}
	}

}