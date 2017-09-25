# audio-player

Mostly just a wrapper over the NativeChannel class from HEAPS.

I take no credit for this, but could be usefull for other project that need minimal cross-platform dynamic audio generation without importing a huge lib.

Sample:
```haxe
var n = 0;
var volume = 0.3;
var frequency = 425;

AudioPlayer
    .create()
    .useGenerator((out, sampleRate) -> for (i in 0...out.length >> 1) {
        var sin = Math.sin( 2 * Math.PI * n * frequency / sampleRate ) * volume;
        out.set(i*2, sin);
        out.set(i*2 + 1, sin);
        n++;
    });
```