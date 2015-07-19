//
//  IdentifierValidator.m
//  FXShop
//
//  Created by wuxinyi on 14-9-1.
//  Copyright (c) 2014年 武新义. All rights reserved.
//

#import "IdentifierValidator.h"
//#import "NSString+ITTAdditions.h"

int getIndex (char ch);
BOOL isNumber (char ch);

int getIndex (char ch) {
    if ((ch >= '0'&& ch <= '9')||(ch >= 'a'&& ch <= 'z')||
        (ch >= 'A' && ch <= 'Z')|| ch == '_') {
        return 0;
    }
    if (ch == '@') {
        return 1;
    }
    if (ch == '.') {
        return 2;
    }
    return -1;
}

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}
@implementation IdentifierValidator

+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL) validateEmail:(NSString *)candidate
{
    NSArray *array = [candidate componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) isValidEmail:(NSString*)value {
    static int state[5][3] = {
        {1, -1, -1},
        {1,  2, -1},
        {3, -1, -1},
        {3, -1, 4},
        {4, -1, -1}
    };
    BOOL valid = TRUE;
    const char *cvalue = [value UTF8String];
    int currentState = 0;
    int len = strlen(cvalue);
    int index;
    for (int i = 0; i < len && valid; i++) {
        index = getIndex(cvalue[i]);
        if (index < 0) {
            valid = FALSE;
        }
        else {
            currentState = state[currentState][index];
            if (currentState < 0) {
                valid = FALSE;
            }
        }
    }
    //end state is invalid
    if (currentState != 4) {
        valid = FALSE;
    }
    return valid;
}

+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL) isValidPhone:(NSString*)value {
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    if (len != 11) {
        return FALSE;
    }
    if (![IdentifierValidator isValidNumber:value])
    {
        return FALSE;
    }
    NSString *preString = [[NSString stringWithFormat:@"%@",value] substringToIndex:1];
//    if ([preString isEqualToString:@"13"] ||
//        [preString isEqualToString: @"15"] ||
//        [preString isEqualToString: @"18"])
    if ([preString isEqualToString:@"1"])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    return TRUE;
}
+ (BOOL) isValidString:(NSString*)value
{
    return value && [value length];
}
const int factor[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktable[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表
+ (BOOL) isValidIdentifier:(NSString*)value
{
    const int LENGTH = 18;
    const char *str = [[value lowercaseString] UTF8String];
    NSInteger i;
    NSInteger length = strlen(str);
    BOOL result = TRUE;
    /*
     * identifier length is invalid
     */
    if (15 != length && LENGTH != length)
    {
        result = FALSE;
    }
    else
    {
        for (i = 1; i < length - 1; i++)
        {
            if(!(str[i] >= '0' && str[i] <= '9'))
            {
                result = FALSE;
                break;
            }
        }
        if (result)
        {
            if(LENGTH == length)
            {
                if (!((str[i] >= '0' && str[i] <= '9')||str[i] == 'X'||str[i] == 'x'))
                {
                    result = FALSE;
                }
            }
        }
        /*
         * check sum for second generation identifier
         */
        if (result && length == LENGTH)
        {
            int i;
            int *ids = malloc(sizeof(int)*LENGTH);
            for (i = 0; i < LENGTH; i++)
            {
                ids[i] = str[i] - 48;
            }
            int checksum = 0;
            for (i = 0; i < LENGTH - 1; i ++ )
            {
                checksum += ids[i] * factor[i];
            }
            if (ids[17] == checktable[checksum%11]||
                (str[17] == 'x' && checktable[checksum % 11] == 10))
            {
                result  = TRUE;
            }
            else
            {
                result  = FALSE;
            }
            free(ids);
            ids = NULL;
        }
    }
    return result;
}
+ (BOOL) isValidPassport:(NSString*)value
{
    const char *str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G'))
    {
        return FALSE;
    }
    if (first == 'P')
    {
        if (length != 8)
        {
            return FALSE;
        }
    }
    if (first == 'G')
    {
        if (length != 9)
        {
            return FALSE;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++)
    {
        if (!(str[i] >= '0' && str[i] <= '9'))
        {
            result = FALSE;
            break;
        }
    }
    return result;
}
/*
 * 常用信用卡卡号规则
 * Issuer Identifier  Card Number                            Length
 * Diner's Club       300xxx-305xxx, 3095xx, 36xxxx, 38xxxx  14
 * American Express   34xxxx, 37xxxx                         15
 * VISA               4xxxxx                                 13, 16
 * MasterCard         51xxxx-55xxxx                          16
 * JCB                3528xx-358xxx                          16
 * Discover           6011xx                                 16
 * 银联                622126-622925                          16
 *
 * 信用卡号验证基本算法：
 * 偶数位卡号奇数位上数字*2，奇数位卡号偶数位上数字*2。
 * 大于10的位数减9。
 * 全部数字加起来。
 * 结果不是10的倍数的卡号非法。
 * prefrences link:http://www.truevue.org/licai/credit-card-no
 *
 */
+ (BOOL) isValidCreditNumber:(NSString*)value
{
    int sum = 0;
    int len = [value length];
    int i = 0;
    
    while (i < len) {
        NSString *tmpString = [value substringWithRange:NSMakeRange(len - 1 - i, 1)];
        int tmpVal = [tmpString intValue];
        if (i % 2 != 0) {
            tmpVal *= 2;
            if(tmpVal>=10) {
                tmpVal -= 9;
            }
        }
        sum += tmpVal;
        i++;
    }
    
    if((sum % 10) == 0)
        return YES;
    else
        return NO;
}
+ (BOOL) isValidBirthday:(NSString*)birthday
{
    BOOL result = FALSE;
    if (birthday && 8 == [birthday length])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:birthday];
//        [formatter release];
        if (date)
        {
            result = TRUE;
        }
    }
    return result;
}
+ (BOOL) isChinaUnicomPhoneNumber:(NSString*) phonenumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CU = @"^1\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    //    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //    NSString * PHS1 = @"^0(10|2[0-5789]|\\d{3}-)\\d{7,8}$";
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    //    NSPredicate *regextestphs1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS1];
    
    if (//([regextestmobile evaluateWithObject:phonenumber] == YES)||
        //        ([regextestcm evaluateWithObject:phonenumber] == YES)||
        //        ([regextestct evaluateWithObject:phonenumber] == YES)||
        ([regextestcu evaluateWithObject:phonenumber] == YES)
        //        || ([regextestphs evaluateWithObject:phonenumber] == YES)
        //        || ([regextestphs1 evaluateWithObject:phonenumber] == YES)
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) isValid:(IdentifierType) type value:(NSString*) value
{
    if (!value ||[[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return FALSE;
    }
    BOOL result = TRUE;
    switch (type)
    {
        case IdentifierTypeZipCode:
            result = [IdentifierValidator isValidZipcode:value];
            break;
        case IdentifierTypeEmail:
            //            result = [IdentifierValidator isValidEmail:value];
            result = [IdentifierValidator validateEmail:value];
            break;
        case IdentifierTypePhone:
            result = [IdentifierValidator isValidPhone:value];
            break;
        case IdentifierTypeUnicomPhone:
            result = [IdentifierValidator isChinaUnicomPhoneNumber:value];
            break;
        case IdentifierTypeQQ:
            result = [IdentifierValidator isValidNumber:value];
            break;
        case IdentifierTypeNumber:
            result = [IdentifierValidator isValidNumber:value];
            break;
        case IdentifierTypeString:
            result = [IdentifierValidator isValidString:value];
            break;
        case IdentifierTypeIdentifier:
            result = [IdentifierValidator isValidIdentifier:value];
            break;
        case IdentifierTypePassort:
            result = [IdentifierValidator isValidPassport:value];
            break;
        case IdentifierTypeCreditNumber:
            result = [IdentifierValidator isValidCreditNumber:value];
            break;
        case IdentifierTypeBirthday:
            result = [IdentifierValidator isValidBirthday:value];
            break;
        default:
            break;
    }
    return result;
}


@end
