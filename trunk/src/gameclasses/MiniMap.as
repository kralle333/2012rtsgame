package gameclasses
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import gameclasses.planets.Planet;
	import org.flixel.*;
	
	public class MiniMap
	{
		private var position:FlxPoint;
		private var levelSize:FlxPoint;
		public var screenRectangle:FlxSprite;
		private var screenSize:FlxPoint = new FlxPoint(800, 600);
		private var rectColor:uint = 0x368036;
		
		private var planets:FlxGroup;
		public var map:FlxSprite;
		
		public function MiniMap(x:int, y:int, width:int, height:int, planets:FlxGroup)
		{
			position = new FlxPoint(x, y);
			levelSize = new FlxPoint(width, height);
			screenRectangle = new FlxSprite();
			var rectangleWidth:int = (800 / width) * 110;
			var rectangleHeight:int = (600 / height) * 110;
			screenRectangle.makeGraphic(width, height, 0x0, false);
			
			//Drawing the rectangle;
			var rect:Shape = new Shape();
			rect.graphics.lineStyle(3, rectColor, 1);
			rect.graphics.drawRect(0, 0, rectangleWidth - 1, rectangleHeight - 1);
			var bitmap:BitmapData = new BitmapData(rectangleWidth, rectangleHeight, true, 0x00FFffFF);
			bitmap.draw(rect);
			screenRectangle.pixels = bitmap;
			screenRectangle.x = x;
			screenRectangle.y = y;
			
			screenRectangle.scrollFactor.x = 0;
			screenRectangle.scrollFactor.y = 0;
			
			map = new FlxSprite().makeGraphic(110, 110, 0x0, true);
			map.x = x + 5;
			map.y = y + 5;
			map.scrollFactor.x = map.scrollFactor.y = 0;
			this.planets = planets;
			addPlanets();
		}
		
		private function addPlanets():void
		{
			for (var i:int = 0; i < planets.length; i++)
			{
				var planet:Planet = planets.members[i];
				var circ:Shape = new Shape();
				circ.graphics.beginFill(0x666666, 1);
				var newPlanetX:int = (planet.x / levelSize.x) * 110;
				var newPlanetY:int = (planet.y / levelSize.y) * 110;
				var newRadius:Number = (planet.size / 2 - 1) / levelSize.x * 110;
				if (planet.owner != null)
				{
					circ.graphics.beginFill(planet.owner.color, 1);
				}
				circ.graphics.drawCircle(newRadius, newRadius, newRadius - 1);
				circ.graphics.endFill();
				var bitMap:BitmapData = new BitmapData(newRadius * 2, newRadius * 2, true, 0x00FFffFF);
				bitMap.draw(circ);
				var circSprite:FlxSprite = new FlxSprite().makeGraphic(newRadius * 2, newRadius * 2, 0x0, true);
				circSprite.pixels = bitMap;
				map.stamp(circSprite, newPlanetX, newPlanetY);
			}
		}
		
		//In world pixels
		public function updatePosition(xOffset:Number, yOffset:Number, inWorldPixels:Boolean):void
		{
			if (inWorldPixels)
			{
				xOffset = (xOffset / levelSize.x) * 110
				yOffset = (yOffset / levelSize.y) * 110
			}
			if (screenRectangle.x + xOffset <= position.x)
			{
				screenRectangle.x = position.x;
			}
			else if (screenRectangle.x + xOffset+screenRectangle.width >= position.x + 110)
			{
				screenRectangle.x = position.x + 110 - screenRectangle.width;
			}
			else
			{
				screenRectangle.x += xOffset;
			}
			
			if (screenRectangle.y + yOffset <= position.y)
			{
				screenRectangle.y = position.y;
			}
			else if (screenRectangle.y + yOffset+screenRectangle.height >= position.y + 110)
			{
				screenRectangle.y = position.y + 110 - screenRectangle.height;
			}
			else
			{
				
				screenRectangle.y += yOffset;		
			}
		}
		
		public function update():void
		{
			if (FlxG.mouse.justReleased() && isMouseTouching())
			{
				updatePosition(FlxG.mouse.screenX - screenRectangle.x, FlxG.mouse.screenY - screenRectangle.y, false)
				FlxG.camera.scroll.x += miniMapPixelsToWorldPixels(FlxG.mouse.screenX - screenRectangle.x);
				FlxG.camera.scroll.y += miniMapPixelsToWorldPixels(FlxG.mouse.screenY - screenRectangle.y);
			}
		}
		private function miniMapPixelsToWorldPixels(n:Number):Number
		{
			return (n *levelSize.x) / 110;
		}
		private function isMouseTouching():Boolean
		{
			return FlxG.mouse.screenX > position.x && FlxG.mouse.screenX < position.x + 110 && FlxG.mouse.screenY > position.y && FlxG.mouse.screenY > position.y && FlxG.mouse.screenY < position.y + 110;
		}
	}

}