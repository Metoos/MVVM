//
//  APIConfig.h
//  ManLiao
//
//  Created by Manloo on 15/12/8.
//  Copyright © 2015年 manloo. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h


typedef enum : NSUInteger {
    successed    = 0000,   //成功
    FirstLogin   = 0001,   //每天首次登入
    Datafailure  = 0002,   //数据错误
    AdoptionBuyingProcess = 0003,//认养抢购流程
    TradingFrozen  = 0004,//认养交易冻结
    OtherDevice    = 1111, //在其他设备登入
    HasBeenBlocked = 3333,  //已封号
    UnLogin        = 6666, //在其他设备登入
} response_code;



/**
 *  接口调试模式 1:测试模式 0:生产模式
 */
#define DEBUGMODE 0

#if DEBUGMODE == 1
/**
 *  Debug状态下的测试API
 */
/**************SERVER CONFIG**************/
// 系统级参数
//#define SERVER_APPKEY @"2015120801"
//#define SERVER_SECRET @"ed45044b6e035abfcbdae11145839b08"
//#define SERVER_KEY @"h9knf5qstzlpky2lvu6hsongjvw8v8i3"
//#define SERVER_NO @"1000000034"

/***************SERVER HOST***************/

#define SERVER_HOST @"http://kuangjinapi.chinafjjdkj.com/"


//#define SERVER_KEY @"mt5R0ONkPbh4PKh8U4FKfuRHbmJM7Exx"
#define SERVER_KEY @"kuangjin_sign"
#else

/**
 *  Release状态下的线上API
 */
/**************SERVER CONFIG**************/
// 系统级参数
//#define SERVER_APPKEY @"2015120801"
//#define SERVER_SECRET @"ed45044b6e035abfcbdae11145839b08"
//#define SERVER_KEY @"h9knf5qstzlpky2lvu6hsongjvw8v8i3"
/***************SERVER HOST***************/

#define SERVER_HOST @"http://kuangjinapi.chinafjjdkj.com/"


#define SERVER_KEY @"kuangjin_sign"

#endif


/***************SERVER API***************/


/**
 * ========================================= 会员接口 =================================================
 **/

/**
 *登录接口：
 **/
#define API_LOGIN [[NSString alloc] initWithFormat:@"%@api/loginapi.html",SERVER_HOST]

/**
 *IP安全验证：
 **/
#define API_IP_SECURITY_VER [[NSString alloc] initWithFormat:@"%@api/dovalidateapi.html",SERVER_HOST]

////退出登录
//#define API_LOGOUT [[NSString alloc] initWithFormat:@"%@%@Jpush/logout",SERVER_HOST,SERVER_WEBSERVICE]


/**
 *注册接口：
 **/
#define API_REGISTER [[NSString alloc] initWithFormat:@"%@api/registerapi.html",SERVER_HOST]

//忘记密码
#define API_SET_NEWPASSWORD [[NSString alloc] initWithFormat:@"%@api/forgetpassword.html",SERVER_HOST]


//更新APP
#define API_UPDATE [[NSString alloc] initWithFormat:@"%@api/versionupdate.html",SERVER_HOST]

//获取区号
#define API_AREACODE [[NSString alloc] initWithFormat:@"%@api/areacode.html",SERVER_HOST]

//退出登录
#define API_LOGOUT [[NSString alloc] initWithFormat:@"%@site/logout.html",SERVER_HOST]

/**
 *获取短信验证码接口：
 **/
#define API_GET_VERCODE [[NSString alloc] initWithFormat:@"%@api/intsendmsg.html",SERVER_HOST]

/********** 首页  ********/
/**
 *刷新用户信息接口：
 **/
#define API_REFRESH [[NSString alloc] initWithFormat:@"%@site/main.html",SERVER_HOST]


/**
 *预约操作接口：
 **/
#define API_BOOKES [[NSString alloc] initWithFormat:@"%@site/bookes.html",SERVER_HOST]

/**
 *预约列表接口：
 **/
#define API_BOOKES_LIST [[NSString alloc] initWithFormat:@"%@site/booklist.html",SERVER_HOST]

/**
 *认养操作接口：
 **/
#define API_SET_ADOPT [[NSString alloc] initWithFormat:@"%@site/rushastro.html",SERVER_HOST]


/**
 *用户签到接口：
 **/
#define API_SIGN [[NSString alloc] initWithFormat:@"%@api/checksign.html",SERVER_HOST]


/**
 *获取消息通知接口：
 **/
#define API_GET_MESSAGE [[NSString alloc] initWithFormat:@"%@site/notice.html",SERVER_HOST]


/**
 *上传图片接口：
 **/
