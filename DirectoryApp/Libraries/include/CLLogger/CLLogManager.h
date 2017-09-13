//
//  CLLogManager.h
//  Codelynks Logger Framework
//
//  Created by Timmi on 3/18/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLogManager;

// Method called by Wrapper to get the logger instance
CLLogManager * CLWrapperGetLoggerInstance();

// C-style interface for logging methods
// All the logging related macros will resolve to either of these methods,
// depending on whether message is in C-style or in Objective-C style

void CLLOG_logMessage(NSString * source,
                       int msgclass,
                       int logType,
                       const char * file,
                       const char * func,
                       int line,
                       NSString * fmt, ...) NS_FORMAT_FUNCTION(7, 8);
void CLLOG_logMessageWithArgList(NSString * source,
                                  int level,
                                  int logType,
                                  const char * file,
                                  const char * func,
                                  int line,
                                  NSString * fmt, va_list args);

void CLLOG_logMessage_C(const char * source,
                         int msgclass,
                         int logType,
                         const char * file,
                         const char * func,
                         int line,
                         const char * fmt, ...) __printflike(7, 8);

// Setters for logger parameters
void CLLOG_setLogLevel(int level);
void CLLOG_setMode(int mode);
void CLLOG_setMaxLogFileSizeInMB(int size);
void CLLOG_setMaxLogFileCount(int count);

// setter to enable/disable diagnostic logger.
void CLLOG_setDiagEnabled(BOOL flag);

// Getters for logger parameters
int CLLOG_getLogLevel();
int CLLOG_getMode();
int CLLOG_getMaxLogFileSizeInMB();
int CLLOG_getMaxLogFileCount();
BOOL CLLOG_isLogEnabled();

// API for compressing the logs folder
// This method compresses contents of /Documents/CodelynksLogs
NSDictionary * CLLOG_compressLogs();

// API for deleting the logs folder.
// This method deletes contents of /Documents/CodelynksLogs
BOOL CLLOG_cleanLogs();

// This method returns the current version of LoggerSDK
NSString * CLLOG_currentLoggerVersion();

// Methods for performance related logging
void CLPerfLoggerInitializeWithLevel(int level);

void CLLOG_logPerfEventWithMsg(NSString * module,
                                int level,
                                NSString * eventName,
                                int eventType,
                                long long eventContext,
                                const char * file,
                                const char * function,
                                int line,
                                NSString * fmt, ...) NS_FORMAT_FUNCTION(9, 10);

void CLLOG_logPerfEventWithMsg_C(const char * module,
                                  int level,
                                  const char * eventName,
                                  int eventType,
                                  long long eventContext,
                                  const char * file,
                                  const char * function,
                                  int line,
                                  const char * fmt, ...) __printflike(9, 10);

void CLLOG_logPerfEvent(NSString * module,
                         int level,
                         NSString * eventName,
                         int eventType,
                         long long context,
                         const char * file,
                         const char * function,
                         int line);

void CLLOG_logPerfEvent_C(const char * module,
                           int level,
                           const char * eventName,
                           int eventType,
                           long long context,
                           const char * file,
                           const char * function,
                           int line);


@interface CLLogManager : NSObject

@property (nonatomic, assign) int loggingMode;
@property (nonatomic, assign) int logLevel;
@property (nonatomic, assign) int maxLogFileSizeInMB;
@property (nonatomic, assign) int maxLogFileCount;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

+ (void) CLLoggerInitialize;
+ (CLLogManager *) sharedInstance;
+ (NSString *) logsDirectory;
+ (NSString *) diagnosticsLogsDirectory;
+ (NSString *)compressedLogFilePath;

+(int) defaultLogLevel;
+(int) defaultLogMode;
+(NSString*) defaultLogTargetString;

// This method returns int equivalent for target
// Ex: If input is "file", return value is CLLOG_MODE_FILE
+ (int) logTargetFromString: (NSString *) target;
+ (NSString*) logTargetStringFromMode:(int)mode;

/** 
 * This method is used to write configuration information to Support bundle.
 *
 * Location of support bundle is /Documents/CodelynksLogs/.
 *
 * @param configInfo  Configuration information. This can be any information which will be helpful for debugging.
 * Valid formats are NSString, NSData, NSDictionary and NSArray. This parameter can not be nil.
 * Ex: VPN configuration, ActiveSync policies.
 * 
 * @param fileName    Name to be assigned for the configuration file. File extension needs to be specified.
 * This parameter can not be nil. The string will be prefixed with "CLLog_" string to avoid file encryption by MDX wrapper.
 * Ex: If file name indicated is "GenericInfo.txt", actual file created in Support bundle will
 * have name "CLLog_GenericInfo.txt"
 *
 * @param error      If there is an error, upon return contains an NSError object that describes the problem.
 * If you are not interested in details of errors, you may pass in NULL.
 *
 * @return           YES if the file is written successfully, otherwise NO.
 */
