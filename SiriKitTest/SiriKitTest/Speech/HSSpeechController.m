//
//  HSSpeechController.m
//  SiriKitTest
//
//  Created by panzihao on 2019/5/30.
//  Copyright © 2019 panzihao. All rights reserved.
//

#import "HSSpeechController.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>    
@interface HSSpeechController () <SFSpeechRecognizerDelegate,SFSpeechRecognitionTaskDelegate>

@property (strong,nonatomic) AVAudioSession * audioSession;

@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest * speechRequest;

@property (strong, nonatomic) SFSpeechRecognizer * recognizer;

/**
 语音识别引擎
 */
@property (strong, nonatomic) AVAudioEngine * audioEngine;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation HSSpeechController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
}

- (void)setup{
    //请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        NSLog(@"status %@", status == SFSpeechRecognizerAuthorizationStatusAuthorized ? @"语音识别权限授权成功" : @"语音识别权限授权失败");
    }];
    
    //设置语音识别参数
    [self.audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [self.audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (IBAction)tapSpeechBtn:(id)sender {
    NSLog(@"***开始讲话");
    
    self.speechRequest = nil;
    [self.recognizer recognitionTaskWithRequest:self.speechRequest delegate:self];
    __weak typeof(self) weakSelf = self;
     AVAudioFormat *recordingFormat = [[self.audioEngine inputNode] outputFormatForBus:0];
    [[self.audioEngine inputNode] installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.speechRequest appendAudioPCMBuffer:buffer];
         NSLog(@"***拼接语音");
    }];
   
    [self.audioEngine prepare];
    NSError *error = nil;
    if (![self.audioEngine startAndReturnError:&error]) {
        NSLog(@"%@",error.userInfo);
    };
    
}
- (IBAction)speechDidFinish:(id)sender {
    NSLog(@"***结束讲话");
    [self releaseEngine];
    [self.speechRequest endAudio];
}

- (void)releaseEngine{
    [[self.audioEngine inputNode] removeTapOnBus:0];
    
    [self.audioEngine stop];

}


#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        NSLog(@"***录音请求被激活");
    }
    else {
        NSLog(@"***录音请求变成未激活");
    }
    
}
#pragma mark - SFSpeechRecognitionTaskDelegate

- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task{
     NSLog(@"***接受到task任务请求");
}


- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription{
    NSLog(@"***语音识别过程中调用,%@",transcription.formattedString);
    self.textLabel.text = transcription.formattedString;
}

- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult{
    NSLog(@"***最终识别调用");
    self.textLabel.text = recognitionResult.bestTranscription.formattedString;
    
}

- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task{
    NSLog(@"***语音解析完成");
}

- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task{
    NSLog(@"***语音解析被取消");
}

- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully{
    if (successfully){
        NSLog(@"***语音解析流程结束，没有错误");
    }
    else {
         NSLog(@"***语音解析流程结束，有错误");
    }
}


#pragma mark - getting & setting

- (AVAudioSession *)audioSession{
    if (_audioSession == nil) {
        _audioSession = [AVAudioSession sharedInstance];
    }
    return _audioSession;
}

- (SFSpeechAudioBufferRecognitionRequest *)speechRequest{
    if (_speechRequest == nil) {
        _speechRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        _speechRequest.shouldReportPartialResults = YES;
    }
    return _speechRequest;
}

- (SFSpeechRecognizer *)recognizer{
    if (_recognizer == nil) {
        _recognizer = [[SFSpeechRecognizer alloc] init];
        // 设置语言为中文
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _recognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
        _recognizer.delegate = self;
    }
    return _recognizer;
}

- (AVAudioEngine *)audioEngine{
    if (_audioEngine == nil) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
@end
