//
//  NSObject+Helper.h
//
//  Created by Carl Shen on 12-8-16.
//  Copyright 2012 ailk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefinition.h"
#import "NSDate+Helper.h"
@interface NSObject(common) 



// 去掉uitableview多余分割线
+(void)setExtraCellLineHidden: (UITableView *)tableView;

//UIColor 转UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (NSString *)md5:(NSString *)str;

+ (NSMutableString *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters;

//获取以前的日期(N天前)
+(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)day;

//获取以前的日期(N月前)
+(NSDate *)getPriousDateFromDate:(NSDate *)date withMonth:(int)month;

//根据指定格式获取日期字符串
+(NSString*)getDateTitleWithFormat:(NSDate* )ddatadate withFormat:(NSString*) strformatter;

//获取当前时间
+(NSString*)currentTime;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/*
//转千分位
-(NSString*)toThousand:(NSString*) strnormal;

//获取以前的日期(N天前)
-(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)day;

//获取以前的日期(N月前)
-(NSDate *)getPriousDateFromDate:(NSDate *)date withMonth:(int)month;

//根据指定格式获取日期字符串
-(NSString*)getDateTitleWithFormat:(NSDate* )ddatadate withFormat:(NSString*) strformatter;

//在指定array中寻找指定的字符串
-(int)findString:(NSArray*) arrstr forStr:(NSString*) strfindstr;

//获取随机整数
-(int)getRandNumber:(int)imaxnumber;

//根据十六进制颜色值解析成RGB值
-(NSArray*) HexString2RGB:(NSString*)hexstring;

//根据16进制获取颜色
-(UIColor*)colorWithHexString:(NSString*) hexstring;



//寻找最大值索引值
-(int)findMaxIndex:(NSMutableArray*) arorig;

//寻找最小值索引值
-(int)findMinIndex:(NSMutableArray*) arorig;

//从除了指定下标之外，寻找最大值索引值
-(int)findMaxIndex:(NSMutableArray*) arorig exceptOfIndex:(NSMutableArray*) arexceptindex;

//从除了指定下标之外，寻找最小值索引值
-(int)findMinIndex:(NSMutableArray*) arorig exceptOfIndex:(NSMutableArray*) arexceptindex;

//将数组排序
-(NSMutableArray*)sortArray:(NSMutableArray*) arorig withSortType:(int) isorttype;

//将数组按某一列排序
-(NSMutableArray*)sortArraysByCol:(NSMutableArray*) arorig withColumnMember:(int)iMember withColumnIndex:(int) isortcol withSortType:(int) isorttype;

//千分位格式化字符串
-(NSString*)formatThousand:(NSString*)strnormal;

//根据刻度数重新计算整数值
-(float)calculateIntegerValue:(float)fvalue sectionnumber:(int)isectionnumber adjust:(int)iadjust;

//组装请求参数-1
-(NSString*)assemblePara:(NSString*)strvisittype;

//组装请求参数-2
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate;

//组装请求参数-3
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype channelcode:(NSString*)strchannelcode datadate:(NSString*)strdatadate;

//组装请求参数-4
-(NSString*)assemblePara:(NSString*)strvisittype username:(NSString*)strusername password:(NSString*)strpassword;

//组装请求参数-5
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate kind:(NSString*)strkind;

//组装请求参数-6
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate channelcode:(NSString*)strchannelcode;

//组装请求参数-7
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate mac:(NSString*)strmac;

//组装请求参数-8
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate mac:(NSString*)strmac searchtype:(NSString*)strsearchtype;

//组装请求参数-9
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate mac:(NSString*)strmac controltype:(NSString*)strcontroltype;

//组装请求参数-10
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype programname:(NSString*)strprogramname datadate:(NSString*)strdatadate;

//生成range
-(NSArray*)makeRange:(int)iminvalue maxvalue:(int)imaxvalue;

//应用是否已安装
-(bool)isAppInstalled:(NSString*)strappname;

//UIView生成UIImage
-(UIImage *)getImageFromView:(UIView *)view;


//fusioncharts显示错误时调用
- (void)displayDataError:(UIWebView *)webView;

//创建fusioncharts
- (void)createChartData:(UIWebView *)webView chartData:(NSString*)strchartdata fusiontype:(NSString *)fusiontypeswf htmlContent:(NSMutableString *)htmlcontentstring chartwidth:(NSString *)chartwidth chartHeight:(NSString *)chartheight;

- (void)plotChart:(UIWebView *)webView htmlContent:(NSMutableString *)htmlcontentstring;
- (void)removeChart;

//解析ＪＳＯＮ
-(NSString *) parseFusionChartJSON:(NSString *)strResult parseTypestart:(NSString*) strparseTypeStart ;
*/
@end
