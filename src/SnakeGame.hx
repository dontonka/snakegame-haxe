// Part of this code is based on Ski game from GM2D.com, no hidding here XD. 
// This is to rampup really fast the Flash game developpment boiler plates in Haxe. 
// Also some stuff are UI related which are not valuated by you guys, but wanted to be 
// nicer still XD, so having that part quickly done is handy.
// Eric Lajeunesse

// Flash
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.filters.GlowFilter;

// Mine
import entities.*;

// Games states
enum SnakeState { FirstRun; Playing; Dead; }
enum Difficulty { Easy; Normal; Hard; }


// Array of the x-coordinate of the trees.
//typedef TreeRow = Array<Float>;

// This is our main class, and in this case, it contains the whole game.
// It extends the standard flash "Sprite" class, which allows child objects
//  and events.  No need for a MovieClip, because we are not using the flash
//  timelining code.
class SnakeGame extends Sprite {
    // Using "copyPixels" we draw into this bitmap...
    var mGameCanvas:BitmapData;
    var mBoardWidth:Int;
    var mBoardHeigth:Int;   

    // What to do on an update...
    var mState : SnakeState;

    // Our entities
    var mBoard:Board;
    var mSnake:Snake;
    var mFood:Food;
 
    // Contains the state (whether currently pressed/down) of every key
    var mKeyDown:Array<Bool>;

    // Time of last step - for calculating time deltas...
    var mLastStep:Float;
    var mEngineLastStep:Float;

    // We increate game speed by increasing steps-per-second.
    // Note that this is independent of the flash frame rate, since we can
    //  do multiple steps per flash redraw.
    var mStepsPerSecond:Float;
    var mUpdatePerSecond:Float;
    var mDifficulty:Difficulty;

    // All position are in "field" coordinates, which are logical pixels.
    // We use the modulo operator (%) to wrap the trees around
    //static var mFieldHeight = 10000;
    var mPlayerX:Float;
    var mPlayerY:Float;

    // Curreny play
    var mScore:Float;
    // Current session
    var mTopScore:Float;
    // GUI items
    var mScoreText:TextField;
    var mTopScoreText:TextField;


