package gameclasses.ships
{
	import misc.ShipMath;
	import org.flixel.*;
	import gameclasses.ships.*;
	import gameclasses.*;
	import gameclasses.planets.*;
	import gameclasses.players.*;
	import org.flixel.plugin.photonstorm.*;
	public class ShipManager extends FlxGroup
	{
		public var bullets:FlxGroup = new FlxGroup();
		public var planets:Array = new Array();
		public function ShipManager(shipsCreated:int,planets:Array)
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
			for (var j:int = 0; j < 200; j++) 
			{
				bullets.add(new Bullet());
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
				s.color = 0xFFFFFF;
				s.changeColor(owner.color);
				owner.onBuild(s);
				owner.ownedPlanets.add(planet);
			}
			ShipMath.ships = members;
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
						if (members[i].enemy != null)
						{
							shootBullet(members[i],members[i].enemy);
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
			var distance:int = 3000;
			for (var i:int = 0; i < length; i++) 
			{
				if (members[i].owner != ship.owner)
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
		private function allyNear(ship:Ship):Ship
		{
			var ally:Ship;
			var distance:int = 3000;
			for (var i:int = 0; i < length; i++) 
			{
				if (members[i].owner == ship.owner)
				{
					var allyDistance:int = FlxMath.vectorLength(members[i].x - ship.x, members[i].y - ship.y);
					if (allyDistance<distance)
					{
						ally = members[i];
						distance = allyDistance;
					}
				}
			}
			if (ally != null)
			{
				ship.ally = ally;
				return ally;
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
				ship.justShot();
			}
		}
	}

}