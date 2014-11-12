package misc
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import gameclasses.planets.Planet;
	import gameclasses.players.*;
	import gameclasses.ships.Ship;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	public class FogOfWar extends FlxSprite
	{
		static private var ships:Array;
		static private var planets:Array;
		static private var humanPlayer:Player;
		private var eraser:Shape = new Shape();
		private var dimensions:FlxPoint;
		
		public function FogOfWar(humanPlayer:Player, dimensions:FlxPoint):void
		{
			//Remember to add in loadlevelstate
			//this.makeGraphic(dimensions.x, dimensions.y, 0xFF000000, true);
			this.dimensions = dimensions;
			ships = humanPlayer.ships.members;
			planets = humanPlayer.ownedPlanets.members;
			eraser.blendMode = BlendMode.ERASE;
			for (var i:int = 0; i < planets.length; i++) 
			{
				//drawLight(planets[i].x+planets[i].size/2, planets[i].y+planets[i].size/2, planets[i].size*2);
			}
			
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function drawLight(x:int, y:int, radius:int):void
		{
			eraser.graphics.beginFill(0xff000000);
			eraser.graphics.drawCircle(x, y, radius);
			eraser.graphics.endFill();
			this.pixels.draw(eraser, null, null, BlendMode.ERASE);
			dirty = true;
		}
		private function drawFog(x:int, y:int, radius:int):void
		{
			
		}
		private function circlePoints(cx:int, cy:int, x:int, y:int, pix:int):void
		{
			if (0 == x)
			{
				pixels.setPixel32(cx, cy + y,0xFFFFFFFF);
				pixels.setPixel32(cx, cy - y,0xFFFFFFFF);
				pixels.setPixel32(cx + y, cy,0xFFFFFFFF);
				pixels.setPixel32(cx - y, cy,0xFFFFFFFF);
			}
			else if (x == y)
			{
				pixels.setPixel32(cx + x, cy + y,0xFFFFFFFF);
				pixels.setPixel32(cx - x, cy + y,0xFFFFFFFF);
				pixels.setPixel32(cx + x, cy - y,0xFFFFFFFF);
				pixels.setPixel32(cx - x, cy - y,0xFFFFFFFF);
			}
			else if (x < y)
			{
				pixels.setPixel32(cx + x, cy + y,0xFFFFFFFF);
				pixels.setPixel32(cx - x, cy + y,0xFFFFFFFF);
				pixels.setPixel32(cx + x, cy - y,0xFFFFFFFF);
				pixels.setPixel32(cx - x, cy - y,0xFFFFFFFF);
				pixels.setPixel32(cx + y, cy + x,0xFFFFFFFF);
				pixels.setPixel32(cx - y, cy + x,0xFFFFFFFF);
				pixels.setPixel32(cx + y, cy - x,0xFFFFFFFF);
				pixels.setPixel32(cx - y, cy - x,0xFFFFFFFF);
			}
		}
		
		private function circleMidpoint(xCenter:int, yCenter:int, radius:int, alpha:Number):void
		{
			var x:int = 0;
			var y:int = radius;
			var p:int = (5 - radius * 4) / 4;
			circlePoints(xCenter, yCenter, x, y, alpha);
			
			while (x < y)
			{
				x++;
				if (p < 0)
				{
					p += 2 * x + 1;
				}
				else
				{
					y--;
					p += 2 * (x - y) + 1;
				}
				circlePoints(xCenter, yCenter, x, y, alpha);
			}
			resetHelpers();
		}
	}

}