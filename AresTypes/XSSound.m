//
//  XSSound.m
//  Athena
//
//  Created by Scott McClaugherty on 7/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSSound.h"
#import "Archivers.h"
#import <AudioToolbox/AudioQueue.h>
#import <vorbis/codec.h>
#import <vorbis/vorbisenc.h>

void doNothing(void *user, AudioQueueRef refQueue, AudioQueueBufferRef inBuffer) {}

@interface XSSound (Private)
- (void) decodeType1SndFromCoder:(ResUnarchiver *)coder;
- (void) decodeType2SndFromCoder:(ResUnarchiver *)coder;
@end

@implementation XSSound
@synthesize name, sampleRate;
@synthesize bufferLength;
@dynamic buffer;

- (id)init {
    self = [super init];
    if (self) {
        name = @"Untitled";
        sampleRate = 22000;
        bufferLength = 0;
        buffer = NULL;
    }
    
    return self;
}

- (void)dealloc {
    free(buffer);
    [name release];
    [super dealloc];
}


- (void)play {
    NSLog(@"Playing");
    AudioStreamBasicDescription streamDesc;
    streamDesc.mSampleRate = sampleRate;
    streamDesc.mFormatID = kAudioFormatLinearPCM;
    streamDesc.mFormatFlags = 0;
    streamDesc.mBytesPerPacket = 1;
    streamDesc.mFramesPerPacket = 1;
    streamDesc.mBytesPerFrame = 1;
    streamDesc.mChannelsPerFrame = 1;
    streamDesc.mBitsPerChannel = 8;

    AudioQueueRef queue;
    AudioQueueNewOutput(&streamDesc, &doNothing, buffer, NULL, NULL, 0, &queue);
    AudioQueueBufferRef aBuffer;
    OSStatus error = AudioQueueAllocateBuffer(queue, bufferLength, &aBuffer);
    memcpy(aBuffer->mAudioData, buffer,bufferLength);
    aBuffer->mAudioDataByteSize = bufferLength;
    assert(!error);
    AudioQueueEnqueueBuffer(queue, aBuffer, 0, NULL);
    AudioQueueFreeBuffer(queue, buffer);
    AudioQueueSetParameter(queue, kAudioQueueParam_Volume, 1.0);
    error = AudioQueuePrime(queue, 0, NULL);
    assert(!error);
    error = AudioQueueStart(queue, NULL);
    assert(!error);
    AudioQueueDispose(queue, false);
}
- (void)setBuffer:(void *)buffer_ {
    if (buffer != NULL) {
        free(buffer);
    }
    buffer = buffer_;
}

- (void *)buffer {
    return buffer;
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        name = [[coder currentName] retain];
        short formatType = [coder decodeSwappedSInt16];
        switch (formatType) {
            case 1:
                [self decodeType1SndFromCoder:coder];
                break;
            case 2:
                [self decodeType2SndFromCoder:coder];
                break;
            default:
                @throw [NSString stringWithFormat:@"Unhandled audio format [%h]", formatType];
                break;
        }
    }
    return self;
}

