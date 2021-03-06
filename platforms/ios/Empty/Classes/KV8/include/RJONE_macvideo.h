#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <mach/mach_time.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


#define MAX_NUM_CH_VIEW_DECODER  64
#define TYPE_SET_DEV_TIMEZONE_RESP  0x10001

typedef struct
{
    unsigned char *data;    //进入解码的数据
    int datasize;   //数据长度
    int Channel;   //进入解码的通道
}RJONE_DecodeData;

typedef struct
{
    void *   glview;
}RJONE_GLVIEW;


typedef struct
{
    int width;
    int height;
}RJONE_VIDEO_SIZE;


typedef struct
{
    UInt8 *yuvBuf;   // 放yuv
}RJONE_YUVBUFFER;

RJONE_GLVIEW  rjoneglview[MAX_NUM_CH_VIEW_DECODER];
RJONE_VIDEO_SIZE rjonesize[MAX_NUM_CH_VIEW_DECODER];
RJONE_YUVBUFFER rjoneyuvdata[MAX_NUM_CH_VIEW_DECODER];

@protocol RJONE_macvideoDelegate <NSObject>


@required

-(void)GetImage:(UIImage*)img;

@end

@interface RJONE_macvideo : NSObject

@property (retain, nonatomic) NSTimer *AudioPlayTimer;
@property (strong,nonatomic) NSString * filepath;

-(void) setDelegate:(id<RJONE_macvideoDelegate>)delg;
-(void) StartShot;
- (void)saveImageToFile;


-(void)SettView:(UIView*) view andImg:(UIImageView *) imageview;
-(void)RJONE_ChangeView:(CGRect) frame;
-(BOOL)RJONE_InitDecode:(int) width  andHe:(int) height andFrame:(CGRect) frame;
-(BOOL)RJONE_ChangeVideoSize:(int) width andheight:(int)height;
-(BOOL)RJONE_UninitDecode;
-(int)RJONE_H264DecodeData:(unsigned char*)data anddatasize:(int) length;


-(void)SettView2:(UIView*) view andImg:(UIImageView *) imageview;
-(void)RJONE_ChangeView2:(CGRect) frame;
-(BOOL)RJONE_InitDecode2:(int) width  andHe:(int) height andFrame:(CGRect) frame;
-(BOOL)RJONE_UninitDecode2;
-(int)RJONE_H264DecodeData2:(unsigned char*)data anddatasize:(int) length;



/////speex
- (void)RJONE_openAudio1:(int)quality;
- (NSData *)RJONE_encode1:(short *)pcmBuffer length:(int)lengthOfShorts;
- (int)RJONE_decode1:(Byte *)encodedBytes length:(int)lengthOfBytes output:(short *)decoded;
- (void)RJONE_close1;

- (int)AviConvertMov:(NSString *) inputfile andout:(NSString *) outputfile;


//write mp4

//int RJONE_InitMp4File(char * path, int w, int h,int isAudio,int frame);

-(void*)RJONE_InitMp4File:(NSString * )path andwidth:(int) width andheight:(int) height andisaudio:(int)isAudio andframe:(int)frame;
-(int) RJONE_StartwriteVideoFrame:(void*)handle data:(char*)videobuf length:(int)vlen;

-(int) RJONE_StartwriteAudioFrame;

//static int RJONE_writeVideoFrame(char * videobuf,int vlen);

//static int RJONE_writeAudioFrame(char * audiobuf,int alen);

-(int) RJONE_uninitMp:(void*)handle;
@end
