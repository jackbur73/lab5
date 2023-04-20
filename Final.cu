#include <stdio.h>


__global__ void square(float *d_out, float *d_in,float *d_in2){
	int idx = threadIdx.x;
	float f = d_in[idx];
    float g=d_in2[idx];
	d_out[idx] = f+g;
}


int main(){
    const int ARRAY_SIZE = 96;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);
	
	float h_in[ARRAY_SIZE];
    float h_in2[ARRAY_SIZE];
    float h_out[ARRAY_SIZE];
	for (int i=0; i < ARRAY_SIZE; i++){
		h_in[i] = float(i);
        h_in2[i] = float(i) + 3;
        h_out[i] = h_in[i] + h_in2[i];


	}
	//float h_out[ARRAY_SIZE];

	float *d_in;
    float *d_in2;
	float *d_out;

	cudaMalloc((void**) &d_in, ARRAY_BYTES); 
    cudaMalloc((void**) &d_in2, ARRAY_BYTES); 
	cudaMalloc((void**) &d_out, ARRAY_BYTES); 

	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
    cudaMemcpy(d_in2 , h_in2, ARRAY_BYTES, cudaMemcpyHostToDevice);

	square<<<1, ARRAY_SIZE>>>(d_out, d_in, d_in2);

	cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

//	for (int i =0; i<ARRAY_SIZE; i++){
//		printf("%f", h_out[i]);
//		printf(((i % 4) !=3)? "\t": "\n");
//	}


        printf("Matrix 1 \n");
    for(int craig = 0; craig < 4 ; craig++)
    {
        printf("%f \t" , h_in[craig]);
        if(craig == 1){
            puts("");
        }
    }
    puts("");

    printf("Matrix 2 \n");
    for(int craig = 0; craig < 4 ; craig++)
    {
        printf("%f \t" , h_in2[craig]);
        if(craig == 1){
            puts("");
        }
    }
    puts("");

    printf("------------------------------------------------\n");
    printf("Matric ADDITION\n");
    printf("Left is D1, Middle is D2, right is D out\n");
    for(int j = 0; j < 4; j++)
    {
        printf("%f \t " , h_in[j]); // Array 1
        printf("%f \t ", h_in2[j]); // Array 2
        printf("%f \t", h_out[j]); // Final 
        puts("");
    }
	
    printf("------------------------------------------------\n");


	cudaFree(d_in);
    cudaFree(d_in2);
	cudaFree(d_out);

	return 0;
}
