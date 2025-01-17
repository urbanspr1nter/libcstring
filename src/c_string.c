#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c_string.h"

String* cstring_create(String* result, const char* s) {
	uint32_t len = strlen(s);

	result = malloc(sizeof(String));	
	result->text = strdup(s);
	result->length = len;
	result->isValid = true;

	return result;	
}

String* cstring_concat(String* result, uint32_t count, ...) {
	uint32_t currLength = 0;

	result = malloc(sizeof(String));
	result->text = malloc(sizeof(char) * 1);
	*(result->text) = '\0';

	va_list args;
	va_start(args, count);

	for (uint32_t i = 0; i < count; i++) {
		String* curr = va_arg(args, String*);

		// Add an extra character to realloc an additional character 
		// if it is the last string just enough for the null terminating byte.
		currLength += (curr->length + (i == count - 1 ? 1 : 0));

		result->text = realloc(result->text, sizeof(char) * currLength);		
		result->text = strncat(result->text, curr->text, curr->length);
	}

	va_end(args);

	result->length = strlen(result->text);	
	result->isValid = true;

	return result;
}

void cstring_free(String* s) {
	if (s->text != NULL) {
		free(s->text);
		s->text = NULL;
	}

	s->length = 0;
	s->isValid = false;

	free(s);
}

bool cstring_equals(String* s, String* t) {
	if (s->length != t->length) {
		return false;
	}

	return strcmp(s->text, t->text) == 0;
}
