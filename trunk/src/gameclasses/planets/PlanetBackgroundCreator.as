package gameclasses.planets
{
	import flash.display.*;
	import flash.geom.Matrix;
	import org.flixel.*;
	
	public class PlanetBackgroundCreator
	{
		[Embed(source='../../../assets/planetoverlays/goldOverlay.png')]
		private var goldTexture:Class;
		private var goldSpots:FlxGroup = new FlxGroup();
		
		[Embed(source='../../../assets/planetoverlays/grassOverlay.png')]
		private var grassTexture:Class;
		private var grassSpots:FlxGroup = new FlxGroup();
		
		[Embed(source='../../../assets/planetoverlays/factory.png')]
		private var factoryTexture:Class;
		private var factorySpots:FlxGroup = new FlxGroup();
		
		[Embed(source='../../../assets/planetoverlays/hq.png')]
		private var hqTexture:Class;
		
		private var planet:Planet;
		private var currentBackground:FlxSprite;
		
		public function PlanetBackgroundCreator(planet:Planet)
		{
			this.planet = planet;
		}
		
		public function createGradiantBorder():void
		{
			planet.gradiantBorder = new FlxSprite(planet.x-planet.size/2,planet.y-planet.size/2).makeGraphic(planet.size * 2, planet.size * 2, 0x0, true);
			var circ:Shape = new Shape();
			var mat:Matrix = new Matrix();
			mat.createGradientBox(planet.size*2, planet.size*2,0, 0,0);
			circ.graphics.beginGradientFill(GradientType.RADIAL, [planet.owner.color,0xffffff], [0.5,0], [100,255], mat, SpreadMethod.PAD, InterpolationMethod.RGB);
			circ.graphics.drawCircle(planet.size,planet.size, planet.size-planet.size/4);
			circ.graphics.drawCircle(planet.size,planet.size, planet.size/2 - 1);
			circ.graphics.endFill();
			var bitMap:BitmapData = new BitmapData(planet.size * 2, planet.size * 2, true, 0x00FFffFF);
			bitMap.draw(circ);
			planet.gradiantBorder.pixels = bitMap;
		}
		
		public function addToBackground(type:String):FlxSprite
		{
			switch (type)
			{
				case "Factory": 
					return addFactories();
					break;
				case "HQ": 
					return addHQ();
					break;
			}
			return null;
		}
		
		private function addHQ():FlxSprite
		{
			var hq:FlxSprite = new FlxSprite();
			hq.loadGraphic(hqTexture);
			currentBackground.stamp(hq, planet.origin.x - hq.width / 2, planet.origin.y - hq.height);
			return currentBackground;
		}
		
		private function addFactories():FlxSprite
		{
			for (var i:int = 0; i < planet.size / 60; i++)
			{
				var factory:FlxSprite = new FlxSprite();
				factory.loadGraphic(factoryTexture, true, false, 8, 8, true);
				factorySpots.add(factory);
				factory.addAnimation("Play", [0, 1, 2], 2);
				factory.play("Play");
				var dist:int = ((planet.size / 2) - 2) * Math.sqrt(Math.random());
				var randAngle:Number = (Math.random() * Math.PI * 2);
				var x:int = -factory.width / 2 + planet.origin.x + dist * Math.cos(randAngle);
				var y:int = -factory.height / 2 + planet.origin.y + dist * Math.sin(randAngle);
				currentBackground.stamp(factory, x, y);
			}
			return currentBackground;
		}
		
		public function createBackground(type:String):FlxSprite
		{
			switch (type)
			{
				case "Gold": 
					return createGoldBackground();
					break;
				case "Grass": 
					return createGrassBackground();
					break;
				case "None": 
					return createStandardBackground(0x666666);
					break;
			}
			return null;
		}
		
		private function createGrassBackground():FlxSprite
		{
			createStandardBackground(0x4AC21F);
			//Draw the background circle:	
			
			for (var i:int = 0; i < planet.size * 2; i++)
			{
				var goldSpot:FlxSprite = new FlxSprite();
				goldSpot.loadGraphic(grassTexture, false, false, 0, 0, true);
				goldSpots.add(goldSpot);
				var dist:int = ((planet.size / 2) - 2) * Math.sqrt(Math.random());
				var randAngle:Number = (Math.random() * Math.PI * 2);
				var x:int = -goldSpot.width / 2 + planet.origin.x + dist * Math.cos(randAngle);
				var y:int = -goldSpot.height / 2 + planet.origin.y + dist * Math.sin(randAngle);
				currentBackground.stamp(goldSpot, x, y);
			}
			return currentBackground;
		}
		
		private function createGoldBackground():FlxSprite
		{
			createStandardBackground(0x666666);
			
			for (var i:int = 0; i < planet.size; i++)
			{
				var goldSpot:FlxSprite = new FlxSprite();
				goldSpot.loadGraphic(goldTexture, false, false, 0, 0, true);
				goldSpots.add(goldSpot);
				var dist:int = ((planet.size / 2) - 2) * Math.sqrt(Math.random());
				var randAngle:Number = (Math.random() * Math.PI * 2);
				var x:int = -goldSpot.width / 2 + planet.origin.x + dist * Math.cos(randAngle);
				var y:int = -goldSpot.height / 2 + planet.origin.y + dist * Math.sin(randAngle);
				currentBackground.stamp(goldSpot, x, y);
			}
			return currentBackground;
		}
		
		private function createStandardBackground(color:uint):FlxSprite
		{
			var background:FlxSprite = new FlxSprite().makeGraphic(planet.size, planet.size*2, 0x0, true);
			
			//Draw the background circle:
			var circ:Shape = new Shape();
			circ.graphics.beginFill(color, 1);
			circ.graphics.lineStyle(1, 0x0);
			circ.graphics.drawCircle(planet.size / 2, planet.size / 2, planet.size / 2 - 1);
			var bitMap:BitmapData = new BitmapData(planet.size, planet.size, true, 0x00FFffFF);
			bitMap.draw(circ);
			background.pixels = bitMap;
			currentBackground = background;
			
			return currentBackground;
		}
	}

}