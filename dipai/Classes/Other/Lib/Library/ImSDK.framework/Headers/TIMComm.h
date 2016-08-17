//
//  TIMComm.h
//  ImSDK
//
//  Created by bodeng on 29/1/15.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#ifndef ImSDK_TIMComm_h
#define ImSDK_TIMComm_h


#define ERR_IMSDK_KICKED_BY_OTHERS      6208

enum ERROR_CODE {
    ERR_SUCC = 0,
    ERR_PARSE_RESPONSE_FAILED            = 6001, //解析响应失败
    ERR_SERIALIZE_REQ_FAILED             = 6002, //序列化请求失败
    ERR_NO_SUCC_RESULT                   = 6003, //批量操作无成功结果
    ERR_INVALID_CONVERSATION             = 6004, //IM: 无效会话
    ERR_LOADMSG_FAILED                   = 6005, //IM: 加载本地消息存储失败
    ERR_FILE_TRANS_AUTH_FAILED           = 6006, //IM: 文件传输 - 鉴权失败
    ERR_FILE_TRANS_NO_SERVER             = 6007, //IM: 文件传输 - 获取svr失败
    ERR_FILE_TRANS_UPLOAD_FAILED         = 6008, //IM: 文件传输 - 上传失败
    ERR_FILE_TRANS_DOWNLOAD_FAILED       = 6009, //IM: 文件传输 - 下载失败
    ERR_HTTP_REQ_FAILED                  = 6010, //HTTP请求失败
    ERR_TO_USER_INVALID                  = 6011, //IM: 无效接收方
    ERR_REQUEST_TIMEOUT                  = 6012, //请求超时
    ERR_SDK_NOT_INITIALIZED              = 6013, //SDK未初始化
    ERR_SDK_NOT_LOGGED_IN                = 6014, //SDK未登录
    ERR_IN_PROGESS                       = 6015, //执行中
    ERR_INVALID_MSG_ELEM                 = 6016, //IM: 无效消息elem
    ERR_INVALID_PARAMETERS               = 6017, //API参数无效
    ERR_INIT_CORE_FAIL					 = 6018, //INIT CORE模块失败
    
    ERR_BIND_FAIL_UNKNOWN                = 6100, //QALSDK未知原因BIND失败
    ERR_BIND_FAIL_NO_SSOTICKET           = 6101, //缺少SSO票据
    ERR_BIND_FAIL_REPEATD_BIND           = 6102, //重复BIND
    ERR_BIND_FAIL_TINYID_NULL            = 6103, //tiny为空
    ERR_BIND_FAIL_GUID_NULL              = 6104, //guid为空
    ERR_BIND_FAIL_UNPACK_REGPACK_FAILED  = 6105, //解注册包失败
    ERR_BIND_FAIL_REG_TIMEOUT            = 6106, //注册超时
    
    ERR_PACKET_FAIL_UNKNOWN              = 6120, //发包未知错误
    ERR_PACKET_FAIL_REQ_NO_NET           = 6121, //发送请求包时没有网络,处理时转换成ERR_REQ_NO_NET_ON_REQ
    ERR_PACKET_FAIL_RESP_NO_NET          = 6122, //发送回复包时没有网络,处理时转换成ERR_REQ_NO_NET_ON_RSP
    ERR_PACKET_FAIL_REQ_NO_AUTH          = 6123, //发送请求包时没有权限
    ERR_PACKET_FAIL_SSO_ERR              = 6124, //SSO错误
    ERR_PACKET_FAIL_REQ_TIMEOUT          = 6125, //请求超时,处理时转化成ERR_REQUEST_TIMEOUT
    ERR_PACKET_FAIL_RESP_TIMEOUT         = 6126, //回复超时,处理时转化成ERR_REQUEST_TIMEOUT
    ERR_PACKET_FAIL_REQ_ON_RESEND        = 6127, //
    ERR_PACKET_FAIL_RESP_NO_RESEND       = 6128, //
    ERR_PACKET_FAIL_FLOW_SAVE_FILTERED   = 6129, //
    ERR_PACKET_FAIL_REQ_OVER_LOAD        = 6130, //
    ERR_PACKET_FAIL_LOGIC_ERR            = 6131,
    
