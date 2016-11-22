//
//  Database.m
//  DbExample
//
//  Created by mac on 08/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "Database.h"
#import "FeedQueryCounter.h"
#import "Feedback.h"
#import "Company.h"
#import "userRoll.h"
#import "Operator.h"
#import "Status.h"
#import "FeedbackType.h"
#import "Query.h"
#import "FeedOrQueryMessageHeader.h"
#import "FeedbackChatingCounter.h"
#import "QueryChatingCounter.h"
#import "AppPreferences.h"
#import "CompanyFeedbackTypeAssociation.h"
#import "CompanyRelatedFeedQueryCounter.h"
#import "Mom.h"
#import "Report.h"
#import "Operator.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"

static Database *db;
@implementation Database
@synthesize getFeedbackAndQueryMessages;
@synthesize feedbackAndQueryTypeArray;
@synthesize SONoArray;
@synthesize DuplicateSONoArray;
@synthesize getFeedbackAndQueryCounter;
+(Database *)shareddatabase
{
    if(!db)
    {
        db=[[Database alloc]init];
        return db;
    }
    else
    {
        return db;
    }
}

-(id)init
{
    if (!db)
    {
        db=[super init];
        
    }
    else
    {
        @throw [NSException exceptionWithName:@"invalid method called" reason:@"use shareddatabase method" userInfo:NULL];
    }
    return db;
}

-(NSString *)getDatabasePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Communicator_DB.sqlite"];
}


- (NSMutableArray *)getFeedbackAndQueryTypes
{
    NSMutableArray* feedbackAndQueryTypesArray=[[NSMutableArray alloc]init];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString *query=@"SELECT * FROM feedbacktype";
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                FeedbackType *fb=[[FeedbackType alloc]init];
                fb.Id =sqlite3_column_int(statement, 0);
                fb.feedbacktype= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                //fb.salary=sqlite3_column_int(statement, 2);
                [feedbackAndQueryTypesArray addObject:fb];
            }
        }
        else
        {
            
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    return feedbackAndQueryTypesArray;
}




-(NSMutableArray*)checkUserAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement9;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT ID FROM user";
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement9, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement9) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement9, 0);
                
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
        }
    }
    else
    {
    }
    
    if (sqlite3_finalize(statement9) == SQLITE_OK)
    {
    }
    else
    {}
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
    }
    return uniqueUserIdArray;
    
    
}


-(NSMutableArray*)checkCompanyAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement3;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT CompanyId FROM company";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement3, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement3) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement3, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
        }
    }
    else
    {
    }
    if (sqlite3_finalize(statement3) == SQLITE_OK)
    {
    }
    else
    {}
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
    }
    return uniqueUserIdArray;
    
    
    
}

-(NSMutableArray*)checkUserRoleAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement2;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT id FROM roles";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement2) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement2, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
        }
    }
    else
    {
    }
    
    if (sqlite3_finalize(statement2) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
    }
    
    return uniqueUserIdArray;
    
    
    
}


-(NSMutableArray*)checkOperatorAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT operator_id FROM operator";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
        }
    }
    else
    {
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
    }
    return uniqueUserIdArray;
    
    
    
}





-(NSMutableArray*)checkStatusIdAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement8;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueStatusIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT Status_Id FROM status";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement8, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement8) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement8, 0);
                [uniqueStatusIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
        }
    }
    else
    {
    }
    
    if (sqlite3_finalize(statement8) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
    }
    return uniqueStatusIdArray;
    
}


-(NSMutableArray*)checkFeedbackTypeIDAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement7;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT ID FROM feedbacktype";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement7, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement7) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement7, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
                
            }
        }
        else
        {
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    if (sqlite3_finalize(statement7) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    return uniqueUserIdArray;
    
    
    
}


-(NSMutableArray*)checkCompanyFeedIdAssoAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueCompanyFeedIdAssoArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT ID FROM CompanyFeedbackTypeAssociation";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueCompanyFeedIdAssoArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    return uniqueCompanyFeedIdAssoArray;
    
    
    
}





int i=3;

-(void)insertCompanyRelatedFeedbackTypeAndUsers:(NSDictionary*)companyRelatedFeedbackAndUsersDict
{
    NSError* error;
    NSString* companyFeedbackTypeAsscociationString=[companyRelatedFeedbackAndUsersDict valueForKey:@"companyFeedBackTypeAssociation"];
    NSData *companyFeedbackTypeAsscociationData = [companyFeedbackTypeAsscociationString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *companyFeedbackTypeAsscociationValue = [NSJSONSerialization JSONObjectWithData:companyFeedbackTypeAsscociationData
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
    
    NSString* userListString=[companyRelatedFeedbackAndUsersDict valueForKey:@"userList"];
    NSData *userListData = [userListString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *userListValue = [NSJSONSerialization JSONObjectWithData:userListData
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&error];

    NSString* operatorListString=[companyRelatedFeedbackAndUsersDict valueForKey:@"listOfOperator"];
    NSData *operatorListData = [operatorListString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *operatorListValue = [NSJSONSerialization JSONObjectWithData:operatorListData
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
    
    NSString* userIdString=[companyRelatedFeedbackAndUsersDict valueForKey:@"userId"];

    
    NSArray* companyIdArray=[companyRelatedFeedbackAndUsersDict valueForKey:@"userCompanyAssociation"];
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* deleteQuery=[NSString stringWithFormat:@"Delete from company Where CompanyId>0"];
    const char * queryi1=[deleteQuery UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"company table data truncated");
            NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        NSLog(@"db is closed");
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    

    for(NSDictionary* companyFeedbackTypeAsscociationDict in companyFeedbackTypeAsscociationValue)
    {
        CompanyFeedbackTypeAssociation* assoObj=[[CompanyFeedbackTypeAssociation alloc]init];
        FeedbackType* feedTypeObj=[[FeedbackType alloc]init];
        Company* companyObj=[[Company alloc]init];
        
        //--------Company and related feedback types---------//
        
        assoObj.Id=[[companyFeedbackTypeAsscociationDict valueForKey:@"id"]intValue];//for CompanyFeedbackTypeAssociation dependancy
        NSDictionary* feedbacktypeDict=[companyFeedbackTypeAsscociationDict valueForKey:@"feedBackType"];
        assoObj.feedbackTypeId= [[feedbacktypeDict valueForKey:@"id"]intValue];//for CompanyFeedbackTypeAssociation dependancy
        
        feedTypeObj.Id=[[feedbacktypeDict valueForKey:@"id"]intValue];
        feedTypeObj.feedbacktype=[feedbacktypeDict valueForKey:@"feedbackType"];
        
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statements = NULL;
        sqlite3* feedbackAndQueryTypesDB1;

        NSString *query3=[NSString stringWithFormat:@"INSERT INTO feedbacktype values(\"%d\",\"%@\")",feedTypeObj.Id,feedTypeObj.feedbacktype];
        
        const char * queryi3=[query3 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB1)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB1, queryi3, -1, &statements, NULL);
            if(sqlite3_step(statements)==SQLITE_DONE)
            {
                
                sqlite3_reset(statements);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB1));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB1));
        }
        
        if (sqlite3_finalize(statements) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB1));
        
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB1) == SQLITE_OK)
        {
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB1));
        }
    
        NSDictionary* companyDict=[companyFeedbackTypeAsscociationDict valueForKey:@"company"];
        assoObj.companyId=[[companyDict valueForKey:@"companyId"]intValue];//for CompanyFeedbackTypeAssociation dependancy

        companyObj.ComanyId=[[companyDict valueForKey:@"companyId"]intValue];
        companyObj.Company_Name=[companyDict valueForKey:@"companyName"];
        companyObj.Company_Address=[companyDict valueForKey:@"companyAddress"];
        companyObj.Company_Contact=[companyDict valueForKey:@"companyContact"];
        companyObj.Company_Email=[companyDict valueForKey:@"companyEmail"];
        
        //-------Company and related users with coreflex users-------//
        
       [[companyFeedbackTypeAsscociationDict valueForKey:@"userList"]intValue];
        
        
        sqlite3_stmt *statement = NULL;
        sqlite3* feedbackAndQueryTypesDB;
        NSString* deleteQuery=[NSString stringWithFormat:@"Delete from company Where CompanyId>0"];

               /* Data insertion: feedback table */
        
        NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
        NSMutableArray* UniqueFeedbackTypeIdArray=[self checkFeedbackTypeIDAvailableOrNot];
        NSMutableArray* UniqueFeedCompanyAssoArray=[self checkCompanyFeedIdAssoAvailableOrNot];

        if (!([uniqueCompanyIdArray containsObject:[NSString stringWithFormat:@"%d",companyObj.ComanyId]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",companyObj.ComanyId,companyObj.Company_Name,companyObj.Company_Address,companyObj.Company_Contact,companyObj.Company_Email,@""];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                   
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }

        }
        
        if (!([UniqueFeedbackTypeIdArray containsObject:[NSString stringWithFormat:@"%d",feedTypeObj.Id]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO feedbacktype values(\"%d\",\"%@\")",feedTypeObj.Id,feedTypeObj.feedbacktype];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"feedbackType table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }

        }
        

        if (!([UniqueFeedCompanyAssoArray containsObject:[NSString stringWithFormat:@"%d",assoObj.Id]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO CompanyFeedbackTypeAssociation values(\"%d\",\"%d\",\"%d\")",assoObj.Id,assoObj.feedbackTypeId,assoObj.companyId];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }

        }

        
//        const char * queryi1=[deleteQuery UTF8String];
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//        {
//            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
//            if(sqlite3_step(statement)==SQLITE_DONE)
//            {
//                NSLog(@"feedback table data inserted");
//                NSLog(@"%@",NSHomeDirectory());
//                sqlite3_reset(statement);
//            }
//            else
//            {
//                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        else
//        {
//            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        if (sqlite3_finalize(statement) == SQLITE_OK)
//        {
//            NSLog(@"statement is finalized");
//        }
//        else
//            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        
//        
//        
//        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//        {
//            NSLog(@"db is closed");
//        }
//        else
//        {
//            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//


    }
    
    
    for (NSDictionary* userListDict in userListValue)
    {
       User *userobj=[[User alloc]init];
        userRoll *userRollObj=[[userRoll alloc]init];
        Company *companyObj=[[Company alloc]init];
       userobj.Id= [[userListDict valueForKey:@"userId"]intValue];
       userobj.username= [userListDict valueForKey:@"userName"];
       userobj.password= [userListDict valueForKey:@"password"];
       NSDictionary* userRollDict= [userListDict valueForKey:@"userRoll"];
          userRollObj.Id=[[userRollDict valueForKey:@"id"]intValue];//user depedancy on userRollObj.Id
          userRollObj.role=[userRollDict valueForKey:@"role"];
       NSDictionary* companyDict=[userListDict valueForKey:@"company"];
          companyObj.ComanyId=[[companyDict valueForKey:@"companyId"]intValue];
          companyObj.Company_Name=[companyDict valueForKey:@"companyName"];
          companyObj.Company_Address=[companyDict valueForKey:@"companyAddress"];
          companyObj.Company_Contact=[companyDict valueForKey:@"companyContact"];
          companyObj.Company_Email=[companyDict valueForKey:@"companyEmail"];
       userobj.email= [userListDict valueForKey:@"email"];
       userobj.mobileNo= [userListDict valueForKey:@"mobileNo"];
       userobj.firstName=[userListDict valueForKey:@"firstName"];
       userobj.lastName=[userListDict valueForKey:@"lastName"];
       userobj.deviceToken=[userListDict valueForKey:@"deviceToken"];


        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement = NULL;
        sqlite3* feedbackAndQueryTypesDB;
        
        NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
        NSMutableArray* uniqueUserIdArray=[self checkUserAvailableOrNot];
        
        if (!([uniqueCompanyIdArray containsObject:[NSString stringWithFormat:@"%d",companyObj.ComanyId]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",companyObj.ComanyId,companyObj.Company_Name,companyObj.Company_Address,companyObj.Company_Contact,companyObj.Company_Email,@""];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }

        }
        
        
        if (!([uniqueUserIdArray containsObject:[NSString stringWithFormat:@"%d",userobj.Id]]))
        {
            
            NSString *query2=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",userobj.Id,userobj.password,userobj.username,userRollObj.Id,companyObj.ComanyId,userobj.email,userobj.mobileNo,userobj.firstName,userobj.lastName,userobj.deviceToken];
            
            const char * queryi2=[query2 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi2, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                   
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }

        }
    }
    
    // insert operators
    
    for (NSDictionary* singleOperatorDict in operatorListValue)
    {
        Operator* operatorObj=[[Operator alloc]init];
        operatorObj.operatorId=[[singleOperatorDict valueForKey:@"operatorId"]intValue];
        operatorObj.firstName=[singleOperatorDict valueForKey:@"firstName"];
        operatorObj.lastName=[singleOperatorDict valueForKey:@"lastName"];
        operatorObj.userName=[singleOperatorDict valueForKey:@"userName"];
        operatorObj.status=[singleOperatorDict valueForKey:@"status"];
        
        
            Database *db=[Database shareddatabase];
            NSString *dbPath=[db getDatabasePath];
            sqlite3_stmt *statement;
            sqlite3* feedbackAndQueryTypesDB;

            NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",operatorObj.operatorId,operatorObj.firstName,operatorObj.lastName,operatorObj.status,operatorObj.userName];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
                NSLog(@"statement is finalized");
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
                NSLog(@"db is closed");
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
        

    }
    
    for (int i=0; i<companyIdArray.count; i++)
    {
   
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO userpermission(CompanyId,USER_ID) values(\"%d\",\"%d\")",[[companyIdArray objectAtIndex:i] intValue],[userIdString intValue]];
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        NSLog(@"db is closed");
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    }
    
}



-(void)insertFeedQueryCounter:(NSDictionary*)companyWithFeedQueryCounters
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL;
    sqlite3* feedbackAndQueryTypesDB;
    NSError* error;
    NSString* feedcomCommunicationCounterString=[companyWithFeedQueryCounters valueForKey:@"feedcomCommunicationCounter"];
    NSData *feedcomCommunicationCounterData = [feedcomCommunicationCounterString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *feedcomCommunicationCounterValue = [NSJSONSerialization JSONObjectWithData:feedcomCommunicationCounterData
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:&error];
    
//    
//    NSString* querycomCommunicationCounterString=[companyWithFeedQueryCounters valueForKey:@"querycomCommunicationCounter"];
//    NSData *querycomCommunicationCounterData = [querycomCommunicationCounterString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *querycomCommunicationCounterValue = [NSJSONSerialization JSONObjectWithData:querycomCommunicationCounterData
//                                                                                      options:NSJSONReadingAllowFragments
//                                                                                        error:&error];
    //NSArray* arr1=[[NSArray alloc]init];
    int j=1;
    NSMutableDictionary* queryTypeCounterBufferDict=[[NSMutableDictionary alloc]init];
    
    //---------for loop for getting query counters from web service insert-> company id as a key with their respective feedtype and counters into dictionary queryTypeCounterBufferDict for future inertion for counters into db-------
    
    //CompanyFeedTypeAndCounter
    NSString *query5=@"DELETE FROM CompanyFeedTypeAndCounter WHERE id>0";
    
    const char * queryi5=[query5 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi5, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
   
    
     }
    else
   {
    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
   }

    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }


//    for(NSString* companyObjectString in [querycomCommunicationCounterValue allKeys])
//    {
//        NSMutableArray* queryCounterBufferArray=[[NSMutableArray alloc]init];
//        
//        NSData *companyObjectdata = [companyObjectString dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSDictionary *companyDict = [NSJSONSerialization JSONObjectWithData:companyObjectdata
//                                                                    options:NSJSONReadingAllowFragments
//                                                                      error:&error];
//        
//        NSLog(@"%@",companyDict);
//        int companyID=[[companyDict valueForKey:@"companyId"]intValue];
//        NSLog(@"%d",companyID);
//
//        
//        NSArray*  feedbackTypesAndCountersArray=  [querycomCommunicationCounterValue valueForKey:companyObjectString];//get array of feedtypes with respective counts for company=#companyObjectString from main dict @"querycomCommunicationCounter"
//        for (int i=0; i<feedbackTypesAndCountersArray.count; i++)
//        {
//            //[feedbackTypesAndCountersArray objectAtIndex:i];
//            NSDictionary* feedTypeAndCountDic=  [feedbackTypesAndCountersArray objectAtIndex:i];
//            int count = [[feedTypeAndCountDic valueForKey:@"count"]intValue];
//            [queryCounterBufferArray addObject:[NSString stringWithFormat:@"%d",count]];
//        }
//        //queryTypeCounterBufferDict=[NSMutableDictionary dictionaryWithObject:queryCounterBufferArray forKey:[NSString stringWithFormat:@"%d",j]];
//        [queryTypeCounterBufferDict setObject:queryCounterBufferArray forKey:[NSString stringWithFormat:@"%d",companyID]];
//    }
    //  NSLog(@"%ld",queryCounterBufferArray.count);
    
    //--------------------------------
    
    
    
    //----------------for loop for insertion or updation of feed or query counters------------

    //--------******fetch all keys of feedcomCommunicationCounterValue in companyObjectString******--------//
    
    for(NSString* companyObjectString in [feedcomCommunicationCounterValue allKeys])
    {
        
        NSData *companyObjectdata = [companyObjectString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *companyDict = [NSJSONSerialization JSONObjectWithData:companyObjectdata
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
        
        int companyID=[[companyDict valueForKey:@"companyId"]intValue];
        
        NSArray*  feedbackTypesAndCountersArray=  [feedcomCommunicationCounterValue valueForKey:companyObjectString];  //will get array of feedtype with counters for one company
        //NSArray* queryCounterForCompanyArray=[queryTypeCounterBufferDict valueForKey:[NSString stringWithFormat:@"%d",companyID]];//will get querycounter from queryTypeCounterBufferDict from particuler company(companyID)

        for (int i=0; i<feedbackTypesAndCountersArray.count; i++)
        {
            CompanyRelatedFeedQueryCounter* obj=[[CompanyRelatedFeedQueryCounter alloc]init];
            obj.companyId=[[companyDict valueForKey:@"companyId"]intValue];

            NSDictionary* feedTypeAndCountDic=  [feedbackTypesAndCountersArray objectAtIndex:i];
            obj.feedCounter = [[feedTypeAndCountDic valueForKey:@"count"]intValue];
            NSDictionary* feedbackTypeDict=[feedTypeAndCountDic valueForKey:@"feedBackTypeTable"];
            obj.feedTypeId= [[feedbackTypeDict valueForKey:@"id"]intValue];
            
            obj.closedCounter = [[feedTypeAndCountDic valueForKey:@"closeCount"]longValue];
            obj.totalCounter = [[feedTypeAndCountDic valueForKey:@"totalCount"]longValue];

            //NSLog(@"%@",[queryCounterForCompanyArray objectAtIndex:i]);
            //obj.queryCounter=0;
            
           // NSLog(@"j=%d company id=%d,id=%d,feedCount=%d,queryCount=%d ",j,obj.companyId,obj.feedTypeId,obj.feedCounter,obj.queryCounter);

            
           
            
            NSString *query1=[NSString stringWithFormat:@"INSERT INTO CompanyFeedTypeAndCounter values(\"%d\",\"%d\",\"%d\",\"%ld\",\"%ld\",\"%ld\")",j,obj.companyId,obj.feedTypeId,obj.feedCounter,obj.closedCounter,obj.totalCounter];
            
            const char * queryi1=[query1 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }

            j++;
 
            }

        

        
        NSLog(@"%@",feedbackTypesAndCountersArray);
        
    }
}



-(NSMutableArray*)findPermittedCompaniesForUsername:(NSString*)usernameString Password:(NSString*)passwordString;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL,*statement1=NULL,*statement2=NULL,*statement10=NULL;
    sqlite3* feedbackAndQueryTypesDB;
    NSError* error;
    NSMutableArray* companyNameOrIdArray=[[NSMutableArray alloc]init];

    
NSString * query = [NSString stringWithFormat:@"SELECT CompanyId FROM user Where USER_NAME='%@' and PASSWORD='%@'",usernameString,passwordString];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                 const char * userId = (const char*)sqlite3_column_text(statement, 0);
                 NSString* companyId=[NSString stringWithUTF8String:userId];
                
                 if ([companyId isEqual:@"1"])
                 {
                    
                    //NSString * query1 = @"SELECT Company_Name FROM company Where CompanyId!=1";
                     NSString* query1=[NSString stringWithFormat:@"SELECT CompanyId from userpermission WHERE USER_ID=(SELECT ID FROM user WHERE USER_NAME='%@')",usernameString];
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement1) == SQLITE_ROW)
                        {
                            const char * companyNameUTF = (const char*)sqlite3_column_text(statement1, 0);
                            NSString* companyName=[NSString stringWithUTF8String:companyNameUTF];
                         //   [companyNameOrIdArray addObject:companyName];
                            
                            NSString* query2=[NSString stringWithFormat:@"SELECT Company_Name FROM company Where CompanyId=%d",[companyName intValue]];
                            
                            if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query2 UTF8String], -1, &statement10, NULL) == SQLITE_OK)// 2. Prepare the query
                            {
                                while (sqlite3_step(statement10) == SQLITE_ROW)
                                {
                                    const char * companyNameUTF = (const char*)sqlite3_column_text(statement10, 0);
                                    NSString* companyName=[NSString stringWithUTF8String:companyNameUTF];
                                    [companyNameOrIdArray addObject:companyName];
                                    
                                }
                            }

                            
                            
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }

                 }
                
                
                else
                {
                    NSString * query2 = [NSString stringWithFormat:@"SELECT Company_Name FROM company Where CompanyId=%@",companyId];
                    
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query2 UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement2) == SQLITE_ROW)
                        {
                            const char * companyNameUTF = (const char*)sqlite3_column_text(statement2, 0);
                            NSString* companyName=[NSString stringWithUTF8String:companyNameUTF];
                            [companyNameOrIdArray addObject:companyName];
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    


                
                }
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    if (sqlite3_finalize(statement1) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
  
    if (sqlite3_finalize(statement2) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    

    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    


    return companyNameOrIdArray;


}



-(void)getFeedbackAndQueryCounterForCompany:(NSString*)companyName;
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL,*statement1=NULL,*statement2=NULL;
    sqlite3* feedbackAndQueryTypesDB;
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.feedTypeWithFeedCounterDict=[[NSMutableDictionary alloc]init];
//    app.feedTypeWithQueryCounterDict=[[NSMutableDictionary alloc]init];
    app.feedQueryCounterDictsWithTypeArray=[[NSMutableArray alloc]init];
    
    NSString * query = [NSString stringWithFormat:@"SELECT feedbackTypeId,feedCounter,closedCounter,totalCounter FROM CompanyFeedTypeAndCounter Where companyId=(Select CompanyId from company Where Company_Name='%@')",companyName];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            BOOL row=NO;
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                row=YES;
                const char * feedbackTypeIdUTF = (const char*)sqlite3_column_text(statement, 0);
                
                const char * feedCounterUTF = (const char*)sqlite3_column_text(statement, 1);
                int feedCounter=[[NSString stringWithUTF8String:feedCounterUTF]intValue];
                
                const char * closedCounterUTF = (const char*)sqlite3_column_text(statement, 2);
                int closedCounter=[[NSString stringWithUTF8String:closedCounterUTF]intValue];
                
                const char * totalCounterUTF = (const char*)sqlite3_column_text(statement, 3);
                int totalCounter=[[NSString stringWithUTF8String:totalCounterUTF]intValue];


                //NSLog(@"%@,%@,%d,%d",companyName,feedbackTypeId,feedCounter,queryCounter);
               NSString* userFrom= [[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];
                NSString* userTo=[[NSUserDefaults standardUserDefaults] valueForKey:@"userTo"];

                int feedbackTypeIdInt=[[NSString stringWithUTF8String:feedbackTypeIdUTF]intValue];
                NSString * query1 = [NSString stringWithFormat:@"SELECT Feedback_Type FROM feedbacktype Where ID=%d",feedbackTypeIdInt];
                NSString * query2 = [NSString stringWithFormat:@"SELECT readStatus FROM feedback Where feedBackType=%d and ((userFrom=%d and userTo=%d) or (userFrom=%d and userTo=%d))",feedbackTypeIdInt,[userFrom intValue],[userTo intValue],[userTo intValue],[userFrom intValue]];

                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        FeedQueryCounter* obj=[[FeedQueryCounter alloc]init];
                        const char * feedbackTypeUTF = (const char*)sqlite3_column_text(statement1, 0);
                        NSString* feedbackType=[NSString stringWithUTF8String:feedbackTypeUTF];
                        obj.feedbackType=feedbackType;
                        obj.openCounter=feedCounter;
                        obj.closedCounter=closedCounter;
                        obj.totalCounter=totalCounter;
                        
                        
                        int readStatus;
                        NSMutableArray* readStatusArray=[[NSMutableArray alloc]init];
                        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query2 UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                        {
                            while (sqlite3_step(statement2) == SQLITE_ROW)
                            {
                                readStatus = sqlite3_column_int(statement2, 0);
                                [readStatusArray addObject:[NSString stringWithFormat:@"%d",readStatus]];
                            }
                        }
                        
                        if ([readStatusArray containsObject:@"1"])
                        {
                            obj.readStatus=1;
                        }
                        else
                        {
                            obj.readStatus=0;
                        }
                        readStatusArray=nil;
//                        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//                        NSString* flag=[defaults valueForKey:@"flag"];
//                        NSString* userFrom,*userTo;
//                        NSLog(@"%@",flag);
//                        NSString* currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
//                        NSString* companyId=[db getCompanyId:currentUser];
//                        if ([companyId isEqual:@"1"])
//                        {
//                            NSString* selectedCompany=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
//                            userTo=[db getUserNameFromCompanyname:selectedCompany];
//                            userFrom=currentUser;
//                        }
//                        else
//                        {
//                            userFrom=currentUser;
//                            userTo=[db getuserNameFromCompanyId:@"1"];
//                        }
//                        
//                        NSString* que=[NSString stringWithFormat:@"Select distinct SO_Number,statusId from feedback Where feedBackType=(Select ID from feedbacktype Where Feedback_Type='%@') and ((userFrom=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)) and (userTo=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)) or (userFrom=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)) and (userTo=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)))",feedbackType,userFrom,userTo,userTo,userFrom];
//
//                        
//                        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
//                        {
//                            if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [que UTF8String], -1, &statement7, NULL) == SQLITE_OK)// 2. Prepare the query
//                            {
//                                int activeCounter=0,closedCounter=0;
//                                while (sqlite3_step(statement7) == SQLITE_ROW)
//                                {
//                                    const char * userId = (const char*)sqlite3_column_text(statement7, 0);
//                                    NSString* soNumber=[NSString stringWithUTF8String:userId];
//                                    const char * statusId = (const char*)sqlite3_column_text(statement7, 1);
//                                    NSString* statusIdString=[NSString stringWithUTF8String:statusId];
//                                    if ([statusIdString isEqual:@"1"])
//                                    {
//                                        activeCounter++;
//                                    }
//                                    else
//                                        closedCounter++;
//                                    NSLog(@"%@",statusIdString);
//                                }
//                                obj.activeCounter=activeCounter;
//                                obj.closeCounter=closedCounter;
//                            }
//                            else
//                            {
//                                NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                            }
//                        }
//                        else
//                        {
//                            NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        }
//                        if (sqlite3_finalize(statement7) == SQLITE_OK)
//                        {
//                            NSLog(@"statement is finalized");
//                        }
//                        else
//                            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        
                        [app.feedQueryCounterDictsWithTypeArray addObject:obj];

                        
                    }
                }
                else
                {
                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement1) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
          
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    



}







