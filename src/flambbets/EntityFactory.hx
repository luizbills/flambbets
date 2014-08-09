package flambbets;

import flambe.Entity;
import haxe.ds.StringMap;

/**
 * Utility to create entities
 */
class EntityFactory {

  /**
   * Defines an entity
   *
   * @param name An unique identifier to represent the entity.
   * @param allocator A function that creates a new entity.
   */
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

  /**
   * allocates an entity
   *
   * @param name The unique identifier of a defined entity.
   * @returns An entity.
   */
  public static function get(name:String):Entity {
    var allocator = _factories.get(name);
    #if debug
      if (allocator == null) {
        throw 'the entity named $name not exists';
      }
    #end
    return allocator();
  }

  /**
   * removes the allocator of an defined entity
   *
   * @param name The unique identifier of a defined entity.
   */
  public static function remove(name:String) {
    _factories.remove(name);
  }

  /**
   * removes all allocators
   */
  public static function clear() {
    _factories = new StringMap<Void -> Entity>();
  }

  private static var _factories:StringMap<Void -> Entity> = new StringMap<Void -> Entity>();
}
