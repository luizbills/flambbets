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
    EntityFactory.set('square', function() {
      var randomColor = Math.floor(Math.random() * 0xFFFFFF);
      var square = new FillSprite(randomColor, 32, 32);

      // ever returns an entity
      return new Entity().add(square);
    });

    for (i in 0...25) {
      var randX = Math.floor(Math.random() * 600);
      var randY = Math.floor(Math.random() * 400);

      // create a defined entity
      var squareEntity = EntityFactory.get('square');
      squareEntity.get(FillSprite).setXY(randX, randY); // random position

      System.root.addChild(squareEntity);
    }
  }

}