-(void)setDatabaseToCompressAndShowTotalQueryOrFeedback:(NSString*)feedbackType
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3_stmt *statement1 = NULL;
    sqlite3_stmt *statement2=NULL;
    sqlite3_stmt *statement3=NULL;
    sqlite3_stmt *statement4=NULL;
    sqlite3_stmt *statement5=NULL;


    FeedOrQueryMessageHeader* headerObj;
    sqlite3* feedbackAndQueryTypesDB;
   // NSMutableArray* getFeedbackAndQueryMessages=[[NSMutableArray alloc]init];
    
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.feedQueryMessageHeaderArray=[[NSMutableArray alloc]init];
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSString* flag=[defaults valueForKey:@"flag"];
    NSString* userFrom,*userTo;
   NSString* currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[db getCompanyId:currentUser];
    
    NSString* clientUserFrom;
    if ([companyId isEqual:@"1"])
    {
        NSString* selectedCompany=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
        userTo=[db getUserNameFromCompanyname:selectedCompany];
        clientUserFrom=userTo;
        userFrom=currentUser;
        
    }
    else
    {
        //NSString* selectedCompany=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
        userFrom=currentUser;
        clientUserFrom=currentUser;

        //[db getuserNameFromCompanyId:@"1"];
        userTo=[db getuserNameFromCompanyId:@"1"];
    }

   
   // @"Select ID from user Where Company_Id=(Select Company_Id from user Where USER_NAME='%@') and USER_ROLL=1";
    NSString* que=[NSString stringWithFormat:@"Select distinct SO_Number,feedBackType from feedback Where feedBackType=(Select ID from feedbacktype Where Feedback_Type='%@') and ((userFrom=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)) and (userTo=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)) or (userFrom=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)) and (userTo=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1)))",feedbackType,userFrom,userTo,userTo,userFrom];
    
    
//     and (userFrom=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1) or userTo=(Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1))
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [que UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                const char * SO_Number = (const char*)sqlite3_column_text(statement, 0);
                NSString *SO_NumberString=[NSString stringWithFormat:@"%s",SO_Number];
                
                const char * feedBackType = (const char*)sqlite3_column_text(statement, 1);
                NSString *feedBackTypeString=[NSString stringWithFormat:@"%s",feedBackType];
                
//                NSString* query4=[NSString stringWithFormat:@"Select Feedback_text from feedback where SO_Number='%s' AND feedbackCounter=(Select MAX(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType=(Select feedBackType from feedback where SO_Number='%s')) ",SO_Number,SO_Number,SO_Number];
 NSString* query4=[NSString stringWithFormat:@"Select Feedback_text from feedback where SO_Number='%s' AND feedbackCounter=(Select MAX(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType='%@') ",SO_Number,SO_Number,feedBackTypeString];
                
                
//(Select MAX(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType=(Select feedBackType from feedback where SO_Number='%s')
                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                {
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query4 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement1) == SQLITE_ROW)
                        {
                           headerObj=[[FeedOrQueryMessageHeader alloc]init];
                            const char * feedTextMsg = (const char*)sqlite3_column_text(statement1, 0);
                            NSString *str2=[NSString stringWithFormat:@"%s",feedTextMsg];
                            //const char * statusId = (const char*)sqlite3_column_text(statement1, 1);
                           // NSString *statusIdString=[NSString stringWithFormat:@"%s",statusId];
                            headerObj.soNumber=SO_NumberString;
                            headerObj.feedText=str2;
                            headerObj.feedbackType=[feedBackTypeString intValue];
                           // headerObj.statusId=[statusIdString intValue];
                            //NSLog(@"%@",statusIdString);
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    
                    //---
                    NSString* reafStatusQuery=[NSString stringWithFormat:@"Select readStatus from feedback where SO_Number='%s' AND feedBackType=%d",SO_Number,headerObj.feedbackType];
                    NSMutableArray* readStatusArray=[[NSMutableArray alloc]init];
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [reafStatusQuery UTF8String], -1, &statement5, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement5) == SQLITE_ROW)
                        {
                            int readStatus = sqlite3_column_int(statement5, 0);
                            
                            [readStatusArray addObject:[NSString stringWithFormat:@"%d",readStatus]];
                                                        // headerObj.statusId=[statusIdString intValue];
                            //NSLog(@"%@",statusIdString);
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    int readStatusCount=0;
                    for (int i=0; i<readStatusArray.count; i++)
                    {
                        if ([[readStatusArray objectAtIndex:i] isEqual:@"1"])
                        {
                            readStatusCount++;
                        }
                    }
                    headerObj.readStatus=readStatusCount;
                    //---
                }
                else
                {
                    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement1) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                
                if (sqlite3_finalize(statement5) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));

                //---------------------------------------------------
                NSString* getuserFeedbackQuery=[NSString stringWithFormat:@"Select userFeedback from feedback where SO_Number='%s' AND feedbackCounter=(Select MAX(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType=(Select feedBackType from feedback where SO_Number='%s'))",SO_Number,SO_Number,SO_Number];
                
                
                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                {
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [getuserFeedbackQuery UTF8String], -1, &statement3, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement3) == SQLITE_ROW)
                        {
                            const char * userFeedback = (const char*)sqlite3_column_text(statement3, 0);
                            NSString *userFeedbackString=[NSString stringWithFormat:@"%s",userFeedback];
                            
                             NSString* getUsernameQuery=[NSString stringWithFormat:@"Select First_NAME,LastName from user where ID='%@'",userFeedbackString];
                            
                            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                            {
                                
                                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [getUsernameQuery UTF8String], -1, &statement4, NULL) == SQLITE_OK)// 2. Prepare the query
                                {
                                    while (sqlite3_step(statement4) == SQLITE_ROW)
                                    {
                                        const char * firstname = (const char*)sqlite3_column_text(statement4, 0);
                                        NSString *firstnameString=[NSString stringWithFormat:@"%s",firstname];
                                        
                                        const char * lastname = (const char*)sqlite3_column_text(statement4, 1);
                                        NSString *lastnameString=[NSString stringWithFormat:@"%s",lastname];
                                        
                                        headerObj.firstname=firstnameString;
                                        headerObj.lastname=lastnameString;
                                    }
                                }
                                else
                                {
                                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                                }
                             }
                            
                            else
                            {
                                NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                            }
                            
                            if (sqlite3_finalize(statement4) == SQLITE_OK)
                            {
                            }
                            else
                                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));

                            //---
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                }
                else
                {
                    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement3) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                

                
                
                //-----------------------------------------------------
                
                
                NSString* getDateAndTimeOfFeedcomOrQuerycom=[NSString stringWithFormat:@"Select dateoffeed,statusId from feedback where SO_Number='%s' AND feedbackCounter=(Select MAX(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType=(Select feedBackType from feedback where SO_Number='%s'))",SO_Number,SO_Number,SO_Number];

                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                {
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [getDateAndTimeOfFeedcomOrQuerycom UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement2) == SQLITE_ROW)
                        {
                            const char * feedDate = (const char*)sqlite3_column_text(statement2, 0);
                            NSString *FeedDateString=[NSString stringWithFormat:@"%s",feedDate];
                            headerObj.feedDate=FeedDateString;
                            
                            const char * statusId = (const char*)sqlite3_column_text(statement2, 1);
                            NSString *statusIdString=[NSString stringWithFormat:@"%s",statusId];
                            headerObj.statusId=[statusIdString intValue];
                            [app.feedQueryMessageHeaderArray addObject:headerObj];
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                }
                else
                {
                    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                
                if (sqlite3_finalize(statement2) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                
                

                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    //sorting for latest date message on top
  FeedOrQueryMessageHeader*  headerObj1=[[FeedOrQueryMessageHeader alloc]init];
    FeedOrQueryMessageHeader*  headerObj2=[[FeedOrQueryMessageHeader alloc]init];
    FeedOrQueryMessageHeader*  temp=[[FeedOrQueryMessageHeader alloc]init];

    NSComparisonResult result;

    for (int i=0; i<app.feedQueryMessageHeaderArray.count; i++)
    {
        for (int j=1; j<app.feedQueryMessageHeaderArray.count-i; j++)
        {
           headerObj1= [app.feedQueryMessageHeaderArray objectAtIndex:j-1];
          headerObj2=  [app.feedQueryMessageHeaderArray objectAtIndex:j];
            result=[headerObj1.feedDate compare:headerObj2.feedDate];
            if (result==NSOrderedAscending)
            {
                temp=[app.feedQueryMessageHeaderArray objectAtIndex:j-1];
                [app.feedQueryMessageHeaderArray replaceObjectAtIndex:j-1 withObject:[app.feedQueryMessageHeaderArray objectAtIndex:j]];
                [app.feedQueryMessageHeaderArray replaceObjectAtIndex:j withObject:temp];
                
            }
        }
    }


}


-(void)getDetailMessagesofFeedbackOrQuery:(int)feedType :(NSString *)SONumber
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement2;
    sqlite3* feedbackAndQueryTypesDB;
   // NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    NSString* query3=[NSString stringWithFormat:@"SELECT Feedback_text,userFeedBack,statusId,EmailSubject,dateoffeed,Attachments,Feedback_id FROM feedback where feedBackType=%d AND SO_Number='%@'",feedType,SONumber];
//    NSString* query2=[NSString stringWithFormat:@"SELECT Query_text,userQuery,userTo,subject,dateofquery,attachment FROM query where feedBackType=%d AND SO_Number='%@'",feedType,SONumber];
   // NSString* query3;
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];

    NSString* str=[defaults valueForKey:@"flag"] ;
    FeedbackChatingCounter *allMessageObj;
//    if ([str isEqualToString:@"0"])
//    {
//        query3=[NSString stringWithFormat:@"%@",query1];
//    }
//    else
//        query3=[NSString stringWithFormat:@"%@",query2];
    
        app.FeedbackOrQueryDetailChatingObjectsArray=[[NSMutableArray alloc]init];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray* userFromUserToArray=[[NSMutableArray alloc]init];
                
                    allMessageObj=[[FeedbackChatingCounter alloc]init];
                
                NSString* messageString = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                NSString* userFromString = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString* statusIdString = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString* emailSubject = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString* dateOfFeed = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                NSString* attachments = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                NSString* feedbackId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];


                
                //[userFromUserToArray addObject:userFromString];
               // [userFromUserToArray addObject:userFromString];
                NSString* userFrom,*userTo,*firstName,*lastName;

//                for (int i=0; i<userFromUserToArray.count; i++)
//                {
                   // NSString* str=[NSString stringWithFormat:@"%@",[userFromUserToArray objectAtIndex:i]];
               
                    NSString* UserfromToQuery=[NSString stringWithFormat:@"SELECT First_NAME,LastName,USER_NAME FROM user where ID='%@'",userFromString];
                

                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [UserfromToQuery UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                      while (sqlite3_step(statement2) == SQLITE_ROW)
                      {
                        
                         
                             firstName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 0)];
                               lastName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 1)];
                               userFrom=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                          
                            userTo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 2)];
                          
                          
                      }
                        
                    
                    }
                    else
                    {
                      NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                   
                    if (sqlite3_finalize(statement2) == SQLITE_OK)
                    {
                    }
                    else
                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    
                    

                 //}
                
               
                    allMessageObj.soNumber=SONumber;
                    allMessageObj.userFrom=userFrom;
                    allMessageObj.userTo=userTo;
                    allMessageObj.emailSubject=emailSubject;
                    allMessageObj.dateOfFeed=dateOfFeed;
                allMessageObj.detailMessage=messageString;
                allMessageObj.feedbackType=feedType;
                allMessageObj.attachments=attachments;
                allMessageObj.feedbackCounter=[feedbackId longLongValue];
                allMessageObj.statusId=[statusIdString intValue];
                    [app.FeedbackOrQueryDetailChatingObjectsArray addObject:allMessageObj];
                
                

                
            }
            

        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
       
        
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    //return uniqueUserIdArray;

}


-(BOOL)validateUserFromLocalDatabase:(NSString *)usernameString :(NSString *)passwordString
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    BOOL flag=false;
    NSString* query1=[NSString stringWithFormat:@"SELECT USER_NAME,PASSWORD FROM user"];
    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {

               // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                NSString* username=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                NSString* password=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                if ([username isEqualToString:usernameString] && [password isEqualToString:passwordString])
                {
                    flag=true;
                }
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    return flag;
}



-(void)setMOMView
{
   
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    app.allMomArray=[[NSMutableArray alloc]init];
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[db getCompanyId:username];
    NSString* userFeedbac=[db getUserIdFromUserName:username];
    NSString* userTo;
    // NSString* selectedCompany = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
    if ([companyId isEqual:@"1"])
    {
        
        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
        userTo=[db getUserIdFromUserNameWithRoll1:username];
        
        //userTo=[db getCompanyId: [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
        
    }
    else
    {
      userTo=[db getUserIdFromUserNameWithRoll1:username];
    
    }
    

    NSString* query1=[NSString stringWithFormat:@"SELECT * FROM mom Where userFrom=%@ or userTo=%@ Order by mom_date DESC",userTo,userTo];

    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Mom* momObj=[[Mom alloc]init];
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                momObj.Id=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]intValue];
                
                momObj.attendee=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                momObj.momDate=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                momObj.keyPoints=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                momObj.subject=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                momObj.userFrom=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 5)]intValue];
                
                momObj.userTo=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 6)]intValue];
                
                momObj.userfeedback=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 7)]intValue];
                
                momObj.dateTime=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 8)];
                
                momObj.readStatus=sqlite3_column_int(statement, 9);
                
                [app.allMomArray addObject:momObj];
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    NSLog(@"%ld",app.allMomArray.count);



}
-(void)setReportView
{
    
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1;
    sqlite3* feedbackAndQueryTypesDB;
    app.allMomArray=[[NSMutableArray alloc]init];
    app.reportFileNamesDict=[[NSMutableDictionary alloc]init];
   // NSMutableDictionary* distinctDateWithFilenamesDict=[[NSMutableDictionary alloc]init];
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[db getCompanyId:username];
    NSString* userTo;
    // NSString* selectedCompany = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
    if ([companyId isEqual:@"1"])
    {
        
        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
        userTo=[db getUserIdFromUserNameWithRoll1:username];
        
        
    }
    else
    {
        userTo=[db getUserIdFromUserNameWithRoll1:username];
        
    }
    
    
    NSString* query1=[NSString stringWithFormat:@"SELECT distinct filedate FROM report Where userFrom=%@ or userTo=%@ Order by filedate DESC",userTo,userTo];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Report* reportObj=[[Report alloc]init];
                NSMutableArray* bufferArr=[[NSMutableArray alloc]init];
                 reportObj.date=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                 NSString* que=[NSString stringWithFormat:@"SELECT name,userfeedback FROM report Where filedate='%@' and (userFrom=%@ or userTo=%@)",reportObj.date,userTo,userTo];

                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [que UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                       Report* reportObj1=[[Report alloc]init];

                        reportObj1.name=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 0)];
                        reportObj1.userfeedback=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 1)]intValue];
                        reportObj1.date=reportObj.date;
                        
                        
                        [bufferArr addObject:reportObj1];
                        

                    }
                    
                    
                }
                else
                {
                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }

                if (sqlite3_finalize(statement1) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                
                
                if (bufferArr!=NULL)
                {
                    //[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault]
                    [app.reportFileNamesDict setObject:[NSKeyedArchiver archivedDataWithRootObject:bufferArr] forKey:reportObj.date];
                    
                }

            }
           
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        

    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    
}


