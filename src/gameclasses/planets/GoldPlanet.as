package gameclasses.planets
{
	import flash.display.*;
	import flash.geom.*;
	import gameclasses.ships.*;
	import gameclasses.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class GoldPlanet extends Planet
	{
		public var goldLeft:int = 0;
		private var nextGoldChange:int = 0;
		public function GoldPlanet(x:int, y:int, size:int, gold:int)
		{
			super(x, y, size,"Gold");
			goldLeft = gold;
		}
	}

}