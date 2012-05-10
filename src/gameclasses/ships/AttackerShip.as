package gameclasses.ships
{
	import org.flixel.*;
	import gameclasses.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class AttackerShip extends Ship
	{
		
		[Embed(source='../../../assets/ships/attackerShip.png')]
		private var texture:Class;
		
		private var heightTimer:FlxTimer = new FlxTimer();
		
		public var enemyNear:Boolean;
		
		public function AttackerShip()
		{
			super(texture,10);
			health = 10;
			speed = 0.015;
			heightTimer.finished = true;
			flyingDistance = 40;
			cost = 20;
			buildTime = 20;
		}
		override public function update():void 
		{
			moveShip();
			super.update();
		
		}
		override public function changeColor(changeColor:uint):void 
		{
			super.changeColor(changeColor);
		}
		private function moveShip():void
		{
			if (!enemyNear && heightTimer.finished)
			{
				shipHeight += Math.random()*2- 1;
				if (shipHeight < -5)
				{
					shipHeight = -5;
				}
				else if (shipHeight > 10)
				{
					shipHeight = 10;
				}
				heightTimer.start(Math.random());
			}
			else if (enemyNear)
			{
				
			}
			
		}
	}

}