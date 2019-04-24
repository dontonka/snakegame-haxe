package entities;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

import ui.*;

class Food implements ICollidible {
    static var MIN_SCORE = 5;
    static var MAX_SCORE = 100;

    var mMainCanvas:BitmapData;
    var mSprite:GameSprite;

    var mCreatedStamp:Float;

    public function new(mainCanvas:BitmapData, inBits:BitmapData) {
        mMainCanvas = mainCanvas;
        mSprite = new GameSprite(mainCanvas, inBits, 0, 0, 28, 28);

        mCreatedStamp = haxe.Timer.stamp();
    }

    public function draw() {
        mSprite.draw(200, 200); // TODO
    }

    public function eat() {
        // TODO: compute score
    }    

    public function isColliding(object:ICollidible) : Bool {
        // Check if the current object collides with the one coming in param
        return false;
    }       
}