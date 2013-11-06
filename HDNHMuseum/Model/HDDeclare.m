//
//  HDDeclare.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-31.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDDeclare.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@interface HDDeclare()
-(void)initVariable;
@end
@implementation HDDeclare
//------------------------------------------------------------------------------
//    + (id)sharedDeclare
//------------------------------------------------------------------------------
+ (id)sharedDeclare
{
    static id sharedDeclare;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDeclare = [[self alloc] init];
    });
    
    return sharedDeclare;
}
//------------------------------------------------------------------------------
//    - (id)init
//------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        [self initVariable];
    }
    return self;
}
-(long long)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to-from + 1)));
    
}
-(void)initVariable
{
    self.autoFlag = YES;
    self.netStatus = YES;
    
    self.channel = @"hengda";
    self.target = @"hengda";
    self.LANSSID = @"sdmsg";
   // self.LANSSID = @"HengDa-Dev";
    
    self.netServerAddress = @"60.216.8.43";
    self.netGatePort = 65530;
    self.netConnectPort = 65531;
    
    self.LANServerAddress = @"10.20.160.101";
//    self.LANServerAddress = @"192.168.0.252";
    self.LANGatePort = 3014;
    self.LANConnectPort = 3050;
    
    self.LANDownloadAddress = @"10.20.160.102:12345";
    self.netDownloadAddress = @"60.216.8.43:65529";
    
    NSString *userInfo = [[self applicationLibraryDirectory] stringByAppendingPathComponent:@"userInfo.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:userInfo])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userInfo];
        self.groupNumber = [dic objectForKey:@"groupNumber"];
        self.userID=[dic objectForKey:@"userID"];
        self.userName=[dic objectForKey:@"userName"];
        self.nickName=[dic objectForKey:@"nickName"];
        self.language=[dic objectForKey:@"language"];
        self.appVersion = [dic objectForKey:@"appVersion"];
        self.dataBaeVersion = [dic objectForKey:@"dataBaeVersion"];
    }
    else
    {
        self.groupNumber = @"0";
        long long  i = [self getRandomNumber:1000000000 to:RAND_MAX];
        self.userID = [NSString stringWithFormat:@"%lld",i];
        self.userName = [NSString stringWithFormat:@"ios%@",self.userID];
        self.nickName = @"游客";
        self.language = @"Chinese";
        self.dataBaeVersion = @"1.0";
        self.appVersion = @"1.0";
        NSDictionary *temp = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.userID,self.userName,self.nickName,self.language,self.groupNumber,self.dataBaeVersion,self.appVersion, nil] forKeys:[NSArray arrayWithObjects:@"userID",@"userName",@"nickName",@"language",@"groupNumber",@"dataBaeVersion",@"appVersion",nil]];
        
        [temp writeToFile:userInfo atomically:YES];
    }
    self.serverAddress = self.netServerAddress;
    self.gatePort = self.netGatePort;
    self.connectPort = self.netConnectPort;
    self.downloadAddress = self.netDownloadAddress;
}
- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [info objectForKey:@"SSID"];
}

