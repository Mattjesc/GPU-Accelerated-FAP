#ifndef FFT_VISUALIZATION_H
#define FFT_VISUALIZATION_H

#include <vector>
#include <cufft.h>

void calculateMagnitude(const std::vector<cufftComplex>& data, std::vector<float>& magnitude);
void calculatePhase(const std::vector<cufftComplex>& data, std::vector<float>& phase);
void generateInputData(std::vector<cufftComplex>& h_data, int N, int signalType);
void fftOnDevice(std::vector<cufftComplex>& h_data);
void performFFTAnalysis(int N, int signalType, float scaleFactor, float minFrequency, float maxFrequency, bool displayPhase);

#endif // FFT_VISUALIZATION_H