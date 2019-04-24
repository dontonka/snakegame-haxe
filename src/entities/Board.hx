package entities;

import flash.display.BitmapData;
import flash.geom.Rectangle;

class Board implements ICollidible {
    public static var BOARD_SPACING = 30;
    static var BOARD_BORDER_WIDTH = 4;
    static var BOARD_BORDER_COLOR = 0xff272e17;
    static var BOARD_BG_COLOR = 0xffa8cb65;

    var mMainCanvas:BitmapData;
    var mMainRect:Rectangle;
    var mOutterRect:Rectangle; 
    var mInnerRect:Rectangle; 

    public function new(mainCanvas:BitmapData) {
        mMainCanvas = mainCanvas;
        mMainRect = new Rectangle(0, 0, mainCanvas.width, mainCanvas.height);
        mOutterRect = new Rectangle(BOARD_SPACING, BOARD_SPACING, mainCanvas.width-BOARD_SPACING*2, mainCanvas.height-BOARD_SPACING*2);
        mInnerRect = new Rectangle(BOARD_SPACING+BOARD_BORDER_WIDTH, BOARD_SPACING+BOARD_BORDER_WIDTH,
                mainCanvas.width-(BOARD_SPACING+BOARD_BORDER_WIDTH)*2, mainCanvas.height-(BOARD_SPACING+BOARD_BORDER_WIDTH)*2);
    }

    public function draw() {
        mMainCanvas.fillRect(mMainRect, BOARD_BG_COLOR);
        mMainCanvas.fillRect(mOutterRect, BOARD_BORDER_COLOR);
        mMainCanvas.fillRect(mInnerRect, BOARD_BG_COLOR);
    }

    public function isColliding(object:ICollidible) : Bool {
        // Check if the current object collides with the one coming in param
        return false;
    }

    public function getBound() : Rectangle {
        return new Rectangle(0,0,0,0);
    }
}