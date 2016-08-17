//
//  IMSDKBugly.h
//  Rqd
//
//  Created by mqq on 14/12/4.
//  Copyright (c) 2014年 tencent.com. All rights reserved.
//

@interface IMSDKBugly : NSObject

/**
 *    @brief  自定义异常捕获回调Block
 *
 *    @param e 返回捕获的NSException对象，如果不是ObjC的异常，则为nil
 */
typedef void(^IMSDKBuglyUncaughtExceptionHandler)(NSException * e);

/**
 *    @brief  设置崩溃发生时的回调block
 *
 *    @param handler 崩溃发生时回调
 */
+ (void)setUncaughtExceptionHandler:(IMSDKBuglyUncaughtExceptionHandler) handler;

/**
 *    @brief  设置是否开启打印sdk的log信息，默认关闭。在startWithAppId:方法之前调用
 *
 *    @param enable 设置为YES，则打印sdk的log信息，在Release产品中请务必设置为NO
 */
+ (void)enableLog:(BOOL)enable;

/**
 *  开启卡顿监控上报功能，默认开启.
 *  你可以在初始化方法之前调用并配置.
 *
 *  注意，只有当后台策略指定卡顿监控开启时，功能才会真正启用。如果你想后台开启此功能的策略，请联系客服QQ
 *
 *  @param 是否开启监控，默认开启
 *  @param 是否开启上报，默认开启
 */
+ (void)enableBlockMonitor:(BOOL) monitor autoReport:(BOOL) reporter;

/**
 *    @brief  初始化IMSDKBugly崩溃上报，在application:didFinishLaunchingWithOptions:方法中调用
 *
 *    @param appId 应用的唯一标识，在IMSDKBugly网站注册应用后获取
 */
+ (void)startWithAppId:(NSString *)appId;

/**
 *    @brief  初始化IMSDKBugly崩溃上报，在application:didFinishLaunchingWithOptions:方法中调用
 *
 *    @param appId   应用的唯一标识，在IMSDKBugly网站注册应用后获取
 *    @param channel (可选)渠道名，如“app store”
 */
+ (void)startWithAppId:(NSString *)appId channel:(NSString *)channel;

/**
 *    @brief  手动上报捕获的ObjC异常
 *
 *    @param anException 已处理定异常对象
 *    @param aMessage    附带描述信息
 */
+ (void)reportException:(NSException *) anException message:(NSString *) aMessage;

/**
 *    @brief  设置渠道名
 *
 *    @param channel 渠道名
 */
+ (void)setChannel:(NSString *)channel;

/**
 *    @brief  设置应用版本信息
 *
 *    @param version 版本信息, 默认版本为CFBundleShortVersionString(CFBundleVersion)
 */
+ (void)setBundleVersion:(NSString *)version;

/**
 *    @brief  设置应用版本信息和build号
 *
 *    @param version Version信息, Bundle version string, short -> CFBundleShortVersionString
 *    @param build   Build信息, Bundle version -> CFBundleVersion
 */
+ (void)setBundleVersion:(NSString *)version build:(NSString *)build;

/**
 *    @brief  设置用户唯一标识，在初始化方法之后调用
 *
 *    @param userId 用户唯一标识
 */
+ (void)setUserId:(NSString *)userId;

/**
 *    @brief  添加崩溃发生时附带的上报信息，不支持中文字符
 *
 *    @param key   附带信息的名称
 *    @param value 附带信息的值
 */
+ (void)setUserData:(NSString *)key value:(NSString *)value;

/**
 *    @brief  添加崩溃发生后附带上报的数据，如App记录的关键流程日志信息
 *
 *    @param data 附件内容，字符长度限制小于10*1024
 */
+ (void)setAttachData:(NSString *) data;

/**
 *    @brief  设置场景标签, 如支付、后台等
 *
 *    @param sceneId 自定义的场景标签Id, 可以在服务平台页面进行配置
 */
+ (void)setScene:(NSUInteger) sceneId;

/**
 *    @brief  添加场景关键数据
 *
 *    @param value 内容, 最大长度限定为200字符
 *    @param key 自定义key(只允许字母和数字), 支持在服务平台页面进行检索
 */
+ (void)addSceneValue:(NSString *) value forKey:(NSString *) key;

/**
 *    @brief  设置设备的唯一标识
 *
 *    @param deviceId 设备唯一标识
 */
+ (void)setDeviceId:(NSString *)deviceId;

/**
 *    @brief  设置应用的标识
 *
 *    @param bundleId 应用标识
 */
+ (void)setBundleId:(NSString *)bundleId;

/**
 *    @brief  设置是否开启崩溃合并上报和进程内堆栈还原功能，默认不开启
 *
 *    @param enableMerge  设置为YES，则崩溃会自动合并，同一崩溃在一天内只会上报一次
 *    @param enableSymbol 设置为YES，则崩溃的堆栈地址会还原成符号后上报
 */
+ (void)enableCrashMerge:(BOOL)enableMerge symbolicate:(BOOL)enableSymbol;

/**
 *  是否开启NSException的异常上报, 默认开启.
 *  你可以在初始化方法之前调用并配置.
 *
 *  @param enable
 */
+ (void)enableNSExceptionReporter:(BOOL) enable;

/**
 *  是否开启信号错误的上报，默认开启.
 *  你可以在初始化方法之前调用并配置.
 *
 *  @param enable
 */
+ (void)enableSignalErrorReporter:(BOOL) enable;

/**
 *    @brief  主动上报崩溃信息
 *
 *    @param name      崩溃错误类型
 *    @param reason    崩溃错误原因
 *    @param callStack 崩溃错误堆栈
 */
+ (void)reportUnityExceptionWithName:(NSString *)name reason:(NSString *)reason stack:(NSString *)callStack;

@end
