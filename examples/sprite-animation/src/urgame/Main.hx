package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.ImageSprite;
import flambe.util.Random;

import flambbets.spritesheet.SpriteSheetAnimation;

using flambbets.spritesheet.SpriteSheetTools;

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
    var spriteSheet = pack.getTexture('link');

    // get the frames to be used in animation
    var frames = spriteSheet.getAllFrames(64, 96);

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
    var spriteSheet2 = spriteSheet;

    // create static sprites
    for (i in 0...6) {

      // you can get a single texture frame using `SpriteSheetManager.getFrame`
      var frame = spriteSheet2.getFrame(i, 64, 96);
      var sprite = new ImageSprite(frame).setXY((15 * i) + (i * 64), 200);

      System.root.addChild(new Entity().add(sprite));
    }
  }
}
