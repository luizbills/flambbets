package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.ImageSprite;
import flambe.util.Random;

import flambbets.spritesheet.SpriteSheetManager;
import flambbets.spritesheet.SpriteSheetAnimation;

class Main {

  private static function main () {
    // Wind up all platform-specific stuff
    System.init();

    // Load up the compiled pack in the assets directory named "bootstrap"
    var manifest = Manifest.fromAssets("bootstrap");
    var loader = System.loadAssetPack(manifest);
    loader.get(onSuccess);
  }

  private static function onSuccess (pack :AssetPack) {
    // use the SpriteSheetManager to create the sprite sheet frames
    SpriteSheetManager.create('link-frames', pack.getTexture('link'), 64, 96);

    // get the frames to be used in animation
    var frames = SpriteSheetManager.getAllFrames('link-frames');

    // use a SpriteSheetAnimation to create and play animations
    var animation = new SpriteSheetAnimation(frames);

    // create a animation named 'walk' with duration 1 second.
    // note: use numeric indexes to define the first and last frame
    animation.add('walk', 0, 5, 1);
    // start an animation using `.play`
    var loop = true;
    animation.play('walk', loop);

    // the component SpriteSheetAnimation requires an ImageSprite
    var sprite = new ImageSprite(null).setXY(50, 50);

    // add to world
    System.root.addChild(new Entity().add(sprite).add(animation));

    // bonus
    SpriteSheetManager.create('crystal-frames', pack.getTexture('crystals'), 64, 64);

    // create static sprites
    for (i in 0...10) {
      var randFrame = Math.floor(Math.random() * 2);
      var randX = Math.floor(Math.random() * 600);
      var randY = Math.floor(Math.random() * 400);

      // you can get a texture frame using `SpriteSheetManager.getFrame`
      var texture = SpriteSheetManager.getFrame('crystal-frames', randFrame);
      var sprite = new ImageSprite(texture);
      sprite.setXY(randX, randY);

      System.root.addChild(new Entity().add(sprite));
    }
  }
}
