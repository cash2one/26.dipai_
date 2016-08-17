//
//  TIMManager.h
//  ImSDK
//
//  Created by bodeng on 28/1/15.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#ifndef ImSDK_TIMManager_h
#define ImSDK_TIMManager_h

#import "TIMComm.h"
#import "TIMMessage.h"
#import "TIMConversation.h"
#import "TIMCallback.h"

/////////////////////////////////////////////////////////
///  Tencent 开放 SDK API
/////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////
///  回调协议
/////////////////////////////////////////////////////////

/**
 *  消息回调
 */
@protocol TIMMessageListener <NSObject>
@optional

/**
 *  新消息通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray*) msgs;
@end


/*
@protocol TIMConversationRefreshListener <NSObject>
@optional
- (void) onRefreshConversation;
@end
*/

/**
 *  连接通知回调
 */
@protocol TIMConnListener <NSObject>
@optional

/**
 *  网络连接成功
 */
- (void)onConnSucc;

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err;

/**
 *  网络连接断开
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err;

@end


/**
 *  用户在线状态通知
 */
@protocol TIMUserStatusListener <NSObject>
@optional
/**
 *  踢下线通知
 */
- (void)onForceOffline;

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err;
@end


/**
 *  通讯管理
 */
@interface TIMManager : NSObject


/**
 *  获取管理器实例
 *
 *  @return 管理器实例
 */
+(TIMManager*)sharedInstance;

/**
 *  初始化SDK,第三方托管账号不能使用该接口初始化
 *
 *  @return 0 成功
 */
-(int) initSdk;

/**
 *  初始化SDK,第三方托管账号必须使用该接口初始化
 *
 * @param sdkAppId    用户标识接入SDK的应用ID
 * @param accountType 用户的账号类型
 *  @return 0 成功
 */
-(int) initSdk:(int)sdkAppId accountType:(NSString *)accountType;

/**
 *  登陆
 *
 *  @param param 登陆参数
 *  @param succ  成功回调
 *  @param fail  失败回调
 *
 *  @return 0 请求成功
 */
-(int) login: (TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail;

/**
 *  获取当前登陆的用户
 *
 *  @return 如果登陆返回用户的identifier，如果未登录返回nil
 */
-(NSString*) getLoginUser;

/**
 *  登陆
 *
 *  @param param 登陆参数
 *  @param cb    回调
 *
 *  @return 0 登陆请求发送成功，等待回调
 */
-(int) login: (TIMLoginParam *)param cb:(id<TIMCallback>)cb;

/**
 *  登出
 *
 *  @param succ 成功回调，登出成功
 *  @param fail 失败回调，返回错误吗和错误信息
 *
 *  @return 0 发送登出包成功，等待回调
 */
-(int) logout:(TIMLoginSucc)succ fail:(TIMFail)fail;

/**
 *  登出
 *
 *  @deprecated 使用logout:fail 替代.
 *
 *  @return 0 成功
 */
-(int) logout;


/**
 *  获取会话
 *
 *  @param type 会话类型，TIM_C2C 表示单聊 TIM_GROUP 表示群聊
 *  @param receiver C2C 为对方用户 identifier， GROUP 为群组Id
 *
 *  @return 会话对象
 */
-(TIMConversation*) getConversation: (TIMConversationType)type receiver:(NSString *)receiver;

/**
 *  删除会话
 *
 *  @param type 会话类型，TIM_C2C 表示单聊 TIM_GROUP 表示群聊
 *  @param receiver    用户identifier 或者 群组Id
 *
 *  @return TRUE:删除成功  FALSE:删除失败
 */
-(BOOL) deleteConversation:(TIMConversationType)type receiver:(NSString*) receiver;

/**
 *  设置消息回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setMessageListener: (id<TIMMessageListener>)listener;
- (id<TIMMessageListener>)messageListener;

/**
 *  设置连接通知回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setConnListener: (id<TIMConnListener>)listener;

/**
 * 获取网络状态
 */
-(TIMNetworkStatus) networkStatus;

/**
 *  获取会话数量
 *
 *  @return 会话数量
 */
-(int) ConversationCount;

/**
 *  通过索引获取会话
 *
 *  @param index 索引
 *
 *  @return 返回对应的会话
 */
- (TIMConversation *)getConversationByIndex:(int)index;

/**
 *  设置环境（在InitSdk之前调用）
 *
 *  @param env  0 正式环境（默认）
 *              1 测试环境
 *              2 beta 环境
 */
-(void)setEnv:(int)env;



/**
 *  获取版本号
 *
 *  @return 返回版本号，字符串表示，例如v1.1.1
 */
-(NSString*) GetVersion;

/**
 *  打印日志，通过ImSDK提供的日志功能打印日志
 *
 *  @param level 日志级别
 *  @param tag   模块tag
 *  @param msg   要输出的日志内容
 */
-(void) log:(TIMLogLevel)level tag:(NSString*)tag msg:(NSString*)msg;

/**
 * 设置日志级别，在initSDK之前调用
 *
 *  @param level 日志级别
 */
-(void) setLogLevel:(TIMLogLevel)level;



/**
 * 获取日志文件路径
 */
-(NSString *) getLogPath;

/**
 * 是否开启sdk日志打印
 */
-(BOOL) getIsLogPrintEnabled;


@end



#endif
