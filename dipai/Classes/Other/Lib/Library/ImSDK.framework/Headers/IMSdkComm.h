//
//  IMSdkComm.h
//  ImSDK
//
//  Created by bodeng on 10/12/14.
//  Copyright (c) 2014 tencent. All rights reserved.
//

#ifndef ImSDK_IMSdkComm_h
#define ImSDK_IMSdkComm_h

@interface OMErrResp : NSObject
{
    NSString*   cmd;                // 返回的命令字
    int         seq;                // 请求包的seq
    NSString*   uin;                // uin
    int         errCode;            // 错误码
    NSString*   errTips;            // error tips
}

@property(nonatomic,retain) NSString* cmd;
@property(nonatomic,retain) NSString* uin;
@property(nonatomic,assign) int seq;
@property(nonatomic,assign) int errCode;
@property(nonatomic,retain) NSString* errTips;

@end


/// 业务相关回调

/**
 *  userid和tinyid 转换回包
 *  userList 存储IMUserId结构
 */
@interface OMUserIdResp : NSObject{
    NSArray*   userList;         // 用户的登录的open id
}


@property(nonatomic,retain) NSArray* userList;

@end

/**
 *  userid转换tinyid回调
 *
 *  @param OMUserIdResp 回包结构
 *
 *  @return 0 处理成功
 */
typedef int (^OMUserIdSucc)(OMUserIdResp *resp);

//请求回调
typedef int (^OMErr)(OMErrResp *resp);


/**
 *  音视频回调
 */
@interface OMCommandResp : NSObject{
    NSData*   rspbody;
}


@property(nonatomic,retain) NSData* rspbody;

@end

// relay 回调
typedef int (^OMCommandSucc)(OMCommandResp *resp);

// request 回调
typedef void (^OMRequestSucc)(NSData * data);
typedef void (^OMRequsetFail)(int code, NSString* msg);

/**
 *  UserId 结构，表示一个用户的账号信息
 */
@interface IMUserId : NSObject{
    NSString*       uidtype;            // uid 类型
    unsigned int    userappid;
    NSString*       userid;             // 用户id
    unsigned long long   tinyid;
    unsigned long long   uin;
}

@property(nonatomic,retain) NSString* uidtype;
@property(nonatomic,assign) unsigned int userappid;
@property(nonatomic,retain) NSString* userid;
@property(nonatomic,assign) unsigned long long tinyid;
@property(nonatomic,assign) unsigned long long uin;

@end



#endif
