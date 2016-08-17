//
//  IMSdkInt.h
//  ImSDK
//
//  Created by bodeng on 10/12/14.
//  Copyright (c) 2014 tencent. All rights reserved.
//

#ifndef ImSDK_IMSdkInt_h
#define ImSDK_IMSdkInt_h

#import <Foundation/Foundation.h>
#import "IMSdkComm.h"


/**
 *  音视频接口
 */
@interface IMSdkInt : NSObject

/**
 *  获取 IMSdkInt 全局对象
 *
 *  @return IMSdkInt 对象
 */
+(IMSdkInt*)sharedInstance;

/**
 *  获取当前登陆用户 TinyID
 *
 *  @return tinyid
 */
-(unsigned long long) getTinyId;


/**
 *  发送请求
 *
 *  @param cmd  命令字
 *  @param body 包体
 *  @param succ 成功回调，返回响应数据
 *  @param fail 失败回调，返回错误码
 *
 *  @return 0 发包成功
 */
-(int) request:(NSString*)cmd body:(NSData*)body succ:(OMRequestSucc)succ fail:(OMRequsetFail)fail;

/**
 *  UserId 转 TinyId
 *
 *  @param userIdList userId列表，IMUserId 结构体
 *  @param succ       成功回调
 *  @param err        失败回调
 *
 *  @return 0 成功
 */
-(int)userIdToTinyId:(NSArray*)userIdList okBlock:(OMUserIdSucc)succ errBlock:(OMErr)err;

/**
 *  TinyId 转 UserId
 *
 *  @param tinyIdList tinyId列表，unsigned long long类型
 *  @param succ       成功回调
 *  @param err        失败回调
 *
 *  @return 0 成功
 */
-(int)tinyIdToUserId:(NSArray*)tinyIdList okBlock:(OMUserIdSucc)succ errBlock:(OMErr)err;

/**
 *  设置超时时间
 *
 *  @param timeout 超时时间
 */
-(void)setReqTimeout:(int)timeout;


-(void) doIMPush:(NSData*)body;

@end

#endif
