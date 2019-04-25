package entities;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

import ui.*;
import physics.*;

class Food implements ICollidible {
    static var SCORE = 10;
    static var SPAWN_SPACING_PERCENT = 0.2;

    var mMainCanvas:BitmapData;
    var mSprite:GameSprite;

    var mPosX:Int;
    var mPosY:Int;

    public function new(mainCanvas:BitmapData, inBits:BitmapData) {
        mMainCanvas = mainCanvas;
        mSprite = new GameSprite(mainCanvas, inBits, 0, 0, 28, 28);
    }

    private function respawnInternal() {
        var spawnSpacingW = Std.int(mMainCanvas.width * SPAWN_SPACING_PERCENT);
        var spawnSpacingH = Std.int(mMainCanvas.height * SPAWN_SPACING_PERCENT);
        mPosX = spawnSpacingW + Std.random(mMainCanvas.width - spawnSpacingW*2);
        mPosY = spawnSpacingH + Std.random(mMainCanvas.height - spawnSpacingH*2); 

        // Ensure position are on a "cell"
        if (mPosX % mSprite.width != 0) {
            mPosX = (Std.int(mPosX / mSprite.width) + 1) * mSprite.width;
        }
        if (mPosY % mSprite.height != 0) {
            mPosY = (Std.int(mPosY / mSprite.height) + 1) * mSprite.height;
        }
    }

    public function respawn(?snake:ICollidible) {
        var colliding = false;

        // Get a random position for the food until it doesn't collide
        do {
            respawnInternal();
            colliding = isColliding(snake);
            //trace("Food colliding: " + colliding);
        } while (colliding);

        //trace("Food: " + mPosX + ", " + mPosY);
    } 

    public function draw() {
        mSprite.draw(mPosX, mPosY);
    }

    public function eat(snake:ICollidible) : Int {
        respawn(snake);
        return SCORE;
    }    

    public function isColliding(target:ICollidible) : Bool {
        if (target == null) return false;

        // Check if the current object collides with the one coming in param
        var targetRect = target.getRegion();
        var localRect = getRegion();

        if (targetRect.intersects(localRect)) {
            //trace("FOOD Collide!!: " + targetRect);
            return true;
        }

        // Also check for all the target parts
        var targetRects = target.getBounds();
        if (targetRects != null) {
            for (node in targetRects) {
                if (node.intersects(localRect)) {
                    return true;
                }
            }
        }
        
        return false;
    }

    public function getRegion() : Rectangle {
        return new Rectangle(mPosX, mPosY, mSprite.width, mSprite.height);
    }

    public function getBounds() : List<Rectangle> {
        var listRects = new List<Rectangle>();
        listRects.add(getRegion());
        return listRects;
    }      
}