-(void)setDocumentView
{
    
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1;
    sqlite3* feedbackAndQueryTypesDB;
    app.allMomArray=[[NSMutableArray alloc]init];
    app.reportFileNamesDict=[[NSMutableDictionary alloc]init];
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[db getCompanyId:username];
    NSString* userTo;
    // NSString* selectedCompany = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
    if ([companyId isEqual:@"1"])
    {
        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
        userTo=[db getUserIdFromUserNameWithRoll1:username];
        
    }
    else
    {
        userTo=[db getUserIdFromUserNameWithRoll1:username];
    }
    
    
    NSString* query1=[NSString stringWithFormat:@"SELECT distinct filedate FROM document Where userFrom=%@ or userTo=%@",userTo,userTo];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Report* reportObj=[[Report alloc]init];
                NSMutableArray* bufferArr=[[NSMutableArray alloc]init];
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //momObj.Id=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]intValue];
                
                reportObj.date=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                
                //[app.allMomArray addObject:momObj];
                NSString* que=[NSString stringWithFormat:@"SELECT name,userfeedback FROM document Where filedate='%@' and (userFrom=%@ or userTo=%@)",reportObj.date,userTo,userTo];
                
                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [que UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        Report* reportObj1=[[Report alloc]init];
                        
                        reportObj1.name=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 0)];
                        reportObj1.userfeedback=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 1)]intValue];
                        //reportObj1.date=reportObj.date;
                        
                       
                        
                        [bufferArr addObject:reportObj1];
                        
                        
                    }
                    
                    
                }
                else
                {
                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement1) == SQLITE_OK)
                {
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                if (bufferArr!=NULL)
                {
                    //[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault]
                    [app.reportFileNamesDict setObject:[NSKeyedArchiver archivedDataWithRootObject:bufferArr] forKey:reportObj.date];
                    
                }
                
            }
            
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    
}


-(User*)getUserUsername:(NSString*)username andPassword:(NSString*)password
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* query1=[NSString stringWithFormat:@"SELECT * FROM user Where USER_NAME='%@' and PASSWORD='%@'",username,password];
    User *userObj=[[User alloc]init];

    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                userObj.Id=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]intValue];
                
                userObj.password=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                 userObj.username=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                 userObj.userRole=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)]intValue];
                
                 userObj.comanyId=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)]intValue];
                
                 userObj.email=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                 userObj.mobileNo=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                 userObj.firstName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 7)];
                
                 userObj.firstName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 8)];
                
                 userObj.lastName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 9)];
                
               
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    return userObj;


}



-(NSString*)getCompanyIdFromCompanyName:(NSString*)CompanyId
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* companyNAME;
    NSString* query1=[NSString stringWithFormat:@"SELECT Company_Name from company Where CompanyId='%@'",CompanyId];
    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                companyNAME=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
               
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    return companyNAME;

}

-(NSString*)getUserNameFromUserId:(int)userId
{
    
    //AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userNAME;
    NSString* query1=[NSString stringWithFormat:@"SELECT USER_NAME from user Where ID=%d",userId];
    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                userNAME=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    
    return userNAME;
    
}


