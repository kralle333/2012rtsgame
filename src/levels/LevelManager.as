package levels
{
	
	public class LevelManager
	{
		
		public function LevelManager()
		{
			
		}
		
		public function giveNextLevel(level:Level):Level
		{
			if (level is Level1)
			{
				return new Level2();
			}
			else if (level is Level2)
			{
				return new Level3();
			}
			return null;
		}
	}

}