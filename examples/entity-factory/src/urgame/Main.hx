package urgame;

import flambe.Entity;
import flambe.System;
import flambe.display.FillSprite;

import flambbets.EntityFactory;

class Main {

  private static function main () {
    // Wind up all platform-specific stuff
    System.init();

    // define an Entity
    EntityFactory.set('red-tile', function() {
      var redTile = new FillSprite(0xFF0000, 32, 32);

      // ever returns an entity
      return new Entity().add(redTile);
    });

    for (i in 0...10) {
      var randX = Math.floor(Math.random() * 600);
      var randY = Math.floor(Math.random() * 400);

      // create a defined entity
      var redTileEntity = EntityFactory.get('red-tile');

      redTileEntity.get(FillSprite).setXY(randX, randY);

      System.root.addChild(redTileEntity);
    }
  }

}