-(void)insertLatestRecordsForFeedcom:(NSDictionary *)notificationData
{
//    NSError* error;
//    NSString*  companyIdMainDictForFeedbackString= [notificationData valueForKey:@"ListOfFeedBack"];
//    NSData *companyIdMainDictForFeedbackData = [companyIdMainDictForFeedbackString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *companyIdMainForFeedbackDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForFeedbackData
//                                                                                 options:NSJSONReadingAllowFragments
//                                                                                   error:&error];
//    
//    
//    for (NSString* companyIdKey in [companyIdMainForFeedbackDict allKeys])
//    {
//        NSLog(@"%@",companyIdKey);
//        
//        NSDictionary* dictFromCompanyIdKey= [companyIdMainForFeedbackDict valueForKey:companyIdKey];
//        for(NSString* SoNoKey in [dictFromCompanyIdKey allKeys])
//        {
//            // NSLog(@"%@",SoNoString);
//            NSDictionary* dictFromSoNoKey = [dictFromCompanyIdKey valueForKey:SoNoKey];
//            
//            for(NSString* feedTypeIdKey in [dictFromSoNoKey allKeys])
//            {
//                NSLog(@"%@",feedTypeIdKey);
//                NSArray* messagesForfeedTypeIdKeyAndSoNoKey_Array = [dictFromSoNoKey valueForKey:feedTypeIdKey];
//                for (int j=0; j<messagesForfeedTypeIdKeyAndSoNoKey_Array.count; j++)
//                {
//                    NSDictionary* oneMessageDict = [messagesForfeedTypeIdKeyAndSoNoKey_Array objectAtIndex:j];
//                    NSLog(@"%@",[oneMessageDict valueForKey:@"feedbackId"]);
//                    Feedback *feedback=[[Feedback alloc]init];

    NSError* error;
    NSString*  companyIdMainDictForFeedbackString= [notificationData valueForKey:@"ListOfFeedBack"];
    NSData *companyIdMainDictForFeedbackData = [companyIdMainDictForFeedbackString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *companyIdMainForFeedbackDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForFeedbackData
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:&error];
    

    for (NSString* companyIdKey in [companyIdMainForFeedbackDict allKeys])
    {

       NSDictionary* feedbackTypesDict= [companyIdMainForFeedbackDict valueForKey:companyIdKey];
        for (NSString* feedbackTypeKey in [feedbackTypesDict allKeys])
        {
              // NSLog(@"%@",SoNoString);
          NSArray* SoNoArrays = [feedbackTypesDict valueForKey:feedbackTypeKey];
            
            for(int n=0;n<SoNoArrays.count;n++)
            {
                //NSLog(@"%@",feedTypeIdKey);
                NSDictionary* SONumDict = [SoNoArrays objectAtIndex:n];

              //NSArray* messagesForfeedTypeIdKeyAndSoNoKey_Array = [SoNoArrays objectAtIndex:n];
         for (NSString* SONumKey in [SONumDict allKeys])
         {
             NSArray* messagesArray = [SONumDict valueForKey:SONumKey];

             for (int t=0; t<messagesArray.count; t++)
             {
             
                   NSDictionary* oneMessageDict = [messagesArray objectAtIndex:t];
                    Feedback *feedback=[[Feedback alloc]init];
                    
                    feedback.feedbackId=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
                    feedback.feedbackText=[oneMessageDict valueForKey:@"feedbackText"];
                    feedback.feedbackText=[feedback.feedbackText stringByEncodingHTMLEntities];
                    //[NSString strin]
                  // feedback.feedbackText= [self stringByStrippingHTML:feedback.feedbackText];
                    //feedback.dateOfFeed=[oneMessageDict valueForKey:@"fdate"];

                   NSString* dateString=[oneMessageDict valueForKey:@"fdate"];
                    
                    //NSString* dateString=[oneMessageDict valueForKey:@"dateofquery"];
                    
                    //query.dateOfQuery=[oneMessageDict valueForKey:@"dateofquery"];
                    //NSString* dateString= allMessageObj1.dateOfFeed;
                    double da=[dateString doubleValue];
                    feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
                    

                    
                    
                    feedback.soNumber=[oneMessageDict valueForKey:@"soNumber"];
                    
                    NSDictionary* operator=[oneMessageDict valueForKey:@"operator"];
                    feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
                    
                    NSDictionary* status=[oneMessageDict valueForKey:@"status"];
                    feedback.statusId=[[status valueForKey:@"statusId"]intValue];
                    
                    NSDictionary* userModelFrom=[oneMessageDict valueForKey:@"userModelFrom"];
                    feedback.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
                    
                    NSDictionary* userModelTo=[oneMessageDict valueForKey:@"userModelTo"];
                    feedback.userTo=[[userModelTo valueForKey:@"userId"]intValue];
                    
                 
                    NSDictionary* userfeedback=[oneMessageDict valueForKey:@"userfeedback"];
                    feedback.userFeedback=[[userfeedback valueForKey:@"userId"]intValue];
                    
                    feedback.attachment=[oneMessageDict valueForKey:@"attachment"];
                    
                    feedback.emailSubject=[oneMessageDict valueForKey:@"emailSubject"];
                 feedback.emailSubject=[feedback.emailSubject stringByEncodingHTMLEntities];

                    NSDictionary* feedBackType=[oneMessageDict valueForKey:@"feedBackType"];
                    feedback.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
                    
                    NSDictionary* counter=[oneMessageDict valueForKey:@"counter"];
                    feedback.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];;

                    //------------model values for feedbackChatingCounter------------//
                    
                    FeedbackChatingCounter* chatingCounterObj=[[FeedbackChatingCounter alloc]init];
                    
                    chatingCounterObj.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];
                   chatingCounterObj.soNumber= [counter valueForKey:@"so_number"];
                    
                    chatingCounterObj.userFrom= [userModelFrom valueForKey:@"userId"];

                    chatingCounterObj.userTo= [userModelTo valueForKey:@"userId"];

                    chatingCounterObj.feedbackType= [[feedBackType valueForKey:@"id"]intValue];

                    chatingCounterObj.count= [[counter valueForKey:@"count"]longValue];

                    User *user=[[User alloc]init];
                    Company *company=[[Company alloc]init];
                    user.username=[userModelFrom valueForKey:@"userName"];
                    user.password=[userModelFrom valueForKey:@"password"];
                 
                    NSDictionary* userRole=[userModelFrom valueForKey:@"userRoll"];
                    user.userRole=[[userRole valueForKey:@"id"]intValue];
                    
                    NSDictionary* companyOb=[userModelFrom valueForKey:@"company"];
                    user.comanyId=[[companyOb valueForKey:@"companyId"]intValue];
                    
                    user.email=[userModelFrom valueForKey:@"email"];
                    user.mobileNo=[userModelFrom valueForKey:@"mobileNo"];
                    user.firstName=[userModelFrom valueForKey:@"firstName"];
                    user.lastName=[userModelFrom valueForKey:@"lastName"];
                    user.deviceToken=[userModelFrom valueForKey:@"deviceToken"];
                    
                    //--------------------------userRole table data values-----------------------------------------------
                    
                    userRoll *userroll=[[userRoll alloc]init];
                    userroll.role=[userRole valueForKey:@"id"];
                    
                    //--------------------------company table data values------------------------------------------------
                    
                    company.Company_Name=[companyOb valueForKey:@"companyName"];
                    company.Company_Contact=[companyOb valueForKey:@"companyContact"];
                    company.Company_Address=[companyOb valueForKey:@"companyAddress"];
                    company.Company_Email=[companyOb valueForKey:@"companyEmail"];
                    //company.userId=[[companyOb valueForKey:@"userID"]intValue];
                    
                    
                    
                    //-------------------------user table data insertion values from userTo------------------------------------------
                    
//                    User *user1=[[User alloc]init];
//                    Company *company1=[[Company alloc]init];
//                    user1.username=[userModelTo valueForKey:@"userName"];
//                    user1.password=[userModelTo valueForKey:@"password"];
                 
//                    NSDictionary* userRole1=[userModelTo valueForKey:@"userRoll"];
//                    user1.userRole=[[userRole1 valueForKey:@"id"]intValue];
                 
//                    NSDictionary* companyOb1=[userModelTo valueForKey:@"company"];
//                    user1.comanyId=[[companyOb1 valueForKey:@"companyId"]intValue];
//                    
//                    user1.email=[userModelTo valueForKey:@"email"];
//                    user1.mobileNo=[userModelTo valueForKey:@"mobileNo"];
//                    user1.firstName=[userModelTo valueForKey:@"firstName"];
//                    user1.lastName=[userModelTo valueForKey:@"lastName"];
//                    user1.deviceToken=[userModelTo valueForKey:@"deviceToken"];
                 
                    //--------------------------userRole table data values-----------------------------------------------
                    
//                    userRoll *userroll1=[[userRoll alloc]init];
//                    userroll1.role=[userRole1 valueForKey:@"id"];
                 
                    //--------------------------company table data values------------------------------------------------
                    
//                    company1.Company_Name=[companyOb1 valueForKey:@"companyName"];
//                    company1.Company_Contact=[companyOb1 valueForKey:@"companyContact"];
//                    company1.Company_Address=[companyOb1 valueForKey:@"companyAddress"];
//                    company1.Company_Email=[companyOb1 valueForKey:@"companyEmail"];
                    //company1.userId=[[companyOb1 valueForKey:@"userID"]intValue];
                    
                    //-------------------------userRole table data values-----------------------------------------------
                    
                    //user.username=[userRole valueForKey:@"role"];
                    //user1.username=[userRole1 valueForKey:@"role"];
                 
                    //-------------------------operator table data values--------------------------------------------------
                    
                    Operator *operatorobj =[[Operator alloc]init];
                    operatorobj.firstName=[operator valueForKey:@"firstName"];
                    operatorobj.lastName=[operator valueForKey:@"lastName"];
                    operatorobj.userName=[operator valueForKey:@"userName"];
                    operatorobj.status=[operator valueForKey:@"status"];
                    
                    //------------------------status table data values-------------------------------------------
                    
                    Status *statusobj=[[Status alloc]init];
                    statusobj.status=[status valueForKey:@"status"];
                    
                    //------------------------feedback_type table data values--------------------------------------------
                    
                    FeedbackType *feedbackTypeObj=[[FeedbackType alloc]init];
                    feedbackTypeObj.feedbacktype=[feedBackType valueForKey:@"feedbackType"];


                    
                    
                    
                    
                    
                    
                    Database *db=[Database shareddatabase];
                    NSString *dbPath=[db getDatabasePath];
                    sqlite3_stmt *statement,*chatingCounterStatement,*statusIdStatement;
                    sqlite3* feedbackAndQueryTypesDB;
                    /// NSString* q2=[NSString stringWithFormat:@"Drop table userpermission"];
                    //  NSString* q3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",NULL,fdate,feedbackText,soNumber,attachment];
                    NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<61"];
                    //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
                    //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES company(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];
                    
                    /* Data insertion: feedback table */
                    
                    
                    NSString *query1=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject,readStatus) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\")",feedback.feedbackId,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject,0];
                    
                    const char * queryi1=[query1 UTF8String];
                    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                    {
                        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
                        if(sqlite3_step(statement)==SQLITE_DONE)
                        {
                           
                            sqlite3_reset(statement);
                        }
                        else
                        {
                            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                    }
                    else
                    {
                        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    
                    if (sqlite3_finalize(statement) == SQLITE_OK)
                    {
                    }
                    else
                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    
                    
                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                    {
                    }
                    else
                    {
                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }

                    
                    
//                    NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedbackchatingcounter values(\"%ld\",\"%ld\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.feedbackCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbackType,chatingCounterObj.userFrom,chatingCounterObj.userTo];
//                    
//                    const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
//                    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                    {
//                        sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
//                        if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//                        {
//                            
//                            sqlite3_reset(chatingCounterStatement);
//                        }
//                        else
//                        {
//                            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        }
//                    }
//                    else
//                    {
//                        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//
//                    if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//                    {
//                    }
//                    else
//                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    
//                    
//                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                    {
//                    }
//                    else
//                    {
//                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//
                 
//                    
//                    NSString *statusIdUpdateQuery=[NSString stringWithFormat:@"Update feedback set statusId=%d Where feedBackType=%d and SO_Number='%@'",feedback.statusId,feedback.feedbackType,feedback.soNumber];
//                    
//                    const char * statusIdUpdateQuery123=[statusIdUpdateQuery UTF8String];
//                    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                    {
//                        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery123, -1, &statusIdStatement, NULL);
//                        if(sqlite3_step(statusIdStatement)==SQLITE_DONE)
//                        {
//                            
//                            sqlite3_reset(statusIdStatement);
//                        }
//                        else
//                        {
//                            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        }
//                    }
//                    else
//                    {
//                        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                    
//                    if (sqlite3_finalize(statusIdStatement) == SQLITE_OK)
//                    {
//                    }
//                    else
//                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    
//                    
//                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                    {
//                    }
//                    else
//                    {
//                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                    

                    
                 //   NSMutableArray* uniqueUserIdArray=[self checkUserAvailableOrNot];
                    NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
                    NSMutableArray* uniqueUserRoleArray=[self checkUserRoleAvailableOrNot];
                    NSMutableArray* uniqueOperatorArray=[self checkOperatorAvailableOrNot];
                    NSMutableArray* uniqueStatusIdArray=[self checkStatusIdAvailableOrNot];

               //     NSString* userid=[NSString stringWithFormat:@"%d",feedback.userFrom];
                    NSString* companyid=[NSString stringWithFormat:@"%d",user.comanyId];
                    NSString* usersRoll=[NSString stringWithFormat:@"%d",user.userRole];
                    NSString* operatorID=[NSString stringWithFormat:@"%d",feedback.operatorId];
                    NSString* statusID=[NSString stringWithFormat:@"%d",feedback.statusId];
                 
                    
                    
                    
                 
//                    if (!([uniqueUserIdArray containsObject:userid]))
//                    {
//                        
//                        NSString *query2=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",feedback.userFrom,user.password,user.username,user.userRole,user.comanyId,user.email,user.mobileNo,user.firstName,user.lastName];
//                        
//                        const char * queryi2=[query2 UTF8String];
//                        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                        {
//                            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi2, -1, &statement, NULL);
//                            if(sqlite3_step(statement)==SQLITE_DONE)
//                            {
//                               
//                                sqlite3_reset(statement);
//                            }
//                            else
//                            {
//                                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                            }
//                        }
//                        else
//                        {
//                            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        }
//                        if (sqlite3_finalize(statement) == SQLITE_OK)
//                        {
//                        }
//                        else
//                            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        
//                        
//                        
//                        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                        {
//                        }
//                        else
//                        {
//                            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        }
//
//                    }
                 
                    
                    
                    if (!([uniqueCompanyIdArray containsObject:companyid]))
                    {
                        
                        NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user.comanyId,company.Company_Name,company.Company_Address,company.Company_Contact,company.Company_Email,@""];
                        
                        const char * queryi3=[query3 UTF8String];
                        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                        {
                            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                            if(sqlite3_step(statement)==SQLITE_DONE)
                            {
                                
                                sqlite3_reset(statement);
                            }
                            else
                            {
                                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                            }
                        }
                        else
                        {
                            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                        if (sqlite3_finalize(statement) == SQLITE_OK)
                        {
                        }
                        else
                            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        
                        
                        
                        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                        {
                        }
                        else
                        {
                            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }

                    }
                    
                    
                    
                    
                    
                    
                    if (!([uniqueUserRoleArray containsObject:usersRoll]))
                    {
                        
                        NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user.userRole,[userRole valueForKey:@"role"]];
                        
                        const char * queryi3=[query3 UTF8String];
                        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                        {
                            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                            if(sqlite3_step(statement)==SQLITE_DONE)
                            {
                                
                                sqlite3_reset(statement);
                            }
                            else
                            {
                                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                            }
                        }
                        else
                        {
                            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                        if (sqlite3_finalize(statement) == SQLITE_OK)
                        {
                        }
                        else
                            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        
                        
                        
                        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                        {
                        }
                        else
                        {
                            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }

                    }
                    
                    
                    
                    if (!([uniqueOperatorArray containsObject:operatorID]))
                    {
                        
                        NSString *query3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",feedback.operatorId,operatorobj.firstName,operatorobj.lastName,operatorobj.status,operatorobj.userName];
                        
                        const char * queryi3=[query3 UTF8String];
                        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                        {
                            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                            if(sqlite3_step(statement)==SQLITE_DONE)
                            {
                                
                                sqlite3_reset(statement);
                            }
                            else
                            {
                                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                            }
                        }
                        else
                        {
                            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                        
                        if (sqlite3_finalize(statement) == SQLITE_OK)
                        {
                        }
                        else
                            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        
                        
                        
                        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                        {
                        }
                        else
                        {
                            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }

                    }
                    
                    
                    if (!([uniqueStatusIdArray containsObject:statusID]))
                    {
                        
                        NSString *query3=[NSString stringWithFormat:@"INSERT INTO status values(\"%d\",\"%@\")",feedback.statusId,statusobj.status];
                        
                        const char * queryi3=[query3 UTF8String];
                        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                        {
                            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                            if(sqlite3_step(statement)==SQLITE_DONE)
                            {
                                
                                sqlite3_reset(statement);
                            }
                            else
                            {
                                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                            }
                        }
                        else
                        {
                            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                        
                        if (sqlite3_finalize(statement) == SQLITE_OK)
                        {
                        }
                        else
                            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        
                        
                        
                        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                        {
                        }
                        else
                        {
                            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }

                    }
             }
             
                    
                }
            }
            
            
        }

    }

  

    
    //--------------------------------------------------------------------
    
    
           //NSLog(@"%@",dic);
//        NSLog(@"in insertttttttttt query data");
//    NSString*  companyIdMainDictForQueryString= [notificationData valueForKey:@"ListOfQuery"];
//    NSData *companyIdMainDictForQueryData = [companyIdMainDictForQueryString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *companyIdMainForQueryDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForQueryData
//                                                                              options:NSJSONReadingAllowFragments
//                                                                                error:&error];
//    
//
//            //NSDictionary* d1;
//    for (NSString* companyIdKey in [companyIdMainForQueryDict allKeys])
//    {
//        NSLog(@"%@",companyIdKey);
//        
//        NSDictionary* dictFromCompanyIdKey= [companyIdMainForQueryDict valueForKey:companyIdKey];
//        for(NSString* SoNoKey in [dictFromCompanyIdKey allKeys])
//        {
//            // NSLog(@"%@",SoNoString);
//            NSDictionary* dictFromSoNoKey = [dictFromCompanyIdKey valueForKey:SoNoKey];
//            
//            for(NSString* feedTypeIdKey in [dictFromSoNoKey allKeys])
//            {
//                NSLog(@"%@",feedTypeIdKey);
//                NSArray* messagesForfeedTypeIdKeyAndSoNoKey_Array = [dictFromSoNoKey valueForKey:feedTypeIdKey];
//                for (int j=0; j<messagesForfeedTypeIdKeyAndSoNoKey_Array.count; j++)
//                {
//                    NSDictionary* oneMessageDict = [messagesForfeedTypeIdKeyAndSoNoKey_Array objectAtIndex:j];
//                    NSLog(@"%@",[oneMessageDict valueForKey:@"feedbackId"]);
//
//        
//            NSLog(@"%@",NSHomeDirectory());
//            
//            //-------------------------feedback table data insertion------------------------------------------
//            
//            Query *query=[[Query alloc]init];
//            
//            query.queryId=[[oneMessageDict valueForKey:@"queryId"]intValue];
//            query.queryText=[oneMessageDict valueForKey:@"queryText"];
//                    
//                    NSString* dateString=[oneMessageDict valueForKey:@"dateofquery"];
//
//            //query.dateOfQuery=[oneMessageDict valueForKey:@"dateofquery"];
//                    //NSString* dateString= allMessageObj1.dateOfFeed;
//                    double da=[dateString doubleValue];
//                    query.dateOfQuery = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
//
//                    
//                    
//            NSDictionary* feedBackType=[oneMessageDict valueForKey:@"feedBackType"];
//            query.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
//            
//            query.soNumber=[oneMessageDict valueForKey:@"soNumber"];
//            
//            NSDictionary* counter=[oneMessageDict valueForKey:@"counter"];
//            query.queryCounter=[[counter valueForKey:@"queryCounter"]intValue];;
//            
//            // NSDictionary* operator=[queryDetailDictionary valueForKey:@"operator"];
//            // feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
//            
//            NSDictionary* status=[oneMessageDict valueForKey:@"status"];
//            query.statusId=[[status valueForKey:@"statusId"]intValue];
//            
//            NSDictionary* userModelFrom=[oneMessageDict valueForKey:@"userModelFrom"];
//            query.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
//            
//            NSDictionary* userModelTo=[oneMessageDict valueForKey:@"userModelTo"];
//            query.userTo=[[userModelTo valueForKey:@"userId"]intValue];
//            
//            NSDictionary* userfeedback=[oneMessageDict valueForKey:@"userquery"];
//            query.userQuery=[[userfeedback valueForKey:@"userId"]intValue];
//            
//            //query.attachment=[queryDetailDictionary valueForKey:@"attachment"];
//            
//            query.emailSubject=[oneMessageDict valueForKey:@"subject"];
//                    
//                    query.attachment=[oneMessageDict valueForKey:@"attachment"];
//                    
//                    
//                    
//                    QueryChatingCounter* chatingCounterObj=[[QueryChatingCounter alloc]init];
//                    
//                    chatingCounterObj.queryCounter=[[counter valueForKey:@"queryCounter"]intValue];
//                    chatingCounterObj.soNumber= [counter valueForKey:@"so_number"];
//                    
//                    chatingCounterObj.userFrom= [userModelFrom valueForKey:@"userId"];
//                    
//                    chatingCounterObj.userTo= [userModelTo valueForKey:@"userId"];
//                    
//                    chatingCounterObj.feedbacktype= [[feedBackType valueForKey:@"id"]intValue];
//                    
//                    chatingCounterObj.count= [[counter valueForKey:@"count"]intValue];
//                    
//
//            
//            //-------------------------user table data insertion values------------------------------------------
//            
//            User *user=[[User alloc]init];
//            Company *company=[[Company alloc]init];
//            user.username=[userModelFrom valueForKey:@"userName"];
//            user.password=[userModelFrom valueForKey:@"password"];
//            
//            NSDictionary* userRole=[userModelFrom valueForKey:@"userRoll"];
//            user.userRole=[[userRole valueForKey:@"id"]intValue];
//            
//            NSDictionary* companyOb=[userModelFrom valueForKey:@"company"];
//            user.comanyId=[[companyOb valueForKey:@"companyId"]intValue];
//            
//            user.email=[userModelFrom valueForKey:@"email"];
//            user.mobileNo=[userModelFrom valueForKey:@"mobileNo"];
//            user.firstName=[userModelFrom valueForKey:@"firstName"];
//            user.lastName=[userModelFrom valueForKey:@"lastName"];
//            
//            //--------------------------userRole table data values-----------------------------------------------
//            
//            userRoll *userroll=[[userRoll alloc]init];
//            userroll.role=[userRole valueForKey:@"role"];
//            
//            //--------------------------company table data values------------------------------------------------
//            
//            company.Company_Name=[companyOb valueForKey:@"companyName"];
//            company.Company_Contact=[companyOb valueForKey:@"companyContact"];
//            company.Company_Address=[companyOb valueForKey:@"companyAddress"];
//            company.Company_Email=[companyOb valueForKey:@"companyEmail"];
//            //company.userId=[[companyOb valueForKey:@"userID"]intValue];
//            
//            
//            
//            //-------------------------user table data insertion values from userTo------------------------------------------
//            
//            User *user1=[[User alloc]init];
//            Company *company1=[[Company alloc]init];
//            user1.username=[userModelTo valueForKey:@"userName"];
//            user1.password=[userModelTo valueForKey:@"password"];
//            
//            NSDictionary* userRole1=[userModelTo valueForKey:@"userRoll"];
//            user1.userRole=[[userRole1 valueForKey:@"id"]intValue];
//            
//            NSDictionary* companyOb1=[userModelTo valueForKey:@"company"];
//            user1.comanyId=[[companyOb1 valueForKey:@"companyId"]intValue];
//            
//            user1.email=[userModelTo valueForKey:@"email"];
//            user1.mobileNo=[userModelTo valueForKey:@"mobileNo"];
//            user1.firstName=[userModelTo valueForKey:@"firstName"];
//            user1.lastName=[userModelTo valueForKey:@"lastName"];
//            
//            //--------------------------userRole table data values-----------------------------------------------
//            
//            userRoll *userroll1=[[userRoll alloc]init];
//            userroll1.role=[userRole1 valueForKey:@"role"];
//            
//            //--------------------------company table data values------------------------------------------------
//            
//            company1.Company_Name=[companyOb1 valueForKey:@"companyName"];
//            company1.Company_Contact=[companyOb1 valueForKey:@"companyContact"];
//            company1.Company_Address=[companyOb1 valueForKey:@"companyAddress"];
//            company1.Company_Email=[companyOb1 valueForKey:@"companyEmail"];
//            //company1.userId=[[companyOb1 valueForKey:@"userID"]intValue];
//            
//            //-------------------------userRole table data values-----------------------------------------------
//            
//            user.username=[userRole valueForKey:@"role"];
//            user1.username=[userRole1 valueForKey:@"role"];
//            
//            //-------------------------operator table data values--------------------------------------------------
//            
//            //        Operator *operatorobj =[[Operator alloc]init];
//            //        operatorobj.firstName=[operator valueForKey:@"firstName"];
//            //        operatorobj.lastName=[operator valueForKey:@"lastName"];
//            //        operatorobj.userName=[operator valueForKey:@"userName"];
//            //        operatorobj.status=[operator valueForKey:@"status"];
//            
//            //------------------------status table data values-------------------------------------------
//            
//            Status *statusobj=[[Status alloc]init];
//            statusobj.status=[status valueForKey:@"status"];
//            
//            //------------------------feedback_type table data values--------------------------------------------
//            
//            FeedbackType *feedbackTypeObj=[[FeedbackType alloc]init];
//            feedbackTypeObj.feedbacktype=[feedBackType valueForKey:@"feedbackType"];
//            NSLog(@"%@",feedbackTypeObj.feedbacktype);
//            
//            
//            
//            Database *db=[Database shareddatabase];
//            NSString *dbPath=[db getDatabasePath];
//            sqlite3_stmt *statement,*chatingCounterStatement;
//            sqlite3* feedbackAndQueryTypesDB;
//            /// NSString* q2=[NSString stringWithFormat:@"Drop table userpermission"];
//            //  NSString* q3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",NULL,fdate,feedbackText,soNumber,attachment];
//            NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<0"];
//            //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
//            //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES Fdeleyeqcompany(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];
//            
//            /* Data insertion: feedback table */
//            
//            
//            NSString *query1=[NSString stringWithFormat:@"INSERT OR REPLACE INTO query values(\"%ld\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\")",query.queryId,query.queryText,query.soNumber,query.queryCounter,query.feedbackType,query.statusId,query.userFrom,query.userTo,query.userQuery,query.dateOfQuery,query.emailSubject,query.attachment];
//            
//            const char * queryi1=[query1 UTF8String];
//            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//            {
//                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
//                if(sqlite3_step(statement)==SQLITE_DONE)
//                {
//                    NSLog(@"query table data inserted");
//                    NSLog(@"%@",NSHomeDirectory());
//                    sqlite3_reset(statement);
//                }
//                else
//                {
//                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//            }
//            else
//            {
//                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//            
//                    if (sqlite3_finalize(statement) == SQLITE_OK)
//                    {
//                        NSLog(@"statement is finalized");
//                    }
//                    else
//                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    
//                    
//                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                    {
//                        NSLog(@"db is closed");
//                    }
//                    else
//                    {
//                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//
//            
//                    NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO querychatingcounter values(\"%d\",\"%d\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.queryCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbacktype,chatingCounterObj.userFrom,chatingCounterObj.userTo];
//                    
//                    const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
//                    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                    {
//                        sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
//                        if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//                        {
//                            NSLog(@"chatingCounter table data inserted");
//                            NSLog(@"%@",NSHomeDirectory());
//                            sqlite3_reset(chatingCounterStatement);
//                        }
//                        else
//                        {
//                            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                        }
//                    }
//                    else
//                    {
//                        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                    
//                    if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//                    {
//                        NSLog(@"statement is finalized");
//                    }
//                    else
//                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    
//                    
//                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                    {
//                        NSLog(@"db is closed");
//                    }
//                    else
//                    {
//                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                    
//
//            /* Data insertion: user table */
//            NSMutableArray* uniqueUserIdArray=[self checkUserAvailableOrNot];
//            NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
//            NSMutableArray* uniqueUserRoleArray=[self checkUserRoleAvailableOrNot];
//            NSMutableArray* uniqueOperatorArray=[self checkOperatorAvailableOrNot];
//            NSMutableArray* uniqueStatusIdArray=[self checkStatusIdAvailableOrNot];
//            NSMutableArray* UniqueFeedbackTypeIdArray=[self checkFeedbackTypeIDAvailableOrNot];
//            
//            NSString* userid=[NSString stringWithFormat:@"%d",query.userFrom];
//            NSString* userid1=[NSString stringWithFormat:@"%d",query.userTo];
//            
//            NSString* useriqueryDetailDictionary=[NSString stringWithFormat:@"%d",query.userTo];
//            NSString* companyid=[NSString stringWithFormat:@"%d",user.comanyId];
//            NSString* companyid1=[NSString stringWithFormat:@"%d",user1.comanyId];
//            NSString* usersRoll=[NSString stringWithFormat:@"%d",user.userRole];
//            NSString* usersRoll1=[NSString stringWithFormat:@"%d",user1.userRole];
//            // NSString* operatorID=[NSString stringWithFormat:@"%d",query.operatorId];
//            NSString* statusID=[NSString stringWithFormat:@"%d",query.statusId];
//            NSString* feedbacktypeID=[NSString stringWithFormat:@"%d",query.feedbackType];
//            
//            
//            
//            
//            NSLog(@"%@",userid);
//            NSLog(@"%lu",(unsigned long)[uniqueUserIdArray count]);
//            
//            if (!([uniqueUserIdArray containsObject:userid]))
//            {
//                
//                NSString *query2=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",query.userFrom,user.password,user.username,user.userRole,user.comanyId,user.email,user.mobileNo,user.firstName,user.lastName];
//                
//                const char * queryi2=[query2 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi2, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            
//            if (!([uniqueUserIdArray containsObject:userid1]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",query.userTo,user1.password,user1.username,user1.userRole,user1.comanyId,user1.email,user1.mobileNo,user1.firstName,user1.lastName];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            if (!([uniqueCompanyIdArray containsObject:companyid]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user.comanyId,company.Company_Name,company.Company_Address,company.Company_Contact,company.Company_Email,@""];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            
//            if (!([uniqueCompanyIdArray containsObject:companyid1]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user1.comanyId,company1.Company_Name,company1.Company_Address,company1.Company_Contact,company1.Company_Email,@""];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            
//            
//            if (!([uniqueUserRoleArray containsObject:usersRoll]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user.userRole,user.username];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            
//            if (!([uniqueUserRoleArray containsObject:usersRoll1]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user1.userRole,user1.username];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            
//            if (!([uniqueStatusIdArray containsObject:statusID]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO status values(\"%d\",\"%@\")",query.statusId,statusobj.status];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//            
//            
//            if (!([UniqueFeedbackTypeIdArray containsObject:feedbacktypeID]))
//            {
//                
//                NSString *query3=[NSString stringWithFormat:@"INSERT INTO feedbacktype values(\"%d\",\"%@\")",query.feedbackType,feedbackTypeObj.feedbacktype];
//                
//                const char * queryi3=[query3 UTF8String];
//                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//                {
//                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                    if(sqlite3_step(statement)==SQLITE_DONE)
//                    {
//                        NSLog(@"user table data inserted");
//                        NSLog(@"%@",NSHomeDirectory());
//                        sqlite3_reset(statement);
//                    }
//                    else
//                    {
//                        NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                    }
//                }
//                else
//                {
//                    NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//                
//                
//                if (sqlite3_finalize(statement) == SQLITE_OK)
//                {
//                    NSLog(@"statement is finalized");
//                }
//                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//
//                
//                
//                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//                {
//                    NSLog(@"db is closed");
//                }
//                else
//                {
//                    NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//
//            }
//                    
//                    
//            
//            
//            
//        }
//      }
//    }
//   }
//    
}
-(void)insertFeedcomNotifiationData:(NSDictionary*)notificationDict readStatusflag:(BOOL) readStatusflag
{
    NSError* error;
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*chatingCounterStatement,*statusIdStatement = NULL;
    sqlite3* feedbackAndQueryTypesDB;
    
    NSString* totalCount=[notificationDict valueForKey:@"totalCount"];
    NSString* openCount=[notificationDict valueForKey:@"openCount"];
    NSString* closeCount=[notificationDict valueForKey:@"closeCount"];

    NSString* notificationDictString=[notificationDict valueForKey:@"Feedbacks"];
    NSData *notificationDictData = [notificationDictString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *notificationArray = [NSJSONSerialization JSONObjectWithData:notificationDictData
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&error];
    
   NSString* companyId= [[Database shareddatabase] getCompanyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]];
    
    NSMutableArray* distinctSONumArray=[[NSMutableArray alloc]init];
    NSMutableArray* newSONumArray=[[NSMutableArray alloc]init];

    int count=0;
    if ([companyId isEqual:@"1"])
    {
       NSString* companyName= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
       companyId= [[Database shareddatabase] getCompanyIdFromCompanyName1:companyName];
    }
    for (int t=0; t<notificationArray.count; t++)
    {
        
        NSDictionary* oneMessageDict = [notificationArray objectAtIndex:t];
        NSLog(@"%@",[oneMessageDict valueForKey:@"feedbackId"]);
        Feedback *feedback=[[Feedback alloc]init];
        
        feedback.feedbackId=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
        feedback.feedbackText=[oneMessageDict valueForKey:@"feedbackText"];
        feedback.feedbackText=[feedback.feedbackText stringByEncodingHTMLEntities];
        //[NSString strin]
        // feedback.feedbackText= [self stringByStrippingHTML:feedback.feedbackText];
        //feedback.dateOfFeed=[oneMessageDict valueForKey:@"fdate"];
        
        NSString* dateString=[oneMessageDict valueForKey:@"fdate"];
        
        //NSString* dateString=[oneMessageDict valueForKey:@"dateofquery"];
        
        //query.dateOfQuery=[oneMessageDict valueForKey:@"dateofquery"];
        //NSString* dateString= allMessageObj1.dateOfFeed;
        double da=[dateString doubleValue];
        feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
        
        
        
        
        feedback.soNumber=[oneMessageDict valueForKey:@"soNumber"];
        
        NSDictionary* operator=[oneMessageDict valueForKey:@"operator"];
        feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
        
        NSDictionary* status=[oneMessageDict valueForKey:@"status"];
        feedback.statusId=[[status valueForKey:@"statusId"]intValue];
        
        NSDictionary* userModelFrom=[oneMessageDict valueForKey:@"userModelFrom"];
        feedback.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
        
        NSDictionary* userModelTo=[oneMessageDict valueForKey:@"userModelTo"];
        feedback.userTo=[[userModelTo valueForKey:@"userId"]intValue];
        
        
        NSDictionary* userfeedback=[oneMessageDict valueForKey:@"userfeedback"];
        feedback.userFeedback=[[userfeedback valueForKey:@"userId"]intValue];
        
        feedback.attachment=[oneMessageDict valueForKey:@"attachment"];
        
        feedback.emailSubject=[oneMessageDict valueForKey:@"emailSubject"];
        feedback.emailSubject=[feedback.emailSubject stringByEncodingHTMLEntities];

        NSDictionary* feedBackType=[oneMessageDict valueForKey:@"feedBackType"];
        feedback.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
        
        NSDictionary* counter=[oneMessageDict valueForKey:@"counter"];
        feedback.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];;
        
        //------------model values for feedbackChatingCounter------------//
        
        FeedbackChatingCounter* chatingCounterObj=[[FeedbackChatingCounter alloc]init];
        
        chatingCounterObj.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];
        chatingCounterObj.soNumber= [counter valueForKey:@"so_number"];
        
        chatingCounterObj.userFrom= [userModelFrom valueForKey:@"userId"];
        
        chatingCounterObj.userTo= [userModelTo valueForKey:@"userId"];
        
        chatingCounterObj.feedbackType= [[feedBackType valueForKey:@"id"]intValue];
        
        chatingCounterObj.count= [[counter valueForKey:@"count"]longValue];
        
        User *user=[[User alloc]init];
        Company *company=[[Company alloc]init];
        user.username=[userModelFrom valueForKey:@"userName"];
        user.password=[userModelFrom valueForKey:@"password"];
        
        NSDictionary* userRole=[userModelFrom valueForKey:@"userRoll"];
        user.userRole=[[userRole valueForKey:@"id"]intValue];
        
        NSDictionary* companyOb=[userModelFrom valueForKey:@"company"];
        user.comanyId=[[companyOb valueForKey:@"companyId"]intValue];
        
        user.email=[userModelFrom valueForKey:@"email"];
        user.mobileNo=[userModelFrom valueForKey:@"mobileNo"];
        user.firstName=[userModelFrom valueForKey:@"firstName"];
        user.lastName=[userModelFrom valueForKey:@"lastName"];
        user.deviceToken=[userModelFrom valueForKey:@"deviceToken"];
        
        //--------------------------userRole table data values-----------------------------------------------
        
        userRoll *userroll=[[userRoll alloc]init];
        userroll.role=[userRole valueForKey:@"id"];
        
        //--------------------------company table data values------------------------------------------------
        
        company.Company_Name=[companyOb valueForKey:@"companyName"];
        company.Company_Contact=[companyOb valueForKey:@"companyContact"];
        company.Company_Address=[companyOb valueForKey:@"companyAddress"];
        company.Company_Email=[companyOb valueForKey:@"companyEmail"];
        //company.userId=[[companyOb valueForKey:@"userID"]intValue];
        
        
        
        //-------------------------user table data insertion values from userTo------------------------------------------
        
        User *user1=[[User alloc]init];
        Company *company1=[[Company alloc]init];
        user1.username=[userModelTo valueForKey:@"userName"];
        user1.password=[userModelTo valueForKey:@"password"];
        
        NSDictionary* userRole1=[userModelTo valueForKey:@"userRoll"];
        user1.userRole=[[userRole1 valueForKey:@"id"]intValue];
        
        NSDictionary* companyOb1=[userModelTo valueForKey:@"company"];
        user1.comanyId=[[companyOb1 valueForKey:@"companyId"]intValue];
        
        user1.email=[userModelTo valueForKey:@"email"];
        user1.mobileNo=[userModelTo valueForKey:@"mobileNo"];
        user1.firstName=[userModelTo valueForKey:@"firstName"];
        user1.lastName=[userModelTo valueForKey:@"lastName"];
        user1.deviceToken=[userModelTo valueForKey:@"deviceToken"];
        
        //--------------------------userRole table data values-----------------------------------------------
        
        userRoll *userroll1=[[userRoll alloc]init];
        userroll1.role=[userRole1 valueForKey:@"id"];
        
        //--------------------------company table data values------------------------------------------------
        
        company1.Company_Name=[companyOb1 valueForKey:@"companyName"];
        company1.Company_Contact=[companyOb1 valueForKey:@"companyContact"];
        company1.Company_Address=[companyOb1 valueForKey:@"companyAddress"];
        company1.Company_Email=[companyOb1 valueForKey:@"companyEmail"];
        //company1.userId=[[companyOb1 valueForKey:@"userID"]intValue];
        
        //-------------------------userRole table data values-----------------------------------------------
        
        //user.username=[userRole valueForKey:@"role"];
        //user1.username=[userRole1 valueForKey:@"role"];
        
        //-------------------------operator table data values--------------------------------------------------
        
        Operator *operatorobj =[[Operator alloc]init];
        operatorobj.firstName=[operator valueForKey:@"firstName"];
        operatorobj.lastName=[operator valueForKey:@"lastName"];
        operatorobj.userName=[operator valueForKey:@"userName"];
        operatorobj.status=[operator valueForKey:@"status"];
        
        //------------------------status table data values-------------------------------------------
        
        Status *statusobj=[[Status alloc]init];
        statusobj.status=[status valueForKey:@"status"];
        
        //------------------------feedback_type table data values--------------------------------------------
        
        FeedbackType *feedbackTypeObj=[[FeedbackType alloc]init];
        feedbackTypeObj.feedbacktype=[feedBackType valueForKey:@"feedbackType"];
        
        //to check soNumber of given type is available in the database,if not update counter of feedcounter table(that means this is newly generated feedback)
        
