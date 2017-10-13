
#ifndef LogTool_h
#define LogTool_h

#ifndef __OPTIMIZE__
#define NSLog(format,...) customPrintf(format,##__VA_ARGS__)
#else
#define NSLog(format,...) {}
#endif

#define customPrintf(format,...) { \
const char *fileName = [NSString stringWithUTF8String:__FILE__].lastPathComponent.UTF8String;\
const char *content = [[NSString stringWithFormat:format,##__VA_ARGS__]UTF8String];\
printf("[ FILENAME:%25s  LINE:%4d ] -> %s \n",fileName,__LINE__,content);\
}

#endif /* LogTool_h */
