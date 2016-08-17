//
//  TIMGroupManager.h
//  ImSDK
//
//  Created by bodeng on 17/3/15.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#ifndef ImSDK_TIMGroupManager_h
#define ImSDK_TIMGroupManager_h

#import "TIMComm.h"
#import "IMSdkComm.h"


@class TIMMessage;

///**
// * 加群选项
// */
//typedef NS_ENUM(NSInteger, TIMGroupAddOpt) {
//    /**
//     *  禁止加群
//     */
//    TIM_GROUP_ADD_FORBID                    = 0,
//    
//    /**
//     *  需要管理员审批
//     */
//    TIM_GROUP_ADD_AUTH                      = 1,
//    
//    /**
//     *  任何人可以加入
//     */
//    TIM_GROUP_ADD_ANY                       = 2,
//};
//
///**
// * 群消息接受选项
// */
//typedef NS_ENUM(NSInteger, TIMGroupReceiveMessageOpt) {
//    /**
//     *  接收消息
//     */
//    TIM_GROUP_RECEIVE_MESSAGE                       = 0,
//    /**
//     *  不接收消息，服务器不进行转发
//     */
//    TIM_GROUP_NOT_RECEIVE_MESSAGE                   = 1,
//    /**
//     *  接受消息，不进行iOS APNs 推送
//     */
//    TIM_GROUP_RECEIVE_NOT_NOTIFY_MESSAGE            = 2,
//};
//
///**
// * 群成员角色
// */
//typedef NS_ENUM(NSInteger, TIMGroupMemberRole) {
//    /**
//     *  群成员
//     */
//    TIM_GROUP_MEMBER_ROLE_MEMBER              = 200,
//    
//    /**
//     *  群管理员
//     */
//    TIM_GROUP_MEMBER_ROLE_ADMIN               = 300,
//    
//    /**
//     *  群主
//     */
//    TIM_GROUP_MEMBER_ROLE_SUPER               = 400,
//};
//
//
///**
// * 群成员获取资料标志
// */
//typedef NS_ENUM(NSInteger, TIMGetGroupMemInfoFlag) {
//    
//    /**
//     * 入群时间
//     */
//    TIM_GET_GROUP_MEM_INFO_FLAG_JOIN_TIME                    = 0x01,
//    /**
//     * 消息标志
//     */
//    TIM_GET_GROUP_MEM_INFO_FLAG_MSG_FLAG                     = 0x01 << 1,
//    /**
//     * 角色
//     */
//    TIM_GET_GROUP_MEM_INFO_FLAG_ROLE_INFO                    = 0x01 << 3,
//    /**
//     * 禁言时间
//     */
//    TIM_GET_GROUP_MEM_INFO_FLAG_SHUTUP_TIME                  = 0x01 << 4,
//};
//
///**
// * 群基本获取资料标志
// */
//typedef NS_ENUM(NSInteger, TIMGetGroupBaseInfoFlag) {
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_NAME                           = 0x01,
//
//    TIM_GET_GROUP_BASE_INFO_FLAG_CREATE_TIME                    = 0x01 << 1,
//
//    TIM_GET_GROUP_BASE_INFO_FLAG_OWNER_UIN                      = 0x01 << 2,
//
//    TIM_GET_GROUP_BASE_INFO_FLAG_SEQ                            = 0x01 << 3,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_TIME                           = 0x01 << 4,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_NEXT_MSG_SEQ                   = 0x01 << 5,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_LAST_MSG_TIME                  = 0x01 << 6,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_APP_ID                         = 0x01 << 7,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_MEMBER_NUM                     = 0x01 << 8,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_MAX_MEMBER_NUM                 = 0x01 << 9,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_NOTIFICATION                   = 0x01 << 10,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_INTRODUCTION                   = 0x01 << 11,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_FACE_URL                       = 0x01 << 12,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_ADD_OPTION                     = 0x01 << 13,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_GROUP_TYPE                     = 0x01 << 14,
//    
//    TIM_GET_GROUP_BASE_INFO_FLAG_LAST_MSG                       = 0x01 << 15,
//};

@interface TIMGroupManager : NSObject

/**
 *  获取群管理器实例
 *
 *  @return 管理器实例
 */
+ (TIMGroupManager *)sharedInstance;

/**
 *  申请加群
 *
 *  @param group 申请加入的群组Id
 *  @param msg   申请消息
 *  @param succ  成功回调（申请成功等待审批）
 *  @param fail  失败回调
 *
 *  @return 0 成功
 */
- (int)JoinGroup:(NSString *)group msg:(NSString *)msg succ:(TIMSucc)succ fail:(TIMFail)fail;

/**
 *  主动退出群组
 *
 *  @param group 群组Id
 *  @param succ  成功回调
 *  @param fail  失败回调
 *
 *  @return 0 成功
 */
- (int)QuitGroup:(NSString *)group succ:(TIMSucc)succ fail:(TIMFail)fail;

@end

/**
 *  群资料信息
 */
@interface TIMGroupInfo : NSObject {
    NSString*       group;          // 群组Id
    NSString*       groupName;      // 群名
    NSString*       groupType;      // 群组类型
    NSString*       owner;          // 创建人
    uint32_t        createTime;     // 群创建时间
    uint32_t        lastInfoTime;   // 最近一次修改资料时间
    uint32_t        lastMsgTime;    // 最近一次发消息时间
    uint32_t        memberNum;      // 群成员数量
    
    NSString*       notification;      // 群公告
    NSString*       introduction;      // 群简介
    
    NSString*       faceURL;            // 群头像
    
    TIMMessage *     lastMsg;           // 最后一条消息
}

/**
 *  群组Id
 */
@property(nonatomic,retain) NSString* group;
/**
 *  群名
 */
@property(nonatomic,retain) NSString* groupName;
/**
 *  群创建人/管理员
 */
@property(nonatomic,retain) NSString * owner;
/**
 *  群类型：Private,Public,Chatroom
 */
@property(nonatomic,retain) NSString* groupType;
/**
 *  群创建时间
 */
@property(nonatomic,assign) uint32_t createTime;
/**
 *  最近一次群资料修改时间
 */
@property(nonatomic,assign) uint32_t lastInfoTime;
/**
 *  最近一次发消息时间
 */
@property(nonatomic,assign) uint32_t lastMsgTime;
/**
 *  群成员数量
 */
@property(nonatomic,assign) uint32_t memberNum;

/**
 *  群公告
 */
@property(nonatomic,retain) NSString* notification;

/**
 *  群简介
 */
@property(nonatomic,retain) NSString* introduction;

/**
 *  群头像
 */
@property(nonatomic,retain) NSString* faceURL;

/**
 *  最后一条消息
 */
@property(nonatomic,retain) TIMMessage* lastMsg;

@end


/**
 *  群组操作结果
 */
typedef NS_ENUM(NSInteger, TIMGroupMemberStatus) {
    /**
     *  操作失败
     */
    TIM_GROUP_MEMBER_STATUS_FAIL              = 0,
    
    /**
     *  操作成功
     */
    TIM_GROUP_MEMBER_STATUS_SUCC              = 1,
    
    /**
     *  无效操作，加群时已经是群成员，移除群组时不在群内
     */
    TIM_GROUP_MEMBER_STATUS_INVALID           = 2,
};


#endif
