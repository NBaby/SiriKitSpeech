#SiriKit特性探究与实践(一)

##背景
***
最近公司希望引进AI相关技术，因此最近对这方面做了些预研。之前已经预研了CoreML图像处理相关内容，所以这次打算看看语音识别相关的内容，先从apple自带的框架下手，为后续的产品开发作技术储备。

本篇文章主要介绍下Speech的语音识别功能。

##iOS 10 的 Speech 框架
***
###介绍
在2016年的WWDC上，apple公司郑重发布了语音识别框架SpeechFramework，有了这个框架，开发者可以十分容易的为自己的App添加语音识别功能，不需要再依赖于其他第三方的语音识别服务，并且，Apple的Siri应用的强大也证明了Apple的语音服务是足够强大的，不通过第三方，也大大增强了用户的安全性。

###官方链接
[官方教程](https://developer.apple.com/videos/play/wwdc2016/509/)

##实践
***
###准备工作
要实现语音识别，就需要先给应用授权。在info.plist添加权限描述。
![语音权限描述.png](https://upload-images.jianshu.io/upload_images/2368050-3bd70dcb3ae4459d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后需要添加speech框架头文件`#import <AVFoundation/AVFoundation.h>`和`#import <Speech/Speech.h>`

接着是进入页面做好权限请求：
![权限请求.png](https://upload-images.jianshu.io/upload_images/2368050-a4f9aab8ab92e69c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

做好这些就可以进行后续开发工作了。

###相关类介绍

* **AVAudioSession**

该类是录音的一些基本环境配置。
![录音环境配置.png](https://upload-images.jianshu.io/upload_images/2368050-410cbea71e0f62d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`AVAudioSessionCategoryRecord` : 设置录音(要录制说的话)

`AVAudioSessionModeMeasurement`:减少系统提供信号对应用程序输入和/或输出音频信号的影响

`AVAudioSessionCategoryOptionDuckOthers`: 在实时通话的场景，降低别的声音。比如QQ音乐，当进行视频通话的时候，会发现QQ音乐自动声音降低了，此时就是通过设置这个选项来对其他音乐App进行了压制

`AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation`:判断当前是否有其他App在播放音频

* **AVAudioEngine**

该类是语音识别引擎，主要负责用户语音的转化成数据流，存储到buffer中。

* **SFSpeechAudioBufferRecognitionRequest**

这个类有点类似httpRequest，就是一个语音解析请求的封装，里面了包含了要解析语音的基本信息。SFSpeechRecognizer可以根据他生成解析任务SFSpeechRecognitionTask。

* **SFSpeechRecognizer**

语音识别类，主要负责将传进去的语音识别出具体的文字，在使用前需要进行一些简单的配置：
![SFSpeechRecognizer配置.png](https://upload-images.jianshu.io/upload_images/2368050-54975c64364e6cdd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* **SFSpeechRecognitionTask**

由 SFSpeechRecognizer根据SFSpeechAudioBufferRecognitionRequest生成任务，然后通过代理返回处理的进度。代理大概有以下回调，回调的时机都已经在注释里展示

![代理回调.png](https://upload-images.jianshu.io/upload_images/2368050-d6d3c4e9dff2c4d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###实现即时语音转文字功能
有了上面的铺垫，就可以很容易实现一个即时语音转文字功能，大致流程如下：

![流程图.png](https://upload-images.jianshu.io/upload_images/2368050-e15b1b8ccb6336ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###Show Me The Code

[demo地址](https://github.com/NBaby/SiriKitSpeech)

##总结
总体来说，语音识别率还是比较高的，而且性能给常强cpu也只用1%左右，并且可以离线使用。


