#include <stdio.h>
#include <math.h>
#include <time.h>
#include <unistd.h>
#include <cuda_runtime_api.h>
#include <errno.h>
#include <unistd.h>


//To compile: nvcc -o Saral_linear Saral_linear.cu -lm
//To run: ./Saral_linear


typedef struct point_t {
  double x;
  double g;
} point_t;

int n_data = 1000;
__device__ int d_n_data = 1000;


point_t data[] = {
  {80.28,111.84},{69.01,103.32},{65.03,113.98},{67.99,137.52},
  {69.19,110.90},{70.95,133.51},{85.59,134.15},{77.00,127.15},
  {85.78,137.75},{68.71,121.37},{85.94,131.72},{ 1.07,24.18},
  {80.35,143.60},{59.32,109.99},{41.52,96.31},{83.30,116.14},
  {51.20,107.74},{98.30,128.55},{49.63,108.75},{76.88,124.57},
  {11.66,59.69},{48.21,91.01},{67.30,117.97},{79.32,138.71},
  {13.19,53.16},{63.57,118.66},{25.92,68.97},{25.76,58.17},
  {79.82,130.26},{93.45,132.58},{68.52,98.17},{14.66,70.76},
  {19.19,54.17},{43.97,87.29},{67.39,116.35},{32.96,90.70},
  {79.64,131.36},{20.82,64.10},{78.93,127.98},{79.46,140.26},
  {78.66,121.01},{27.41,77.13},{35.16,91.20},{21.16,75.02},
  { 1.38,54.06},{11.99,59.10},{35.23,84.83},{26.81,68.13},
  {31.16,67.83},{67.50,128.87},{13.64,53.45},{27.28,67.19},
  {94.73,126.65},{ 4.59,41.14},{57.04,110.07},{ 9.54,44.95},
  {47.30,85.11},{90.47,150.19},{24.92,74.58},{44.77,81.11},
  {65.31,130.19},{73.00,110.08},{19.40,55.77},{30.47,84.60},
  {38.12,79.13},{66.74,113.32},{82.66,136.16},{44.74,107.07},
  { 7.88,46.19},{89.46,121.81},{38.29,98.28},{32.63,76.72},
  {49.53,97.14},{56.86,89.62},{61.86,109.79},{83.01,137.92},
  { 0.74,50.95},{27.17,68.87},{48.80,87.51},{85.78,126.50},
  {49.10,86.53},{42.05,104.46},{59.22,112.94},{84.52,125.35},
  {94.14,144.23},{ 3.42,37.88},{64.20,115.35},{88.91,129.72},
  {97.96,142.92},{67.57,95.31},{33.98,82.94},{11.17,44.75},
  {72.41,129.20},{30.18,71.41},{43.88,86.52},{34.30,66.42},
  {49.94,82.07},{43.47,76.70},{ 6.49,49.39},{81.52,112.17},
  {71.99,114.57},{72.18,118.49},{65.50,99.80},{15.10,39.50},
  {22.46,65.77},{80.90,116.10},{ 6.66,31.75},{ 6.43,55.12},
  {83.51,126.72},{49.11,82.61},{84.66,132.42},{68.27,119.81},
  {11.71,53.72},{ 7.26,53.46},{40.22,69.57},{72.77,130.47},
  {61.07,102.01},{48.65,80.67},{31.20,81.90},{25.29,75.48},
  { 1.21,31.27},{69.19,110.28},{65.20,112.69},{47.14,87.73},
  {31.65,70.07},{78.42,137.29},{41.91,83.85},{17.51,66.44},
  {13.79,59.51},{42.32,91.01},{19.87,63.07},{97.57,134.65},
  {24.38,77.11},{54.04,110.45},{39.90,86.09},{ 7.49,52.33},
  {90.82,129.37},{77.87,126.33},{68.17,121.34},{51.30,93.27},
  { 8.74,51.31},{ 9.64,58.20},{ 3.22,45.87},{26.00,61.66},
  {83.48,143.06},{36.40,88.34},{37.33,92.70},{56.80,97.36},
  {28.63,76.69},{90.13,126.26},{46.72,89.85},{10.29,68.98},
  {81.18,147.64},{75.67,112.71},{13.22,61.70},{49.96,92.33},
  { 8.07,54.39},{66.63,97.79},{74.09,132.72},{21.77,61.84},
  {74.76,107.18},{20.43,71.00},{ 1.51,23.81},{59.53,104.96},
  {72.85,96.03},{28.95,80.52},{ 2.17,45.64},{43.72,84.30},
  {83.72,136.81},{75.56,127.91},{92.61,124.07},{19.47,61.60},
  {89.96,153.85},{58.97,99.76},{26.75,65.03},{82.49,118.56},
  {83.33,123.69},{50.04,78.26},{73.81,114.51},{63.82,98.24},
  {58.90,103.03},{45.76,73.43},{81.80,132.53},{12.25,59.68},
  {18.33,56.35},{ 1.30,44.84},{76.86,111.33},{26.93,61.10},
  {22.01,80.51},{32.34,72.48},{14.19,74.43},{85.42,128.48},
  {93.13,130.95},{94.56,153.36},{47.32,92.25},{ 2.68,48.86},
  {78.04,131.39},{84.20,133.08},{69.61,128.29},{23.34,53.65},
  {47.55,92.15},{21.36,46.76},{85.53,119.72},{63.60,100.63},
  {59.20,92.41},{75.25,121.18},{69.17,113.31},{22.48,65.46},
  {93.08,131.93},{70.54,102.09},{54.46,91.58},{42.40,80.36},
  {55.91,84.00},{22.07,57.31},{14.92,49.59},{65.44,118.47},
  {51.27,92.64},{55.20,112.20},{61.44,112.45},{28.79,60.05},
  {70.29,111.62},{80.78,119.13},{85.38,136.74},{28.14,53.50},
  {57.52,109.98},{43.17,87.03},{75.18,123.90},{90.06,130.07},
  { 5.73,44.77},{34.05,88.05},{85.44,130.66},{78.40,123.68},
  {78.70,107.77},{ 8.97,56.04},{85.49,135.86},{47.27,86.34},
  {84.56,131.16},{60.14,89.48},{13.38,51.48},{65.96,107.08},
  { 9.51,33.59},{57.81,107.54},{ 5.79,40.22},{22.88,84.72},
  {78.29,143.42},{80.99,114.87},{42.48,84.20},{82.29,127.09},
  {58.18,94.62},{45.57,74.11},{45.10,80.78},{ 1.94,44.35},
  {47.22,87.60},{ 4.10,58.60},{59.80,99.28},{88.87,134.73},
  {19.69,73.23},{11.26,60.07},{45.71,82.05},{62.19,104.58},
  { 4.92,37.68},{95.86,126.41},{ 2.95,56.88},{ 6.52,40.53},
  {95.19,142.78},{58.06,101.54},{18.25,65.12},{88.97,151.05},
  {74.29,117.95},{45.35,96.27},{28.77,59.13},{ 3.23,32.66},
  {87.07,132.30},{74.46,126.69},{43.20,82.92},{ 6.74,33.91},
  {65.54,99.99},{18.34,46.98},{84.72,131.37},{76.86,117.86},
  {27.51,58.67},{38.79,72.17},{62.76,103.73},{17.10,69.29},
  {22.21,63.68},{95.38,146.68},{71.23,103.21},{ 1.79,29.88},
  {46.80,82.89},{91.10,136.45},{62.36,104.08},{78.11,124.91},
  { 9.47,69.74},{97.68,153.87},{94.95,137.63},{32.57,62.53},
  {30.70,81.06},{54.81,92.53},{80.46,140.54},{82.46,122.94},
  { 7.26,43.71},{21.66,70.68},{50.34,63.87},{42.88,101.99},
  {66.92,104.79},{86.64,136.49},{28.22,76.66},{89.67,135.56},
  {85.99,138.84},{20.92,55.71},{85.54,141.98},{97.81,157.77},
  {41.86,84.63},{55.16,102.13},{89.14,137.21},{22.96,53.01},
  {57.88,93.61},{73.37,130.94},{84.61,121.63},{21.49,49.66},
  {95.20,144.13},{70.71,110.77},{54.28,101.88},{24.63,68.31},
  {81.83,125.02},{34.57,83.01},{ 1.69,51.38},{63.84,87.27},
  {77.02,124.03},{31.68,73.93},{83.63,139.52},{67.91,85.70},
  {30.67,81.33},{99.61,161.41},{15.06,53.71},{28.75,73.85},
  {53.93,96.14},{22.74,67.29},{66.05,126.91},{57.80,103.49},
  {54.86,97.54},{88.48,138.11},{75.22,129.44},{45.33,75.44},
  {25.71,55.28},{42.45,86.12},{32.52,60.40},{89.59,122.06},
  {70.63,118.31},{ 6.57,59.91},{86.29,136.71},{53.44,94.98},
  {77.10,134.15},{47.57,104.22},{52.99,101.86},{54.50,102.75},
  { 3.51,39.52},{86.79,147.73},{21.74,56.12},{25.33,62.86},
  {24.70,48.33},{36.02,83.30},{85.28,129.46},{43.88,89.92},
  {79.29,124.12},{64.90,103.59},{20.79,67.15},{72.54,125.82},
  {25.88,62.33},{89.59,141.41},{12.41,75.03},{10.71,41.11},
  {82.63,131.92},{32.23,69.69},{63.96,95.97},{29.95,90.45},
  {81.21,128.85},{79.10,138.05},{45.01,76.99},{82.38,136.49},
  {97.18,155.85},{61.42,80.17},{86.93,148.97},{23.03,54.09},
  {96.88,148.47},{85.88,127.09},{ 9.15,58.53},{79.36,124.46},
  {18.04,62.82},{ 9.12,53.25},{24.90,68.34},{55.09,99.24},
  {12.01,62.98},{93.45,152.21},{35.18,74.12},{24.44,71.20},
  { 3.30,41.25},{48.19,81.72},{34.50,79.79},{35.29,65.54},
  {25.20,70.28},{98.14,135.27},{ 5.07,48.52},{25.14,56.49},
  {67.50,106.17},{86.36,131.62},{ 2.57,51.28},{17.57,71.77},
  {58.95,113.74},{61.06,111.77},{87.21,135.74},{ 3.62,46.35},
  {86.30,146.64},{79.48,112.44},{29.48,54.93},{52.59,82.17},
  {53.91,99.26},{60.03,95.27},{18.42,37.26},{95.68,133.11},
  {37.11,82.66},{ 3.26,45.55},{80.00,125.31},{12.23,51.29},
  {14.62,55.22},{54.47,94.22},{69.80,127.74},{22.12,75.03},
  {49.20,105.99},{97.87,146.43},{30.74,74.59},{11.60,46.54},
  {32.87,66.41},{71.73,120.20},{59.98,112.71},{26.85,59.86},
  {83.28,130.41},{79.55,107.06},{33.22,74.30},{59.39,115.51},
  {74.86,108.98},{23.50,67.18},{61.82,120.08},{ 0.98,33.23},
  {43.67,81.24},{81.21,127.05},{45.24,84.95},{49.42,79.98},
  {19.08,54.21},{64.88,107.94},{70.59,131.83},{14.01,46.19},
  {77.86,123.41},{74.96,122.21},{69.74,114.67},{66.11,119.35},
  {40.78,86.13},{72.16,114.36},{ 2.23,37.86},{67.85,108.81},
  { 4.00,30.66},{13.25,49.76},{81.61,140.84},{91.34,140.02},
  {20.46,54.24},{44.08,97.65},{94.59,141.09},{95.54,147.51},
  {37.61,96.39},{30.42,70.79},{75.35,131.84},{82.63,139.37},
  {50.60,113.24},{76.45,125.55},{60.79,107.96},{64.53,98.82},
  {58.09,103.91},{86.12,154.32},{82.93,128.27},{25.10,67.85},
  {36.66,72.79},{59.62,102.51},{19.07,67.68},{ 2.51,19.76},
  {65.15,112.93},{ 3.41,42.69},{21.01,68.84},{25.64,65.20},
  {74.75,142.99},{11.73,64.96},{22.32,35.37},{88.58,143.39},
  {84.25,137.50},{53.74,83.55},{26.34,87.97},{89.52,142.87},
  {48.20,111.86},{52.37,126.78},{90.52,142.63},{72.99,116.75},
  {46.02,90.69},{67.93,116.43},{25.46,87.66},{36.91,79.44},
  {73.50,120.80},{62.80,113.37},{ 1.71,21.87},{77.14,122.32},
  {27.64,68.82},{38.58,89.39},{87.47,146.96},{64.23,117.17},
  {81.95,150.86},{11.35,54.32},{89.48,141.31},{28.26,60.52},
  {32.07,83.18},{54.64,101.52},{ 1.85,40.55},{93.92,134.40},
  {27.70,54.37},{20.29,62.29},{84.55,119.83},{78.23,138.78},
  {72.08,108.48},{76.23,132.86},{97.25,141.08},{61.24,104.75},
  {57.63,90.50},{62.89,122.04},{88.82,135.63},{45.91,83.96},
  { 2.28,50.29},{83.75,143.02},{55.05,106.77},{20.09,69.84},
  {17.36,63.16},{15.20,42.01},{71.08,123.50},{60.21,102.04},
  {61.74,101.95},{19.81,56.81},{30.62,90.42},{16.24,40.88},
  {77.90,133.22},{54.69,94.28},{68.42,107.80},{32.73,85.53},
  {84.71,117.37},{82.84,143.79},{68.28,110.79},{46.19,80.80},
  {84.90,127.81},{57.41,97.59},{83.64,138.47},{32.46,73.51},
  {54.30,97.61},{74.50,132.13},{30.35,78.19},{43.64,94.96},
  { 4.58,42.12},{32.44,61.17},{78.45,136.26},{15.01,62.40},
  { 0.60,39.59},{61.71,115.81},{19.41,53.28},{52.83,97.44},
  {89.90,138.12},{65.81,107.31},{81.60,141.43},{37.49,81.10},
  { 6.11,32.04},{35.40,74.71},{ 7.45,54.33},{85.84,141.17},
  {34.05,85.71},{75.05,131.22},{59.33,102.43},{60.60,90.41},
  {71.04,123.91},{15.86,67.12},{87.31,134.98},{79.27,126.72},
  {12.09,27.07},{74.19,121.27},{54.67,86.73},{26.52,53.43},
  {45.94,76.72},{11.63,46.56},{16.98,61.97},{10.37,53.64},
  {20.75,55.70},{81.14,124.45},{29.14,69.32},{19.06,79.72},
  { 5.63,57.93},{39.60,87.45},{46.99,93.32},{54.53,101.83},
  {25.87,67.93},{43.02,87.65},{51.29,86.74},{72.73,116.30},
  {87.62,139.99},{29.17,65.91},{32.39,61.63},{89.94,139.91},
  { 8.36,46.95},{54.04,104.56},{77.15,126.44},{54.45,101.38},
  {29.85,76.85},{ 2.57,36.70},{75.47,113.60},{43.37,83.35},
  {14.24,64.09},{50.52,87.73},{59.58,112.90},{27.49,50.79},
  {56.90,103.06},{98.73,147.46},{52.94,96.88},{49.73,105.17},
  {31.13,83.48},{67.43,127.53},{87.28,143.61},{44.67,63.63},
  {27.06,77.88},{34.69,83.26},{67.12,118.73},{75.28,110.47},
  {36.62,90.76},{18.27,58.18},{33.04,73.96},{41.92,78.66},
  {78.30,142.93},{83.80,136.12},{73.13,123.87},{65.12,113.96},
  {75.41,143.95},{52.98,102.72},{39.18,81.72},{73.21,135.62},
  {80.63,135.89},{52.95,104.31},{67.51,115.81},{86.94,123.70},
  {23.74,59.22},{17.40,68.26},{19.28,83.79},{72.51,114.23},
  {87.18,113.61},{66.20,109.57},{69.31,112.57},{74.56,123.94},
  {27.72,76.72},{65.62,113.24},{54.14,107.24},{69.61,113.11},
  {53.20,88.82},{26.17,70.83},{58.19,88.52},{78.31,133.59},
  {77.61,136.78},{51.85,88.96},{34.04,66.04},{ 8.17,49.16},
  {55.42,77.73},{28.07,47.92},{30.70,57.34},{11.52,55.95},
  {24.62,66.34},{79.49,121.21},{77.01,116.02},{26.24,71.96},
  {66.03,112.03},{90.44,142.12},{84.74,118.56},{88.51,141.97},
  { 5.75,30.28},{91.42,140.43},{16.44,58.80},{ 1.85,41.30},
  {98.06,151.45},{45.49,83.15},{ 4.39,43.11},{66.47,112.28},
  {24.14,73.06},{54.39,109.20},{80.10,114.54},{16.15,62.84},
  {53.06,128.60},{28.82,65.52},{51.46,103.32},{47.36,95.47},
  {91.79,143.89},{26.65,70.36},{ 0.46,41.43},{77.83,133.69},
  {96.38,141.97},{27.39,85.58},{95.88,122.46},{68.17,103.29},
  {15.99,59.45},{70.75,126.78},{74.31,122.65},{92.94,147.29},
  {36.58,72.69},{67.80,106.28},{80.63,114.04},{19.24,65.73},
  {44.13,79.26},{71.83,98.58},{42.61,79.00},{18.09,74.33},
  {79.85,145.11},{33.14,79.94},{84.53,139.20},{81.06,149.27},
  {65.98,137.19},{58.33,99.78},{37.88,77.34},{ 3.41,41.80},
  {39.27,67.97},{11.33,48.29},{37.08,78.26},{30.37,65.84},
  {11.96,62.82},{46.99,96.49},{80.61,146.25},{20.02,38.47},
  {28.70,57.43},{ 5.89,34.35},{50.94,93.38},{88.62,131.74},
  {93.34,137.62},{59.55,88.62},{46.51,109.78},{47.06,96.32},
  {58.96,107.60},{ 0.26,43.91},{30.62,75.49},{32.30,79.27},
  {26.68,73.74},{94.08,136.25},{26.08,67.15},{38.78,86.01},
  {80.73,124.97},{11.82,77.70},{69.20,104.90},{93.83,141.27},
  {41.34,84.44},{99.66,144.84},{98.29,150.09},{23.23,63.91},
  {89.42,136.33},{ 0.72,18.94},{61.28,104.18},{12.28,55.69},
  {52.29,93.41},{ 6.43,28.77},{40.75,80.81},{30.98,72.27},
  {45.78,96.05},{ 3.79,46.15},{73.13,111.30},{19.05,64.24},
  {84.09,133.70},{30.45,71.89},{41.38,68.00},{90.16,134.87},
  {20.04,66.23},{51.26,102.86},{79.66,126.85},{54.27,114.34},
  {33.96,75.18},{30.62,65.66},{46.45,81.88},{97.94,155.24},
  {77.06,120.97},{19.78,60.69},{33.99,85.03},{97.89,137.79},
  {70.68,113.56},{81.37,129.50},{ 6.18,48.73},{27.76,64.33},
  { 4.31,57.38},{11.38,56.13},{59.13,112.88},{ 8.50,62.75},
  {65.80,98.96},{ 6.78,42.27},{ 7.99,53.70},{22.79,48.87},
  {78.07,133.24},{51.94,112.37},{82.16,133.10},{74.00,117.77},
  {37.79,86.42},{41.39,87.97},{78.71,136.20},{64.26,103.93},
  {92.78,152.23},{98.96,140.45},{12.32,61.81},{27.23,83.37},
  {36.45,80.98},{92.42,144.04},{ 2.72,53.42},{59.48,88.45},
  {70.50,105.34},{80.16,132.58},{61.51,108.36},{86.50,134.28},
  {32.96,82.65},{ 0.64,32.10},{39.82,91.31},{99.68,143.76},
  {63.79,108.23},{47.75,89.16},{11.92,54.09},{89.68,132.03},
  {40.77,97.01},{87.58,142.22},{ 8.26,52.72},{50.70,100.28},
  { 4.13,34.87},{53.84,123.63},{99.60,155.96},{51.25,87.16},
  {69.82,102.22},{ 9.41,50.84},{23.25,62.70},{92.16,119.43},
  { 1.84,35.06},{18.06,76.10},{36.81,91.33},{72.15,100.71},
  {77.60,127.24},{41.48,59.25},{20.38,58.43},{82.18,138.50},
  {56.06,104.05},{11.51,40.93},{88.87,140.79},{92.66,146.03},
  {36.67,80.71},{23.98,47.32},{92.81,151.09},{88.34,145.92},
  {51.26,83.61},{43.52,62.31},{52.67,86.79},{77.58,124.73},
  {83.51,132.16},{ 4.20,42.68},{38.26,73.92},{21.97,74.34},
  {94.49,140.41},{22.52,48.71},{59.36,112.53},{97.17,138.85},
  {13.15,53.76},{83.07,132.32},{90.18,132.67},{53.89,93.31},
  {56.42,101.62},{15.19,57.65},{75.37,120.39},{16.45,66.86},
  {67.68,120.80},{ 4.99,48.64},{ 4.01,40.14},{60.64,103.00},
  {78.01,132.07},{30.74,69.65},{ 2.15,30.89},{85.10,124.77},
  {78.89,141.68},{ 9.27,64.76},{86.91,142.52},{ 0.08,27.66},
  {37.42,85.31},{45.97,91.19},{95.03,144.64},{39.97,69.83},
  {63.40,111.83},{24.69,65.95},{75.52,144.52},{93.23,133.27},
  {77.35,116.79},{45.18,103.86},{28.45,68.21},{47.25,98.21},
  {66.66,99.22},{17.64,45.07},{86.25,160.90},{ 2.32,35.57},
  {80.24,125.32},{19.86,67.96},{76.86,135.07},{19.09,68.80},
  {74.88,124.94},{47.35,96.83},{29.79,54.70},{42.72,95.93},
  {30.70,70.60},{89.86,144.06},{49.69,86.04},{54.59,83.19},
  {23.84,61.52},{47.36,90.79},{17.13,52.77},{31.34,67.25},
  {54.82,92.48},{39.57,87.96},{79.79,121.76},{57.88,107.79},
  {63.14,100.25},{86.27,134.68},{ 2.82,52.26},{71.37,106.46},
  {91.46,127.64},{87.54,143.95},{81.67,127.61},{39.96,83.70},
  { 5.55,51.13},{97.87,148.81},{73.91,137.10},{90.34,122.06},
  {53.22,103.70},{43.77,78.61},{37.29,71.53},{19.77,81.25},
  { 2.47,49.45},{22.42,82.43},{98.67,170.97},{67.53,101.73},
  {87.19,139.84},{47.01,101.03},{37.06,83.05},{88.48,132.13},
  {87.16,139.83},{69.34,103.44},{ 2.99,37.05},{10.18,44.27},
  {23.27,77.81},{60.69,110.87},{86.55,140.31},{31.10,76.60},
  {28.66,64.56},{93.71,133.04},{69.16,125.99},{80.68,128.93},
  {20.97,49.93},{16.15,70.98},{41.19,70.89},{90.68,134.76},
  {83.72,128.87},{79.56,133.35},{42.03,85.18},{31.54,75.44},
  {32.66,78.39},{75.97,131.76},{26.20,67.22},{23.41,46.76},
  {46.73,90.98},{65.34,120.10},{73.16,121.50},{16.12,57.98},
  { 7.82,54.40},{49.77,116.00},{24.81,55.24},{68.01,104.18},
  {28.94,88.67},{26.63,61.77},{45.58,116.48},{96.65,134.97},
  {86.33,152.46},{77.22,128.21},{73.32,133.86},{61.20,101.74},
  {97.72,140.04},{28.55,76.92},{44.18,85.65},{42.58,96.20},
  {52.50,119.23},{53.08,89.51},{93.69,130.36},{44.66,105.99},
  {15.15,58.05},{31.87,79.86},{ 8.91,42.05},{90.25,141.68},
  {69.37,120.41},{16.27,66.54},{70.74,112.11},{55.49,124.42}
};
double residual_error(double x, double g, double m, double c) {
  double e = (m * x) + c - g;
  return e * e;
}

