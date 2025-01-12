#ifndef LIB_C_STRING_H
#define LIB_C_STRING_H

#include <stdbool.h>
#include <stdint.h>

typedef struct String {
	char* text;
	uint32_t length;
} String;

String* cstring_create(String* result, char* s);
void cstring_free(String* s);
bool cstring_equals(String* s, String* t);


#endif
