package gameclasses.menu.building 
{
	import org.flixel.*;

	public class BuildOption extends FlxButton
	{
		public var mouseOver:Boolean = false;
		public function BuildOption(x:int,y:int,texture:Class) 
		{
			super(x, y, null, null, onOver, onOut);
			loadGraphic(texture);
			exists = false;
		}
		
		private function onOver():void
		{
			color = 0xFF00FF;
			mouseOver = true;
		}
		private function onOut():void
		{
			color = 0xFFFFFF;
			mouseOver = false;
		}
	}

}