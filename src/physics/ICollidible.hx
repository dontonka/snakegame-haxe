package physics;

import flash.geom.Rectangle;

interface ICollidible {
    public function isColliding(target:ICollidible):Bool;
    public function getRegion():Rectangle;
    public function getBounds():List<Rectangle>;
}