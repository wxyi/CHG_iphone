//
//  SQLiteManager.m
//  seu_iphone
//
//  Created by fanxun on 14-4-29.
//  Copyright (c) 2014年 fanxun. All rights reserved.
//

#import "SQLiteManager.h"
#import "BanKCode.h"


@implementation SQLiteManager
static dispatch_once_t onceToken;
static SQLiteManager *sSharedInstance;

#pragma mark  singleton方法
+(SQLiteManager *)sharedInstance{
    NSString *lastVersion = [ConfigManager sharedInstance].lastClientVersion;
    NSString *currentVersion = [ConfigManager sharedInstance].sysVersion;
    if(lastVersion.length != 0 && ![lastVersion isEqualToString:currentVersion]){//更新
        sSharedInstance = [[SQLiteManager alloc] init];
    } else {
        dispatch_once(&onceToken, ^{
            sSharedInstance = [[SQLiteManager alloc] init];
        });
    }
    return sSharedInstance;
}

#pragma mark 初始化方法
-(id)init{
    self=[super init];
    if(self){
        DLog(@"%@",APPDocumentsDirectory);
        _dbQueue=[FMDatabaseQueue databaseQueueWithPath:[APPDocumentsDirectory  stringByAppendingPathComponent:@"com_zbiti_seu.sqlite"]];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            
        }];
        //NSLog(@"===========%@",APPDocumentsDirectory);
        NSString *lastVersion = [ConfigManager sharedInstance].lastClientVersion;
        NSString *currentVersion = [ConfigManager sharedInstance].sysVersion;
        if(lastVersion.length != 0 && ![lastVersion isEqualToString:currentVersion]){//更新
            [self dropAndQueryTables];
        }
        [self createTable];
        if(lastVersion.length != 0 && ![lastVersion isEqualToString:currentVersion]){//更新
            [self insertOldDatas];
            [ConfigManager sharedInstance].lastClientVersion = [ConfigManager sharedInstance].sysVersion;
            DLog(@"%@",[ConfigManager sharedInstance].lastClientVersion);
        }
    }
    return self;
}

-(void)dropAndQueryTables{
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:@"drop table tbl_bankcode"];
            [db executeUpdate:@"drop table tbl_addressprovince"];
            [db executeUpdate:@"drop table tbl_addresscity"];
            [db executeUpdate:@"drop table tbl_addressarea"];
            if([db hadError]){
                *rollback=YES;
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
        }
    }];
}

-(void)insertOldDatas{
//    [self saveOrUpdateConversations:oldConverations];
//    //[self updateAppsData:oldApps];
//    [self saveOrUpdateAppComponments:oldAppComponments];
//    [self saveOrUpdateAppMsgComponments:oldAppMsgComponments];
//    [self saveOrUpdateAppUrlHandles:oldAppUrlHandles];
//    [self saveOrUpdateAppInstallRecordsData:oldAppInstallRecords];
}


#pragma mark 创建表
-(void) createTable{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            if(![db tableExists:@"tbl_bankcode"]){
                [db executeUpdate:CT_SQL_BankCode];
            }
            if(![db tableExists:@"tbl_addressprovince"]){
                [db executeUpdate:CT_SQL_AddressProvinceCode];
            }
            if(![db tableExists:@"tbl_addresscity"]){
                [db executeUpdate:CT_SQL_AddressCityCode];
            }
            if(![db tableExists:@"tbl_addressarea"]){
                [db executeUpdate:CT_SQL_AddressAreaCode];
            }

            if([db hadError]){
                *rollback=YES;
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
        }
    }];

}

-(NSMutableArray*) getBankCodeDatas{
    __block NSMutableArray *list;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        list = [[NSMutableArray alloc] init];
        FMResultSet *rs=[db executeQuery:Q_SQL_BankCode];
        BanKCode *mData;
        while([rs next]) {
            mData=[[BanKCode alloc] init];
            
            mData.bankName =[rs stringForColumn:@"bankName"];
            mData.bankCode =[rs stringForColumn:@"bankCode"];
            mData.cardCodeList =[rs stringForColumn:@"cardCodeList"];
            
            [list addObject:mData];
        }
        [rs close];
        
    }];
    return list;
}

-(void) deleteBankCodeData{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_BankCode];
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}

-(void) saveOrUpdateBankCodeData:(NSMutableArray *) arrays{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for(BanKCode *mData in arrays){
                [db executeUpdate:R_SQL_BankCode,mData.bankName,mData.bankCode,mData.cardCodeList];
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}
#pragma make 根据cardcode查找银行卡名
-(BanKCode*)getBankCodeDataByCardCode:(NSString*)cardCode
{
    BanKCode *mData=[[BanKCode alloc]init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:Q_SQL_BankCodeByCode,cardCode];

        if(rs.next){
            mData.bankName =[rs stringForColumn:@"bankName"];
            mData.bankCode =[rs stringForColumn:@"bankCode"];
            mData.cardCodeList =[rs stringForColumn:@"cardCodeList"];

        }
        [rs close];
        
    }];
    return mData;
}