    ERR_LOGIN_KICKED_OFF_BY_OTHER        = 6208, // 账号被踢
    ERR_LOGIN_AUTH_FAILED                = 6207, // 账号认证失败（tinyid转换失败）
    
    ERR_REQ_NO_NET_ON_REQ                = 6200, // 请求的时候没有网络
    ERR_REQ_NO_NET_ON_RSP                = 6201, // 响应的时候没有网络
    
    ERR_REQ_CONTENT_ATTACK               = 80001, // 消息内容安全打击
    
    ERR_LOGIN_SIG_EXPIRE                 = 70001,       // 登陆返回，票据过期
};


/**
 * 网络连接状态
 */
typedef NS_ENUM(NSInteger, TIMNetworkStatus) {
    /**
     * 已连接
     */
    TIM_NETWORK_STATUS_CONNECTED             = 1,
    /**
     * 链接断开
     */
    TIM_NETWORK_STATUS_DISCONNECTED          = 2,
};


/**
 * 日志级别
 */
typedef NS_ENUM(NSInteger, TIMLogLevel) {
    TIM_LOG_NONE                = 0,
    TIM_LOG_ERROR               = 1,
    TIM_LOG_WARN                = 2,
    TIM_LOG_INFO                = 3,
    TIM_LOG_DEBUG               = 4,
};

/////////////////////////////////////////////////////////
///  回调Block
/////////////////////////////////////////////////////////

/**
 *  获取消息回调
 *
 *  @param NSArray 消息列表
 */
typedef void (^TIMGetMsgSucc)(NSArray *);

/**
 *  一般操作成功回调
 */
typedef void (^TIMSucc)();

/**
 *  一般操作失败回调
 *
 *  @param code     错误码
 *  @param NSString 错误描述
 */
typedef void (^TIMFail)(int code, NSString *);

/**
 *  登陆成功回调
 */
typedef void (^TIMLoginSucc)();


/**
 *  群列表回调
 *
 *  @param NSArray 群列表
 */
typedef void (^TIMGroupListSucc)(NSArray *);


/**
 *  日志回调
 *
 *  @param lvl      输出的日志级别
 *  @param NSString 日志内容
 */
typedef void (^TIMLogFunc)(TIMLogLevel lvl, NSString *);



/////////////////////////////////////////////////////////
///  基本类型
/////////////////////////////////////////////////////////

/**
 *  登陆信息
 */

@interface TIMLoginParam : NSObject{
    NSString*       accountType;        // 用户的账号类型
    NSString*       identifier;         // 用户名
    NSString*       userSig;            // 鉴权Token
    NSString*       appidAt3rd;          // App用户使用OAuth授权体系分配的Appid

    int             sdkAppId;           // 用户标识接入SDK的应用ID
}

/**
 *  用户的账号类型
 */
@property(nonatomic,retain) NSString* accountType;

/**
 * 用户名
 */
@property(nonatomic,retain) NSString* identifier;

/**
 *  鉴权Token
 */
@property(nonatomic,retain) NSString* userSig;

/**
 *  App用户使用OAuth授权体系分配的Appid
 */
@property(nonatomic,retain) NSString* appidAt3rd;


/**
 *  用户标识接入SDK的应用ID
 */
@property(nonatomic,assign) int sdkAppId;

@end



/**
 * 会话类型：
 *      C2C     双人聊天
 *      GROUP   群聊
 */
typedef NS_ENUM(NSInteger, TIMConversationType) {
    /**
     *  C2C 类型
     */
    TIM_C2C              = 1,
    
    /**
     *  群聊 类型
     */
    TIM_GROUP            = 2,
    
    /**
     *  系统消息
     */
    TIM_SYSTEM           = 3,
};



/**
 *  消息状态
 */
typedef NS_ENUM(NSInteger, TIMMessageStatus){
    /**
     *  消息发送中
     */
    TIM_MSG_STATUS_SENDING              = 1,
    /**
     *  消息发送成功
     */
    TIM_MSG_STATUS_SEND_SUCC            = 2,
    /**
     *  消息发送失败
     */
    TIM_MSG_STATUS_SEND_FAIL            = 3,
    /**
     *  消息被删除
     */
    TIM_MSG_STATUS_HAS_DELETED          = 4,
};




#endif
