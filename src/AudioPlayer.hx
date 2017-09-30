package;

import haxe.ds.Option;
import haxe.io.Float32Array;

using OptionTools;

class AudioPlayer {

    public var sampleRate(default, null) : Float = AudioChannel.DEFAULT_SAMPLE_RATE;
    public var bufferSamples(default, null) : Int;

    var _channel : Option<AudioChannel> = None;
    var _generator : Float32Array->Float->Void = null;

    public static function create( ?bufferSamples : Int = 8192 ) : AudioPlayer {
        return new AudioPlayer(bufferSamples);
    }

    public function new( bufferSamples : Int ) {
        this.bufferSamples = bufferSamples;
    }

    public function useGenerator( ?generator : Float32Array->Float->Void = null ) {
        _generator = generator;

        switch( _channel ) {
            case Some(channel) : channel.generator = _generator.mapOption((f) -> (out) -> f(out, sampleRate));
            case None : 
        }

        return this;
    }

    public function stop() {
        switch( _channel ) {
            case Some(channel) : channel.stop();
            case None : 
        }

        _channel = None;

        return this;
    }

    public function play() {
        // Stop previously playing channel
        stop();

        // Create new channel
        var channel = new AudioChannel(bufferSamples);
        _channel = Some(channel);

        sampleRate = AudioChannel.sampleRate;
        useGenerator(_generator);

        // TODO: If channel dies, re-create it?

        return this;
    }
}