package states
{
	import misc.Cursor;
	import org.flixel.*;
	[SWF(width="800", height="600", backgroundColor="#386860")]
	public class Main extends FlxGame
	{
		public function Main()
		{
			super(800, 600, IntroState, 1); 
			FlxG.mouse.load(Cursor.normalCursor);
		}
	}
}