+ (BOOL) writeConfigInfoToSupportBundle:(id) configInfo
                           withFileName:(NSString *) fileName
                                  error:(NSError **) error;

/**
 * This method is used to delete an existing configuration file from Support bundle.
 *
 * Location of support bundle is /Documents/CodelynksLogs/.
 *
 * @param fileName    Name of the configuration file which needs to be deleted. File extension needs to be specified.
 * This string will be prefixed with "CLLog_" string for forming the actual file name for deletion. 
 * Ex: If file name indicated is "GenericInfo.txt", actual file checked for deletion in Support bundle will
 * have name "CLLog_GenericInfo.txt"
 *
 * @param error      If there is an error, upon return contains an NSError object that describes the problem.
 * If you are not interested in details of errors, you may pass in NULL.
 *
 * @return           YES if the file is deleted successfully, otherwise NO.
 */
+ (BOOL) removeConfigFileFromSupportBundleWithName:(NSString *) fileName
                                             error:(NSError **) error;

/**
 * This method compresses the Support bundle.
 * Location of support bundle is /Documents/CodelynksLogs/
 * @return Returns a dictionary with following keys:
 * CLLOG_COMPRESSED_FOLDER_PATH: Path to compressed logs folder.
 * CLLOG_COMPRESSED_FOLDER_MIMETYPE: Mime type of the zip. This is always "application/zip"
 * CLLOG_COMPRESSED_FOLDER_NAME: Name of compressed file.
 */
+ (NSDictionary *)createZippedLogFiles;

/**
 * This method adds a new key:value pair to AppInfo.txt file present in Support bundle.
 * Location of support bundle is /Documents/CodelynksLogs/.
 * @param value The string to store in the Support bundle.
 * @param key The key with which to associate with the value.
 * @return YES if addition of new key-value pair was successful, otherwise NO
 */
+ (BOOL) addStringToSupportBundle:(NSString *)value withKey:(NSString *) key;

/**
 * This method appends the contents of input dictionary to AppInfo.txt file present in Support bundle.
 * Location of support bundle is /Documents/CodelynksLogs/.
 * @param dictionary Dictionary to be written to AppInfo.txt. 
 
 * Input dictionary can have only property list objects: NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary. For NSArray and NSDictionary objects, their contents must be property list objects.
 * @return YES if addition of new dictionary was successful, otherwise NO
 */
+ (BOOL) addDictionaryToSupportBundle: (NSDictionary *) dictionary;

/**
 * This method appends the contents of input dictionary to AppInfo.txt file present in Support bundle.
 * Location of support bundle is /Documents/CodelynksLogs/.
 * @param dict Dictionary to be written to AppInfo.txt.
 * @param clearExistingEntries If YES, existing entries in AppInfo.txt which were added using this method will be deleted.
 * Input dictionary can have only property list objects: NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary. For NSArray and NSDictionary objects, their contents must be property list objects.
 * @return YES if addition of new dictionary was successful, otherwise NO
 */
+ (BOOL)addDictionaryToSupportBundle:(NSDictionary *)dict
                clearExistingEntries:(BOOL)clearExistingEntries;

- (id)initWithLoggerName:(NSString *) loggerName
                 appName:(NSString *) appNameOrNil
                logLevel:(int) level
                    mode:(int) mode
                 enabled:(BOOL) enabled
      maxLogFileSizeInMB:(int) maxLogFileSize
         maxLogFileCount:(int) maxLogFileCount;

- (void) logMessageFromModule: (NSString *) module
                 withLogLevel: (int) level
                         file: (const char *) file
                     function: (const char *) function
                         line: (int) line
                       format: (NSString *) format, ... NS_FORMAT_FUNCTION(6, 7);

- (void) logMessageFromModule: (NSString *) module
                 withLogLevel: (int) level
                         file: (const char *) file
                     function: (const char *) function
                         line: (int) line
                       format: (NSString *) format
                         args: (va_list)args;
- (void) rollCurrentLogFile;
@end

