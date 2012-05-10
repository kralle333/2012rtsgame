package states
{
	import levels.Level1;
	import org.flixel.*;
	
	public class MainMenuState extends FlxState
	{
		private var selectLevelButton:FlxButton;
		private var startButton:FlxButton;
		private var title:FlxText = new FlxText(200, 30, 500, "The Lump World");
		
		public function MainMenuState()
		{
			startButton = new FlxButton(320, 450, "Start Game", startClicked);
			selectLevelButton = new FlxButton(320, 500, "Select Level", selectClicked);
			add(title);
			add(startButton);
			add(selectLevelButton);
			title.size = 100;
		
		}
		
		private function startClicked():void
		{
			var lls:LoadLevelState = new LoadLevelState();
			FlxG.switchState(lls);
			lls.setCurrentLevel(new Level1());
		}
		
		private function selectClicked():void
		{
			FlxG.switchState(new SelectLevelState());
		}
	}

}