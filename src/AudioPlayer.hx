package;

import haxe.ds.Option;
import haxe.io.Float32Array;

using OptionTools;

class AudioChannel extends NativeChannel {

    public static inline var DEFAULT_SAMPLE_RATE:Float = 44100.0;

    public var sampleRate(get, null):Float;
    public var generator:Option<Float32Array->Void> = None;

    public function new( bufferSamples : Int ) {
        super(bufferSamples);
    }

    function get_sampleRate():Float {
        #if js
        return NativeChannel.ctx == null ? DEFAULT_SAMPLE_RATE : NativeChannel.ctx.sampleRate;
        #else
        return DEFAULT_SAMPLE_RATE;
        #end
    }

    override function onSample( out : Float32Array ) {
        switch( generator ) {
            case Some( generator ) : generator(out);
            case None : for (i in 0...out.length) out.set(i, 0.0);
        }
	}
}

class AudioPlayer {

    public var sampleRate:Float = AudioChannel.DEFAULT_SAMPLE_RATE;

    var _channel:AudioChannel;
    var _generator:Option<Float32Array->Float->Void> = None;

    public static function create( ?bufferSamples : Int = 8192 ) : AudioPlayer {
        return new AudioPlayer(bufferSamples);
    }

    public function new( bufferSamples : Int ) {
        _channel = new AudioChannel(8192);
        sampleRate = _channel.sampleRate;

        // TODO: If channel dies, re-create it?
    }

    public function useGenerator( generator : Float32Array->Float->Void ) {
        _generator = generator.fromNullable();
        _channel.generator = generator.mapFromNullable((f) -> (out) -> f(out, sampleRate));
        return this;
    }
}