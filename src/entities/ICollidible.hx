package entities;

import flash.geom.Rectangle;

interface ICollidible {
    public function isColliding(target:ICollidible):Bool;
    public function getBound():Rectangle;
    //public function executeCollideAction(object:ICollidible):Int;
}