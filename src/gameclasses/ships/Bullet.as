package gameclasses.ships
{
	import gameclasses.players.*;
	import misc.ShipMath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	public class Bullet extends FlxSprite
	{
		[Embed(source='../../../assets/ships/bullet.png')]
		private var texture:Class;
		private var bulletSpeed:int = 50;
		public var owner:Ship;
		private var timer:FlxTimer = new FlxTimer();
		
		public function Bullet()
		{
			super(0, 0, texture);
			exists = false;
		}
		
		override public function update():void
		{
			super.update();
			if (timer.finished || (owner.currentPlanet != null &&  ShipMath.getDistanceToPlanetOrigin(new FlxPoint(x,y),owner.currentPlanet)> owner.currentPlanet.size-owner.currentPlanet.size/4))
			{
				exists = false;
			}
		}
		
		public function shoot(startX:int, startY:int, angle:Number):void
		{
			exists = true;
			color = owner.owner.color;
			x = startX;
			y = startY;
			velocity.x = bulletSpeed * Math.cos(angle);
			velocity.y = bulletSpeed * Math.sin(angle);
			owner.smoothChangeAngle = angle * (180 / Math.PI) - 90;
		}
	}

}