- (void) decodeType1SndFromCoder:(ResUnarchiver *)coder {
    short typeCount = [coder decodeSwappedSInt16];
    if (typeCount != 1) {
        @throw @"Sound containing more than 1 data type are not supported";
    }
    short dataFormat = [coder decodeSwappedSInt16];
    if (dataFormat != SAMPLEDSYNTH) {
        @throw @"Unsupported synth format";
    }
    unsigned int initOpts = [coder decodeSwappedSInt32] & 0xffffffdf;
    //Assume either nothing or mono and discard the 0x20 flag
    if (!(initOpts == 0 || initOpts == INITMONO) ) {
        @throw @"Unhandled initialization options";
    }
    short commandCount = [coder decodeSwappedSInt16];
    //Only handle sounds with one command
    if (commandCount != 1) {
        @throw @"Multiple commands unsupported";
    }
    
    unsigned short command = [coder decodeSwappedUInt16];
    if (command != 0x8051) {
        @throw [NSString stringWithFormat:@"Unhandled sound command %4x", command];
    }
    
//    short param1 = [coder decodeSInt16];//param 1 is unused
    [coder skip:2u];
    unsigned int headerLocation = [coder decodeSwappedUInt32];
    [coder seek:headerLocation];
    
    unsigned int bufferOffset = [coder decodeUInt32];
#pragma unused(bufferOffset)
    bufferLength = [coder decodeSwappedUInt32];

    unsigned int sampleRateIn = [coder decodeSwappedUInt32];

    switch (sampleRateIn) {
        case RATE32KHZ:
            sampleRate = 32000;
            break;
        case RATE22050HZ:
            sampleRate = 22050;
            break;
        case RATE22KHZ:
            sampleRate = 22000;
            break;
        case RATE16KHZ:
            sampleRate = 16000;
            break;
        case RATE11KHZ:
            sampleRate = 11000;
            break;
        case RATE11025HZ:
            sampleRate = 11025;
            break;
        case RATE8KHZ:
            sampleRate = 8000;
            break;
        default:
            @throw [NSString stringWithFormat:@"Unsupported rate 0x%08x", sampleRate];
            break;
    }
    int loopStart = [coder decodeSwappedSInt32];
    int loopEnd = [coder decodeSwappedSInt32];
    char sampleEncoding = [coder decodeSInt8];
    char baseFreq = [coder decodeSInt8];
    #pragma unused(loopStart, loopEnd, sampleEncoding, baseFreq)
    //#define kMiddleC 60
    buffer = malloc(bufferLength);
    [coder readBytes:buffer length:bufferLength];
}

- (void) decodeType2SndFromCoder:(ResUnarchiver *)coder {
    short refCount = [coder decodeSInt16];
    if (refCount != 0) {
        NSLog(@"NOTICE: nonzero refcount in snd data");
    }
    short commandCount = [coder decodeSwappedSInt16];
    if (commandCount != 1) {
        @throw [NSString stringWithFormat:@"snd  resources with more than one command are unspported [%hi]", commandCount];
    }
    unsigned short command = [coder decodeSwappedUInt16];
    if (command != 0x8051) {
        @throw [NSString stringWithFormat:@"Unhandled sound command %4x", command];
    }
    
//    short param1 = [coder decodeSInt16];//param 1 is unused
    [coder skip:2u];
    unsigned int headerLocation = [coder decodeSwappedUInt32];
    [coder seek:headerLocation];
    
    unsigned int bufferOffset = [coder decodeUInt32];
#pragma unused(bufferOffset)
    bufferLength = [coder decodeSwappedUInt32];
    unsigned int sampleRateIn = [coder decodeSwappedUInt32];

    switch (sampleRateIn) {
        case RATE32KHZ:
            sampleRate = 32000;
            break;
        case RATE22050HZ:
            sampleRate = 22050;
            break;
        case RATE22KHZ:
            sampleRate = 22000;
            break;
        case RATE16KHZ:
            sampleRate = 16000;
            break;
        case RATE11KHZ:
            sampleRate = 11000;
            break;
        case RATE11025HZ:
            sampleRate = 11025;
            break;
        case RATE8KHZ:
            sampleRate = 8000;
            break;
        default:
            @throw [NSString stringWithFormat:@"Unsupported rate 0x%08x", sampleRate];
            break;
    }
    int loopStart = [coder decodeSwappedSInt32];
    int loopEnd = [coder decodeSwappedSInt32];
    char sampleEncoding = [coder decodeSInt8];
    char baseFreq = [coder decodeSInt8];
    #pragma unused(loopStart, loopEnd, sampleEncoding, baseFreq)
//#define kMiddleC 60
    buffer = malloc(bufferLength);
    [coder readBytes:buffer length:bufferLength];
}


- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder setName:name];

    [coder encodeSInt16:1];//format 1
    [coder encodeSInt16:1];//1 data type encoded
    [coder encodeSInt16:SAMPLEDSYNTH];//data format
    [coder encodeUInt32:INITMONO];//initialization options
    [coder encodeSInt16:1];//1 command
    [coder encodeUInt16:0x8051];//bufferCommand
    [coder skip:2];//skip param 1
    [coder encodeUInt32:SOUNDHEADERLOC];//param 2 (the location of the sound header)
    [coder encodeUInt32:0];//no offset
    
    [coder encodeUInt32:bufferLength];

    switch (sampleRate) {
        case 32000:
            [coder encodeUInt32:RATE32KHZ];
        case 22050:
            [coder encodeUInt32:RATE22050HZ];
        case 22000:
            [coder encodeUInt32:RATE22KHZ];
        case 16000:
            [coder encodeUInt32:RATE16KHZ];
        case 11000:
            [coder encodeUInt32:RATE11KHZ];
        case 11025:
            [coder encodeUInt32:RATE11025HZ];
        case 8000:
            [coder encodeUInt32:RATE8KHZ];
            break;
        default:
            @throw [NSString stringWithFormat:@"Unsupported rate %i", sampleRate];
            break;
    }
    
    //I don't know what to do here
    [coder encodeSInt32:1];//loop start
    [coder encodeSInt32:2];//loop end
    
    [coder encodeSInt8:0];//sample encoding I dunno what it does
    [coder encodeUInt8:kMiddleC];//base frequency
    [coder writeBytes:buffer length:bufferLength];
}


+ (NSString *)typeKey {
    return @"snd";
}

+ (ResType)resType {
    return 'snd ';
}

+ (BOOL)isPacked {
    return NO;
}


- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super init];
    if (self) {
        //Work out the file path
        name = [[coder decodeString] retain];
        NSString *fileName = [coder baseDir];
        fileName = [fileName stringByAppendingPathComponent:@"Sounds"];
        fileName = [fileName stringByAppendingPathComponent:name];
        fileName = [fileName stringByAppendingPathExtension:@"ogg"];//Hardcoded

        FILE *file = fopen([fileName UTF8String], "rb");
        if (file == NULL) {
            @throw @"File could not be opened";
        }
        //A bunch of NSDatas go here
        ///they will be mushed together at the end
        NSMutableArray *pcmBlocks = [NSMutableArray array];

        char *rbuffer;
        int byteCount;
        const int bufferSize = 4096;
        int totalLength = 0;
        ogg_sync_state oy;
        ogg_stream_state os;
        ogg_page og;
        ogg_packet op;

        vorbis_info vi;
        vorbis_comment vc;
        vorbis_dsp_state v;
        vorbis_block vb;

        //begin ogg
        ogg_sync_init(&oy);
        while (1) {//Read through the data in blocks
            rbuffer = ogg_sync_buffer(&oy, bufferSize);
            byteCount = fread(rbuffer, 1, bufferSize, file);
            ogg_sync_wrote(&oy, byteCount);

            if (ogg_sync_pageout(&oy, &og) != 1) {
                if (byteCount < bufferSize) break;//out of data, end the loop
                //else
                @throw @"An error has occured with the ogg decoder";
            }

            //set up the stream
            ogg_stream_init(&os, ogg_page_serialno(&og));

            //begin vorbis
            vorbis_info_init(&vi);
            vorbis_comment_init(&vc);
            if (ogg_stream_pagein(&os, &og) < 0) {
                @throw @"Ogg Stream Error";
            }

            if (ogg_stream_packetout(&os, &op) != 1) {
                @throw @"Error reading ogg header packet";
            }

            if (vorbis_synthesis_headerin(&vi, &vc, &op) < 0) {
                @throw @"Stream does not contain vorbis data";
            }

            //read the other vorbis headers
            int i = 0;
            while (i < 2) {
                while (i < 2) {
                    int result = ogg_sync_pageout(&oy, &og);
                    if (result == 0) break;//get more data
                    if (result == 1) {
                        ogg_stream_pagein(&os, &og);
                        while (i < 2) {
                            result = ogg_stream_packetout(&os, &op);
                            if (result == 0) break;
                            if (result < 0) {
                                @throw @"Corrupt secondary header";
                            }
                            result = vorbis_synthesis_headerin(&vi, &vc, &op);
                            if (result < 0) {
                                @throw @"Corrupt secondary header";
                            }
                            i++;
                        }
                    }
                }
                //get more data
                rbuffer = ogg_sync_buffer(&oy, bufferSize);
                byteCount = fread(rbuffer, 1, byteCount, file);
                if (byteCount == 0 && i < 2) {
                    @throw @"Missing vorbis headers";
                }
                ogg_sync_wrote(&oy, byteCount);

            }

            assert(sampleRate == 0 || sampleRate == vi.rate);
            sampleRate = vi.rate;

//            if (vi.channels > 1) {
//                NSLog(@"Multiple audio channels found in stream [%i]. All additional channels will be discarded", vi.channels);
//            }
            int convSize = 4096 / vi.channels;
            if (vorbis_synthesis_init(&v, &vi) == 0) {
                vorbis_block_init(&v, &vb);
                int eos = 0;
                //The REAL decode loop
                while (!eos) {
                    while (!eos) {
                        int result = ogg_sync_pageout(&oy, &og);
                        if (result == 0) break;//get more data
                        if (result < 0) {
//                            NSLog(@"ERROR: Corrupt bitstream data, will continue...");
                        } else {
                            ogg_stream_pagein(&os, &og);
                            while (1) {
                                result = ogg_stream_packetout(&os, &op);
                                if (result == 0) break;//more data
                                if (result < 0) {
                                    //corrupt data
                                    //ignore
                                    NSLog(@"Skipping corrupt data");
                                } else {
                                    float **pcm;
                                    int samples;
                                    if (vorbis_synthesis(&vb, &op) == 0) {//read
                                        vorbis_synthesis_blockin(&v, &vb);
                                    }
                                    //read samples and convert to unsigned 8bit integer
                                    //TODO: make AudioConverter do this
                                    while ((samples = vorbis_synthesis_pcmout(&v, &pcm)) > 0) {
                                        int bout = (samples<convSize?samples:convSize);
                                        totalLength += bout;
                                        unsigned char *tbuffer = malloc(bout);
                                        for (int j = 0; j < bout; j++) {
                                            //convert range to 0-255
                                            int tmp = (int)floor(pcm[0][j] * 128.0f);
                                            tmp += 128;
                                            //fix clipping
                                            if (tmp < 0) tmp = 0;
                                            if (tmp >= 255) tmp = 255;
                                            tbuffer[j] = (unsigned char)tmp;
                                        }
                                        [pcmBlocks addObject:[NSData dataWithBytes:tbuffer length:bout]];
                                        free(tbuffer);
                                        vorbis_synthesis_read(&v, bout);
                                    }
                                }
                            }
                            if (ogg_page_eos(&og)) eos = 1;
                        }
                    }
                    if (!eos) {
                        rbuffer = ogg_sync_buffer(&oy, bufferSize);
                        byteCount = fread(rbuffer, 1, bufferSize, file);
                        ogg_sync_wrote(&oy, byteCount);
                        if (byteCount == 0) eos = 1;
                    }
                }
                vorbis_block_clear(&vb);
                vorbis_dsp_clear(&v);
            } else {
                @throw @"Corrupt vorbis header";
            }


            ogg_stream_clear(&os);
            vorbis_comment_clear(&vc);
            vorbis_info_clear(&vi);
        }
        ogg_sync_clear(&oy);
        fclose(file);

        [self setBuffer:malloc(totalLength)];
        int cursor = 0;
        for (NSData *block in pcmBlocks) {
            [block getBytes:buffer+cursor];
            cursor += [block length];
        }
        bufferLength = cursor;
        assert(bufferLength > 0);
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:name];
    //Can't really write the files out with the old format, so skip.
    if (![coder isPluginFormat]) return;

    NSString *fileName = [coder baseDir];
    fileName = [fileName stringByAppendingPathComponent:@"Sounds"];
    fileName = [fileName stringByAppendingPathComponent:[name stringByReplacingOccurrencesOfString:@"/" withString:@":"]];
    fileName = [fileName stringByAppendingPathExtension:@"ogg"];//Hardcoded

    FILE *file = fopen([fileName UTF8String], "wb");
    if (file == NULL) {
        @throw @"Could not open file for writing.";
    }

    vorbis_info vi;
    vorbis_comment vc;
    vorbis_dsp_state vd;
    vorbis_block vb;
    ogg_stream_state os;
    ogg_page og;
    ogg_packet op;

    int eos = 0, ret;
    @try {
        vorbis_info_init(&vi);
        //Because the other supported format is lossless I see no reason not to go for max quality
        ret = vorbis_encode_init_vbr(&vi, 1, sampleRate, 1.0f);
        if (ret) @throw @"Bad Mode";

        vorbis_comment_init(&vc);
        vorbis_comment_add_tag(&vc, "ENCODER", "Athena");

        vorbis_analysis_init(&vd, &vi);
        vorbis_block_init(&vd, &vb);

        srand(time(NULL));
        ogg_stream_init(&os, rand());

        {
            ogg_packet header;
            ogg_packet header_comm;
            ogg_packet header_code;

            vorbis_analysis_headerout(&vd, &vc, &header, &header_comm, &header_code);
            ogg_stream_packetin(&os, &header);
            ogg_stream_packetin(&os, &header_comm);
            ogg_stream_packetin(&os, &header_code);

            while (!eos) {
                int result = ogg_stream_flush(&os, &og);
                if (result == 0) break;
                fwrite(og.header, 1, og.header_len, file);
                fwrite(og.body, 1, og.body_len, file);
            }
        }

        const long READ_LENGTH = 4096;
        void *cursor = buffer;
        long counter = 0;
        while (!eos) {
//            long i;
            long bytes;
            //advance the cursor
            if (counter + READ_LENGTH <= bufferLength) {
                cursor = buffer + counter;
                counter += READ_LENGTH;
                bytes = READ_LENGTH;
            } else if (counter == bufferLength) {
                bytes = 0;
            } else if (counter + READ_LENGTH > bufferLength) {
                cursor = buffer+counter;
                bytes = bufferLength - counter;
                counter = bufferLength;
            }

            if (bytes == 0) {
                vorbis_analysis_wrote(&vd, 0);
            } else {
                float **floatbuffer = vorbis_analysis_buffer(&vd, READ_LENGTH);

                int i;
                for (i = 0; i < bytes; i++) {
                    floatbuffer[0][i] = (((unsigned char *)cursor)[i])/128.0f - 1.0f;
                }
                vorbis_analysis_wrote(&vd, i);
            }

            while (vorbis_analysis_blockout(&vd, &vb) == 1) {
                vorbis_analysis(&vb, NULL);
                vorbis_bitrate_addblock(&vb);

                while (vorbis_bitrate_flushpacket(&vd, &op)) {
                    ogg_stream_packetin(&os, &op);
                    while (!eos) {
                        int result = ogg_stream_pageout(&os, &og);
                        if (result == 0) break;
                        fwrite(og.header, 1, og.header_len, file);
                        fwrite(og.body, 1, og.body_len, file);
                        if (ogg_page_eos(&og)) eos = 1;
                    }
                }
            }
        }
    }
    @catch (NSString *exception) {
        NSLog(@"Exception: %@", exception);
        @throw @"Encoding Error";
    }
    @finally {
        ogg_stream_clear(&os);
        vorbis_block_clear(&vb);
        vorbis_dsp_clear(&vd);
        vorbis_comment_clear(&vc);
        vorbis_info_clear(&vi);
        fclose(file);
    }

}

+ (BOOL) isComposite {
    return NO;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
