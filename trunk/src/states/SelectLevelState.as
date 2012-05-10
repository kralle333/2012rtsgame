package states
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import gameclasses.Player;
	import levels.*;
	import org.flixel.*;
	
	public class SelectLevelState extends FlxState
	{
		private var levelsDict:Dictionary = new Dictionary();
		private var xPos:int = 30;
		public function SelectLevelState()
		{
			add(new FlxText(30, 30, 400, "Select Level"));
			levelsDict[0] = new FlxButton(xPos, 60, "Level 1", clickedZero)
			add(levelsDict[0]);
			levelsDict[1] = new FlxButton(xPos, 80, "Level 2", clickedOne)
			add(levelsDict[1]);
			levelsDict[2] = new FlxButton(xPos, 100, "Level 3", clickedTwo)
			add(levelsDict[2]);
		}
		
		private function clickedZero():void
		{
			var lls:LoadLevelState = new LoadLevelState();
			FlxG.switchState(lls);
			lls.setCurrentLevel(new Level1());
		}
		
		private function clickedOne():void
		{
			var lls:LoadLevelState = new LoadLevelState();
			FlxG.switchState(lls);
			lls.setCurrentLevel(new Level2());
		}
		private function clickedTwo():void
		{
			var lls:LoadLevelState = new LoadLevelState();
			FlxG.switchState(lls);
			lls.setCurrentLevel(new Level3());
		}

	}

}