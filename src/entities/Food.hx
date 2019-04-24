package entities;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

import ui.*;

class Food {
    var mMainCanvas:BitmapData;
    var mSprite:GameSprite;

    public function new(mainCanvas:BitmapData, inBits:BitmapData) {
        mMainCanvas = mainCanvas;
        mSprite = new GameSprite(mainCanvas, inBits, 0, 0, 28, 28);
    }

    public function draw() {
        mSprite.draw(200, 200); // TODO
    }
}