// Gaurav Sheni
// CSC 391 
// September 16, 2015
// Project 1


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//declaring kernel call
__global__ void decrement(char* line, char* answer);

__global__ void decrement(char *current, char* answer){
	int i = threadIdx.x;
	answer[i] = (char)( (int) current[i] - 1 );
}

int main ( int argc, char *argv[] )
{
	//check to make sure that there is only two command line arguments
	if (argc != 2){
		printf ("Incorrect number of command line arugments.\r\n");
		//exit with 1 because exit(1) indicates that there were an error
		exit(1);
	}

	//open the file to be read, give the first, argument
	//"r" is for read
	FILE *file = fopen(argv[1], "r"); 

	//line keeps the input data, inialize to null. 
	char* line = NULL;
	//for determining how many characters are in the input data
	int lengthOfFile;

	//make sure the file exists and is valid
	if ( file != NULL ){

		//first go to the end of the file and find out how many characters were counted
		fseek(file, 0, SEEK_END);
		//store number of charactes found.
		lengthOfFile = ftell(file);

		//allocate a character arry based on how many characters were found
		//we need to + 1 because we need room for the null terminator character
		line = (char *) malloc(lengthOfFile* sizeof(char) + 1 ) ;

		//go back to the beginning of the input file
		fseek (file , 0 , SEEK_SET);

		//
		char current_line[lengthOfFile+1];
		while (fgets(current_line, sizeof(current_line), file)) {
	        line = current_line;
	    }
		fclose ( file );
	}
	//error message if file does not exist. 
	else{
		printf ("File could not be opened.\r\n");
		printf ("File may not exist or the command line arugment is incorrectly named.\r\n");
		//exit with 1 because exit(1) indicates that there were an error
		exit(1);
   }
   	// printf ("Character Count = %d.\r\n", lengthOfFile);
   	char answer[lengthOfFile];

	char *dev_line;
	char *dev_answer;

	int size = lengthOfFile * sizeof(char);

	cudaMalloc((void**)&dev_line, size);
	cudaMalloc((void**)&dev_answer, size);

	cudaMemcpy(dev_line, line, size, cudaMemcpyHostToDevice);

	decrement<<< 1, lengthOfFile >>>(dev_line, dev_answer);

	cudaThreadSynchronize();

	cudaMemcpy(answer, dev_answer, size, cudaMemcpyDeviceToHost);
	
    cudaFree(dev_line);
    cudaFree(dev_answer);

	printf("Decoded --- Message is: \r\n%s",answer);

	exit (0);
}





