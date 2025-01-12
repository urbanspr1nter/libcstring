#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c_string.h"

String* cstring_create(String* result, char* s) {
	uint32_t len = strlen(s);
	
	result->text = strdup(s);
	result->length = len;

	return result;	
}

void cstring_free(String* s) {
	if (s->text != NULL) {
		free(s->text);
		s->text = NULL;
	}

	s->length = 0;

	free(s);
}

bool cstring_equals(String* s, String* t) {
	if (s->length != t->length) {
		return false;
	}

	return strcmp(s->text, t->text) == 0;
}