#define API_UPLOAD [[NSString alloc] initWithFormat:@"%@api/uploadimg.html",SERVER_HOST]

/**
 *修改头像接口：
 **/
//#define API_UPDATE_HEAD [[NSString alloc] initWithFormat:@"%@user/updicon.html",SERVER_HOST]

/**
 *我的界面接口：
 **/
#define API_GET_MYDATA [[NSString alloc] initWithFormat:@"%@user/personal.html",SERVER_HOST]

/**
 *修改昵称接口：
 **/
//#define API_SET_NICKNAME [[NSString alloc] initWithFormat:@"%@user/alternick.html",SERVER_HOST]

/**
 *获取我的银行卡接口：
 **/
#define API_GET_BANKCARD [[NSString alloc] initWithFormat:@"%@user/addcard.html",SERVER_HOST]
/**
 *添加/绑定银行卡接口：
 **/
#define API_BINDING_BANKCARD [[NSString alloc] initWithFormat:@"%@user/back.html",SERVER_HOST]

/**
 *获取银行卡信息接口：
 **/
#define API_GET_BANKCARD_INFO [[NSString alloc] initWithFormat:@"%@user/modify.html",SERVER_HOST]
/**
 *修改银行卡信息接口：
 **/
#define API_UPDATE_BANKCARD_INFO [[NSString alloc] initWithFormat:@"%@user/updbankdata.html",SERVER_HOST]

/**
 *删除银行卡接口：
 **/
#define API_DELETE_BANKCARD [[NSString alloc] initWithFormat:@"%@user/bank.html",SERVER_HOST]

/**
 *修改登录密码接口：
 **/
#define API_CHANGE_LOGINPWD [[NSString alloc] initWithFormat:@"%@user/signup.html",SERVER_HOST]

/**
 *修改支付密码接口：
 **/
#define API_CHANGE_PAYPWD [[NSString alloc] initWithFormat:@"%@user/paypass.html",SERVER_HOST]

/**
 *设置支付密码接口：
 **/
#define API_SET_PAYPWD [[NSString alloc] initWithFormat:@"%@api/setpaypwd.html",SERVER_HOST]


/**
 *帮助中心接口
 **/
#define API_HELP_CENTER_LIST [[NSString alloc] initWithFormat:@"%@article/articlelist.html",SERVER_HOST]

/**
 *帮助中心详情接口
 **/
#define API_HELP_CENTER_DETAIL [[NSString alloc] initWithFormat:@"%@article/articledetail.html",SERVER_HOST]


/**线上客服接口
**/
#define API_CUSTOMER_SERVICE [[NSString alloc] initWithFormat:@"%@article/customer.html",SERVER_HOST]
/**
 *投诉建议接口：
 **/
#define API_FEEDBACK [[NSString alloc] initWithFormat:@"%@article/feedback.html",SERVER_HOST]

/**
 *投诉建议记录接口：
 **/
#define API_FEEDBACK_LIST [[NSString alloc] initWithFormat:@"%@article/feedlist.html",SERVER_HOST]

/**
 *投诉建议详情接口：
 **/
#define API_FEEDBACK_DETAIL [[NSString alloc] initWithFormat:@"%@article/feedetail.html",SERVER_HOST]

/**
 *充值界面数据接口：
 **/
#define API_GET_RECHARGE [[NSString alloc] initWithFormat:@"%@profile/diffrechangeface.html",SERVER_HOST]

/**
 *充值接口：
 **/
#define API_SET_RECHARGE [[NSString alloc] initWithFormat:@"%@profile/diffrechange.html",SERVER_HOST]

/**
 *充值记录接口：
 **/
#define API_GET_RECHARGE_LIST [[NSString alloc] initWithFormat:@"%@profile/diffwalist.html",SERVER_HOST]

/**
 *GSB记录接口：
 **/
#define API_GET_GSB_RECORD [[NSString alloc] initWithFormat:@"%@profile/gsblist.html",SERVER_HOST]

/**
 *DOGE记录接口：
 **/
#define API_GET_DOGE_RECORD [[NSString alloc] initWithFormat:@"%@profile/dogelist.html",SERVER_HOST]

/**
 *微分记录接口：
 **/
#define API_GET_DIFFEREN_RECORD [[NSString alloc] initWithFormat:@"%@profile/differen.html",SERVER_HOST]

/**
 *收益记录接口：
 **/
#define API_GET_EARNING_RECORD [[NSString alloc] initWithFormat:@"%@profile/profit.html",SERVER_HOST]

/**
 *资产展示记录接口：
 **/
#define API_GET_ASSETSHOW_RECORD [[NSString alloc] initWithFormat:@"%@profile/assetplay.html",SERVER_HOST]

/**
 *总资产记录接口：
 **/
