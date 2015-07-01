//
//  SQLiteManager.h
//  seu_iphone
//
//  Created by fanxun on 14-4-29.
//  Copyright (c) 2014年 fanxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "SQLStatement.h"
#import "BanKCode.h"

#import "ProvinceInfo.h"
#import "CityInfo.h"
#import "AreaInfo.h"
@interface SQLiteManager : NSObject{
    FMDatabaseQueue *_dbQueue;
 
}

+(SQLiteManager *)sharedInstance;

-(NSMutableArray*) getBankCodeDatas;

-(void) deleteBankCodeData;
-(void) saveOrUpdateBankCodeData:(NSMutableArray *) arrays;
-(BanKCode*)getBankCodeDataByCardNumber:(NSString*)cardNumber;
-(BanKCode*)getBankCodeDataByCardCode:(NSString*)cardCode;

//地址对照表
-(NSMutableArray*) getProvinceCodeData;
-(NSMutableArray*) getAreaCodeData;
-(NSMutableArray*) getCityCodeData;

-(void) deleteProvinceCodeData;
-(void) deleteAreaCodeData;
-(void) deleteCityCodeData;
-(void) saveOrUpdateProvinceCodeData:(NSMutableArray *) arrays;
-(void) saveOrUpdateAreaCodeData:(NSMutableArray *) arrays;
-(void) saveOrUpdateCityCodeData:(NSMutableArray *) arrays;

-(NSMutableArray*)getAreaCodeDataByFatherID:(NSString*)FatherID;
-(NSMutableArray*)getCityCodeDataByFatherID:(NSString*)FatherID;


