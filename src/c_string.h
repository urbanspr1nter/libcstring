#ifndef LIB_C_STRING_H
#define LIB_C_STRING_H

#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>

extern struct String {
	char* text;
	uint32_t length;
	bool isValid;
};

typedef struct String String;

String* cstring_create(String* result, const char* s);
String* cstring_concat(String* result, uint32_t count, ...);
void cstring_free(String* s);
bool cstring_equals(String* s, String* t);


#endif
