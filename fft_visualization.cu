#include "fft_visualization.h"
#include <cufft.h>
#include <iostream>
#include <cmath>
#include <cuda_runtime.h>
#include <vector>
#include <complex>
#include <algorithm> // Include this header for std::max_element

// Error handling macro
#define CHECK(call)                                                        \
{                                                                          \
    const cudaError_t error = call;                                        \
    if (error != cudaSuccess)                                              \
    {                                                                      \
        std::cerr << "Error: " << __FILE__ << ":" << __LINE__ << ", "      \
                  << cudaGetErrorString(error) << std::endl;               \
        exit(1);                                                           \
    }                                                                      \
}

// Function to calculate the magnitude of complex numbers
void calculateMagnitude(const std::vector<cufftComplex>& data, std::vector<float>& magnitude) {
    for (size_t i = 0; i < data.size(); i++) {
        magnitude[i] = sqrt(data[i].x * data[i].x + data[i].y * data[i].y);
    }
}

// Function to calculate the phase of complex numbers
void calculatePhase(const std::vector<cufftComplex>& data, std::vector<float>& phase) {
    for (size_t i = 0; i < data.size(); i++) {
        phase[i] = atan2(data[i].y, data[i].x);
    }
}

// Function to generate input data
void generateInputData(std::vector<cufftComplex>& h_data, int N, int signalType) {
    h_data.resize(N);
    for (int i = 0; i < N; i++) {
        float t = 2 * M_PI * i / N;
        switch (signalType) {
            case 1: // Sine wave
                h_data[i].x = sin(t);
                h_data[i].y = 0.0f;
                break;
            case 2: // Square wave
                h_data[i].x = (i % (N / 2) < (N / 4)) ? 1.0f : -1.0f;
                h_data[i].y = 0.0f;
                break;
            case 3: // Sawtooth wave
                h_data[i].x = 2 * (t / (2 * M_PI) - floor(0.5 + t / (2 * M_PI)));
                h_data[i].y = 0.0f;
                break;
            case 4: // Triangle wave
                h_data[i].x = 2 * abs(2 * (t / (2 * M_PI) - floor(0.5 + t / (2 * M_PI)))) - 1;
                h_data[i].y = 0.0f;
                break;
            default:
                std::cerr << "Unknown signal type" << std::endl;
                exit(1);
        }
    }
}

// FFT function
void fftOnDevice(std::vector<cufftComplex>& h_data) {
    cufftHandle plan;
    cufftComplex *d_data;
    size_t size = sizeof(cufftComplex) * h_data.size();

    // Allocate device memory
    CHECK(cudaMalloc(&d_data, size));
    CHECK(cudaMemcpy(d_data, h_data.data(), size, cudaMemcpyHostToDevice));

    // Create FFT plan
    if (cufftPlan1d(&plan, h_data.size(), CUFFT_C2C, 1) != CUFFT_SUCCESS) {
        std::cerr << "CUFFT error: Plan creation failed" << std::endl;
        cudaFree(d_data);
        exit(1);
    } else {
        std::cout << "CUFFT Plan creation successful." << std::endl;
    }

    // Create CUDA events for timing
    cudaEvent_t start, stop;
    CHECK(cudaEventCreate(&start));
    CHECK(cudaEventCreate(&stop));

    // Record start event
    CHECK(cudaEventRecord(start, 0));

    // Execute FFT
    if (cufftExecC2C(plan, d_data, d_data, CUFFT_FORWARD) != CUFFT_SUCCESS) {
        std::cerr << "CUFFT error: ExecC2C Forward failed" << std::endl;
        cufftDestroy(plan);
        cudaFree(d_data);
        CHECK(cudaEventDestroy(start));
        CHECK(cudaEventDestroy(stop));
        exit(1);
    } else {
        std::cout << "CUFFT execution successful." << std::endl;
    }

    // Synchronize to ensure FFT computation is complete
    CHECK(cudaDeviceSynchronize());

    // Record stop event
    CHECK(cudaEventRecord(stop, 0));
    CHECK(cudaEventSynchronize(stop));

    // Compute elapsed time
    float elapsed_time;
    CHECK(cudaEventElapsedTime(&elapsed_time, start, stop));
    std::cout << "FFT computation time: " << elapsed_time << " ms" << std::endl;

    // Copy result back to host
    CHECK(cudaMemcpy(h_data.data(), d_data, size, cudaMemcpyDeviceToHost));

    // Clean up
    cufftDestroy(plan);
    cudaFree(d_data);
    CHECK(cudaEventDestroy(start));
    CHECK(cudaEventDestroy(stop));
}

void performFFTAnalysis(int N, int signalType, float scaleFactor, float minFrequency, float maxFrequency, bool displayPhase) {
    std::vector<cufftComplex> h_data;
    generateInputData(h_data, N, signalType);

    // Debug: Print input data
    std::cout << "Input Data:" << std::endl;
    for (int i = 0; i < N; i++) {
        std::cout << "Data[" << i << "]: (" << h_data[i].x << ", " << h_data[i].y << ")" << std::endl;
    }

    // Perform FFT on Device
    fftOnDevice(h_data);

    // Calculate magnitude spectrum
    std::vector<float> magnitude(N);
    calculateMagnitude(h_data, magnitude);

    // Calculate phase spectrum
    std::vector<float> phase(N);
    calculatePhase(h_data, phase);

    // Normalize magnitude spectrum
    float maxMagnitude = *std::max_element(magnitude.begin(), magnitude.end());
    for (auto& mag : magnitude) {
        mag /= maxMagnitude;
        mag *= scaleFactor;
    }

    // Output magnitude spectrum within the specified frequency range
    std::cout << "Magnitude Spectrum:" << std::endl;
    for (int i = 0; i < N; i++) {
        float frequency = static_cast<float>(i) / N * 2 * M_PI;
        if (frequency >= minFrequency && frequency <= maxFrequency) {
            std::cout << "Magnitude[" << i << "]: " << magnitude[i] << std::endl;
        }
    }

    // Output phase spectrum within the specified frequency range if requested
    if (displayPhase) {
        std::cout << "Phase Spectrum:" << std::endl;
        for (int i = 0; i < N; i++) {
            float frequency = static_cast<float>(i) / N * 2 * M_PI;
            if (frequency >= minFrequency && frequency <= maxFrequency) {
                std::cout << "Phase[" << i << "]: " << phase[i] << std::endl;
            }
        }
    }

    // Output frequency spectrum within the specified frequency range
    std::cout << "Frequency Spectrum:" << std::endl;
    for (int i = 0; i < N; i++) {
        float frequency = static_cast<float>(i) / N * 2 * M_PI;
        if (frequency >= minFrequency && frequency <= maxFrequency) {
            std::cout << "Frequency[" << i << "]: " << frequency << std::endl;
        }
    }
}