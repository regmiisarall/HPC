#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <crypt.h>
#include <time.h>
#include <math.h>
#include <mpi.h>
/***********************************************************************
*******
  Demonstrates how to crack an encrypted password using a simple
  "brute force" algorithm. Works on passwords that consist only of 2
uppercase
  letters and a 2 digit integer. Your personalised data set is included
in the
  code. 

 
************************************************************************
******/
int n_passwords = 4;

char *encrypted_passwords[] = {
  "$6$KB$SjQpmnMtmvzsiL43FPUsaQPwtGmR52870.sgY0BQQ/SEWOhg57FMPAqJ.DUJKR9QvsQD4KEqgHlTAMYScXwkA.",
  "$6$KB$dWRMunG0MNBi43C6.XgLgxVY8DL31iybaffxwt4nS465Yl8j1WVCE3yrG0r6OowrSN5Z6svImqyGLnWXaFcgr.",
  "$6$KB$QA4KTFfCfcu3nG9ZdsYoviipAUs281dawKFcDGg0395mzu61nkt.W9a3FHj9696Q7dMQdoIRUudaKpr87EYf3/",
  "$6$KB$RdoFybakl8y8pqldFdW4.I30Wtt1gBjGqSqO1Uuqrs9IESm5VsjzXULsxm9GzeylmjdCYPupiFe5jH0FqcVgb0"
};

/**
 Required by lack of standard function in C.   
*/

void substr(char *dest, char *src, int start, int length){
  memcpy(dest, src + start, length);
  *(dest + length) = '\0';
}

/**
 This function can crack the kind of password explained above. All
combinations
 that are tried are displayed and when the password is found, #, is put
at the 
 start of the line. Note that one of the most time consuming operations
that 
 it performs is the output of intermediate results, so performance
experiments 
 for this kind of program should not include this. i.e. comment out the
printfs.
*/

void crackAM(char *salt_and_encrypted){
  int x, y, z;     // Loop counters
  char salt[7];    // String used in hashing the password. Need space

  char plain[7];   // The combination of letters currently being checked
  char *enc;       // Pointer to the encrypted password
  int count = 0;   // The number of combinations explored so far

  substr(salt, salt_and_encrypted, 0, 6);

  for(x='A'; x<='M'; x++){
    for(y='A'; y<='Z'; y++){
      for(z=0; z<=99; z++){
        sprintf(plain, "%c%c%02d", x, y, z); 
        enc = (char *) crypt(plain, salt);
        count++;
        if(strcmp(salt_and_encrypted, enc) == 0){
          printf("#%-8d%s %s\n", count, plain, enc);
        } /*else {
          printf(" %-8d%s %s\n", count, plain, enc);
        }*/
      }
    }
  }
  printf("%d solutions explored\n", count);
}

void crackNZ(char *salt_and_encrypted){
  int x, y, z;     // Loop counters
  char salt[7];    // String used in hashing the password. Need space

  char plain[7];   // The combination of letters currently being checked
  char *enc;       // Pointer to the encrypted password
  int count = 0;   // The number of combinations explored so far

  substr(salt, salt_and_encrypted, 0, 6);

  for(x='N'; x<='Z'; x++){
    for(y='A'; y<='Z'; y++){
      for(z=0; z<=99; z++){
        sprintf(plain, "%c%c%02d", x, y, z); 
        enc = (char *) crypt(plain, salt);
        count++;
        if(strcmp(salt_and_encrypted, enc) == 0){
          printf("#%-8d%s %s\n", count, plain, enc);
        } /*else {
          printf(" %-8d%s %s\n", count, plain, enc);
        }*/
      }
    }
  }
  printf("%d solutions explored\n", count);
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
int main(int argc, char *argv[]){

 struct timespec start, finish;   
  long long int time_elapsed;
  clock_gettime(CLOCK_MONOTONIC, &start);

 

int size, rank;

  MPI_Init(NULL, NULL);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  if(size != 3) {
    if(rank == 0) {
      printf("This program needs to run on exactly 3 processes\n");
    }
  } else {
    if(rank ==0){
      int x;
      MPI_Send(&x, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);  
      MPI_Send(&x, 1, MPI_INT, 2, 0, MPI_COMM_WORLD);
      
	
    } 
else if (rank == 1){
        int number, i;
      	MPI_Recv(&number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD,MPI_STATUS_IGNORE);
	for ( i = 0; i<n_passwords;i<i++){
		crackAM(encrypted_passwords[i]);
	
        }
      }
	else {
      	int number, i;
      	MPI_Recv(&number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD,MPI_STATUS_IGNORE);
	for (i = 0; i<n_passwords;i<i++){
		crackNZ(encrypted_passwords[i]);
	}
       }
  }
  MPI_Finalize(); 
 clock_gettime(CLOCK_MONOTONIC, &finish);
      time_difference(&start, &finish, &time_elapsed);
      printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed,
                                         (time_elapsed/1.0e9));
  return 0;
}


