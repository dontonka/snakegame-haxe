package entities;

import flash.geom.Rectangle;

interface ICollidible {
    public function isColliding(object:ICollidible):Bool;
    public function getBound():Rectangle;
    //public function executeCollideAction(object:ICollidible):Int;
}