/*
 The GameSprite is a rectangle of pixels that can be
  quickyly and easily copied to the screen.  Perhaps a better name would
  be Sprite, but that would be too confusing.
 The main purpose of this class is to do a "copyPixels", and it just gathers
  the required data together to make this very easy.
*/
package ui;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class GameSprite
{
   public var width:Int;
   public var height:Int;

   var mMainCanvas:BitmapData;
   var mBits:BitmapData;
   var mRect:Rectangle;
   var mPoint:Point;
   // The "hotspot" is the logical origin of the object, with respect
   //  to the top left of its bitmap rectangle.  This allows you to deal
   //  with the position of the object, without having to worry about drawing
   //  offsets etc.
   var mHotX:Float;
   var mHotY:Float;

   // Passing the arena into the constructor is not really required,
   //  but doing this reduces the number of params we have to pass into
   //  the Draw function;
   public function new(mainCanvas:BitmapData,inBits:BitmapData,inX:Int, inY:Int, inW:Int, inH:Int,
           ?inHotX:Null<Float>, ?inHotY:Null<Float>)
   {
      mMainCanvas = mainCanvas;
      mBits = inBits;
      mRect = new Rectangle(inX,inY,inW,inH);
      mPoint = new Point(0,0);
      width = inW;
      height = inH;

      // If null is provided, assume the centre.
      mHotX = inHotX==null ? inW/2 : inHotX;
      mHotY = inHotY==null ? inH/2 : inHotY;
   }

   public function draw(inX:Float,inY:Float)
   {
      mPoint.x = inX-mHotX;
      mPoint.y = inY-mHotY;
      mMainCanvas.copyPixels(mBits,mRect,mPoint,null,null,true);
   }
}