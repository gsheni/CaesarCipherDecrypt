#include <stdio.h>
#include <string.h>
#include <stdlib.h>

__global__ void convert2nums(char* line, char answer[]);

__global__ void convert2nums(char* line, char answer[]){
	int i;
	int current;
	char character;

	for( i = 0; line[i] != '\0'; i++) {
		current = (int) line[i];
		character = (char) (current -1);
		answer[i] = character;
	}
}

int main ( int argc, char *argv[] )
{
		if (argc != 2){
		printf ("Incorrect number of command line arugments.\r\n");
		exit(0);
	}

	FILE *file = fopen(argv[1], "r"); // "r" for read

	char* line = NULL;
	int lengthOfFile;

	if ( file != NULL ){

		fseek(file, 0, SEEK_END);
		lengthOfFile = ftell(file);

		line = (char *) malloc(lengthOfFile* sizeof(char) + 1 ) ;

		fseek (file , 0 , SEEK_SET);

		char current_line[lengthOfFile+1];
		while (fgets(current_line, sizeof(current_line), file)) {
	        line = current_line;
	    }
		fclose ( file );
	}
	else{
		printf ("File could not be opened.\r\n");
		printf ("File may not exist or incorrectly named.\r\n");
   }

   	char answer[lengthOfFile];

	char *dev_line;
	char *dev_answer;

	int size = lengthOfFile * sizeof(char);

	cudaMalloc((void**)&dev_line, size);
	cudaMalloc((void**)&dev_answer, size);

	cudaMemcpy(dev_line, line, size, cudaMemcpyHostToDevice);

	convert2nums<<<1, 1>>>(dev_line,dev_answer);

	cudaThreadSynchronize();

	cudaMemcpy(answer, dev_answer, size, cudaMemcpyDeviceToHost);
	
    cudaFree(dev_answer);

	printf("Decoded Message is: \r\n%s",answer);

	exit (0);
}





