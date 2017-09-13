//
//  CLLoggerConstants.h
//  Codelynks Logger Framework
//
//  Created by Timmi on 3/18/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

// Current logger version
#define CLLOG_CURRENT_LOGGER_VERSION       @"1.0"

// Modes can be OR'd together
#define CLLOG_MODE_FILE		0x0001
#define CLLOG_MODE_CONSOLE		0x0002
#define CLLOG_MODE_REMOTE		0x0004

// Modes names
#define CLLOG_MODENAME_FILE		"file"
#define CLLOG_MODENAME_CONSOLE		"console"
#define CLLOG_MODENAME_REMOTE		"remote"

// Activity message classes
#define CLLOG_MSG_CRITICAL			1
#define CLLOG_MSG_ERROR			2
#define CLLOG_MSG_WARNING			3
#define CLLOG_MSG_INFO				4
#define CLLOG_MSG_DETAIL			5

// Diagnostic message classes
#define CLLOG_LVL_NOTHING      0
#define CLLOG_LVL_CRITICAL		CLLOG_MSG_CRITICAL
#define CLLOG_LVL_ERROR		CLLOG_MSG_ERROR
#define CLLOG_LVL_WARNING		CLLOG_MSG_WARNING
#define CLLOG_LVL_INFO			CLLOG_MSG_INFO
#define CLLOG_LVL_DETAIL		CLLOG_MSG_DETAIL
#define CLLOG_LVL_DEBUG1		6
#define CLLOG_LVL_DEBUG2		(CLLOG_LVL_DEBUG1 + 1)
#define CLLOG_LVL_DEBUG3		(CLLOG_LVL_DEBUG1 + 2)
#define CLLOG_LVL_DEBUG4		(CLLOG_LVL_DEBUG1 + 3)
#define CLLOG_LVL_DEBUG5		(CLLOG_LVL_DEBUG1 + 4)
#define CLLOG_LVL_DEBUG6		(CLLOG_LVL_DEBUG1 + 5)
#define CLLOG_LVL_DEBUG7		(CLLOG_LVL_DEBUG1 + 6)
#define CLLOG_LVL_DEBUG8		(CLLOG_LVL_DEBUG1 + 7)
#define CLLOG_LVL_DEBUG9		(CLLOG_LVL_DEBUG1 + 8)
#define CLLOG_LVL_DEBUG10		(CLLOG_LVL_DEBUG1 + 9)

// Default values Max levels of logs to show in a debug or release build
#define CLLOG_DEFAULT_MAX_LVL_DEBUG_BUILD      CLLOG_LVL_DEBUG3
#define CLLOG_DEFAULT_MAX_LVL_RELEASE_BUILD    CLLOG_LVL_INFO
#define CLLOG_DEFAULT_MODE_DEBUG_BUILD         CLLOG_MODE_FILE | CLLOG_MODE_CONSOLE
#define CLLOG_DEFAULT_MODE_RELEASE_BUILD       CLLOG_MODE_FILE | CLLOG_MODE_CONSOLE

// Tag names for important message classes
#define CLLOG_MSG_TAG_CRITICAL     @"CRITICAL"
#define CLLOG_MSG_TAG_ERROR        @"ERROR"
#define CLLOG_MSG_TAG_WARN         @"WARNING"
#define CLLOG_MSG_TAG_INFO         @"INFO"
#define CLLOG_MSG_TAG_DETAIL       @"DETAIL"
#define CLLOG_MSG_TAG_DEBUG1       @"DEBUG1"
#define CLLOG_MSG_TAG_DEBUG2       @"DEBUG2"
#define CLLOG_MSG_TAG_DEBUG3       @"DEBUG3"
#define CLLOG_MSG_TAG_DEBUG4       @"DEBUG4"
#define CLLOG_MSG_TAG_DEBUG5       @"DEBUG5"
#define CLLOG_MSG_TAG_DEBUG6       @"DEBUG6"
#define CLLOG_MSG_TAG_DEBUG7       @"DEBUG7"
#define CLLOG_MSG_TAG_DEBUG8       @"DEBUG8"
#define CLLOG_MSG_TAG_DEBUG9       @"DEBUG9"
#define CLLOG_MSG_TAG_DEBUG10      @"DEBUG10"

