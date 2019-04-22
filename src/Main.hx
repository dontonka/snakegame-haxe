import flash.display.Sprite;

class Square extends Sprite{

    public function new() 
    {
        super();
        this.graphics.beginFill(0x0000FF, 1);
        this.graphics.drawRect(0, 0, 50, 50);
    }
}

class Main extends Sprite
{
    public function new()
    {
        super();
        var square = new Square();
        addChild(square);
    }
    static function main() 
    {
        flash.Lib.current.addChild(new Main());
    }
}