//        NSString* counterUpdateQuery=[NSString stringWithFormat:@"SELECT distinct SO_Number FROM feedback Where feedBackType=%d and ((userFrom=%d and userTo=%d) or (userFrom=%d and userTo=%d)) ",feedback.feedbackType,feedback.userFrom,feedback.userTo,feedback.userTo,feedback.userFrom];
//
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
//        {
//            if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [counterUpdateQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
//            {
//                while (sqlite3_step(statement) == SQLITE_ROW)
//                {
//                    
//                    // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
//                   NSString* firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
//                    [distinctSONumArray addObject:firstName];
//                    // NSLog(@"%@",userid);
//                    
//                }
//            }
//            else
//            {
//                NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        else
//        {
//            NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        if (sqlite3_finalize(statement) == SQLITE_OK)
//        {
//        }
//        else
//            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//        {
//        }
//        else
//        {
//            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        if (![distinctSONumArray containsObject:feedback.soNumber])
//        {
//            count++;
//                            if (user.comanyId==1)
//                            {
//                                [newSONumArray addObject:[NSString stringWithFormat:@"%d",user1.comanyId]];
//            
//                            }
//                            else
//                            {
//                                [newSONumArray addObject:[NSString stringWithFormat:@"%d",user.comanyId]];
//            
//                            }
//            
//                                [newSONumArray addObject:[NSString stringWithFormat:@"%d",feedback.feedbackType]];
//        }
//        for (int c=0; c<distinctSONumArray.count; c++)
//        {
//            if (!([NSString stringWithFormat:@"%@",[distinctSONumArray objectAtIndex:c]]==feedback.soNumber))
//            {
//                if (user.comanyId==1)
//                {
//                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",user1.comanyId]];
//
//                }
//                else
//                {
//                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",user.comanyId]];
//
//                }
//                
//                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",feedback.feedbackType]];
//
//                
//                count++;
//            }
//        }
        
        
        
       
        /// NSString* q2=[NSString stringWithFormat:@"Drop table userpermission"];
        //  NSString* q3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",NULL,fdate,feedbackText,soNumber,attachment];
        NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<61"];
        //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
        //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES company(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];
        
        /* Data insertion: feedback table */
        int readStatusFlagForStar;

        if (readStatusflag)
        {
            readStatusFlagForStar=1;
        }
        else
        {
         readStatusFlagForStar=0;
        }
        
        NSString *query1=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject,readStatus) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\")",feedback.feedbackId,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject,readStatusFlagForStar];
        
        const char * queryi1=[query1 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                
                sqlite3_reset(statement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
                   }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
                   }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
        
        NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedbackchatingcounter values(\"%ld\",\"%ld\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.feedbackCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbackType,chatingCounterObj.userFrom,chatingCounterObj.userTo];
        
        const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
            {
                
                sqlite3_reset(chatingCounterStatement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
        {
            
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
                   }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
        
        NSString *statusIdUpdateQuery=[NSString stringWithFormat:@"Update feedback set statusId=%d Where Feedback_id=%ld and SO_Number='%@'",feedback.statusId,feedback.feedbackId,feedback.soNumber];
        
        const char * statusIdUpdateQuery123=[statusIdUpdateQuery UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery123, -1, &statusIdStatement, NULL);
            if(sqlite3_step(statusIdStatement)==SQLITE_DONE)
            {
                                sqlite3_reset(statusIdStatement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statusIdStatement) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        NSString* companyId;
        if (user.comanyId==1)
        {
            companyId=[NSString stringWithFormat:@"%d",user1.comanyId];
            
        }
        else
        {
            companyId=[NSString stringWithFormat:@"%d",user.comanyId];

            
        }

        NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=%d,closedCounter=%d,totalCounter=%d Where feedbackTypeId=%d and CompanyId='%@'",[openCount intValue] ,[closeCount intValue],[totalCount intValue],feedback.feedbackType,companyId];
        
        const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
            {
                
                sqlite3_reset(chatingCounterStatement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        

        
    }

    // Update CompanyFeedTypeAndCounter if its new feedback
//    if (count>0)
//    {
//        NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=(Select feedCounter from CompanyFeedTypeAndCounter Where CompanyId='%@' and feedbackTypeId=%d)+1 Where feedbackTypeId='%@' and CompanyId='%@'",[newSONumArray objectAtIndex:0] ,[[newSONumArray objectAtIndex:1] intValue],[newSONumArray objectAtIndex:1],[newSONumArray objectAtIndex:0]];
//        
//        const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//        {
//            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
//            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//            {
//               
//                sqlite3_reset(chatingCounterStatement);
//            }
//            else
//            {
//                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        else
//        {
//            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//        {
//        }
//        else
//            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        
//        
//        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//        {
//        }
//        else
//        {
//            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        

 //   }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_DATA_UPDATE object:nil];//for notification clcik data update

    
}




//- (NSString *)stringByEncodingHTMLEntities {
//    // Can return self so create new string if we're a mutable string
//    return [NSString stringWithString:[self gtm_stringByEscapingForAsciiHTML]];
//}
//
//- (NSString *)gtm_stringByEscapingHTMLUsingTable:(HTMLEscapeMap*)table
//                                          ofSize:(NSUInteger)size
//                                 escapingUnicode:(BOOL)escapeUnicode {
//    NSUInteger length = [self length];
//    if (!length) {
//        return self;
//    }
//
//    NSMutableString *finalString = [NSMutableString string];
//    NSMutableData *data2 = [NSMutableData dataWithCapacity:sizeof(unichar) * length];
//
//    // this block is common between GTMNSString+HTML and GTMNSString+XML but
//    // it's so short that it isn't really worth trying to share.
//    const unichar *buffer = CFStringGetCharactersPtr((CFStringRef)self);
//    if (!buffer) {
//        // We want this buffer to be autoreleased.
//        NSMutableData *data = [NSMutableData dataWithLength:length * sizeof(UniChar)];
//        if (!data) {
//            // COV_NF_START  - Memory fail case
//            //			_GTMDevLog(@"couldn't alloc buffer");
//            return nil;
//            // COV_NF_END
//        }
//        [self getCharacters:[data mutableBytes]];
//        buffer = [data bytes];
//    }
//
//    if (!buffer || !data2) {
//        // COV_NF_START
//        //		_GTMDevLog(@"Unable to allocate buffer or data2");
//        return nil;
//        // COV_NF_END
//    }
//
//    unichar *buffer2 = (unichar *)[data2 mutableBytes];
//
//    NSUInteger buffer2Length = 0;
//
//    for (NSUInteger i = 0; i < length; ++i) {
//        HTMLEscapeMap *val = bsearch(&buffer[i], table,
//                                     size / sizeof(HTMLEscapeMap),
//                                     sizeof(HTMLEscapeMap), EscapeMapCompare);
//        if (val || (escapeUnicode && buffer[i] > 127)) {
//            if (buffer2Length) {
//                CFStringAppendCharacters((CFMutableStringRef)finalString,
//                                         buffer2,
//                                         buffer2Length);
//                buffer2Length = 0;
//            }
//            if (val) {
//                [finalString appendString:val->escapeSequence];
//            }
//            else {
//                //				_GTMDevAssert(escapeUnicode && buffer[i] > 127, @"Illegal Character");
//                [finalString appendFormat:@"&#%d;", buffer[i]];
//            }
//        } else {
//            buffer2[buffer2Length] = buffer[i];
//            buffer2Length += 1;
//        }
//    }
//    if (buffer2Length) {
//        CFStringAppendCharacters((CFMutableStringRef)finalString,
//                                 buffer2,
//                                 buffer2Length);
//    }
//    return finalString;
//}
//





-(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags {
    NSRange r;
    while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
    return stringWithHtmlTags;
}




-(void)insertLatestRecordsForMOM:(NSDictionary *)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"ListOfMOM"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *companyIdMainForMOMDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                                 options:NSJSONReadingAllowFragments
                                                                                   error:&error];
    
    
    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
    {
        
        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
        for (int i=0; i<arrayFromCompanyIdKey.count; i++)
        {
            Mom *momObj=[[Mom alloc]init];
            NSDictionary* singleMOMDict=[arrayFromCompanyIdKey objectAtIndex:i];
           momObj.Id= [[singleMOMDict valueForKey:@"id"]intValue];
           momObj.momDate= [singleMOMDict valueForKey:@"date"];
           momObj.attendee= [singleMOMDict valueForKey:@"attendee"];
           momObj.subject= [singleMOMDict valueForKey:@"subject"];
           momObj.keyPoints= [singleMOMDict valueForKey:@"keypoints"];
            
           NSDictionary* userFromDict= [singleMOMDict valueForKey:@"userModelFrom"];
           momObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
            
           NSDictionary* userToDict= [singleMOMDict valueForKey:@"userModelTo"];
           momObj.userTo= [[userToDict valueForKey:@"userId"]intValue];
            
           NSDictionary* userFeedback= [singleMOMDict valueForKey:@"userfeedback"];
           momObj.userfeedback= [[userFeedback valueForKey:@"userId"]intValue];
            
           momObj.dateTime= [singleMOMDict valueForKey:@"dateTime"];

            momObj.keyPoints= [momObj.keyPoints stringByEncodingHTMLEntities];
            NSString* dateString=[NSString stringWithFormat:@"%@",momObj.dateTime];
            
            
            
            long mssince1970=[dateString doubleValue];
            momObj.dateTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:mssince1970/1000.0]];
            // feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:da]];
            //  feedback.dateOfFeed = [NSDate dateWithTimeIntervalSinceReferenceDate:da/1000];
            
            
            // NSString* dts=[[APIManager sharedManager] getDate];
            NSArray* dt= [momObj.dateTime componentsSeparatedByString:@" "];
            momObj.dateTime=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [dateFormatter setDateFormat:DATE_TIME_FORMAT];
            NSDate* utcTime = [dateFormatter dateFromString:momObj.dateTime];
            NSLog(@"UTC time: %@", utcTime);
            
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:DATE_TIME_FORMAT];
            NSString* localTime = [dateFormatter stringFromDate:utcTime];
            NSLog(@"localTime:%@", localTime);
            
            
            momObj.dateTime=localTime;

            NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO mom values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%d\")", momObj.Id,momObj.attendee,momObj.momDate,momObj.keyPoints,momObj.subject,momObj.userFrom,momObj.userTo,momObj.userfeedback,momObj.dateTime,0];
            
            Database *db=[Database shareddatabase];
            NSString *dbPath=[db getDatabasePath];
            sqlite3_stmt *statement;
            sqlite3* feedbackAndQueryTypesDB;
            
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
     
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));

        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
                   }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        

        
        }
    
    }
}



-(void)insertReportData:(NSDictionary *)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"ListOfReports"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *companyIdMainForMOMDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:&error];
    
    
    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
    {
        
        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
               for (int i=0; i<arrayFromCompanyIdKey.count; i++)
        {
            NSDictionary* singleReportDict=[arrayFromCompanyIdKey objectAtIndex:i];

            Report* reportObj=[[Report alloc]init];
            
            reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
            reportObj.name=[singleReportDict valueForKey:@"name"];
            reportObj.date=[singleReportDict valueForKey:@"date"];
            NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
            reportObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
            NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
            reportObj.userto=[[userToDict valueForKey:@"userId"]intValue];
            NSDictionary* userFeedbackDict=[singleReportDict valueForKey:@"userfeedback"];
            reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
            reportObj.description=[singleReportDict valueForKey:@"description"];
            reportObj.datetime=[singleReportDict valueForKey:@"dateTime"];
           
            NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO report values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
            
            Database *db=[Database shareddatabase];
            NSString *dbPath=[db getDatabasePath];
            sqlite3_stmt *statement;
            sqlite3* feedbackAndQueryTypesDB;
            
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                   
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
                          }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));

            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
               
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            

            
        }
    }
}

-(void)insertDocumentsData:(NSDictionary *)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"ListOfDocuments"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *companyIdMainForMOMDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:&error];
    
    
    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
    {
        
        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
               for (int i=0; i<arrayFromCompanyIdKey.count; i++)
        {
            NSDictionary* singleReportDict=[arrayFromCompanyIdKey objectAtIndex:i];
            
            Report* reportObj=[[Report alloc]init];
            
            reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
            reportObj.name=[singleReportDict valueForKey:@"name"];
            reportObj.date=[singleReportDict valueForKey:@"date"];
            NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
            reportObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
            NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
            reportObj.userto=[[userToDict valueForKey:@"userId"]intValue];
            NSDictionary* userFeedbackDict=[singleReportDict valueForKey:@"userfeedback"];
            reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
            reportObj.description=[singleReportDict valueForKey:@"description"];
            reportObj.datetime=[singleReportDict valueForKey:@"dateTime"];
            
            NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO document values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
            
            Database *db=[Database shareddatabase];
            NSString *dbPath=[db getDatabasePath];
            sqlite3_stmt *statement;
            sqlite3* feedbackAndQueryTypesDB;
            
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
                           }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));

            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
                            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            
            
            
        }
    }
}


-(void)insertNewReportData:(NSDictionary* )notificationData
{
    Report* reportObj=[[Report alloc]init];

    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"response"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *singleReportDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    
        //
    
        reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
        reportObj.name=[singleReportDict valueForKey:@"name"];
    
        reportObj.date=[notificationData valueForKey:@"date"];
        
        NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
        reportObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
        
        NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
        reportObj.userto=[[userToDict valueForKey:@"userId"]intValue];
        
        NSDictionary* userFeedbackDict=[singleReportDict valueForKey:@"userfeedback"];
        reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
        
        reportObj.description=[singleReportDict valueForKey:@"description"];
    
        reportObj.datetime=[notificationData valueForKey:@"dateTime"];
        
        NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO report values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement;
        sqlite3* feedbackAndQueryTypesDB;
        
        
        const char * queryi3=[query3 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                
                sqlite3_reset(statement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
            
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW object:nil];

 
}


-(void)insertNewDocumentData:(NSDictionary*)notificationData
{
    Report* reportObj=[[Report alloc]init];

    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"response"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *singleReportDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    
        
        //
        
        
    
        reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
        reportObj.name=[singleReportDict valueForKey:@"name"];
    
        reportObj.date=[notificationData valueForKey:@"date"];
        
        NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
        reportObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
        
        NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
        reportObj.userto=[[userToDict valueForKey:@"userId"]intValue];
        
        NSDictionary* userFeedbackDict=[singleReportDict valueForKey:@"userfeedback"];
        reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
        
        reportObj.description=[singleReportDict valueForKey:@"description"];
    
        reportObj.datetime=[notificationData valueForKey:@"dateTime"];
        
        NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO document values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement;
        sqlite3* feedbackAndQueryTypesDB;
        
        
        const char * queryi3=[query3 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                
                sqlite3_reset(statement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
            
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
            
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW object:nil];
    

}

-(NSString*)getCompanyId:(NSString*)username
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* companyId;

    NSString *query3=[NSString stringWithFormat:@"Select CompanyId from user Where USER_NAME='%@'",username];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
               companyId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    
    return companyId;
}


-(NSString*)getCompanyIdFromCompanyName1:(NSString*)CompanyName;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* companyId;
    
    NSString *query3=[NSString stringWithFormat:@"Select CompanyId from company Where Company_Name='%@'",CompanyName];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                companyId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return companyId;
}

-(NSString*)getuserNameFromCompanyId:(NSString*)companyId
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* username;
    
    NSString *query3=[NSString stringWithFormat:@"Select USER_NAME from user Where CompanyId='%@' and USER_ROLL=1",companyId];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                companyId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return companyId;
}


-(NSString*)getUserNameFromCompanyname:(NSString*)companyname
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* username;
    
    NSString *query3=[NSString stringWithFormat:@"Select USER_NAME from user Where CompanyId=(Select CompanyId from company Where Company_Name='%@') and USER_ROLL=1",companyname];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                username=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    
    return username;
}



-(NSString*)getUserIdFromUserNameWithRoll1:(NSString*)username
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    
    NSString *query3=[NSString stringWithFormat:@"Select ID from user Where CompanyId=(Select CompanyId from user Where USER_NAME='%@') and USER_ROLL=1",username];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                userid=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
              
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    return userid;

}

//-(long)getFeedbackCounterFromSONumberAndFeedbackType:(NSString*)sonumber :(int)feedtype
//{
//    Database *db=[Database shareddatabase];
//    NSString *dbPath=[db getDatabasePath];
//    sqlite3_stmt *statement;
//    sqlite3* feedbackAndQueryTypesDB;
//    NSString *query1;
//    long feedbackCounter;
//    NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
//    NSString *query3=[NSString stringWithFormat:@"Select MAX(count) from feedbackchatingcounter Where SoNumber='%@' and feedBackType=%d",sonumber,feedtype];
//    
//    NSString *query4=[NSString stringWithFormat:@"Select MAX(count) from querychatingcounter Where SoNumber='%@' and feedBackType=%d",sonumber,feedtype];
//
//    if ([str isEqualToString:@"0"])
//    {
//        query1=[NSString stringWithFormat:@"%@",query3];
//        
//    }
//    else
//    query1=[NSString stringWithFormat:@"%@",query4];
//        
//    
//
//   
//    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
//    {
//        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
//        {
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                
//                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
//                feedbackCounter=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]longLongValue];
//              
//                
//            }
//        }
//        else
//        {
//            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//    }
//    else
//    {
//        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    if (sqlite3_finalize(statement) == SQLITE_OK)
//    {
//          }
//    else
//        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    
//    
//    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//    {
//       
//    }
//    else
//    {
//        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    return feedbackCounter;
//    
//}
//


-(NSString*)getUserIdFromUserName:(NSString*)username
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    
    NSString *query3=[NSString stringWithFormat:@"Select ID from user Where USER_NAME='%@'",username];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                userid=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
               
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    

    
    return userid;

}