__device__ double d_residual_error(double x, double g, double m, double c) {
  double e = (m * x) + c - g;
  return e * e;
}

double rms_error(double m, double c) {
  int i;
  double mean;
  double error_sum = 0;
  
  for(i=0; i<n_data; i++) {
    error_sum += residual_error(data[i].x, data[i].g, m, c);
  }
  
  mean = error_sum / n_data;
  
  return sqrt(mean);
}

__global__ void d_rms_error(double *m, double *c, double *error_sum_arr, point_t *d_data) {

	int i = threadIdx.x + blockIdx.x * blockDim.x;

  error_sum_arr[i] = d_residual_error(d_data[i].x, d_data[i].g, *m, *c);
}

int time_difference(struct timespec *start, struct timespec *finish, 
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
  int i;
  double bm = 1.3;
  double bc = 10;
  double be;
  double dm[8];
  double dc[8];
  double e[8];
  double step = 0.01;
  double best_error = 999999999;
  int best_error_i;
  int minimum_found = 0;
  
  double om[] = {0,1,1, 1, 0,-1,-1,-1};
  double oc[] = {1,1,0,-1,-1,-1, 0, 1};

	struct timespec start, finish;   
  long long int time_elapsed;

	
  clock_gettime(CLOCK_MONOTONIC, &start);

	cudaError_t error;

	
  double *d_dm;
  double *d_dc;
	double *d_error_sum_arr;
	point_t *d_data;
	
  be = rms_error(bm, bc);

	
	error = cudaMalloc(&d_dm, (sizeof(double) * 8));
 	if(error){
   	fprintf(stderr, "cudaMalloc on d_dm returned %d %s\n", error,
    	cudaGetErrorString(error));
   	exit(1);
 	}
	
	
	error = cudaMalloc(&d_dc, (sizeof(double) * 8));
 	if(error){
   	fprintf(stderr, "cudaMalloc on d_dc returned %d %s\n", error,
  	  cudaGetErrorString(error));
   	exit(1);
 	}
	
	
	error = cudaMalloc(&d_error_sum_arr, (sizeof(double) * 1000));
 	if(error){
   	fprintf(stderr, "cudaMalloc on d_error_sum_arr returned %d %s\n", error,
   	  cudaGetErrorString(error));
   	exit(1);
 	}

	
	error = cudaMalloc(&d_data, sizeof(data));
 	if(error){
   	fprintf(stderr, "cudaMalloc on d_data returned %d %s\n", error,
   	  cudaGetErrorString(error));
   	exit(1);
 	}

  while(!minimum_found) {
    for(i=0;i<8;i++) {
      dm[i] = bm + (om[i] * step);
      dc[i] = bc + (oc[i] * step);    
    }

		
  	error = cudaMemcpy(d_dm, dm, (sizeof(double) * 8), cudaMemcpyHostToDevice);  
  	if(error){
    	fprintf(stderr, "cudaMemcpy to d_dm returned %d %s\n", error,
      cudaGetErrorString(error));
  	}

		
  	error = cudaMemcpy(d_dc, dc, (sizeof(double) * 8), cudaMemcpyHostToDevice);  
  	if(error){
    	fprintf(stderr, "cudaMemcpy to d_dc returned %d %s\n", error,
      cudaGetErrorString(error));
  	}

		
  	error = cudaMemcpy(d_data, data, sizeof(data), cudaMemcpyHostToDevice);  
  	if(error){
    	fprintf(stderr, "cudaMemcpy to d_data returned %d %s\n", error,
      cudaGetErrorString(error));
  	}
		
    for(i=0;i<8;i++) {
			
			double h_error_sum_arr[1000];
			double error_sum_total;
			double error_sum_mean;
			d_rms_error <<<100,10>>>(&d_dm[i], &d_dc[i], d_error_sum_arr, d_data);
			cudaThreadSynchronize();
		  error = cudaMemcpy(&h_error_sum_arr, d_error_sum_arr, (sizeof(double) * 1000), cudaMemcpyDeviceToHost);  
		  if(error){
	    fprintf(stderr, "cudaMemcpy to error_sum returned %d %s\n", error,
	      cudaGetErrorString(error));
		  }
			for(int j=0; j<n_data; j++) {
    		error_sum_total += h_error_sum_arr[j];
  		}

			error_sum_mean = error_sum_total / n_data;
			e[i] = sqrt(error_sum_mean);

      if(e[i] < best_error) {
        best_error = e[i];
        best_error_i = i;
      }

			error_sum_total = 0;
    }


    if(best_error < be) {
      be = best_error;
      bm = dm[best_error_i];
      bc = dc[best_error_i];
    } else {
      minimum_found = 1;
    }
  }

	error = cudaFree(d_dm);
	if(error){
		fprintf(stderr, "cudaFree on d_dm returned %d %s\n", error,
	  	cudaGetErrorString(error));
		exit(1);
	}
	
	error = cudaFree(d_dc);
	if(error){
		fprintf(stderr, "cudaFree on d_dc returned %d %s\n", error,
			cudaGetErrorString(error));
		exit(1);
	}

	error = cudaFree(d_data);
	if(error){
		fprintf(stderr, "cudaFree on d_data returned %d %s\n", error,
	  	cudaGetErrorString(error));
	 	exit(1);
	}
		
	error = cudaFree(d_error_sum_arr);
	if(error){
		fprintf(stderr, "cudaFree on d_error_sum_arr returned %d %s\n", error,
	  	cudaGetErrorString(error));
	 	exit(1);
	}

  printf("minimum m,c is %lf,%lf with error %lf\n", bm, bc, be);

	clock_gettime(CLOCK_MONOTONIC, &finish);

  time_difference(&start, &finish, &time_elapsed);

  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, 
         (time_elapsed/1.0e9));
	
  return 0;
}
