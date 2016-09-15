package states 
{
	import levels.Level;
	import levels.LevelManager;
	import org.flixel.*;

	public class ScoreScreenState extends FlxState
	{
		private var wonText:FlxText = new FlxText(30, 30, FlxG.width, "Level completed!\n\nClick to continue");
		private var showWonText:Boolean = false;
		private var level:Level;
		private var levelManager:LevelManager;
		public function ScoreScreenState(level:Level)
		{
			this.level = level;
			levelManager = new LevelManager();
		}
		override public function create():void 
		{
			super.create();
			add(wonText);
			wonText.size = 60;
			wonText.exists = false;
		}
		override public function update():void 
		{
			super.update();
			showWonText = true;
			wonText.exists = true;
			if (FlxG.mouse.justPressed())
			{
				var lls:LoadLevelState = new LoadLevelState();
				FlxG.switchState(lls);
				lls.setCurrentLevel(levelManager.giveNextLevel(level));
			}
		}
		
	}

}