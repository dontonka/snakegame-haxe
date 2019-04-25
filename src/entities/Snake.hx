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
    static var SPAWN_SPACING_PERCENT = 0.2;

    var mMainCanvas:BitmapData;
    var mSprite:GameSprite;
    var mLength:Int;
    var mDirection:Int;
    var mStepSize:Int; 
    var mSnakeNodes:List<Point>;

    public function new(mainCanvas:BitmapData, inBits:BitmapData) {
        mMainCanvas = mainCanvas;
        mSprite = new GameSprite(mainCanvas, inBits, 28, 0, 28, 28);

        // Default values
        mLength = 3;
        mDirection = Std.random(4); // 4 directions, not gonna change soon
        mStepSize = mSprite.width;  

        respawn();       
    }

    private function respawn() {
        mLength = 3;

        // Respawn the snake at a random place on the board
        var spawnSpacingW = Std.int(mMainCanvas.width * SPAWN_SPACING_PERCENT);
        var spawnSpacingH = Std.int(mMainCanvas.height * SPAWN_SPACING_PERCENT);
        var startingHeadX = spawnSpacingW + Std.random(mMainCanvas.width - spawnSpacingW*2);
        var startingHeadY = spawnSpacingH + Std.random(mMainCanvas.height - spawnSpacingH*2);
        
        // Ensure position are on a cell
        if (startingHeadX % mSprite.width != 0) {
            startingHeadX = (Std.int(startingHeadX / mSprite.width) + 1) * mSprite.width;
        }
        if (startingHeadY % mSprite.height != 0) {
            startingHeadY = (Std.int(startingHeadY / mSprite.height) + 1) * mSprite.height;
        }
        
        createSnakeNodes(startingHeadX, startingHeadY);        
    } 

    private function createSnakeNodes(headX:Int, headY:Int) {
        var x = headX;
        var y = headY;

        mSnakeNodes = new List<Point>();
        for (i in 0...mLength) {
            var pt = new Point(x, y);
            mSnakeNodes.add(pt);
            trace("createSnakeNodes Snake: " + pt);
            x += mStepSize;
        }  
    }

    public function draw() {
        for (node in mSnakeNodes) {
            mSprite.draw(node.x, node.y);
        }
    }

    public function move() {
        // Allocate the memory only once
        var swapPos = new Point(0, 0);
        var previousPos = new Point(0, 0);
        var nodeId = 0;

        for (node in mSnakeNodes) {
            swapPos.x = node.x;
            swapPos.y = node.y;    

            if (nodeId == 0) {
                if (mDirection == DIR_LEFT) {
                    node.x -= mStepSize; 
                } else if (mDirection == DIR_RIGTH) { 
                    node.x += mStepSize; 
                } else if (mDirection == DIR_UP) { 
                    node.y -= mStepSize; 
                } else if (mDirection == DIR_DOWN) {
                    node.y += mStepSize; 
                }
            } else {
                node.x = previousPos.x;
                node.y = previousPos.y;                 
            }

            previousPos.x = swapPos.x;
            previousPos.y = swapPos.y;  
            nodeId++;
        }        
    } 

    public function updateDirection(keyDown:Array<Bool>) {
        // Prevent going into opposite direction as the current direction

        if (keyDown[Keyboard.LEFT] && mDirection != DIR_RIGTH) {
            mDirection = DIR_LEFT; 
        } else if (keyDown[Keyboard.RIGHT] && mDirection != DIR_LEFT) { 
            mDirection = DIR_RIGTH;
        } else if (keyDown[Keyboard.UP] && mDirection != DIR_DOWN) { 
            mDirection = DIR_UP;
        } else if (keyDown[Keyboard.DOWN] && mDirection != DIR_UP) { 
            mDirection = DIR_DOWN;
        }        
    }    

    public function grow(size = 1) {
        // Increase the size of the of the snake by 'size' amount of node
        var head = mSnakeNodes.first();
        mSnakeNodes.push(new Point(head.x, head.y));
    } 

    public function isColliding(object:ICollidible) : Bool {
        // Check if the current object collides with the one coming in param
        return false;
    }     

    public function getBound() : Rectangle {
        var head = mSnakeNodes.first();
        return new Rectangle(head.x, head.y, mSprite.width, mSprite.height);
    }
}