package entities;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

import ui.*;

class Food implements ICollidible {
    static var MIN_SCORE = 5;
    static var MAX_SCORE = 100;
    static var SPAWN_SPACING_PERCENT = 0.2;

    var mMainCanvas:BitmapData;
    var mSprite:GameSprite;

    var mCreatedStamp:Float;
    var mPosX:Int;
    var mPosY:Int;

    public function new(mainCanvas:BitmapData, inBits:BitmapData) {
        mMainCanvas = mainCanvas;
        mSprite = new GameSprite(mainCanvas, inBits, 0, 0, 28, 28);

        respawn();
    }

    private function respawn() {
        mCreatedStamp = haxe.Timer.stamp();

        var spawnSpacingW = Std.int(mMainCanvas.width * SPAWN_SPACING_PERCENT);
        var spawnSpacingH = Std.int(mMainCanvas.height * SPAWN_SPACING_PERCENT);
        mPosX = spawnSpacingW + Std.random(mMainCanvas.width - spawnSpacingW*2);
        mPosY = spawnSpacingH + Std.random(mMainCanvas.height - spawnSpacingH*2); 

        // Ensure position are on a cell
        if (mPosX % mSprite.width != 0) {
            mPosX = (Std.int(mPosX / mSprite.width) + 1) * mSprite.width;
        }
        if (mPosY % mSprite.height != 0) {
            mPosY = (Std.int(mPosY / mSprite.height) + 1) * mSprite.height;
        }         

        trace("Food: " + mPosX + ", " + mPosY);
    } 

    public function draw() {
        mSprite.draw(mPosX, mPosY);
    }

    public function eat() : Int {
        // TODO: compute score
        var score = MIN_SCORE;

        // TODO: ensure there are no snakes present in the new position
        respawn();

        return score;
    }    

    public function isColliding(target:ICollidible) : Bool {
        // Check if the current object collides with the one coming in param
        var targetRect = target.getBound();
        var localRect = getBound();

        //trace("isColliding!!: " + colliderRect + " VS (" + mPosX + ", " + mPosY + ")");

        if (targetRect.intersects(localRect)) {
            trace("Collide!!: " + targetRect);
            return true;
        }
        
        return false;
    }

    public function getBound() : Rectangle {
        return new Rectangle(mPosX, mPosY, mSprite.width, mSprite.height);
    }
}