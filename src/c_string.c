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


StringList* cstring_split(StringList* result, String* s, const char separator) {
	if (s == NULL) {
		fprintf(stderr, "Must provide a string to split.\n");
		exit(1);
	}

	char* copiedString = strdup(s->text);
	
	char* separatorString = malloc(sizeof(char) * 2);
	if (separatorString == NULL) {
		fprintf(stderr, "Couldn't allocate memory for the separator string.\n");	
		exit(1);
	}
	separatorString[0] = separator;
	separatorString[1] = '\0';

	char* savedPtr;
	char* token = strtok_r(copiedString, separatorString, &savedPtr);

	uint32_t elementCount = 0;
	result = malloc(sizeof(StringList));
	if (result == NULL) {
		fprintf(stderr, "Couldn't allocate memory for the result pointer.\n");
		exit(1);
	}

	while (token != NULL) {
		elementCount++;
		result->strings = realloc(result->strings, sizeof(String*) * elementCount);
		if (result->strings == NULL) {
			fprintf(stderr, "Couldn't allocate memory for result strings.\n");
			exit(1);
		}

		uint32_t index = elementCount - 1;
		*(result->strings + index) = cstring_create(result->strings + index, token);

		token = strtok_r(NULL, separatorString, &savedPtr);
	}

	result->length = elementCount;

	free(separatorString);
	free(copiedString);

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
