//
//  DBMachine.m
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBMachine.h"
#import "DBError.h"

@implementation DBMachine

- (void)dealloc
{
    sqlite3_close(_db);
}

- (id)initWithFile:(NSString *)filePath
{
    if (self = [super init])
    {
        if (filePath)
        {
            _filePath = [filePath copy];
        }
    }
    
    return self;
}

- (BOOL)startWithError:(NSError *__autoreleasing *)error
{
    int code = sqlite3_open([_filePath UTF8String], &_db);
    
    BOOL success = (code == SQLITE_OK);
    
    if (!success)
    {
        *error = [NSError DBErrorWithDB:_db];
    }
    
    return success;
}

- (BOOL)executeSQL:(NSString *)sql error:(NSError *__autoreleasing *)error
{
    char *errorMsg;
    
    int code = sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &errorMsg);
    
    BOOL success = (code == SQLITE_OK);
    
    if (!success)
    {
        *error = [NSError DBErrorWithCode:code message:errorMsg ? [NSString stringWithUTF8String:errorMsg] : nil];
    }
    
    sqlite3_free(errorMsg);
    
    return success;
}

- (sqlite3_stmt *)preparedStatementForSQL:(NSString *)sql error:(NSError *__autoreleasing *)error
{
    sqlite3_stmt *statement = NULL;
    
    int code = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL);
    
    if (code != SQLITE_OK)
    {
        *error = [NSError DBErrorWithDB:_db];
        
        sqlite3_finalize(statement);
        
        statement = NULL;
    }
    
    return statement;
}

- (void)bindValue:(id)value byType:(DBValueType)type toPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location error:(NSError *__autoreleasing *)error
{
    if (value && statement)
    {
        int code = SQLITE_OK;
        
        switch (type)
        {
            case DBValueType_Int:
            case DBValueType_LongLong:
                code = sqlite3_bind_int64(statement, location, [(NSNumber *)value longLongValue]);
                break;
            case DBValueType_Double:
                code = sqlite3_bind_double(statement, location, [(NSNumber *)value doubleValue]);
                break;
            case DBValueType_Text:
                code = sqlite3_bind_text(statement, location, [(NSString *)value UTF8String], -1, SQLITE_STATIC);
                break;
            case DBValueType_Blob:
                code = sqlite3_bind_blob(statement, location, [(NSData *)value bytes], (int)[(NSData *)value length], SQLITE_STATIC);
                break;
            case DBValueType_NULL:
                code = sqlite3_bind_null(statement, location);
            default:
                break;
        }
        
        if (code != SQLITE_OK)
        {
            *error = [NSError DBErrorWithDB:_db];
        }
    }
}

- (id)columnValueFromPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location inType:(DBValueType)type
{
    id value = nil;
    
    switch (type)
    {
        case DBValueType_Int:
            value = [NSNumber numberWithLongLong:sqlite3_column_int64(statement, location)];
            break;
        case DBValueType_LongLong:
            value = [NSNumber numberWithLongLong:sqlite3_column_int64(statement, location)];
            break;
        case DBValueType_Double:
            value = [NSNumber numberWithDouble:sqlite3_column_double(statement, location)];
            break;
        case DBValueType_Text:
        {
            const unsigned char *text = sqlite3_column_text(statement, location);
            if (text)
            {
                value = [NSString stringWithUTF8String:(char *)text];
            }
        }
            break;
        case DBValueType_Blob:
            value = [NSData dataWithBytes:sqlite3_column_blob(statement, location) length:sqlite3_column_bytes(statement, location)];
            break;
        default:
            break;
    }
    
    return value;
}

- (NSString *)columnNameOfPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location
{
    return [NSString stringWithUTF8String:sqlite3_column_name(statement, location)];
}

- (int)columnDataCountOfPreparedStatement:(sqlite3_stmt *)statement
{
    return sqlite3_data_count(statement);
}

- (int)stepStatement:(sqlite3_stmt *)statement error:(NSError *__autoreleasing *)error
{
    int code = sqlite3_step(statement);
    
    if (code != SQLITE_OK && code != SQLITE_DONE)
    {
        *error = [NSError DBErrorWithDB:_db];
    }
    
    return code;
}

- (void)resetStatement:(sqlite3_stmt *)statement error:(NSError *__autoreleasing *)error
{
    int code = sqlite3_reset(statement);
    
    if (code != SQLITE_OK)
    {
        *error = [NSError DBErrorWithDB:_db];
    }
}

- (void)finalizeStatement:(sqlite3_stmt *)statement error:(NSError *__autoreleasing *)error
{
    int code = sqlite3_finalize(statement);
    
    if (code != SQLITE_OK)
    {
        *error = [NSError DBErrorWithDB:_db];
    }
}

- (BOOL)commitTransactionBlock:(void (^)(void))block error:(NSError *__autoreleasing *)error
{
    BOOL success = YES;
    
    if ([self executeSQL:@"begin transaction;" error:error])
    {
        block();
        
        if (![self executeSQL:@"commit transaction;" error:error])
        {
            success = NO;
            
            [self executeSQL:@"rollback transaction" error:error];
        }
    }
    else
    {
        success = NO;
    }
    
    return success;
}

@end