-(ProvinceInfo*)getProvinceNameByProvinceID:(NSString*)ProvinceID;
-(CityInfo*)getCityNameByCityID:(NSString*)CityID;
-(AreaInfo*)getAreaNameByAreaID:(NSString*)AreaID;
//-(NSMutableArray*) getSites;
//-(void) saveOrUpdateSitesData:(NSArray *) mData;
//-(void) deleteSitesData;
//-(NSMutableArray*) getMyFavorites:(NSNumber *) userId favTime:(NSString *) lastFavTime;
//-(NSNumber*) getMyFavIdBySiteIdAndArticleId:(NSNumber *) siteId articleId:(NSNumber *) articleId;
//-(void) saveOrUpdateFavsData:(NSMutableArray *) mData;
//-(void) deleteFavByFavId:(NSNumber *)favId;
//-(void) deleteFavByUserId:(NSNumber *)userId;
//
//
//
//
//#pragma mark 保存我的导航
//-(void) saveOrUpdateNavigationRss:(NSMutableArray *) mData;
//#pragma mark 获取我的daoahng
//-(NSMutableArray*) getNavigationRss:(NSNumber *)userId;
//
//#pragma mark 获取我的导航条数
//-(NSInteger ) getNavigationRssCount:(NSNumber *)userId;
//-(NSMutableArray*) getNavigationMoveRss:(NSNumber *)userId;
//-(void)deleteNavigationRss;
//-(void)deleteSysNavigationRss;
//#pragma mark 删除我的daoahng
//-(void)deleteNavigationRssById:(NSString *)rssId;
//-(void)deleteNavigationRssBySiteIdAndCIdAndUserId:(NSInteger )siteId cId:(NSInteger) cId uId:(NSNumber *)uId;
//
//#pragma mark 保存订阅列表
//-(void) saveOrUpdateRssList:(NSMutableArray *) mData;
//#pragma mark 获取订阅列表
//-(NSMutableArray*) getRssList:(NSNumber *)userId;
//-(NSMutableArray*) getRssList:(NSNumber *)userId rssType:(NSNumber *)rssType;
//-(NSMutableArray*) getSysRssList:(NSNumber *)userId;
//#pragma mark 删除订阅列表
//-(void)deleteRssList;
//-(void)deleteRssListBySiteIdAndCIdAndUserId:(NSInteger )siteId cId:(NSInteger) cId uId:(NSNumber *)uId;
//
//-(NSMutableArray*) getColumnsBySite:(NSInteger )siteId;
//
//-(NSMutableArray*) getColumnsByColumn:(NSInteger)columnId;
//-(void) saveOrUpdateColumnsData:(NSMutableArray *) mData;
//-(void) deleteColumn;
//
//
//-(NSMutableArray*) getDepartments:(NSNumber *) parentId ;
//#pragma mark 根据部门Ids获取部门
//-(NSMutableArray*) getDepartmentByIds:(NSString *) parentIds;
//#pragma mark 根据部门Ids删除部门
//-(void) deleteDeptByIds:(NSMutableArray *)deptIds;
//-(void) saveOrUpdateDeptData:(NSMutableArray *) mData;
//-(void) deleteDeptById:(NSNumber *)deptId;
//#pragma mark 更新topDepartment parentId=0
//-(void) updateTopDepartment:(NSString *) tops;
//-(NSMutableArray*) getUsers:(NSNumber *) deptId ;
//-(NSMutableArray*) getUsersByBeginId:(NSNumber *) deptId userId:(NSNumber *) userId;
//-(NSMutableArray *) getUserByUserNameOrLoginName:(NSString *)userName loginName:(NSString *)loginName;
//-(NSMutableArray*) getAllUsers;
//-(NSMutableArray*) getAllUserAndDepts;
//-(NSMutableArray*) getAllUserAndDeptsByDeptId:(NSNumber *)deptId;
//-(void) saveOrUpdateUserData:(NSMutableArray *) mData;
//-(void) deleteUserById:(NSNumber *)userId;
//-(void) deleteUserByIds:(NSMutableArray *)userIds;
//-(void) deleteDepts;
//-(void) deleteDeptUsers;
//-(void) deleteUsers;
//
//
//-(NSMutableArray*) getFoldersBySiteId:(NSNumber *)siteId;
//
//
//-(NSMutableArray*) getFoldersByParentId:(NSNumber *)parentId;
//
//-(void) saveOrUpdateFoldersData:(NSMutableArray *) mData;
//
//-(void) deleteFolderBySiteId:(NSNumber *)siteId;
//
//-(void) deleteFolderByParentId:(NSNumber *)parentId;
//
//-(NSMutableArray*) getFolderArticlesByFolderIdAndTime:(NSNumber *)folderId time:(NSString *) timestamp;
//
//-(void) saveOrUpdateFolderArticlesData:(NSMutableArray *) mData;
//
//-(void) deleteFolderArticleById:(NSNumber *)articleId ;
//
//#pragma mark 获取会话列表
//-(NSMutableArray*) getConversations;
//-(NSInteger) getConversationUnReadCountByUserId:(NSString *)userId;
//#pragma mark 保存或更新会话
//-(void) saveOrUpdateConversations:(NSMutableArray *) conversations;
//#pragma mark 保存或更新会话
//
//#pragma mark 删除会话
//-(void) deleteConversationBySTId:(NSString *) userId targetId:(NSString *) targetId;
//
//#pragma mark 更新unreadCount
//-(void) updateConversationbySTId:(NSString *) userId targetId:(NSString *) targetId;
//-(void) updateConversation:(void (^)(BOOL success,NSString *msg)) successBlock;
//-(void) updateConversationSysbySTId:(NSString *) userId targetId:(NSString *) targetId;
//
//#pragma mark 获取会话
//-(NSMutableArray *) getConversationsByUserId:(NSString *) myId ;
//#pragma mark 获取聊天
//-(NSMutableArray *) getConversationChatsByUserId:(NSString *) myId;
//#pragma mark 获取待办会话
//-(NSMutableArray *) getConversationPendingsByUserId:(NSString *) myId ;
//
//
//#pragma mark 获取会话列表
//-(NSMutableArray*) getChats;
//#pragma mark 获取会话列表
//-(NSMutableArray*) getChatsBytimestamp:(NSString *) myId targetId:(NSString *)targetId timstamp:(NSString *) timstamp;
//
//-(void) saveOrUpdateChats:(NSMutableArray *) chats;
//-(void) updateChatByNewChatId:(NSString *) newChatId chatId:(NSString *) oldChatId timstamp:(NSString *) timstamp;
//-(void) deleteChatBySTId:(NSString *) userId targetId:(NSString *) targetId;
//-(void) deleteAllChatBySTId:(NSString *) userId targetId:(NSString *) targetId;
//#pragma mark 删除会话
//-(void) deleteChat:(NSString *) chatId;
//
//#pragma mark 获取评论列表
//-(NSMutableArray*) getCommentsBytimestamp:(NSNumber *) articleId timstamp:(NSString *) timstamp;
//
//#pragma mark 保存或更新会话
//-(void) saveOrUpdateComments:(NSMutableArray *) comments;
//-(void) deleteCommentByArticleId:(NSNumber *) articleId ;
//
//
//-(NSMutableArray *) getArticlesByColumnIdAndTime:(NSNumber *)ColumnId time:(NSString *) timestamp;
//
//
//-(void) saveOrUpdateArticlesData:(NSMutableArray *) mData;
//
//-(void) deleteArticleById:(NSNumber *)articleId ;
//
//#pragma mark 应用分类
//-(NSMutableArray *) getAppCategorys;
//-(void) saveOrUpdateAppCategorysData:(NSMutableArray *) mData;
//-(void) deleteAppCategorys;
//-(MAppCategory *) getAppCategoryById :(NSNumber *) appCategoryId;
//#pragma mark 应用
//-(NSMutableArray *) getAppsByTimestamp:(NSNumber *) beginIndex;
//-(MApp *) getAppByOrginAppId:(NSNumber *) orginAppId;
//-(NSMutableArray *) getAppByAndRecommend : (NSInteger)beginIndex categoryId:(NSNumber *) appCategoryId;
//-(NSMutableArray *) getAppByAndRank :(NSNumber *) beginIndex categoryId:(NSNumber *) appCategoryId;
//-(NSMutableArray *) getAppsByState:(NSNumber *) state;
//-(MApp *) getAppById:(NSNumber *)appId;
//-(MAppUrlHandle *) getAppUrlHandleByAppVersionId:(NSNumber *)appVersionId;
//-(void) deleteApps;
//-(void) deleteAppByCategoryId:(NSNumber *) appCategoryId;
//-(void) saveOrUpdateAppsData:(NSMutableArray *) mData;
//-(void) saveOrUpdateAppData:(MApp *) app;
//-(void) updateAppInstalllState:(NSNumber *) orginAppId state:(NSNumber *)state;
//-(NSMutableArray *) getAppIndexsByIndexState:(NSInteger)indexApp;
//-(void) updateAppIndex:(NSNumber *) appId state:(NSInteger)indexApp;
//-(void) updateAppByNewAppId:(NSNumber *) appId newApp:(MApp *)newApp;
//
//#pragma mark 安装记录
//-(void) saveOrUpdateAppInstallRecordsData:(NSMutableArray *) mData;
//-(void) saveOrUpdateAppInstallRecordData:(MApp *) app;
//-(MApp *) getAppInstallRecordById:(NSNumber *) appId;
//-(NSMutableArray *)getAppInstallRecords;
//-(NSMutableArray *) getAppInstallRecordIndexsByIndexState:(NSInteger)indexApp;
//-(void) updateAppInstallRecordIndex:(NSNumber *) appId state:(NSInteger)indexApp;
//-(NSMutableArray *) getPendingUpdateAppInstallRecords;
//-(void) updateAppInstallRecordByNewAppId:(NSNumber *) appId newApp:(MApp *)app;
//-(void) replaceAppInstallRecordByNewAppId:(NSNumber *) appId newApp:(MApp *)app;
//-(void) deleteAppInstallRecordByAppId:(NSNumber *)appId;
//-(void) updateAppInstalllRecordState:(NSNumber *) orginAppId state:(NSNumber *)state;
//#pragma mark top应用
//
//-(NSMutableArray *) getTopGlobalApps;
//
//-(NSMutableArray *) getTopAppsByCategory:(NSNumber *) appCategoryId;
//
//-(void) deleteTopGlobalApps;
//-(void) deleteTopAppByCategoryId:(NSNumber *) appCategoryId;
//
//-(void) saveOrUpdateTopAppsData:(NSMutableArray *) mData;
//
//#pragma mark 获取应用评论列表
//-(NSMutableArray*) getAppCommentsBytimestamp:(NSNumber *) appId timstamp:(NSString *) timstamp;
//
//#pragma mark 保存或更新会话
//-(void) saveOrUpdateAppComment:(MAppComment *) appComment;
//-(void) saveOrUpdateAppComments:(NSMutableArray *) appComments;
//-(void) deleteAppCommentByAppId:(NSNumber *) appId ;
//
//#pragma mark 保存或更新应用部件
//-(NSMutableArray*) getAppComponmentsByState:(NSInteger) state;
//-(NSMutableArray*) getAppComponmentsByAppId:(NSNumber *) appId;
//-(MAppComponment*) getAppComponmentById:(NSNumber *) comId;
//-(void) saveOrUpdateAppComponment:(MAppComponment *) appComponment;
//-(void) saveOrUpdateAppComponments:(NSMutableArray *) appComponments;
//-(void) deleteAppComponmentByAppId:(NSNumber *) appId;
//
//#pragma mark 保存或更新应用消息部件
//-(NSMutableArray*) getAppMsgComponmentsByAppId:(NSNumber *) appId;
//-(MAppMsgComponment*) getAppMsgComponmentByAppIdAndBizType:(NSNumber *) appId bizType:(NSString *)bizType;
//-(void) saveOrUpdateAppMsgComponment:(MAppMsgComponment *) appComponment;
//-(void) saveOrUpdateAppMsgComponments:(NSMutableArray *) appComponments;
//-(void) deleteAppMsgComponmentByAppId:(NSNumber *)appId;
//
//#pragma mark 保存或更新应用URL配置
//-(MAppUrlHandle*) getAppUrlHandleByAppId:(NSNumber *) appId;
//-(void) saveOrUpdateAppUrlHandles:(NSMutableArray *) handles;
//-(MAppUrlHandle *) getAppUrlHandleByWidgetId:(NSNumber *)widgetId;
//-(void) saveOrUpdateAppUrlHandle:(MAppUrlHandle *) handle;
//-(void) deleteAppUrlHandleByAppId:(NSNumber *)appId;
//
//#pragma mark 好友
//-(NSMutableArray *) getAllFriends:(NSNumber *)fromUserId;
//-(NSMutableArray*) getFriends:(NSNumber *) groupId;
//-(MFriend *) getFriendById:(NSNumber *) friendId fromUserId:(NSNumber *)fromUserId;
//-(NSMutableArray *) getSearchFriends:(NSString *)key fromUserId:(NSNumber *)fromUserId;
//-(void) saveOrUpdateFriendData:(NSMutableArray *) mData;
//-(void) saveOrUpdateFriData:(MFriend *)mData;
//-(void) deleteFriendById:(NSNumber *)friendId;
//-(void) deleteFriendByIds:(NSMutableArray *)friendIds;
//-(void) deleteFriends:(NSNumber *)fromUserId;
//-(void) deleteFriendByGroupId:(NSNumber *)groupId;
//
//#pragma mark 好友分组
//-(NSMutableArray *) getAllGroups:(NSNumber *)fromUserId;
//-(NSMutableArray*) getAllSelectGroups:(NSNumber *)fromUserId groupId:(NSNumber *)groupId;
//-(NSMutableArray*) getAllCustomGroups:(NSNumber *)fromUserId;
//-(MGroup *) getGroupById:(NSNumber *) groupId;
//-(void) saveOrUpdateGroupData:(NSMutableArray *) mData;
//-(void) deleteGroupById:(NSNumber *)groupId;
//-(void) deleteGroupByIds:(NSMutableArray *)groupIds;
//-(void) deleteGroups;
//
//#pragma mark 群发功能
//-(NSMutableArray*) getMessage:(NSNumber *) userId;
//-(void) saveOrUpdateMessage:(MMessage *) msg;
//-(void) saveOrUpdateMessages:(NSMutableArray *) messages;
//-(void) deleteAllMessage;
@end
