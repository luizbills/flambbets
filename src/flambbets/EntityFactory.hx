package flambbets;

import flambe.Entity;
import haxe.ds.StringMap;

class EntityFactory {

  public static function set(name:String, allocator:Void -> Entity) {
    #if debug
      if (name.length == 0) {
        throw 'invalid name argument';
      }

      if (_factories.exists(name) == true) {
        throw 'entity named $name already defined';
      }
    #end

    _factories.set(name, allocator);
  }

  public static function get(name:String):Entity {
    var allocator = _factories.get(name);
    if (allocator == null) {
      return null;
    }
    return allocator();
  }

  public static function remove(name:String) {
    _factories.remove(name);
  }

  public static function clear(name:String, allocator:Void -> Entity) {
    _factories = new StringMap<Void -> Entity>();
  }

  private static var _factories:StringMap<Void -> Entity> = new StringMap<Void -> Entity>();
}
