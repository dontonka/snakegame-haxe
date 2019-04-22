import flash.display.Sprite;

class WormSprite extends Sprite{

    public function new() 
    {
        super();
        this.graphics.beginFill(0x0000FF, 1);
        this.graphics.drawRect(0, 0, 50, 50);
    }
}

class FoodSprite extends Sprite{

    public function new()
    {
        super();
        this.graphics.beginFill(0x00FFFF, 1);
        this.graphics.drawCircle(100, 100, 50);
    }
}

class Main extends Sprite
{
    public function new()
    {
        super();
        var worm = new WormSprite();
        var food = new FoodSprite();
        addChild(worm);
        addChild(food);
    }
    static function main() 
    {
        flash.Lib.current.addChild(new Main());
    }
}