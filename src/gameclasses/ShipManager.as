package gameclasses
{
	import org.flixel.*;
	import gameclasses.ships.*;
	import gameclasses.*;
	import gameclasses.planets.*;
	import org.flixel.plugin.photonstorm.*;
	public class ShipManager extends FlxGroup
	{
		public var bullets:FlxGroup = new FlxGroup();
		public function ShipManager(shipsCreated:int)
		{
			for (var i:int = 0; i < shipsCreated/3; i++)
			{
				var a:AttackerShip = new AttackerShip();
				add(a);
				a.exists = false;
				
				var m:MinerShip = new MinerShip();
				add(m);
				m.exists = false;
				
				var c:ColonizerShip = new ColonizerShip();
				add(c);
				c.exists = false;
			}
		}
		
		public function addShips(planet:Planet, amount:int,owner:Player,type:Class):void
		{
			for (var i:int = 0; i < amount; i++)
			{	
				var s:Ship = Ship(getFirstAvailable(type));
				s.exists = true;
				s.planet = planet;
				s.owner = owner;
				planet.getShip(s);
				s.angleToPlanet = Math.random() * Math.PI * 2;
				s.changeColor(owner.color);
				owner.onBuild(s);
				owner.ownedPlanets.add(planet);
			}
		}
		override public function update():void 
		{
			super.update();
			for (var i:int = 0; i < length; i++) 
			{
				if (members[i].exists && members[i].planet != null)
				{
					if (members[i] is AttackerShip && members[i].canShoot == true)
					{
						var enemy:Ship = enemyNear(members[i]);
						if (enemy != null)
						{
							shootBullet(members[i], enemy);
						}
					}
				}
			}
			FlxG.overlap(bullets, this, bulletCollision);
		}
		
		private function bulletCollision(bullet:FlxObject, ship:FlxObject):void
		{
			if (Bullet(bullet).exists && Bullet(bullet).owner.owner != Ship(ship).owner)
			{
				Ship(ship).damage(1);
				Bullet(bullet).exists = false;
			}
		}
		private function enemyNear(ship:Ship):Ship
		{
			var enemy:Ship;
			var distance:int = 1000;
			for (var i:int = 0; i < length; i++) 
			{
				if (members[i].color != ship.color)
				{
					var enemyDistance:int = FlxMath.vectorLength(members[i].x - ship.x, members[i].y - ship.y);
					if (enemyDistance<distance)
					{
						enemy = members[i];
						distance = enemyDistance;
					}
				}
			}
			if (enemy != null)
			{
				ship.enemy = enemy;
				return enemy;
			}
			return null;
		}
		
		private function shootBullet(ship:Ship, enemyShip:Ship):void
		{
			var bullet:Bullet = Bullet(bullets.getFirstAvailable());
			if (bullet != null)
			{
				bullet.owner = ship;
				bullet.shoot(ship.x, ship.y, Math.PI+Math.atan2(ship.y - enemyShip.y, ship.x - enemyShip.x));
				bullet.exists = true;
				ship.justShot();
			}
		}
	}

}