// Log message categories
#define CLLOG_LOG_TYPE_ACTIVITY            1
#define CLLOG_LOG_TYPE_DIAGNOSTIC          2
#define CLLOG_LOG_TYPE_SECURE              3
#define CLLOG_LOG_TYPE_PERFORMANCE         4

// Logger types
#define CLLOG_LOGGER_TYPE_NONE             0
#define CLLOG_LOGGER_TYPE_DIAGNOSTIC       1
#define CLLOG_LOGGER_TYPE_PERFORMANCE      2

// Timestamp formats
#define CLLOG_FILENAME_TIMESTAMP_FORMAT    @"yyyy-MM-dd-HH-mm-ssZ" //2013-07-24-18-32+0530
// Timestamp in ISO 8601 format
#define CLLOG_LOG_TIMESTAMP_FORMAT         @"yyyy-MM-dd'T'HH:mm:ss.SSSZ" //2013-11-04T11:55:33.369+0530

// Default values
#define CLLOG_ROOT_LOGS_FOLDER_NAME           @"CodelynksLogs"
#define CLLOG_COMPRESSED_ZIP_NAME             @"CodelynksLogs.zip"
#define CLLOG_ROOT_LOGS_FOLDER_PATH_C         "/Documents/CodelynksLogs"
#define CLLOG_COMPRESSED_ZIP_PATH_C           "/Documents/CodelynksLogs.zip"
#define CLLOG_FILE_PREFIX                     "Log_"

#define CLLOG_DEFAULT_LOGGER_NAME             @"DefaultLogger"
#define CLLOG_DEFAULT_APP_NAME                @"DefaultApp"
#define CLLOG_DEFAULT_MAX_LOG_FILE_SIZE       2 // in MB
#define CLLOG_DEFAULT_MAX_LOG_FILE_COUNT      5
#define CLLOG_ALLOWED_MAX_LOG_FILE_SIZE       5 // in MB
#define CLLOG_ALLOWED_MAX_LOG_FILE_COUNT      8

#define CLLOG_DIAGNSOTIC_LOGGER               @"Logs"
#define CLLOG_PERFORMANCE_LOGGER              @"Performance"

// Constants used with performance logging related macros and methods
#define CLLOG_PERF_ARGS_PREFIX                @"clPerfArgs:"
#define CLLOG_PERF_ARGS_SEPERATOR             @":"

#define CLLOG_PERF_EVENT_TYPE_START           0
#define CLLOG_PERF_EVENT_TYPE_STOP            1
#define CLLOG_PERF_EVENT_TYPE_TIMESTAMP       2

#define CLLOG_PERF_EVENT_NAME_START           @"Start"
#define CLLOG_PERF_EVENT_NAME_STOP            @"Stop"
#define CLLOG_PERF_EVENT_NAME_TIMESTAMP       @"Timestamp"

// Constants used for archiving and unarchiving
#define CLLOG_COMPRESSED_FOLDER_PATH         @"clCompressedLogFolderPath"
#define CLLOG_COMPRESSED_FOLDER_MIMETYPE     @"clCompressedLogFolderMimeType"
#define CLLOG_COMPRESSED_FOLDER_NAME         @"clCompressedLogFolderName"

// Constants for indicating the CLLogger errors
#define CLLOG_ERROR_DOMAIN                   @"CLLoggerErrorDomain"

typedef enum
{
    CLLoggerErrorUnknown = 100,
    CLLoggerErrorInvalidDataType,
    CLLoggerErrorFileNameNotFound,
    CLLoggerErrorInputDataNotFound
} CLLoggerError;

