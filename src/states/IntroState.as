package states
{
	import org.flixel.*;
	
	public class IntroState extends FlxState
	{
		private var title1:FlxText;
		private var title2:FlxText;
		private var title3:FlxText;
		private var title4:FlxText;
		private var timer:FlxTimer;
		private var titlesShown:Boolean = false;
		private var frame:int = 0;
		private var speed:Number = 0.005;
		
		override public function create():void
		{
			super.create();
			FlxG.mouse.show();
			timer = new FlxTimer();
			title1 = new FlxText(20, 20, 1000, "In a far away universe....");
			title2 = new FlxText(20, 40, 1000, "\nNot exactly sure where it is,\nbut it was somewhere,");
			title3 = new FlxText(20, 150, 1000, "\nwell but in this universe they\nwould fight for lumps of gold,\nbecause the universe is tiny");
			title4 = new FlxText(20, 400, 1000, "We call this universe:\n\n        The Lump World");
			title1.size = 40;
			title1.alpha = 0;
			title2.size = 40;
			title2.alpha = 0;
			title2.color = 0xFF9F9F9F;
			title3.size = 40;
			title3.alpha = 0;
			title4.size = 40;
			title4.alpha = 0;
			title4.color = 0xFF9F9F9F;
			add(title1);
			add(title2);
			add(title3);
			add(title4);
			frame = 1;
		}
		
		override public function update():void
		{
			if (title1.alpha < 1)
			{
				title1.alpha += speed;
			}
			else if (title2.alpha < 1)
			{
				title2.alpha += speed;
			}
			else if (title3.alpha < 1)
			{
				title3.alpha += speed;
			}
			else if (title4.alpha < 1)
			{
				title4.alpha += speed;
			}
			if (FlxG.keys.ENTER || FlxG.keys.ESCAPE || FlxG.keys.SPACE || FlxG.mouse.justReleased())
			{
				FlxG.switchState(new MainMenuState());
			}
			super.update();
		}
	}

}