-(void)setLanguage:(NSString *)language
{
    if (_language!=nil)
    {
        _language = nil;
    }
    _language = language;
    if ([_language isEqualToString:@"Chinese"])
    {
        self.alertTitle = @"提示";
        self.alertCancel = @"取消";
        self.alertOK = @"确定";
        self.InvalidInput = @"无此编号展品";
        self.downloading = @"正在下载";
        self.downloadFailed = @"当前网络状态不稳定，请检查您的网络设置";
        self.instralling = @"正在安装资源文件";
        self.unit = @"ChineseUnit";
        self.education = @"特色教育";
        self.SOS = @"紧急求助";
        self.SOSSuceed = @"发送成功";
        self.Interaction = @"互动方式";
        self.Questionnaire = @"问卷调查";
        self.Feedback = @"意见反馈";
        self.outsideService = @"您现在的智慧服务为馆外模式，不能向馆内进行紧急求助";
        self.noMessage = @"没有新消息通知";
        self.map = @"地图导览";
        self.strategy = @"场馆攻略";
        self.visit = @"参观攻略";
        self.traffic = @"交通信息";
        self.arrive = @"到馆路线";
        self.museumInfo= @"场馆信息";
        self.website=@"官方网址";
        self.myFriend = @"我的同伴";
        self.joinGroup = @"加入现有群组";
        self.registerGroup = @"注册新的群组";
        self.registerFailed = @"注册失败";
        self.registerSucceed = @"注册组号成功，您当前的组号为:";
        self.joinNumberNeed = @"请输入您要加入的群组号";
        self.outsideGroup = @"您现在的智慧服务为馆外模式,不能使用馆内定位功能";
        self.joinFailed = @"加入失败";
        self.noLocationInfo = @"暂无当前成员的馆内位置信息";
        self.introduce = @"场馆概况";
        self.information = @"场馆资讯";
        self.AutoNavigation = @"自动导览";
        self.settingLanguage = @"语言设置";
        self.autoLocation = @"自动讲解";
        self.setting = @"系统设置";
        self.Panoramic = @"360全景";
        self.NewVersions = @"检测到软件有新版本，是否更新";
        self.NewDatabase = @"检测到有新的展品信息，是否更新";
        self.detail = @"资讯详情";
        self.myinformation = @"我的信息";
        self.thenews = @"最新消息";
        self.yourInside = @"您现在的智慧服务为馆内模式";
        self.yourOutside = @"您现在的智慧服务为馆外模式";
        self.nameLabel = @"昵称:";
        self.groupLabel = @"组号:";
        self.input = @"请输入新的昵称";
        self.nullcontent = @"发送内容不能为空";
        self.feedbacksuceed = @"提交成功";
    }
    else
    {
        self.alertTitle = @"Alert";
        self.alertCancel = @"Cancel";
        self.alertOK = @"OK";
        self.downloading = @"Downloading";
        self.instralling = @"Instralling";
        self.unit = @"EnglishUnit";
        self.InvalidInput = @"No current number of exhibits";
        self.downloadFailed = @"Current network status is unstable, check your network settings";
        self.education = @"Education";
        self.SOS = @"SOS";
        self.SOSSuceed = @"Sent successfully";
        self.Interaction = @"Interaction";
        self.Questionnaire = @"Questionnaire";
        self.Feedback = @"Feedback";
        self.outsideService = @"You are intelligent services for the museum outside the model, not to facilitate the emergency";
        self.noMessage = @"No new message notification";
        self.map = @"Map";
        self.strategy = @"Raiders";
        self.visit = @"Visit Raiders";
        self.traffic = @"Traffic";
        self.arrive = @"Directions to the museum";
        self.museumInfo= @"Venue";
        self.website=@"Official Website";
        self.myFriend = @"Friends";
        self.joinGroup = @"Join a Group";
        self.registerGroup = @"Register a new group";
        self.registerSucceed = @"Registration is successful, your current group number is:";
        self.registerFailed = @"Registration failed";
        self.joinNumberNeed = @"Please enter the number you want to join the group";
        self.outsideGroup = @"You are intelligent services for the museum outside the model, you can not use the museum positioning function";
        self.joinFailed = @"Join fails";
        self.noLocationInfo = @"No current location information Friends";
        self.introduce = @"Overview";
        self.information = @"Information";
        self.AutoNavigation = @"Auto";
        self.settingLanguage = @"Laguage";
        self.autoLocation = @"Automatic explain";
        self.setting = @"System Settings";
        self.Panoramic = @"Panoramic";
        self.NewVersions = @"There are new versions of the software detects whether the update";
        self.NewDatabase = @"There are new exhibits detected information is updated";
        self.detail = @"Detail";
        self.myinformation = @"My Information";
        self.thenews = @"New Messages";
        self.yourInside = @"Museum mode";
        self.yourOutside = @"Outside the museum mode";
        self.nameLabel = @"Name:";
        self.groupLabel = @"Group:";
        self.input = @"Please enter a new nickname";
        self.nullcontent = @"Can not be empty";
        self.feedbacksuceed = @"Submit Success";
    }

}
-(NSString *)applicationLibraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex: 0];
    //return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex: 0];
}
-(NSURL *)applicationLibraryURLDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
 //    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
-(void)upadteDataVersion:(NSString *)aVersion
{
     NSString *userInfo = [[self applicationLibraryDirectory] stringByAppendingPathComponent:@"userInfo.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userInfo];
    self.dataBaeVersion = aVersion;
    [dic setValue:self.dataBaeVersion forKey:@"dataBaeVersion"];
    [dic writeToFile:userInfo atomically:YES];
}
@end
