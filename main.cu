#include <iostream>
#include "fft_visualization.h"

int main() {
    int N;
    int signalType;
    float scaleFactor;
    float minFrequency, maxFrequency;
    bool displayPhase;

    std::cout << "Enter the size of FFT: ";
    std::cin >> N;

    std::cout << "Choose signal type (1: Sine wave, 2: Square wave, 3: Sawtooth wave, 4: Triangle wave): ";
    std::cin >> signalType;

    std::cout << "Enter magnitude scaling factor: ";
    std::cin >> scaleFactor;

    std::cout << "Enter minimum frequency to display: ";
    std::cin >> minFrequency;

    std::cout << "Enter maximum frequency to display: ";
    std::cin >> maxFrequency;

    std::cout << "Display phase spectrum? (1: Yes, 0: No): ";
    std::cin >> displayPhase;

    performFFTAnalysis(N, signalType, scaleFactor, minFrequency, maxFrequency, displayPhase);

    return 0;
}