//
//  TIMConversation.h
//  ImSDK
//
//  Created by bodeng on 28/1/15.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#ifndef ImSDK_TIMConversation_h
#define ImSDK_TIMConversation_h

#import "TIMComm.h"
#import "TIMCallback.h"

@class TIMMessage;

/**
 *  会话
 */
@interface TIMConversation : NSObject


/**
 *  初始化会话
 *
 *  @param type    会话类型
 *  @param recever 会话ID
 *
 *  @return 0 成功
 */
- (id)init:(TIMConversationType)type receiver:(NSString *)receiver;

/**
 *  获取会话人，单聊为对方账号，群聊为群组Id
 *
 *  @return 会话人
 */
-(NSString*) getReceiver;

/**
 *  获取会话类型
 *
 *  @return 会话类型
 */
-(TIMConversationType) getType;

- (void)addNewMessages:(TIMMessage *)msg;

@end


#endif