    // All the graphics are provided in the input image (BitmapData).
    function new(inBitmap:BitmapData) {
    
        // Since this class inherits from Sprite, we must call this.
        super();
        // Haxe does not automatically add the main class to the stage (it adds
        //  a "boot" object to the stage, which becomes "flash.Lib.current").
        //  In order to see anything, this class must be on the stage, so we
        //  add ourselves as child to the haxe boot class.  Subsequent objects
        //  (eg, the TextFields) get added to ourselves.
        flash.Lib.current.addChild(this);

        mKeyDown = [];

        mBoardWidth = flash.Lib.current.stage.stageWidth;
        mBoardHeigth = flash.Lib.current.stage.stageHeight;

        // These two lines of code are the key to the "copyPixels" method of
        //  flash game creation.
        // First, an offscreen buffer (BitmapData) is created to hold all the graphics.
        // Then an instance of this is placed on the stage.  We can then simply change
        //  the offscreen buffer and have the changes visible.  This does not necessarily
        //  have to be the same size as the game, but in this case it is.
        mGameCanvas = new BitmapData(mBoardWidth, mBoardHeigth);
        addChild(new Bitmap(mGameCanvas));

        // Create game entities
        mBoard = new Board(mGameCanvas);
        mSnake = new Snake(mGameCanvas, inBitmap);
        mFood = new Food(mGameCanvas, inBitmap);
        mDifficulty = Difficulty.Normal; // TODO: make this customizable

        // I have chosen to add the event listeners to stage rather then
        //  other display objects.  Since there are no objects that will take
        //  keyboard focus, all the key events will go to the stage.
        // It is best to have a single OnEnter and do all the updates from there,
        //  so it may as well be on the stage.
        stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown );
        stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp );
        stage.addEventListener(Event.ENTER_FRAME, OnEnter);

        // The "GUI" consists of two TextFields overlapping the board.
        // These do not use "copyPixels", but take advantage of some of the
        //  other benefits provided by flash display list model.
        // In a "real" game, you should use a custom embedded font, rather than
        //  some crappy default.
        mScoreText = new TextField();
        mScoreText.x = 10;
        mScoreText.y = 10;
        var format:TextFormat = new TextFormat();
        format.font = "Arial";
        format.bold = true;
        format.color = 0xffffff;
        format.size = 20;
        mScoreText.defaultTextFormat = format;
        mScoreText.text = "Score:0";
        mScoreText.width = mBoardWidth;
        mScoreText.filters = [ new  GlowFilter(0x0000ff, 1.0, 3, 3, 3, 3, false, false) ];
        addChild(mScoreText);

        mTopScoreText = new TextField();
        mTopScoreText.x = 100;
        mTopScoreText.y = 10;
        format.color = 0xffffff;
        mTopScoreText.defaultTextFormat = format;
        mTopScoreText.filters = [ new  GlowFilter(0xff0000, 1.0, 3, 3, 3, 3, false, false) ];
        addChild(mTopScoreText);

        // Just something small to aspire too...
        mTopScore = 0;
        CheckTopScore(1000);

        mLastStep = haxe.Timer.stamp();
        mEngineLastStep = haxe.Timer.stamp();

        Reset();
        // Slightly different message at the beginning
        mState = SnakeState.FirstRun;
    }

    // Update the top score at the end of the game, if required.
    function CheckTopScore(inScore:Float) {
        if (inScore>mTopScore)
        {
            mTopScore = inScore;
            var s = Std.int(mTopScore * 0.1);
            mTopScoreText.text = "TopScore:" + s + "0";
            var w = mTopScoreText.textWidth;
            mTopScoreText.width = w + 300;
            mTopScoreText.x = mBoardWidth - w;
        }
    }

    // Get ready to start the game again
    function Reset() {
        mPlayerX = 320;
        mPlayerY = 20;
        mScore = 0;
        mStepsPerSecond = 30;

        if (mDifficulty == Difficulty.Easy) {
            mUpdatePerSecond = 3;
        } else if (mDifficulty == Difficulty.Normal) {
            mUpdatePerSecond = 5;
        } else if (mDifficulty == Difficulty.Hard) {
            mUpdatePerSecond = 8;
        }

    }

   // Update one step.
   function Update() {
        // Actually need to move down ?
        if (mState == SnakeState.Playing) {
            // Only move the snakes if according to speed it is the time todo so.
            if (TickGame() && /*!mKeyDown[Keyboard.SPACE]*/) {
                if (mFood.isColliding(mSnake)) {
                    mScore += mFood.eat();
                    mSnake.grow();
                } else {
                    // TODO:
                }
                mSnake.move();
            }
            
            // We do update the direction as fast as we can.
            mSnake.updateDirection(mKeyDown);
        }      
    }

    function TickGame() : Bool {
        // Compute if we need to tick the snake now or not according to
        // the game difficulties (so snake speed)
        var now = haxe.Timer.stamp();
        var steps = Math.floor((now-mEngineLastStep) * mUpdatePerSecond);
        mEngineLastStep += steps / mUpdatePerSecond;

        return (steps != 0);
    }

    // Update the graphics based on class variables.
    // Note that this will be called less frequently than the "Update" call.
    // inExtra is not used in this example, because scrolling seems smooth enough.
    function Render(inExtra:Float) {
        // Draw the main board
        mBoard.draw();

        // Draw the snakes
        mSnake.draw();

        // Draw the food
        mFood.draw();

        // Update the gui message.
        if (mState == SnakeState.FirstRun)
        {
            mScoreText.text = "Press any key to start";
        }
        else if (mState == SnakeState.Playing)
        {
            // Round scores to nearest 10 for display purposes
            var s = Std.int(mScore * 0.1);
            mScoreText.text = "Score:" + s + "0";
        }
        else
        {
            var s = Std.int(mScore * 0.1);
            if (mScore>=mTopScore)
            mScoreText.text = "Top Score! " + s + "0" + "    Press [space] to go again";
            else
            mScoreText.text = "You scored " + s + "0" + "    Press [space] to try again";
        }        
    }


   // Respond to a key-down event.
   function OnKeyDown(event:KeyboardEvent) {
        // When a key is held down, multiple KeyDown events are generated.
        // This check means we only pick up the first one.
        if (!mKeyDown[event.keyCode])
        {
            // Most of the game runs off the "mKeyDown" state, but the in beginning we
            //  use the transition event...
            if (mState == SnakeState.FirstRun)
                mState = SnakeState.Playing;
            else if (mState == SnakeState.Dead && event.keyCode==Keyboard.SPACE)
            {
                Reset();
                mState = SnakeState.Playing;
            }
            // Store for use in game
            mKeyDown[event.keyCode] = true;
        }
    }

   // Key-up event
   function OnKeyUp(event:KeyboardEvent) {
        // Store for use in game
        mKeyDown[event.keyCode] = false;
    }

   // This function gets called once per flash frame.
   // This will be approximately the rate specified in the swf, but usually a
   //  bit slower.  For accurate timing, we will not rely on flash to call us
   //  consistently, but we will do our own timing.
   function OnEnter(e:flash.events.Event) {
        var now = haxe.Timer.stamp();
        // Do a number of descrete steps based on the mStepsPerSecond.
        var steps = Math.floor( (now-mLastStep) * mStepsPerSecond );
        // Since the mStepsPerSecond may change in the Update call, make sure
        //  we do all our calculations before we call Update.
        mLastStep += steps / mStepsPerSecond;
        var fractional_step = (now-mLastStep) * mStepsPerSecond;

        for(i in 0...steps)
            Update();

        // This helps flash efficiently update the bitmap, batching the changes
        mGameCanvas.lock();

        // fractional_step is something we don't use, but it could be used to do some
        //  dead-reckoning in the render code to smooth out the display.
        Render(fractional_step);

        // This completes the batching
        mGameCanvas.unlock();
    }

   // Haxe will always look for a static function called "main".
   static public function main() {
        // There are a number of ways to get bitmap data into flash.
        // In this case, we're loading it from a file that is placed next to the
        //  game swf.  Other ways will be described later.
        // Since the downloding of the bitmap from a remote location may take some
        //  time, flash uses an asynchronous api to delivier the data.
        //  This means that the request is sent and the data only becomes valid when
        //  the callback is called.  A loading screen would be appropriate here, but
        //  that's beond the scope of this example, as is appropriate error checking.

        // Create the request object...
        var loader = new flash.display.Loader();
        // When the image is ready, instanciate the game class...
        loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
            function(_) { new SnakeGame(untyped loader.content.bitmapData); });
        // Fire off the request and wait...
        loader.load(new flash.net.URLRequest("gfx.png"));
    }
}