-(NSMutableArray*)getMaxFeedIdAndCounter:(NSString*)soNumber :(int)feedType
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* feedid,*counter;
    NSString* query1,*query2;
    NSMutableArray* feedIdAndCounterArray=[[NSMutableArray alloc]init];
    NSString *query3=[NSString stringWithFormat:@"Select MAX(Feedback_id),MAX(feedbackCounter) from feedback"];
    NSString *query4=[NSString stringWithFormat:@"Select MAX(Query_id),MAX(QueryCounter) from query"];
    NSString *query5=[NSString stringWithFormat:@"Select statusId,operatorId from feedback Where SO_Number='%@' and feedBackType=%d",soNumber,feedType];
    NSString *query6=[NSString stringWithFormat:@"Select statusId,Query_id from query Where SO_Number='%@' and feedBackType=%d",soNumber,feedType];

    NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
        if ([str isEqualToString:@"0"])
    {
        query1=[NSString stringWithFormat:@"%@",query3];
        query2=[NSString stringWithFormat:@"%@",query5];

    }
    else
    {
        query1=[NSString stringWithFormat:@"%@",query4];
        query2=[NSString stringWithFormat:@"%@",query6];

    }
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                feedid=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                counter=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];

              
                
            }
            [feedIdAndCounterArray addObject:feedid];
            [feedIdAndCounterArray addObject:counter];
            
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
       
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
           }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    


    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
    
    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query2 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
    {
        while (sqlite3_step(statement1) == SQLITE_ROW)
        {
            
            // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
            feedid=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 0)];
            counter=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 1)];
            
            
        }
        [feedIdAndCounterArray addObject:feedid];
        [feedIdAndCounterArray addObject:counter];
        
    }
    else
    {
        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement1) == SQLITE_OK)
    {
       
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    

    
    return feedIdAndCounterArray;

}

-(NSMutableArray*)getFeedTypeIdAndMaxCounter:(NSString*)feedbackType;
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* feedid,*counter,*feedTypeId;
    NSString* query1;
    NSMutableArray* feedIdAndCounterArray=[[NSMutableArray alloc]init];
    NSString *query3=[NSString stringWithFormat:@"Select MAX(Feedback_id),MAX(feedbackCounter) from feedback"];
    NSString *query4=[NSString stringWithFormat:@"Select MAX(Query_id),MAX(QueryCounter) from query"];
    NSString *query2=[NSString stringWithFormat:@"Select ID from feedbacktype Where Feedback_Type='%@'",feedbackType];
    
    NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
    if ([str isEqualToString:@"0"])
    {
        query1=[NSString stringWithFormat:@"%@",query3];
        
    }
    else
    {
        query1=[NSString stringWithFormat:@"%@",query4];
        
    }
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {

                if((char*)sqlite3_column_text(statement, 0) != NULL)
                {
                   feedid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                }
                if ((char*)sqlite3_column_text(statement, 0) == NULL)
                {
                    feedid=@"0";

                }
                if((char*)sqlite3_column_text(statement, 1) != NULL)
                {
                    counter = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                }
                if ((char*)sqlite3_column_text(statement, 1) == NULL)
                {
                    counter=@"0";
                    
                }
                
            }
            [feedIdAndCounterArray addObject:feedid];
            [feedIdAndCounterArray addObject:counter];
            
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
        
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
          }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    

    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query2 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement1) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                feedTypeId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 0)];
                
                
            }
            [feedIdAndCounterArray addObject:feedTypeId];
            
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement1) == SQLITE_OK)
    {
       
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return feedIdAndCounterArray;





}

//-(void)insertUserReply:(Feedback*)feedback
//{
//  
//
//    
//    Database *db=[Database shareddatabase];
//    NSString *dbPath=[db getDatabasePath];
//    sqlite3_stmt *statement;
//    sqlite3* feedbackAndQueryTypesDB;
//      NSString* query4=[NSString stringWithFormat:@"Delete from query where Query_id=5"];
//    NSString *query1,*query2,*query3;
//    /* Data insertion: feedback table */
//   
//    
//   query2=[NSString stringWithFormat:@"INSERT INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\")",feedback.feedbackId+1,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter+1,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject,0];
//    
//    query3=[NSString stringWithFormat:@"INSERT INTO query values(\"%ld\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\")",feedback.feedbackId+1,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter+1,feedback.feedbackType,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.dateOfFeed,feedback.emailSubject];
//    NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
//    if ([str isEqualToString:@"0"])
//    {
//        query1=[NSString stringWithFormat:@"%@",query2];
//        
//    }
//    else
//    {
//        query1=[NSString stringWithFormat:@"%@",query3];
//        
//    }
//
//    //const char * queryi1=[query4 UTF8String];
//    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//    {
//        sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL);
//        if(sqlite3_step(statement)==SQLITE_DONE)
//        {
//            NSLog(@"feedback table data inserted");
//            NSLog(@"%@",NSHomeDirectory());
//            sqlite3_reset(statement);
//        }
//        else
//        {
//            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//    }
//    else
//    {
//        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    if (sqlite3_finalize(statement) == SQLITE_OK)
//    {
//        NSLog(@"statement is finalized");
//    }
//    else
//        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    
//    
//
//    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//    {
//        NSLog(@"db is closed");
//    }
//    else
//    {
//        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//
//
//
//
//
//
//}



-(void)insertUpdatedRecordsForFeedcom:(NSDictionary*)recordDict
{

    NSError* error;
    NSString*  ListOffeedbacksString= [recordDict valueForKey:@"ListOffeedbacks"];
    NSData *ListOffeedbacksStringData = [ListOffeedbacksString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *ListOffeedbacksStringArray = [NSJSONSerialization JSONObjectWithData:ListOffeedbacksStringData
                                                                                 options:NSJSONReadingAllowFragments
                                                                                   error:&error];
    NSString*  closeCount= [recordDict valueForKey:@"closeCount"];
    NSString*  openCount= [recordDict valueForKey:@"openCount"];
    NSString*  totalCount= [recordDict valueForKey:@"totalCount"];

    //t0 increase close counter if status is closed
    BOOL closeStatus = false;
    int feedbackTypeId = 0;
                    for (int j=0; j<ListOffeedbacksStringArray.count; j++)
                {
                    NSDictionary* oneMessageDict = [ListOffeedbacksStringArray objectAtIndex:j];
                                     Feedback *feedback=[[Feedback alloc]init];
                    
                    feedback.feedbackId=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
                    feedback.feedbackText=[oneMessageDict valueForKey:@"feedbackText"];
                    feedback.feedbackText=[feedback.feedbackText stringByEncodingHTMLEntities];
                    
                    NSString* dateString=[oneMessageDict valueForKey:@"fdate"];
                    
                   
                    double da=[dateString doubleValue];
                   // feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
                   // feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:da]];
                 //  feedback.dateOfFeed = [NSDate dateWithTimeIntervalSinceReferenceDate:da/1000];
                    NSString* dts=[[APIManager sharedManager] getDate];
                    NSArray* dt= [dts componentsSeparatedByString:@" "];
                    feedback.dateOfFeed=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
                    
                    
                    feedback.soNumber=[oneMessageDict valueForKey:@"soNumber"];
                    
                    NSDictionary* operator=[oneMessageDict valueForKey:@"operator"];
                    feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
                    
                    NSDictionary* status=[oneMessageDict valueForKey:@"status"];
                    feedback.statusId=[[status valueForKey:@"statusId"]intValue];
                    
                    
                    NSDictionary* userModelFrom=[oneMessageDict valueForKey:@"userModelFrom"];
                    feedback.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
                    
                    NSDictionary* userModelTo=[oneMessageDict valueForKey:@"userModelTo"];
                    feedback.userTo=[[userModelTo valueForKey:@"userId"]intValue];
                    
                    
                    NSDictionary* userfeedback=[oneMessageDict valueForKey:@"userfeedback"];
                    feedback.userFeedback=[[userfeedback valueForKey:@"userId"]intValue];
                    
                    feedback.attachment=[oneMessageDict valueForKey:@"attachment"];
                    
                    feedback.emailSubject=[oneMessageDict valueForKey:@"emailSubject"];
                    feedback.emailSubject=[feedback.emailSubject stringByEncodingHTMLEntities];

                    NSDictionary* feedBackType=[oneMessageDict valueForKey:@"feedBackType"];
                    feedback.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
                    
                    if (feedback.statusId==2)
                    {
                        closeStatus=true;
                        feedbackTypeId=feedback.feedbackType;
                    }

                    NSDictionary* counter=[oneMessageDict valueForKey:@"counter"];
                    feedback.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];;
                    
                    //------------model values for feedbackChatingCounter------------//
                    
                    FeedbackChatingCounter* chatingCounterObj=[[FeedbackChatingCounter alloc]init];
                    
                    chatingCounterObj.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];
                    chatingCounterObj.soNumber= [counter valueForKey:@"so_number"];
                    
                    chatingCounterObj.userFrom= [userModelFrom valueForKey:@"userId"];
                    
                    chatingCounterObj.userTo= [userModelTo valueForKey:@"userId"];
                    
                    chatingCounterObj.feedbackType= [[feedBackType valueForKey:@"id"]intValue];
                    
                    chatingCounterObj.count= [[counter valueForKey:@"count"]longValue];
                    
                    
                    
                    Database *db=[Database shareddatabase];
                    NSString *dbPath=[db getDatabasePath];
                    sqlite3_stmt *statement,*chatingCounterStatement;
                    sqlite3* feedbackAndQueryTypesDB;
                   
                    
                    
                    NSString *query1=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject,readStatus) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\")",feedback.feedbackId,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject,0];
                    
                    const char * queryi1=[query1 UTF8String];
                    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                    {
                        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
                        if(sqlite3_step(statement)==SQLITE_DONE)
                        {
                            
                            sqlite3_reset(statement);
                        }
                        else
                        {
                            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                    }
                    else
                    {
                        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    
                    if (sqlite3_finalize(statement) == SQLITE_OK)
                    {
                                           }
                    else
                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    
                    
                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                    {
                       
                    }
                    else
                    {
                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    
                    
                    
                    NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedbackchatingcounter values(\"%ld\",\"%ld\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.feedbackCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbackType,chatingCounterObj.userFrom,chatingCounterObj.userTo];
                    
                    const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
                    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                    {
                        sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
                        if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
                        {
                            
                            sqlite3_reset(chatingCounterStatement);
                        }
                        else
                        {
                            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        }
                    }
                    else
                    {
                        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    
                    if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
                    {
                        
                    }
                    else
                        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    
                    
                    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                    {
                       
                    }
                    else
                    {
                        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    
                    
                    
                }
    
    
    if (closeStatus)
    {
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement,*chatingCounterStatement;
        sqlite3* feedbackAndQueryTypesDB;
        
        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
        NSString* companyId=[[Database shareddatabase] getCompanyId:username];
        NSString* selectedCompany;
        if ([companyId isEqual:@"1"])
        {
            selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
            companyId= [[Database shareddatabase] getCompanyIdFromCompanyName1:selectedCompany];
        }
        else
        {
            //companyId= [[Database shareddatabase] getCompanyIdFromCompanyName:companyId];
        }

        NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=%ld,closedCounter=%ld,totalCounter=%ld Where feedbackTypeId=%d and CompanyId=%d",[openCount longLongValue],[closeCount longLongValue],[totalCount longLongValue],feedbackTypeId,[companyId intValue]];
        
        const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
            {
                sqlite3_reset(chatingCounterStatement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }

    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_DATA_UPDATE object:nil];

}


//-(void)insertUpdatedRecordsForQueryCom:(NSDictionary*)recordDict
//{
//    
//    NSError* error;
//    NSString*  ListOffeedbacksString= [recordDict valueForKey:@"ListOfqueries"];
//    NSData *ListOffeedbacksStringData = [ListOffeedbacksString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSArray *ListOffeedbacksStringArray = [NSJSONSerialization JSONObjectWithData:ListOffeedbacksStringData
//                                                                          options:NSJSONReadingAllowFragments
//                                                                            error:&error];
//    
//    for (int j=0; j<ListOffeedbacksStringArray.count; j++)
//    {
//        
//        //------------------------------
//        
//        NSDictionary* oneMessageDict = [ListOffeedbacksStringArray objectAtIndex:j];
//        
//        //-------------------------feedback table data insertion------------------------------------------
//        
//        Query *query=[[Query alloc]init];
//        
//        query.queryId=[[oneMessageDict valueForKey:@"queryId"]intValue];
//        query.queryText=[oneMessageDict valueForKey:@"queryText"];
//        
//        NSString* dateString=[oneMessageDict valueForKey:@"dateofquery"];
//        
//        double da=[dateString doubleValue];
//        query.dateOfQuery = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
//        
//        
//        
//        NSDictionary* feedBackType=[oneMessageDict valueForKey:@"feedBackType"];
//        query.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
//        
//        query.soNumber=[oneMessageDict valueForKey:@"soNumber"];
//        
//        NSDictionary* counter=[oneMessageDict valueForKey:@"counter"];
//        query.queryCounter=[[counter valueForKey:@"queryCounter"]intValue];;
//        
//        NSDictionary* status=[oneMessageDict valueForKey:@"status"];
//        query.statusId=[[status valueForKey:@"statusId"]intValue];
//        
//        NSDictionary* userModelFrom=[oneMessageDict valueForKey:@"userModelFrom"];
//        query.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
//        
//        NSDictionary* userModelTo=[oneMessageDict valueForKey:@"userModelTo"];
//        query.userTo=[[userModelTo valueForKey:@"userId"]intValue];
//        
//        NSDictionary* userfeedback=[oneMessageDict valueForKey:@"userquery"];
//        query.userQuery=[[userfeedback valueForKey:@"userId"]intValue];
//        
//        
//        query.emailSubject=[oneMessageDict valueForKey:@"subject"];
//        query.attachment=[oneMessageDict valueForKey:@"attachment"];
//
//       AppPreferences* app= [AppPreferences sharedAppPreferences];
//               QueryChatingCounter* chatingCounterObj=[[QueryChatingCounter alloc]init];
//        
//        chatingCounterObj.queryCounter=[[counter valueForKey:@"queryCounter"]intValue];
//        chatingCounterObj.soNumber= [counter valueForKey:@"so_number"];
//        
//        chatingCounterObj.userFrom= [userModelFrom valueForKey:@"userId"];
//        
//        chatingCounterObj.userTo= [userModelTo valueForKey:@"userId"];
//        
//        chatingCounterObj.feedbacktype= [[feedBackType valueForKey:@"id"]intValue];
//        
//        chatingCounterObj.count= [[counter valueForKey:@"count"]intValue];
//        
//        //-------------------------------------
//        Database *db=[Database shareddatabase];
//        NSString *dbPath=[db getDatabasePath];
//        sqlite3_stmt *statement,*chatingCounterStatement;
//        sqlite3* feedbackAndQueryTypesDB;
//        
//        NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<61"];
//        
//        
//        NSString *query1=[NSString stringWithFormat:@"INSERT OR REPLACE INTO query values(\"%ld\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\")",query.queryId,query.queryText,query.soNumber,query.queryCounter,query.feedbackType,query.statusId,query.userFrom,query.userTo,query.userQuery,query.dateOfQuery,query.emailSubject,query.attachment];
//        
//        const char * queryi1=[query1 UTF8String];
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//        {
//            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
//            if(sqlite3_step(statement)==SQLITE_DONE)
//            {
//                NSLog(@"feedback table data inserted");
//                NSLog(@"%@",NSHomeDirectory());
//                sqlite3_reset(statement);
//            }
//            else
//            {
//                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        else
//        {
//            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        if (sqlite3_finalize(statement) == SQLITE_OK)
//        {
//            NSLog(@"statement is finalized");
//        }
//        else
//            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        
//        
//        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//        {
//            NSLog(@"db is closed");
//        }
//        else
//        {
//            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        
//        
//        NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO querychatingcounter values(\"%d\",\"%d\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.queryCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbacktype,chatingCounterObj.userFrom,chatingCounterObj.userTo];
//        
//        const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//        {
//            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
//            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//            {
//                NSLog(@"chatingCounter table data inserted");
//                NSLog(@"%@",NSHomeDirectory());
//                sqlite3_reset(chatingCounterStatement);
//            }
//            else
//            {
//                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        else
//        {
//            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//        {
//            NSLog(@"statement is finalized");
//        }
//        else
//            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        
//        
//        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//        {
//            NSLog(@"db is closed");
//        }
//        else
//        {
//            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        
//        
//        
//    }
//    
//}



-(void)insertNewFeedback:(NSDictionary*)oneMessageDict :(NSDictionary*)responseDict
{
        Feedback *feedback=[[Feedback alloc]init];
        
        feedback.feedbackId=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
        feedback.feedbackText=[oneMessageDict valueForKey:@"feedText"];
        
        
        feedback.dateOfFeed=[oneMessageDict valueForKey:@"dateOfFeed"];
        
    
        feedback.soNumber=[oneMessageDict valueForKey:@"soNumber"];
        
        feedback.operatorId=[[oneMessageDict valueForKey:@"operatorId"]intValue];
        
        feedback.statusId=[[oneMessageDict valueForKey:@"statusId"]intValue];
        
        feedback.userFrom=[[oneMessageDict valueForKey:@"userFrom"]intValue];
        
        feedback.userTo=[[oneMessageDict valueForKey:@"userTo"]intValue];
        
    
        feedback.userFeedback=[[oneMessageDict valueForKey:@"userFeedback"]intValue];
        
        feedback.attachment=[oneMessageDict valueForKey:@"attachment"];
        
        feedback.emailSubject=[oneMessageDict valueForKey:@"subject"];
 //   feedback.emailSubject=[feedback.emailSubject stringByEncodingHTMLEntities];
//
    
        feedback.feedbackType=[[oneMessageDict valueForKey:@"feedbackType"]intValue];
        
        feedback.feedbackCounter=[[oneMessageDict valueForKey:@"feedbackCounter"]longLongValue];
        
        //------------model values for feedbackChatingCounter------------//
        
        FeedbackChatingCounter* chatingCounterObj=[[FeedbackChatingCounter alloc]init];
        
    chatingCounterObj.feedbackCounter=[[oneMessageDict valueForKey:@"feedbackId"]intValue];

        chatingCounterObj.soNumber= [oneMessageDict valueForKey:@"soNumber"];
        
        chatingCounterObj.userFrom= [oneMessageDict valueForKey:@"userFrom"];
        
        chatingCounterObj.userTo= [oneMessageDict valueForKey:@"userTo"];
        
        chatingCounterObj.feedbackType= [[oneMessageDict valueForKey:@"feedbackType"]intValue];
        
        chatingCounterObj.count= [[oneMessageDict valueForKey:@"feedbackCounter"]longLongValue];
        
        
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement,*chatingCounterStatement;
        sqlite3* feedbackAndQueryTypesDB;
        
        //NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<61"];
        
        
        NSString *query1=[NSString stringWithFormat:@"INSERT INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject,readStatus) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\")",feedback.feedbackId,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackId,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject,1];
        
        const char * queryi1=[query1 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
               
                sqlite3_reset(statement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
                   }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
           
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
        
        NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedbackchatingcounter values(\"%ld\",\"%ld\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.feedbackCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbackType,chatingCounterObj.userFrom,chatingCounterObj.userTo];
        
        const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
            {
                
                sqlite3_reset(chatingCounterStatement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
        {
           
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
                   }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
    
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[db getCompanyId:username];
//    closeCount = 0;
//    code = 1000;
//    feedbackCount = 1;
//    feedbackCounterId = 16;
//    openCount = 9;
//    totalCount = 9;
    
   NSString* totalCount= [responseDict valueForKey:@"totalCount"];
    NSString* openCount= [responseDict valueForKey:@"openCount"];

    NSString* closeCount= [responseDict valueForKey:@"totalCount"];

    if ([companyId isEqual:@"1"])
    {
       NSString* selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
       companyId= [db getCompanyIdFromCompanyName1:selectedCompany];
    }
    NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=%d,totalCounter=%d,closed          Counter=%d Where feedbackTypeId=%d and CompanyId=%d",[openCount intValue],[totalCount intValue],[closeCount intValue],chatingCounterObj.feedbackType,[companyId intValue]];
    
    const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
        if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
        {
                       sqlite3_reset(chatingCounterStatement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
    {
           }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
            }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_DATA_UPDATE object:nil];
        
}




//-(void)insertNewQuery:(NSDictionary*)oneMessageDict
//{
//
//    //NSLog(@"%@",[oneMessageDict valueForKey:@"feedbackId"]);
//    
//    //-------------------------feedback table data insertion------------------------------------------
//    
//    Query *query=[[Query alloc]init];
//    
//    
//    query.queryId=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
//    query.queryText=[oneMessageDict valueForKey:@"feedText"];
//    
//    query.dateOfQuery=[oneMessageDict valueForKey:@"dateOfFeed"];
//    
//    
//    
//    query.feedbackType=[[oneMessageDict valueForKey:@"feedbackType"]intValue];
//    
//    query.soNumber=[oneMessageDict valueForKey:@"soNumber"];
//    
//    query.queryCounter=[[oneMessageDict valueForKey:@"feedbackId"]intValue];;
//    
//    // NSDictionary* operator=[queryDetailDictionary valueForKey:@"operator"];
//    // feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
//    
//    query.statusId=[[oneMessageDict valueForKey:@"statusId"]intValue];
//    
//    query.userFrom=[[oneMessageDict valueForKey:@"userFrom"]intValue];
//    
//    query.userTo=[[oneMessageDict valueForKey:@"userTo"]intValue];
//    
//    query.userQuery=[[oneMessageDict valueForKey:@"userFeedback"]intValue];
//    
//    //query.attachment=[queryDetailDictionary valueForKey:@"attachment"];
//    
//    query.emailSubject=[oneMessageDict valueForKey:@"subject"];
//    
//    
//    
//    QueryChatingCounter* chatingCounterObj=[[QueryChatingCounter alloc]init];
//    
//    chatingCounterObj.queryCounter=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
//    chatingCounterObj.soNumber= [oneMessageDict valueForKey:@"soNumber"];
//    
//    chatingCounterObj.userFrom= [oneMessageDict valueForKey:@"userFrom"];
//    
//    chatingCounterObj.userTo= [oneMessageDict valueForKey:@"userTo"];
//    
//    chatingCounterObj.feedbacktype= [[oneMessageDict valueForKey:@"feedbackType"]intValue];
//    
//    chatingCounterObj.count= [[oneMessageDict valueForKey:@"feedbackCounter"]intValue];
//    query.attachment= [oneMessageDict valueForKey:@"attachment"];
//
//    //-------------------------------------
//    Database *db=[Database shareddatabase];
//    NSString *dbPath=[db getDatabasePath];
//    sqlite3_stmt *statement,*chatingCounterStatement;
//    sqlite3* feedbackAndQueryTypesDB;
//    
//    NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<61"];
//    
//    
//    NSString *query1=[NSString stringWithFormat:@"INSERT OR REPLACE INTO query values(\"%ld\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\")",query.queryId,query.queryText,query.soNumber,query.queryCounter,query.feedbackType,query.statusId,query.userFrom,query.userTo,query.userQuery,query.dateOfQuery,query.emailSubject,query.attachment];
//    
//    const char * queryi1=[query1 UTF8String];
//    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//    {
//        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
//        if(sqlite3_step(statement)==SQLITE_DONE)
//        {
//            NSLog(@"feedback table data inserted");
//            NSLog(@"%@",NSHomeDirectory());
//            sqlite3_reset(statement);
//        }
//        else
//        {
//            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//    }
//    else
//    {
//        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    if (sqlite3_finalize(statement) == SQLITE_OK)
//    {
//        NSLog(@"statement is finalized");
//    }
//    else
//        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    
//    
//    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//    {
//        NSLog(@"db is closed");
//    }
//    else
//    {
//        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    
//    
//    NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO querychatingcounter values(\"%d\",\"%d\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.queryCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbacktype,chatingCounterObj.userFrom,chatingCounterObj.userTo];
//    
//    const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
//    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//    {
//        sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
//        if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//        {
//            NSLog(@"chatingCounter table data inserted");
//            NSLog(@"%@",NSHomeDirectory());
//            sqlite3_reset(chatingCounterStatement);
//        }
//        else
//        {
//            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//    }
//    else
//    {
//        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//    {
//        NSLog(@"statement is finalized");
//    }
//    else
//        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    
//    
//    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//    {
//        NSLog(@"db is closed");
//    }
//    else
//    {
//        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    
//
//    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
//    NSString* companyId=[db getCompanyId:username];
//    NSString*  selectedCompany;
//    if ([companyId isEqualToString:@"1"])
//    {
//        selectedCompany=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
//        //companyId= [db getCompanyIdFromCompanyName:selectedCompany];
//        
//    }
//    
//     NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set queryCounter=(Select queryCounter from CompanyFeedTypeAndCounter Where CompanyId=(Select CompanyId from company Where Company_Name='%@') and feedbackTypeId=%d)+1 Where feedbackTypeId=%d and CompanyId=(Select CompanyId from company Where Company_Name='%@')",selectedCompany,chatingCounterObj.feedbacktype,chatingCounterObj.feedbacktype,selectedCompany];
//    const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
//    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//    {
//        sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
//        if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//        {
//            NSLog(@"CompanyFeedTypeAndCounter table data Updated");
//            NSLog(@"%@",NSHomeDirectory());
//            sqlite3_reset(chatingCounterStatement);
//        }
//        else
//        {
//            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//    }
//    else
//    {
//        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//    if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//    {
//        NSLog(@"statement is finalized");
//    }
//    else
//        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    
//    
//    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//    {
//        NSLog(@"db is closed");
//    }
//    else
//    {
//        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//    }
//    
//   
//}
//

-(void)insertNewMOM:(NSDictionary*)responseDict
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString *query1;
    /* Data insertion: mom table */
    
    Mom* momObj=[Mom new];
   momObj.subject= [responseDict valueForKey:@"subject"];
    momObj.momDate=[responseDict valueForKey:@"createdDate"];
   momObj.attendee= [responseDict valueForKey:@"attendee"];
   momObj.keyPoints= [responseDict valueForKey:@"keyPoints"];
   momObj.userFrom= [[responseDict valueForKey:@"userFrom"]intValue];
    momObj.userTo=[[responseDict valueForKey:@"userTo"]intValue];
   momObj.userfeedback= [[responseDict valueForKey:@"userFeedback"]intValue];
   momObj.dateTime= [responseDict valueForKey:@"submittedDateTime"];
    momObj.Id=[[responseDict valueForKey:@"momId"]longLongValue];

    
    NSString* dateString=[NSString stringWithFormat:@"%@",momObj.dateTime];
    
    
    
//    long mssince1970=[dateString doubleValue];
//    momObj.dateTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:mssince1970/1000.0]];
    // feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:da]];
    //  feedback.dateOfFeed = [NSDate dateWithTimeIntervalSinceReferenceDate:da/1000];
    
    
    // NSString* dts=[[APIManager sharedManager] getDate];
    NSArray* dt= [momObj.dateTime componentsSeparatedByString:@" "];
    momObj.dateTime=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
    
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    [dateFormatter setDateFormat:DATE_TIME_FORMAT];
//    NSDate* utcTime = [dateFormatter dateFromString:momObj.dateTime];
//    NSLog(@"UTC time: %@", utcTime);
//    
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    [dateFormatter setDateFormat:DATE_TIME_FORMAT];
//    NSString* localTime = [dateFormatter stringFromDate:utcTime];
//    NSLog(@"localTime:%@", localTime);
    
   // momObj.dateTime=localTime;

   query1=[NSString stringWithFormat:@"INSERT OR REPLACE into mom(id,attendee,mom_date,keypoints,subject,userFrom,userTo,userFeedback,fileDatetime,readStatus) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%d\")",momObj.Id,momObj.attendee,momObj.momDate,momObj.keyPoints,momObj.subject,momObj.userFrom,momObj.userTo,momObj.userfeedback,momObj.dateTime,0];
    
    const char * queryi1=[query1 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }


    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    

    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_MOM_VIEW object:nil];

}


-(NSMutableArray*)getAllUsersOfCompany:(NSString*)companyId andCompany:(NSString*)companyId1
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableArray* userIdsArray=[[NSMutableArray alloc]init];
    
    NSString *query3=[NSString stringWithFormat:@"Select ID from user Where CompanyId='%@' or CompanyId='%@'",companyId,companyId1];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                [userIdsArray addObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
            }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
            }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return userIdsArray;
    


}


-(NSString*)getClosedByUserName:(int)feedbackType andsoNumber:(NSString*)soNumber
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* firstName,*lastName,*firstNameLastName;
    
    NSString *query3= [NSString stringWithFormat:@"Select First_NAME,LastName from user Where ID=(Select userFeedBack from feedback Where feedbackCounter=(Select MAX(feedbackCounter) from feedback Where feedBackType=%d and SO_Number='%@'))",feedbackType,soNumber];
;
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
               firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                lastName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];

               // NSLog(@"%@",userid);
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
          }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
           }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    firstNameLastName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    return firstNameLastName;
    
}



-(NSMutableDictionary*)getAllOperaotorUsernames
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableDictionary* operatorUsernamesDict=[[NSMutableDictionary alloc]init];
    
    NSString *query3=@"Select username,operator_id from operator";
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
                [operatorUsernamesDict setObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
               
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
           }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return operatorUsernamesDict;
    
    
    
}


