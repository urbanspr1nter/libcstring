#ifndef LIB_C_STRING_H
#define LIB_C_STRING_H

#include <stdbool.h>
#include <stdint.h>

extern struct String {
	char* text;
	uint32_t length;
};

typedef struct String String;

String* cstring_create(String* result, const char* s);
void cstring_free(String* s);
bool cstring_equals(String* s, String* t);


#endif
