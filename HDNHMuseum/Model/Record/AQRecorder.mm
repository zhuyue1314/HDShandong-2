/*
 
 File: AQRecorder.mm
 Abstract: n/a
 Version: 2.5
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 
 
 */

#include "AQRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "HDDeclare.h"

static int RFID = 0;
// ____________________________________________________________________________________
// Determine the size, in bytes, of a buffer necessary to represent the supplied number
// of seconds of audio data.
int AQRecorder::ComputeRecordBufferSize(const AudioStreamBasicDescription *format, float seconds)
{
	int packets, frames, bytes = 0;
	try {
		frames = (int)ceil(seconds * format->mSampleRate);
		
		if (format->mBytesPerFrame > 0)
			bytes = frames * format->mBytesPerFrame;
		else {
			UInt32 maxPacketSize;
			if (format->mBytesPerPacket > 0)
				maxPacketSize = format->mBytesPerPacket;	// constant packet size
			else {
				UInt32 propertySize = sizeof(maxPacketSize);
				AudioQueueGetProperty(mQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize,
                                                    &propertySize);
			}
			if (format->mFramesPerPacket > 0)
				packets = frames / format->mFramesPerPacket;
			else
				packets = frames;	// worst-case scenario: 1 frame in a packet
			if (packets == 0)		// sanity check
				packets = 1;
			bytes = packets * maxPacketSize;
		}
	} catch (CAXException e) {
		char buf[256];
		fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
		return 0;
	}
	return bytes;
}
// ____________________________________________________________________________________
// AudioQueue callback function, called when an input buffers has been filled.
void AQRecorder::MyInputBufferHandler(	void *								inUserData,
                                      AudioQueueRef						inAQ,
                                      AudioQueueBufferRef					inBuffer,
                                      const AudioTimeStamp *				inStartTime,
                                      UInt32								inNumPackets,
                                      const AudioStreamPacketDescription*	inPacketDesc)
{
    
	AQRecorder *aqr = (AQRecorder *)inUserData;
	try {
		if (inNumPackets > 0)
        {
            
            int numBytes = inBuffer->mAudioDataByteSize;
            SInt16 *testBuffer = (SInt16*)inBuffer->mAudioData;
            analyse *analyser= new analyse(numBytes);

            int result =  analyser->GetFilterValueRrom1(testBuffer);
            //result = 101;
            NSLog(@"result:%d",result);
            if (![[HDDeclare sharedDeclare]autoFlag])
            {
                result=0;
                RFID =0;
            }
            if (result)
            {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
                NSString *string = [NSString stringWithFormat:@"%d",result];
                NSLog(@"AQRecord:%@",string);
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:string forKey:@"content"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"result" object:nil userInfo:dic];
                [pool release];
            }
            if ((result != RFID) && result)
            {
                RFID = result;
                //NSLog(@"hfjaskhfls");
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
                NSString *string = [NSString stringWithFormat:@"%d",result];
                NSLog(@"RFID:%@",string);
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:string forKey:@"content"];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"RFID" object:nil userInfo:dic];
                [pool release];
            }
            //delete a;
            delete analyser;
        }
		
		// if we're not stopping, re-enqueue the buffe so that it gets filled again
		if (aqr->IsRunning())
			AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
	} catch (CAXException e) {
		char buf[256];
		fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
	}
}

AQRecorder::AQRecorder()
{
	mIsRunning = false;
	mRecordPacket = 0;
}

AQRecorder::~AQRecorder()
{
	AudioQueueDispose(mQueue, TRUE);
	AudioFileClose(mRecordFile);
}
void AQRecorder::SetupAudioFormat(UInt32 inFormatID)
{

    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    
    //UInt32 audioRoute = kAudioSessionOverrideAudioRoute_None;
    //UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
    
    //UInt32 doChangeDefaultRoute = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    AudioSessionSetActive(true);
    
    
	memset(&mRecordFormat, 0, sizeof(mRecordFormat));
    
	UInt32 size = sizeof(mRecordFormat.mSampleRate);
	AudioSessionGetProperty(	kAudioSessionProperty_CurrentHardwareSampleRate,
                                          &size,
                                          &mRecordFormat.mSampleRate);
    
	size = sizeof(mRecordFormat.mChannelsPerFrame);
	AudioSessionGetProperty(	kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                                          &size,
                                          &mRecordFormat.mChannelsPerFrame);
    
	mRecordFormat.mFormatID = inFormatID;
	if (inFormatID == kAudioFormatLinearPCM)
	{        
        mRecordFormat.mSampleRate = 16000;
        mRecordFormat.mFormatFlags =  kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        mRecordFormat.mChannelsPerFrame = 1;
		mRecordFormat.mBitsPerChannel = 16;
		mRecordFormat.mBytesPerPacket = mRecordFormat.mBytesPerFrame = (mRecordFormat.mBitsPerChannel / 8) * mRecordFormat.mChannelsPerFrame;
		mRecordFormat.mFramesPerPacket = 1;
	}
}

void AQRecorder::StartRecord()
{
	int i, bufferByteSize;
    try {
        
		SetupAudioFormat(kAudioFormatLinearPCM);
		AudioQueueNewInput(
                                         &mRecordFormat,
                                         MyInputBufferHandler,
                                         this /* userData */,
                                         NULL /* run loop */, NULL /* run loop mode */,
                                         0 /* flags */, &mQueue);
		mRecordPacket = 0;
        // allocate and enqueue buffers
		bufferByteSize = ComputeRecordBufferSize(&mRecordFormat, kBufferDurationSeconds);	// enough bytes for half a second
		for (i = 0; i < kNumberRecordBuffers; ++i)
        {
			AudioQueueAllocateBuffer(mQueue, bufferByteSize, &mBuffers[i]);
			AudioQueueEnqueueBuffer(mQueue, mBuffers[i], 0, NULL);
		}
		// start the queue
		mIsRunning = true;
		AudioQueueStart(mQueue, NULL);
	}
	catch (CAXException e) {
		char buf[256];
		fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
	}
	catch (...) {
		fprintf(stderr, "An unknown error occurred\n");;
	}	
    
}

void AQRecorder::StopRecord()
{
	mIsRunning = false;
	AudioQueueStop(mQueue, true);	
	AudioQueueDispose(mQueue, true);
	AudioFileClose(mRecordFile);
}

