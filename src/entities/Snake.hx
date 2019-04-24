package entities;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.ui.Keyboard;


import ui.*;

class Snake implements ICollidible {
    static var DIR_LEFT = 0;
    static var DIR_RIGTH = 1;
    static var DIR_UP = 2;
    static var DIR_DOWN = 3;
    static var SPAWN_SPACING_PERCENT = 0.15;

    var mMainCanvas:BitmapData;
    var mSprite:GameSprite;
    var mLength:Int;
    var mSpeed:Int;
    var mDirection:Int;
    var mHeadX:Int;
    var mHeadY:Int; 

    public function new(mainCanvas:BitmapData, inBits:BitmapData) {
        mMainCanvas = mainCanvas;
        mSprite = new GameSprite(mainCanvas, inBits, 28, 0, 28, 28);

        // Default values
        mLength = 3;
        mSpeed = 1;
        mDirection = Std.random(4); // 4 directions, not gonna change soon
        mHeadX = Std.random(mMainCanvas.width - Std.int(mMainCanvas.width * SPAWN_SPACING_PERCENT));
        mHeadY = Std.random(mMainCanvas.height - Std.int(mMainCanvas.width * SPAWN_SPACING_PERCENT));         
    }

    public function draw() {
        mSprite.draw(mHeadX, mHeadY);
    }

    public function move() {
        if (mDirection == DIR_LEFT) {
            mHeadX--; 
        } else if (mDirection == DIR_RIGTH) { 
            mHeadX++; 
        } else if (mDirection == DIR_UP) { 
            mHeadY--; 
        } else if (mDirection == DIR_DOWN) { 
            mHeadY++; 
        }
    } 

    public function updateDirection(keyDown:Array<Bool>) {
        if (keyDown[Keyboard.LEFT]) {
            mDirection = DIR_LEFT; 
        } else if (keyDown[Keyboard.RIGHT]) { 
            mDirection = DIR_RIGTH;
        } else if (keyDown[Keyboard.UP]) { 
            mDirection = DIR_UP;
        } else if (keyDown[Keyboard.DOWN]) { 
            mDirection = DIR_DOWN;
        }        
    }    

    public function grow(size = 1) {
        // Increase the size of the of the snake by 'size' amount of node
    } 

    public function respawn() {
        // Respawn the snake at a random place on the board
    }  

    public function isColliding(object:ICollidible) : Bool {
        // Check if the current object collides with the one coming in param
        return false;
    }     
}