package gameclasses.ships 
{
	import gameclasses.Player;
	import org.flixel.FlxSprite;
	public class Bullet extends FlxSprite
	{
		[Embed(source='../../../assets/ships/bullet.png')]
		private var texture:Class;
		private var bulletSpeed:int = 30;
		public var owner:Ship;
		public function Bullet() 
		{
			super(0, 0, texture);
			exists = false;
		}
		
		public function shoot(startX:int, startY:int, angle:Number):void
		{
			color = owner.color;
			x = startX;
			y = startY;
			velocity.x = bulletSpeed * Math.cos(angle);
			velocity.y = bulletSpeed * Math.sin(angle);
			owner.angle = angle;
		}
	}

}