#define API_GET_TOTALASSETS_RECORD [[NSString alloc] initWithFormat:@"%@profile/totalassets.html",SERVER_HOST]

/**
 *预约记录接口：
 **/
#define API_GET_SUBSCRIBE_RECORD [[NSString alloc] initWithFormat:@"%@site/booklist.html",SERVER_HOST]


/**
 *分享邀请码界面接口：
 **/
#define API_GET_SHARE [[NSString alloc] initWithFormat:@"%@site/shared.html",SERVER_HOST]


/**
 *安全中心界面接口：
 **/
#define API_GET_SECURITY [[NSString alloc] initWithFormat:@"%@user/safetylist.html",SERVER_HOST]
/**
*我的团队接口：
**/
#define API_GET_MYTEAM [[NSString alloc] initWithFormat:@"%@user/myteam.html",SERVER_HOST]
/**
 *查看我的团队接口：
 **/
#define API_GET_LOOK_MYTEAM [[NSString alloc] initWithFormat:@"%@user/lookteam.html",SERVER_HOST]

/**
 *实名认证接口：
 **/
#define API_SET_NAME_AUTH [[NSString alloc] initWithFormat:@"%@user/auth.html",SERVER_HOST]

/**
*绑定支付宝和微信接口：
**/
#define API_SET_BANDING_WA [[NSString alloc] initWithFormat:@"%@user/bindalipay.html",SERVER_HOST]
/**
 *绑定银行卡接口：
 **/
#define API_SET_BANDING_CARD [[NSString alloc] initWithFormat:@"%@user/bindbank.html",SERVER_HOST]

/**
 *微分转赠页面接口：
 **/
#define API_SET_DIFFERENTIAL_TRANSFER_PAGE [[NSString alloc] initWithFormat:@"%@profile/differenweb.html",SERVER_HOST]

/**
 *微分转赠接口：
 **/
#define API_SET_DIFFERENTIAL_TRANSFER [[NSString alloc] initWithFormat:@"%@profile/giftgiving.html",SERVER_HOST]

/**
 *认养列表接口：
 **/
#define API_GET_ADOPTLIST [[NSString alloc] initWithFormat:@"%@trade/adoptlist.html",SERVER_HOST]
/**
 *认养详情接口：
 **/
#define API_GET_ADOPTLIST_DETAIL [[NSString alloc] initWithFormat:@"%@trade/adopdetail.html",SERVER_HOST]
/**
 *认养付款上传 和 申诉上传接口：
 **/
#define API_GET_ADOPT_OPERATE [[NSString alloc] initWithFormat:@"%@trade/adopoperate.html",SERVER_HOST]

/**
 *申诉回复接口：
 **/
#define API_SET_ADOPT_REPLY [[NSString alloc] initWithFormat:@"%@trade/appealfeed.html",SERVER_HOST]


/**
 *转让列表接口：
 **/
#define API_GET_TRANSFERLIST [[NSString alloc] initWithFormat:@"%@trade/translist.html",SERVER_HOST]
/**
 *转让详情接口：
 **/
#define API_GET_TRANSFER_DETAIL [[NSString alloc] initWithFormat:@"%@trade/transeldetail.html",SERVER_HOST]
/**
 *转让确认订单操作 ( 包含申诉详情中订单确认)：
 **/
#define API_GET_TRANSFER_OPERATE [[NSString alloc] initWithFormat:@"%@trade/tradepay.html",SERVER_HOST]

/**
 *转让申诉操作( 详情中申诉 和 列表中申诉)接口：
 **/
#define API_SET_TRANSFER_REPLY [[NSString alloc] initWithFormat:@"%@trade/transappeal.html",SERVER_HOST]

/**
 *出售资产页面接口：
 **/
#define API_SET_SALEASSTE_PAGE [[NSString alloc] initWithFormat:@"%@profile/saledetail.html",SERVER_HOST]

/**
 *出售资产接口：
 **/
#define API_SET_SALEASSTE [[NSString alloc] initWithFormat:@"%@profile/assetsoperate.html",SERVER_HOST]

/**
 *关于我们接口：
 **/
#define API_GET_ABOUT [[NSString alloc] initWithFormat:@"%@api/versionupdate.html",SERVER_HOST]

/**
 *退出登录接口：
 **/
#define API_SET_LOGOUT [[NSString alloc] initWithFormat:@"%@api/logout.html",SERVER_HOST]

/**
 *回购列表接口：
 **/
#define API_GET_BUYBACK [[NSString alloc] initWithFormat:@"%@user/buyback.html",SERVER_HOST]


/***************API VERSION***************/
//
#define API_VERSION @""

#endif /* APIConfig_h */