-(NSMutableArray*)getAllUsersFirstnameLastname:(NSString*)company1 company2:(NSString *)company2;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableArray* userObjectsArray=[NSMutableArray new];
    if (company2==nil)
    {
        company2=company1;
    }
    NSString *query3=[NSString stringWithFormat:@"Select First_Name,LastName,ID from user Where CompanyId='%@' or CompanyId='%@'",company1,company2];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                User* userObject=[[User alloc]init];
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
              userObject.firstName=  [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                userObject.lastName=  [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
               userObject.Id=  [[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)]intValue];

                [userObjectsArray addObject:userObject];
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return userObjectsArray;
}


-(void)removeUserdata
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;

    NSString *truncateQuery1=@"Delete from user Where Id>0";
    NSString *truncateQuery2=@"Delete from feedback Where Feedback_id>0";
    NSString *truncateQuery3=@"Delete from feedbackchatingcounter Where FeedBack_Counter>0";
    NSString *truncateQuery4=@"Delete from CompanyFeedTypeAndCounter Where ID>0";
    NSString *truncateQuery5=@"Delete from report Where id>0";
    NSString *truncateQuery6=@"Delete from document Where id>0";
    NSString *truncateQuery7=@"Delete from mom Where id>0";
    NSString *truncateQuery8=@"Delete from userpermission Where id>0";


  //  NSString *truncateQuery5=@"Delete from user Where Id>0";

    const char * statusIdUpdateQuery1=[truncateQuery1 UTF8String];
    const char * statusIdUpdateQuery2=[truncateQuery2 UTF8String];
    const char * statusIdUpdateQuery3=[truncateQuery3 UTF8String];
    const char * statusIdUpdateQuery4=[truncateQuery4 UTF8String];
    const char * statusIdUpdateQuery5=[truncateQuery5 UTF8String];
    const char * statusIdUpdateQuery6=[truncateQuery6 UTF8String];
    const char * statusIdUpdateQuery7=[truncateQuery7 UTF8String];
    const char * statusIdUpdateQuery8=[truncateQuery8 UTF8String];

    //const char * statusIdUpdateQuery5=[truncateQuery1 UTF8String];

    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery1, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery2, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }

        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }

        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery4, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }

        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery5, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }

        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery6, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }

        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery7, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery8, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }


}


