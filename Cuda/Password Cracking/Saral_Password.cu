#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
  This program gives an example of a poor way to implement a password cracker
  in CUDA C. It is poor because it acheives this with just one thread, which
  is obviously not good given the scale of parallelism available to CUDA
  programs.
  
  The intentions of this program are:
    1) Demonstrate the use of __device__ and __global__ functions
    2) Enable a simulation of password cracking in the absence of library 
       with equivalent functionality to libcrypt. The password to be found
       is hardcoded into a function called is_a_match.   

  Compile and run with:
    nvcc -o Saral_Password Saral_Password.cu
    ./Saral_Password
   
  Dr Kevan Buckley, University of Wolverhampton, 2018
*****************************************************************************/

/****************************************************************************
  This function returns 1 if the attempt at cracking the password is 
  identical to the plain text password string stored in the program. 
  Otherwise,it returns 0.
*****************************************************************************/

__device__ int is_a_match(char *attempt) {
	char mypassword1[] = "SA9780";
	char mypassword2[] = "AS3145";
	char mypassword3[] = "EE4652";
	char mypassword4[] = "BB2565";


	char *p = attempt;
	char *r = attempt;
	char *a = attempt;
	char *t = attempt;
	char *p1 = mypassword1;
	char *p2 = mypassword2;
	char *p3 = mypassword3;
	char *p4 = mypassword4;

	while(*p == *p1) { 
		if(*p == '\0') 
		{
			printf("Password: %s\n",mypassword1);
			break;
		}

		p++;
		p1++;
	}
	
	while(*r == *p2) { 
		if(*r == '\0') 
		{
			printf("Password: %s\n",mypassword2);
			break;
		}

		r++;
		p2++;
	}

	while(*a == *p3) { 
		if(*a == '\0') 
		{
			printf("Password: %s\n",mypassword3);
			break;
		}

		a++;
		p3++;
	}

	while(*t == *p4) { 
		if(*t == '\0') 
		{
			printf("Password: %s\n",mypassword4);
			return 1;
		}

		t++;
		p4++;
	}
	return 0;

}

__global__ void  kernel() {
	char s1,s2,s3,s4;

	char password[7];
	password[6] = '\0';

	int i = blockIdx.x+65;
	int j = threadIdx.x+65;
	char firstMatch = i; 
	char secondMatch = j; 

	password[0] = firstMatch;
	password[1] = secondMatch;
	for(s1='0'; s1<='9'; s1++){
		for(s2='0'; s2<='9'; s2++){
			for(s3='0'; s3<='9'; s3++){
				for(s4='0'; s4<='9'; s4++){
					password[2] = s1;
					password[3] = s2;
					password[4] = s3;
					password[5] = s4; 
					if(is_a_match(password)) {
					} 
					else {
	     			//printf("tried: %s\n", password);		  
					}
				}
			}
		}
	}
}

int time_difference(struct timespec *start, 
	struct timespec *finish, 
	long long int *difference) {
	long long int ds =  finish->tv_sec - start->tv_sec; 
	long long int dn =  finish->tv_nsec - start->tv_nsec; 
	if(dn < 0 ) {
		ds--;
		dn += 1000000000; 
	} 
	*difference = ds * 1000000000 + dn;
	return !(*difference > 0);
}


int main() {

	struct  timespec start, finish;
	long long int time_elapsed;
	clock_gettime(CLOCK_MONOTONIC, &start);

	kernel <<<26,26>>>();
	cudaThreadSynchronize();

	clock_gettime(CLOCK_MONOTONIC, &finish);
	time_difference(&start, &finish, &time_elapsed);
	printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9)); 

	return 0;
}


