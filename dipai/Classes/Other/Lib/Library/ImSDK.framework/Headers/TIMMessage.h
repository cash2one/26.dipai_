//
//  TIMMessage.h
//  ImSDK
//
//  Created by bodeng on 28/1/15.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#ifndef ImSDK_TIMMessage_h
#define ImSDK_TIMMessage_h


#import <Foundation/Foundation.h>

#import "TIMComm.h"
#import "TIMCallback.h"



/**
 *  消息会话
 */
@class TIMConversation;

/**
 *  消息Elem基类
 */
@interface TIMElem : NSObject
@end

/**
 *  文本消息Elem
 */
@interface TIMTextElem : TIMElem
/**
 *  消息文本
 */
@property(nonatomic,retain) NSString * text;

@end


/**
 *  表情消息类型
 */
@interface TIMFaceElem : TIMElem

/**
 *  表情索引，用户自定义
 */
@property(nonatomic, assign) int index;
/**
 *  额外数据，用户自定义
 */
@property(nonatomic,retain) NSData * data;
@end



/**
 *  消息
 */
@interface TIMMessage : NSObject {
    //    imcore::Msg msg;
    
@protected
    NSMutableArray *_elems;
    
    TIMMessageStatus _status;
    BOOL _isRead;
    BOOL _isSelf;
    NSUInteger _seq;
    NSUInteger _rand;
    NSUInteger _flag;
    NSUInteger _time;
    NSDate *_timestamp;
    NSString *_sender;
}

//- (imcore::Msg) getMessage;
//- (imcore::Msg *) getMessagePtr;
//- (id) initWithMsg:(imcore::Msg)msg;




@property (nonatomic, weak) TIMConversation *conversation;

/**
 *  增加Elem
 *
 *  @param elem elem结构
 *
 *  @return 0       表示成功
 *          1       禁止添加Elem（文件或语音多于两个Elem）
 *          2       未知Elem
 */
-(int) addElem:(TIMElem*)elem;

/**
 *  获取对应索引的Elem
 *
 *  @param index 对应索引
 *
 *  @return 返回对应Elem
 */
-(TIMElem*) getElem:(int)index;

/**
 *  获取Elem数量
 *
 *  @return elem数量
 */
-(int) elemCount;

/**
 *  获取会话
 *
 *  @return 该消息所对应会话
 */
-(TIMConversation*) getConversation;

/**
 *  是否已读
 *
 *  @return TRUE 已读  FALSE 未读
 */
-(BOOL) isReaded;

/**
 *  消息状态
 *
 *  @return TIMMessageStatus 消息状态
 */
-(TIMMessageStatus) status;

/**
 *  是否发送方
 *
 *  @return TRUE 表示是发送消息    FALSE 表示是接收消息
 */
-(BOOL) isSelf;

/**
 *  获取发送方
 *
 *  @return 发送方标识
 */
-(NSString *) sender;


/**
 *  当前消息的时间戳
 *
 *  @return 时间戳
 */
-(NSDate *) timestamp;

@end

#endif