-(void)updateReadStatus:(NSString*)SONumber feedbackType:(NSString*)feedbackType
{
    
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statusIdStatement;
    sqlite3* feedbackAndQueryTypesDB;
    
    NSString *statusIdUpdateQuery=[NSString stringWithFormat:@"Update feedback set readStatus=0 Where feedBackType='%@' and SO_Number='%@'",feedbackType,SONumber];
    
    const char * statusIdUpdateQuery123=[statusIdUpdateQuery UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery123, -1, &statusIdStatement, NULL);
        if(sqlite3_step(statusIdStatement)==SQLITE_DONE)
        {
           
            sqlite3_reset(statusIdStatement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statusIdStatement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    


}


-(NSMutableArray*)getFeedbackIDs:(NSString*)feedbackType userFrom:(NSString*)userFrom userTo:(NSString*)userTo
{
    
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableArray* userObjectsArray=[NSMutableArray new];
    
NSString* query3=[NSString stringWithFormat:@"Select Feedback_id from feedback Where feedBackType=(Select ID from feedbacktype Where Feedback_Type='%@') and ((userFrom='%@' and userTo='%@') or (userFrom='%@' and userTo='%@'))",feedbackType,userFrom,userTo,userTo,userFrom];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
               NSString* feedbackId= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                                [userObjectsArray addObject:feedbackId];
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return userObjectsArray;

}

-(NSMutableArray*)getMOMIds:(NSString*)userFrom userTo:(NSString*)userTo
{
    
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableArray* userObjectsArray=[NSMutableArray new];
    
    NSString* query3=[NSString stringWithFormat:@"Select id from mom Where ((userFrom='%@' and userTo='%@') or (userFrom='%@' and userTo='%@'))",userFrom,userTo,userTo,userFrom];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
                NSString* feedbackId= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                [userObjectsArray addObject:feedbackId];
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return userObjectsArray;
    
}

-(NSMutableArray*)getReportIds:(NSString*)userFrom userTo:(NSString*)userTo
{
    
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableArray* userObjectsArray=[NSMutableArray new];
    
    NSString* query3=[NSString stringWithFormat:@"Select id from report Where ((userfrom='%@' and userto='%@') or (userfrom='%@' and userto='%@'))",userFrom,userTo,userTo,userFrom];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
                NSString* feedbackId= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                [userObjectsArray addObject:feedbackId];
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return userObjectsArray;
    
}

-(NSMutableArray*)getDocumentIds:(NSString*)userFrom userTo:(NSString*)userTo
{
    
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* userid;
    NSMutableArray* userObjectsArray=[NSMutableArray new];
    
    NSString* query3=[NSString stringWithFormat:@"Select id from document Where ((userfrom='%@' and userto='%@') or (userfrom='%@' and userto='%@'))",userFrom,userTo,userTo,userFrom];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
                NSString* feedbackId= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                [userObjectsArray addObject:feedbackId];
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return userObjectsArray;
    
}

-(int)getFeedbackIdFromFeedbackType:(NSString*)feedbackType
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int feedbackId;
    NSString *query3=[NSString stringWithFormat:@"Select ID from feedbacktype Where Feedback_Type='%@'",feedbackType];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //operatorUsernamesDict=[NSMutableDictionary dictionaryWithObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)] forKey:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]];
                feedbackId=  sqlite3_column_int(statement, 0);
                
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
    return feedbackId;

}

-(void)getLoadMoreData:(NSDictionary*)notificationData
{
    NSError* error;
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*chatingCounterStatement,*statusIdStatement = NULL;
    sqlite3* feedbackAndQueryTypesDB;
    
    NSString* totalCount=[notificationData valueForKey:@"totalCount"];
    NSString* openCount=[notificationData valueForKey:@"openCount"];
    NSString* closeCount=[notificationData valueForKey:@"closeCount"];

    NSString*  companyIdMainDictForFeedbackString= [notificationData valueForKey:@"Feedbacks"];
    NSData *companyIdMainDictForFeedbackData = [companyIdMainDictForFeedbackString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *companyIdMainForFeedbackDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForFeedbackData
                                                                                 options:NSJSONReadingAllowFragments
                                                                                   error:&error];
    
    
//    NSString*  totalCountString= [notificationData valueForKey:@"totalCount"];
//    NSData *totalCountData = [totalCountString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *totalCountDict = [NSJSONSerialization JSONObjectWithData:totalCountData
//                                                                                 options:NSJSONReadingAllowFragments
//                                                                                   error:&error];
//    
//    NSString*  openCountString= [notificationData valueForKey:@"openCount"];
//    NSData *openCountData = [openCountString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *openCountDict = [NSJSONSerialization JSONObjectWithData:openCountData
//                                                                   options:NSJSONReadingAllowFragments
//                                                                     error:&error];
//    
//    NSString*  closeCountString= [notificationData valueForKey:@"closeCount"];
//    NSData *closeCountData = [closeCountString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *closeCountDict = [NSJSONSerialization JSONObjectWithData:closeCountData
//                                                                   options:NSJSONReadingAllowFragments
//                                                                     error:&error];
    
    NSString* companyId= [[Database shareddatabase] getCompanyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]];
    
    NSMutableArray* distinctSONumArray=[[NSMutableArray alloc]init];
    NSMutableArray* newSONumArray=[[NSMutableArray alloc]init];
    
    int count=0;
    if ([companyId isEqual:@"1"])
    {
        NSString* companyName= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
        companyId= [[Database shareddatabase] getCompanyIdFromCompanyName1:companyName];
    }

    for (NSString* SONumberKey in [companyIdMainForFeedbackDict allKeys])
    {
        NSArray* messagesArray = [companyIdMainForFeedbackDict valueForKey:SONumberKey];
        
        for (int t=0; t<messagesArray.count; t++)
        {
            
            NSDictionary* oneMessageDict = [messagesArray objectAtIndex:t];
            Feedback *feedback=[[Feedback alloc]init];
            
            feedback.feedbackId=[[oneMessageDict valueForKey:@"feedbackId"]intValue];
            feedback.feedbackText=[oneMessageDict valueForKey:@"feedbackText"];
            feedback.feedbackText=[feedback.feedbackText stringByEncodingHTMLEntities];
            //[NSString strin]
            // feedback.feedbackText= [self stringByStrippingHTML:feedback.feedbackText];
            //feedback.dateOfFeed=[oneMessageDict valueForKey:@"fdate"];
            
            NSString* dateString=[oneMessageDict valueForKey:@"fdate"];
            
            //NSString* dateString=[oneMessageDict valueForKey:@"dateofquery"];
            
            //query.dateOfQuery=[oneMessageDict valueForKey:@"dateofquery"];
            //NSString* dateString= allMessageObj1.dateOfFeed;
            double da=[dateString doubleValue];
            feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
            
            
            
            
            feedback.soNumber=[oneMessageDict valueForKey:@"soNumber"];
            
            NSDictionary* operator=[oneMessageDict valueForKey:@"operator"];
            feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
            
            NSDictionary* status=[oneMessageDict valueForKey:@"status"];
            feedback.statusId=[[status valueForKey:@"statusId"]intValue];
            
            NSDictionary* userModelFrom=[oneMessageDict valueForKey:@"userModelFrom"];
            feedback.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
            
            NSDictionary* userModelTo=[oneMessageDict valueForKey:@"userModelTo"];
            feedback.userTo=[[userModelTo valueForKey:@"userId"]intValue];
            
            
            NSDictionary* userfeedback=[oneMessageDict valueForKey:@"userfeedback"];
            feedback.userFeedback=[[userfeedback valueForKey:@"userId"]intValue];
            
            feedback.attachment=[oneMessageDict valueForKey:@"attachment"];
            
            feedback.emailSubject=[oneMessageDict valueForKey:@"emailSubject"];
            feedback.emailSubject=[feedback.emailSubject stringByEncodingHTMLEntities];

            NSDictionary* feedBackType=[oneMessageDict valueForKey:@"feedBackType"];
            feedback.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
            
            NSDictionary* counter=[oneMessageDict valueForKey:@"counter"];
            feedback.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];;
            
            //------------model values for feedbackChatingCounter------------//
            
            FeedbackChatingCounter* chatingCounterObj=[[FeedbackChatingCounter alloc]init];
            
            chatingCounterObj.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];
            chatingCounterObj.soNumber= [counter valueForKey:@"so_number"];
            
            chatingCounterObj.userFrom= [userModelFrom valueForKey:@"userId"];
            
            chatingCounterObj.userTo= [userModelTo valueForKey:@"userId"];
            
            chatingCounterObj.feedbackType= [[feedBackType valueForKey:@"id"]intValue];
            
            chatingCounterObj.count= [[counter valueForKey:@"count"]longValue];
            
            User *user=[[User alloc]init];
            Company *company=[[Company alloc]init];
            user.username=[userModelFrom valueForKey:@"userName"];
            user.password=[userModelFrom valueForKey:@"password"];
            
            NSDictionary* userRole=[userModelFrom valueForKey:@"userRoll"];
            user.userRole=[[userRole valueForKey:@"id"]intValue];
            
            NSDictionary* companyOb=[userModelFrom valueForKey:@"company"];
            user.comanyId=[[companyOb valueForKey:@"companyId"]intValue];
            
            user.email=[userModelFrom valueForKey:@"email"];
            user.mobileNo=[userModelFrom valueForKey:@"mobileNo"];
            user.firstName=[userModelFrom valueForKey:@"firstName"];
            user.lastName=[userModelFrom valueForKey:@"lastName"];
            user.deviceToken=[userModelFrom valueForKey:@"deviceToken"];
            
            //--------------------------userRole table data values-----------------------------------------------
            
            userRoll *userroll=[[userRoll alloc]init];
            userroll.role=[userRole valueForKey:@"id"];
            
            //--------------------------company table data values------------------------------------------------
            
            company.Company_Name=[companyOb valueForKey:@"companyName"];
            company.Company_Contact=[companyOb valueForKey:@"companyContact"];
            company.Company_Address=[companyOb valueForKey:@"companyAddress"];
            company.Company_Email=[companyOb valueForKey:@"companyEmail"];
            //company.userId=[[companyOb valueForKey:@"userID"]intValue];
            
            
            
            //-------------------------user table data insertion values from userTo------------------------------------------
            
            User *user1=[[User alloc]init];
            Company *company1=[[Company alloc]init];
            user1.username=[userModelTo valueForKey:@"userName"];
            user1.password=[userModelTo valueForKey:@"password"];
            
            NSDictionary* userRole1=[userModelTo valueForKey:@"userRoll"];
            user1.userRole=[[userRole1 valueForKey:@"id"]intValue];
            
            NSDictionary* companyOb1=[userModelTo valueForKey:@"company"];
            user1.comanyId=[[companyOb1 valueForKey:@"companyId"]intValue];
            
            user1.email=[userModelTo valueForKey:@"email"];
            user1.mobileNo=[userModelTo valueForKey:@"mobileNo"];
            user1.firstName=[userModelTo valueForKey:@"firstName"];
            user1.lastName=[userModelTo valueForKey:@"lastName"];
            user1.deviceToken=[userModelTo valueForKey:@"deviceToken"];
            
            //--------------------------userRole table data values-----------------------------------------------
            
            userRoll *userroll1=[[userRoll alloc]init];
            userroll1.role=[userRole1 valueForKey:@"id"];
            
            //--------------------------company table data values------------------------------------------------
            
            company1.Company_Name=[companyOb1 valueForKey:@"companyName"];
            company1.Company_Contact=[companyOb1 valueForKey:@"companyContact"];
            company1.Company_Address=[companyOb1 valueForKey:@"companyAddress"];
            company1.Company_Email=[companyOb1 valueForKey:@"companyEmail"];
            //company1.userId=[[companyOb1 valueForKey:@"userID"]intValue];
            
            //-------------------------userRole table data values-----------------------------------------------
            
            //user.username=[userRole valueForKey:@"role"];
            //user1.username=[userRole1 valueForKey:@"role"];
            
            //-------------------------operator table data values--------------------------------------------------
            
            Operator *operatorobj =[[Operator alloc]init];
            operatorobj.firstName=[operator valueForKey:@"firstName"];
            operatorobj.lastName=[operator valueForKey:@"lastName"];
            operatorobj.userName=[operator valueForKey:@"userName"];
            operatorobj.status=[operator valueForKey:@"status"];
            
            //------------------------status table data values-------------------------------------------
            
            Status *statusobj=[[Status alloc]init];
            statusobj.status=[status valueForKey:@"status"];
            
            //------------------------feedback_type table data values--------------------------------------------
            
            FeedbackType *feedbackTypeObj=[[FeedbackType alloc]init];
            feedbackTypeObj.feedbacktype=[feedBackType valueForKey:@"feedbackType"];
            
            
            NSString* counterUpdateQuery=[NSString stringWithFormat:@"SELECT distinct SO_Number FROM feedback Where feedBackType=%d and ((userFrom=%d and userTo=%d) or (userFrom=%d and userTo=%d)) ",feedback.feedbackType,feedback.userFrom,feedback.userTo,feedback.userTo,feedback.userFrom];
            
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
            {
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [counterUpdateQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                        NSString* soNumber= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                        [distinctSONumArray addObject:soNumber];
                        // NSLog(@"%@",userid);
                        
                    }
                }
                else
                {
                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            NSString* companyId;
            if (user.comanyId==1)
            {
                companyId=[NSString stringWithFormat:@"%d",user1.comanyId];
                
            }
            else
            {
                companyId=[NSString stringWithFormat:@"%d",user.comanyId];
                
                
            }

            
//            if (![distinctSONumArray containsObject:feedback.soNumber])
//            {
//                count++;
//                
//                if (user.comanyId==1)
//                {
//                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",user1.comanyId]];
//                    
//                }
//                else
//                {
//                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",user.comanyId]];
//                    
//                }
//                
//                [newSONumArray addObject:[NSString stringWithFormat:@"%d",feedback.feedbackType]];
//            }
            //        for (int c=0; c<distinctSONumArray.count; c++)
            //        {
            //            if (!([NSString stringWithFormat:@"%@",[distinctSONumArray objectAtIndex:c]]==feedback.soNumber))
            //            {
            //                if (user.comanyId==1)
            //                {
            //                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",user1.comanyId]];
            //
            //                }
            //                else
            //                {
            //                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",user.comanyId]];
            //
            //                }
            //
            //                    [newSONumArray addObject:[NSString stringWithFormat:@"%d",feedback.feedbackType]];
            //
            //
            //                count++;
            //            }
            //        }
            
            
            
            
            /// NSString* q2=[NSString stringWithFormat:@"Drop table userpermission"];
            //  NSString* q3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",NULL,fdate,feedbackText,soNumber,attachment];
            //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
            //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES company(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];
            
            /* Data insertion: feedback table */
            
            
            NSString *query1=[NSString stringWithFormat:@"INSERT INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject,readStatus) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\")",feedback.feedbackId,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject,1];
            
            const char * queryi1=[query1 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
//            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//            {
//            }
//            else
//            {
//                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
            
            
            
            NSString *chatingCounterQuery=[NSString stringWithFormat:@"INSERT OR REPLACE INTO feedbackchatingcounter values(\"%ld\",\"%ld\",\"%@\",\"%d\",\"%@\",\"%@\")",chatingCounterObj.feedbackCounter,chatingCounterObj.count,chatingCounterObj.soNumber,chatingCounterObj.feedbackType,chatingCounterObj.userFrom,chatingCounterObj.userTo];
            
            const char * chatingCounterQuery1=[chatingCounterQuery UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery1, -1, &chatingCounterStatement, NULL);
                if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(chatingCounterStatement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            
            
            NSString *statusIdUpdateQuery=[NSString stringWithFormat:@"Update feedback set statusId=%d Where Feedback_id=%d and SO_Number='%@'",feedback.statusId,feedback.feedbackType,feedback.soNumber];
            
            const char * statusIdUpdateQuery123=[statusIdUpdateQuery UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery123, -1, &statusIdStatement, NULL);
                if(sqlite3_step(statusIdStatement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statusIdStatement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statusIdStatement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            
            
            
            NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=%d,closedCounter=%d,totalCounter=%d Where feedbackTypeId=%d and CompanyId='%@'",[openCount intValue] ,[closeCount intValue],[totalCount intValue],feedback.feedbackType,companyId];
            
            const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
                if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(chatingCounterStatement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
            {
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
            }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            

        }
        
//        
//        if (count>0)
//        {
//            NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=(Select feedCounter from CompanyFeedTypeAndCounter Where CompanyId='%@' and feedbackTypeId=%d)+1 Where feedbackTypeId='%@' and CompanyId='%@'",[newSONumArray objectAtIndex:0] ,[[newSONumArray objectAtIndex:1] intValue],[newSONumArray objectAtIndex:1],[newSONumArray objectAtIndex:0]];
//            
//            const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
//            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//            {
//                sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
//                if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
//                {
//                    
//                    sqlite3_reset(chatingCounterStatement);
//                }
//                else
//                {
//                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//            }
//            else
//            {
//                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//            
//            if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
//            {
//                            }
//            else
//                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            
//            
//            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
//            {
//                           }
//            else
//            {
//                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//            
//            
//        }
//
     
        
    }
    
    if (companyIdMainForFeedbackDict.count==0)
    {
        NSString* currentFeedbackType= [[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"];
        int feedTypeId= [[Database shareddatabase] getFeedbackIdFromFeedbackType:currentFeedbackType];
        NSString* clientcompanyId= [[NSUserDefaults standardUserDefaults] valueForKey:@"clientCompanyId"];
        NSString *chatingCounterQuery12=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=%d,closedCounter=%d,totalCounter=%d Where feedbackTypeId=%d and CompanyId='%@'",[openCount intValue] ,[closeCount intValue],[totalCount intValue],feedTypeId,clientcompanyId];
        
        const char * chatingCounterQuery123=[chatingCounterQuery12 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, chatingCounterQuery123, -1, &chatingCounterStatement, NULL);
            if(sqlite3_step(chatingCounterStatement)==SQLITE_DONE)
            {
                
                sqlite3_reset(chatingCounterStatement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(chatingCounterStatement) == SQLITE_OK)
        {
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        

    }
   

      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_DATA_UPDATE object:nil];//load more data update
}



-(void)insertReportNotificationData:(NSDictionary *)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"response"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *singleReportDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:&error];
    
//    
//    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
//    {
//        NSLog(@"%@",companyIdKey);
//        
//        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
//        NSLog(@"%ld",arrayFromCompanyIdKey.count);
//        for (int i=0; i<arrayFromCompanyIdKey.count; i++)
//        {
           // NSDictionary* singleReportDict=[arrayFromCompanyIdKey objectAtIndex:i];
            
            Report* reportObj=[[Report alloc]init];
            
            reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
            reportObj.name=[singleReportDict valueForKey:@"name"];
            reportObj.date=[singleReportDict valueForKey:@"fileDate"];
           // NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
            reportObj.userFrom=[[singleReportDict valueForKey:@"userModelFrom"]intValue];
           // NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
            reportObj.userto=[[singleReportDict valueForKey:@"userModelTo"]intValue];
            reportObj.userfeedback=[[singleReportDict valueForKey:@"userfeedback"]intValue];
            //reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
            reportObj.description=[singleReportDict valueForKey:@"description"];
            reportObj.datetime=[singleReportDict valueForKey:@"dateTime"];
            
            NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO report values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
            
            Database *db=[Database shareddatabase];
            NSString *dbPath=[db getDatabasePath];
            sqlite3_stmt *statement;
            sqlite3* feedbackAndQueryTypesDB;
            
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
            if (sqlite3_finalize(statement) == SQLITE_OK)
            {
               
            }
            else
                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            
            
            if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
            {
                           }
            else
            {
                NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
            
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW object:nil];
  
    
            
//        }
//    }
}
-(void)insertDocumentNotificationData:(NSDictionary *)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"response"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *singleReportDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&error];
    
    //
    //    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
    //    {
    //        NSLog(@"%@",companyIdKey);
    //
    //        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
    //        NSLog(@"%ld",arrayFromCompanyIdKey.count);
    //        for (int i=0; i<arrayFromCompanyIdKey.count; i++)
    //        {
    // NSDictionary* singleReportDict=[arrayFromCompanyIdKey objectAtIndex:i];
    
    Report* reportObj=[[Report alloc]init];
    
    reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
    reportObj.name=[singleReportDict valueForKey:@"name"];
    reportObj.date=[singleReportDict valueForKey:@"fileDate"];
    // NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
    reportObj.userFrom=[[singleReportDict valueForKey:@"userModelFrom"]intValue];
    // NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
    reportObj.userto=[[singleReportDict valueForKey:@"userModelTo"]intValue];
    reportObj.userfeedback=[[singleReportDict valueForKey:@"userfeedback"]intValue];
    //reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
    reportObj.description=[singleReportDict valueForKey:@"description"];
    reportObj.datetime=[singleReportDict valueForKey:@"dateTime"];
    
    NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO document values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
            }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW object:nil];

    
    //        }
    //    }
}


-(void)insertMOMNotificationData:(NSDictionary *)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"response"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *singleMOMDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&error];
    
    //
    //    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
    //    {
    //        NSLog(@"%@",companyIdKey);
    //
    //        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
    //        NSLog(@"%ld",arrayFromCompanyIdKey.count);
    //        for (int i=0; i<arrayFromCompanyIdKey.count; i++)
    //        {
    // NSDictionary* singleReportDict=[arrayFromCompanyIdKey objectAtIndex:i];
    
    Mom* momObj=[[Mom alloc]init];
    momObj.Id= [[singleMOMDict valueForKey:@"id"]intValue];
    momObj.momDate= [singleMOMDict valueForKey:@"mom_date"];
    momObj.attendee= [singleMOMDict valueForKey:@"Attendee"];
    momObj.subject= [singleMOMDict valueForKey:@"Subject"];
    momObj.keyPoints= [singleMOMDict valueForKey:@"Keypoints"];
    
    momObj.userFrom= [[singleMOMDict valueForKey:@"userModelFrom"]intValue];
   // momObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
    
    momObj.userTo= [[singleMOMDict valueForKey:@"userModelTo"]intValue];
   // momObj.userTo= [[userToDict valueForKey:@"userId"]intValue];
    
    momObj.userfeedback= [[singleMOMDict valueForKey:@"userfeedback"]intValue];
    //momObj.userfeedback= [[userFeedback valueForKey:@"userId"]intValue];
    
    momObj.dateTime= [singleMOMDict valueForKey:@"mom_fill_date_time"];
    
    NSString* dateString=[NSString stringWithFormat:@"%@",momObj.dateTime];
    
    
    
    long mssince1970=[dateString doubleValue];
    momObj.dateTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:mssince1970/1000.0]];
    // feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:da]];
    //  feedback.dateOfFeed = [NSDate dateWithTimeIntervalSinceReferenceDate:da/1000];
    
    
    // NSString* dts=[[APIManager sharedManager] getDate];
    NSArray* dt= [momObj.dateTime componentsSeparatedByString:@" "];
    momObj.dateTime=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:DATE_TIME_FORMAT];
    NSDate* utcTime = [dateFormatter dateFromString:momObj.dateTime];
    NSLog(@"UTC time: %@", utcTime);
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:DATE_TIME_FORMAT];
    NSString* localTime = [dateFormatter stringFromDate:utcTime];
    NSLog(@"localTime:%@", localTime);
    
    momObj.dateTime=localTime;

    
   momObj.keyPoints= [momObj.keyPoints stringByEncodingHTMLEntities];
    NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO mom values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%d\")", momObj.Id,momObj.attendee,momObj.momDate,momObj.keyPoints,momObj.subject,momObj.userFrom,momObj.userTo,momObj.userfeedback,momObj.dateTime,1];
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
            }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_MOM_VIEW object:nil];
    //        }
    //    }
}

-(void)insertLoadMoreMOMNotificationData:(NSDictionary*)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"Mom"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *singleMOMArray = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
    
    //
    //    for (NSString* companyIdKey in [companyIdMainForMOMDict allKeys])
    //    {
    //        NSLog(@"%@",companyIdKey);
    //
    //        NSArray* arrayFromCompanyIdKey= [companyIdMainForMOMDict valueForKey:companyIdKey];
    //        NSLog(@"%ld",arrayFromCompanyIdKey.count);
    //        for (int i=0; i<arrayFromCompanyIdKey.count; i++)
    //        {
    // NSDictionary* singleReportDict=[arrayFromCompanyIdKey objectAtIndex:i];
    
    for (int i=0; i<singleMOMArray.count; i++)
    {
        
       NSDictionary* singleMOMDict= [singleMOMArray objectAtIndex:i];
        Mom* momObj=[[Mom alloc]init];
    momObj.Id= [[singleMOMDict valueForKey:@"id"]intValue];
    momObj.momDate= [singleMOMDict valueForKey:@"date"];
    momObj.attendee= [singleMOMDict valueForKey:@"attendee"];
    momObj.subject= [singleMOMDict valueForKey:@"subject"];
    momObj.keyPoints= [singleMOMDict valueForKey:@"keypoints"];
    
   NSDictionary* userFromDict= [singleMOMDict valueForKey:@"userModelFrom"];
     momObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
    
    NSDictionary* userToDict= [singleMOMDict valueForKey:@"userModelTo"];
    momObj.userTo= [[userToDict valueForKey:@"userId"]intValue];
    
    NSDictionary* userFeedback= [singleMOMDict valueForKey:@"userfeedback"];
    momObj.userfeedback= [[userFeedback valueForKey:@"userId"]intValue];
    
    momObj.dateTime= [singleMOMDict valueForKey:@"dateTime"];
        momObj.keyPoints= [momObj.keyPoints stringByEncodingHTMLEntities];
        NSString* dateString=[NSString stringWithFormat:@"%@",momObj.dateTime];
        
        
        
        long mssince1970=[dateString doubleValue];
        momObj.dateTime = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:mssince1970/1000.0]];
        // feedback.dateOfFeed = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:da]];
        //  feedback.dateOfFeed = [NSDate dateWithTimeIntervalSinceReferenceDate:da/1000];
        
        
        // NSString* dts=[[APIManager sharedManager] getDate];
        NSArray* dt= [momObj.dateTime componentsSeparatedByString:@" "];
        momObj.dateTime=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:DATE_TIME_FORMAT];
        NSDate* utcTime = [dateFormatter dateFromString:momObj.dateTime];
        NSLog(@"UTC time: %@", utcTime);
        
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:DATE_TIME_FORMAT];
        NSString* localTime = [dateFormatter stringFromDate:utcTime];
        NSLog(@"localTime:%@", localTime);

        
        momObj.dateTime=localTime;

        
    NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO mom values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%d\")", momObj.Id,momObj.attendee,momObj.momDate,momObj.keyPoints,momObj.subject,momObj.userFrom,momObj.userTo,momObj.userfeedback,momObj.dateTime,1];
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
           }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_MOM_VIEW object:nil];

  
}

-(void)insertLoadMoreReportNotificationData:(NSDictionary*)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"Reports"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *singleReportArray = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&error];
    for (int i=0; i<singleReportArray.count; i++)
    {
        
        NSDictionary* singleReportDict= [singleReportArray objectAtIndex:i];
    //
         Report* reportObj=[[Report alloc]init];
    
    reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
    reportObj.name=[singleReportDict valueForKey:@"name"];
    reportObj.date=[singleReportDict valueForKey:@"date"];
            
     NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
    reportObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
            
     NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
    reportObj.userto=[[userToDict valueForKey:@"userId"]intValue];
            
    NSDictionary* userFeedbackDict=[singleReportDict valueForKey:@"userfeedback"];
   reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
            
    reportObj.description=[singleReportDict valueForKey:@"description"];
    reportObj.datetime=[singleReportDict valueForKey:@"dateTime"];
    
    NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO report values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
           }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
        }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW object:nil];
    

}


-(void)insertLoadMoreDocumentNotificationData:(NSDictionary*)notificationData
{
    NSError* error;
    NSString*  companyIdMainDictForMOMString= [notificationData valueForKey:@"Documents"];
    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *singleReportArray = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    for (int i=0; i<singleReportArray.count; i++)
    {
        
        NSDictionary* singleReportDict= [singleReportArray objectAtIndex:i];
        //
        
        
        Report* reportObj=[[Report alloc]init];
        
        reportObj.Id=[[singleReportDict valueForKey:@"id"]intValue];
        reportObj.name=[singleReportDict valueForKey:@"name"];
        reportObj.date=[singleReportDict valueForKey:@"date"];
        
        NSDictionary* userFromDict=[singleReportDict valueForKey:@"userModelFrom"];
        reportObj.userFrom=[[userFromDict valueForKey:@"userId"]intValue];
        
        NSDictionary* userToDict=[singleReportDict valueForKey:@"userModelTo"];
        reportObj.userto=[[userToDict valueForKey:@"userId"]intValue];
        
        NSDictionary* userFeedbackDict=[singleReportDict valueForKey:@"userfeedback"];
        reportObj.userfeedback=[[userFeedbackDict valueForKey:@"userId"]intValue];
        
        reportObj.description=[singleReportDict valueForKey:@"description"];
        reportObj.datetime=[singleReportDict valueForKey:@"dateTime"];
        
        NSString *query3=[NSString stringWithFormat:@"INSERT OR REPLACE INTO document values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", reportObj.Id,reportObj.date,reportObj.datetime,reportObj.description,reportObj.name,reportObj.userFrom,reportObj.userto,reportObj.userfeedback];
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement;
        sqlite3* feedbackAndQueryTypesDB;
        
        
        const char * queryi3=[query3 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                
                sqlite3_reset(statement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
           
        }
        else
            NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
           
        }
        else
        {
            NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW object:nil];
    
    
}


-(NSString*)getAdminUserId
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement3;
    sqlite3* feedbackAndQueryTypesDB;
    NSString *userId;
    NSString * query = @"SELECT ID FROM user Where USER_ROLL=1 and CompanyId=1";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement3, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement3) == SQLITE_ROW)
            {
                const char * feedTextMsg = (const char*)sqlite3_column_text(statement3, 0);
                userId=[NSString stringWithFormat:@"%s",feedTextMsg];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    if (sqlite3_finalize(statement3) == SQLITE_OK)
    {
            }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    return userId;
    
    
    
}

-(void)updateMom:(int)momId
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statusIdStatement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString *userId;
    NSString *statusIdUpdateQuery=[NSString stringWithFormat:@"Update mom set readStatus=0 Where id=%d",momId];
    
    const char * statusIdUpdateQuery123=[statusIdUpdateQuery UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, statusIdUpdateQuery123, -1, &statusIdStatement, NULL);
        if(sqlite3_step(statusIdStatement)==SQLITE_DONE)
        {
            
            sqlite3_reset(statusIdStatement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statusIdStatement) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPADTE_MOM_VIEW object:nil];
}

-(NSString*)getFirstnameLastnameFromUserId:(int)userID;

{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement3;
    sqlite3* feedbackAndQueryTypesDB;
    NSString *firstName,*lastName;
    NSString * query = [NSString stringWithFormat:@"SELECT First_NAME,LastName FROM user Where ID=%d",userID];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement3, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement3) == SQLITE_ROW)
            {
                const char * feedTextMsg = (const char*)sqlite3_column_text(statement3, 0);
                firstName=[NSString stringWithFormat:@"%s",feedTextMsg];
                
                const char * feedTextMsg1 = (const char*)sqlite3_column_text(statement3, 1);
                lastName=[NSString stringWithFormat:@"%s",feedTextMsg1];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    if (sqlite3_finalize(statement3) == SQLITE_OK)
    {
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    NSString* name=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    return name ;
    

}
@end