-(NSMutableArray*) getProvinceCodeData
{
    __block NSMutableArray *list;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        list = [[NSMutableArray alloc] init];
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressProvinceCode];
        ProvinceInfo *mData;
        while([rs next]) {
            mData=[[ProvinceInfo alloc] init];
            
            mData.strProvince =[rs stringForColumn:@"Province"];
            mData.strProvinceID =[rs stringForColumn:@"ProvinceID"];
            
            [list addObject:mData];
        }
        [rs close];
        
    }];
    return list;

}
-(NSMutableArray*) getAreaCodeData
{
    __block NSMutableArray *list;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        list = [[NSMutableArray alloc] init];
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressAreaCode];
        AreaInfo *mData;
        while([rs next]) {
            mData=[[AreaInfo alloc] init];
            
            mData.strAreaID =[rs stringForColumn:@"AreaID"];
            mData.strAreaName =[rs stringForColumn:@"AreaName"];
            mData.strFatherID =[rs stringForColumn:@"FatherID"];
            
            [list addObject:mData];
        }
        [rs close];
        
    }];
    return list;
}
-(NSMutableArray*) getCityCodeData
{
    __block NSMutableArray *list;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        list = [[NSMutableArray alloc] init];
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressCityCode];
        CityInfo *mData;
        while([rs next]) {
            
            mData=[[CityInfo alloc] init];
            
            mData.strCityID =[rs stringForColumn:@"CityID"];
            mData.strCityName =[rs stringForColumn:@"CityName"];
            mData.strFatherID =[rs stringForColumn:@"FatherID"];
            [list addObject:mData];
        }
        [rs close];
        
    }];
    return list;
}

-(void) deleteProvinceCodeData
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_AddressProvinceCode];
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}
-(void) deleteAreaCodeData
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_AddressArea];
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}
-(void) deleteCityCodeData
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_AddressCity];
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}
-(void) saveOrUpdateProvinceCodeData:(NSMutableArray *) arrays
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for(ProvinceInfo *mData in arrays){
                [db executeUpdate:R_SQL_AddressProvinceCode,mData.strProvince,mData.strProvinceID];
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}
-(void) saveOrUpdateAreaCodeData:(NSMutableArray *) arrays
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for(AreaInfo *mData in arrays){
                [db executeUpdate:R_SQL_AddressAreaCode,mData.strAreaID,mData.strAreaName,mData.strFatherID];
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}
-(void) saveOrUpdateCityCodeData:(NSMutableArray *) arrays
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for(CityInfo *mData in arrays){
                [db executeUpdate:R_SQL_AddressCityCode,mData.strCityID,mData.strCityName ,mData.strFatherID];
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}

-(NSMutableArray*)getAreaCodeDataByFatherID:(NSString*)FatherID
{
    __block NSMutableArray *list;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        list = [[NSMutableArray alloc] init];
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressAreabyFatherID,FatherID];
        AreaInfo *mData;
        while([rs next]) {
            mData=[[AreaInfo alloc] init];
            
            mData.strAreaID =[rs stringForColumn:@"AreaID"];
            mData.strAreaName =[rs stringForColumn:@"AreaName"];
            mData.strFatherID =[rs stringForColumn:@"FatherID"];

            [list addObject:mData];
        }
        [rs close];
        
    }];
    return list;
}
-(NSMutableArray*)getCityCodeDataByFatherID:(NSString*)FatherID
{
    __block NSMutableArray *list;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        list = [[NSMutableArray alloc] init];
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressCitybyFatherID,FatherID];
        CityInfo *mData;
        while([rs next]) {
            mData=[[CityInfo alloc] init];
            
            mData.strCityID =[rs stringForColumn:@"CityID"];
            mData.strCityName =[rs stringForColumn:@"CityName"];
            mData.strFatherID =[rs stringForColumn:@"FatherID"];
            [list addObject:mData];
        }
        [rs close];
        
    }];
    return list;
}

-(ProvinceInfo*)getProvinceNameByProvinceID:(NSString*)ProvinceID{
    ProvinceInfo *mData=[[ProvinceInfo alloc]init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressProvinceCodeByProvinceID,ProvinceID];
        
        if(rs.next){
            mData.strProvince =[rs stringForColumn:@"province"];
            mData.strProvinceID =[rs stringForColumn:@"provinceID"];
        }
        [rs close];
        
    }];
    return mData;
}
-(CityInfo*)getCityNameByCityID:(NSString*)CityID{
    CityInfo *mData=[[CityInfo alloc]init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressCityByCityID,CityID];
        
        if(rs.next){
            mData.strCityID =[rs stringForColumn:@"CityID"];
            mData.strCityName =[rs stringForColumn:@"CityName"];
            mData.strFatherID =[rs stringForColumn:@"FatherID"];
            
        }
        [rs close];
        
    }];
    return mData;
}
-(AreaInfo*)getAreaNameByAreaID:(NSString*)AreaID
{
    AreaInfo *mData=[[AreaInfo alloc]init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:Q_SQL_AddressAreaByDistrictID,AreaID];
        
        if(rs.next){
            mData.strAreaID =[rs stringForColumn:@"AreaID"];
            mData.strAreaName =[rs stringForColumn:@"AreaName"];
            mData.strFatherID =[rs stringForColumn:@"FatherID"];
            
        }
        [rs close];
        
    }];
    return mData;
}
@end
