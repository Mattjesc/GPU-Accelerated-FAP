# GPU-Accelerated Frequency Analysis Prototype using CUDA, Unit Testing, and User-Defined Settings

![image](https://github.com/user-attachments/assets/6919bd71-5c57-4e24-8847-5b5f2ad4a7df)

## Overview

This project is a GPU-accelerated frequency analysis prototype that utilizes CUDA for high-performance computing, unit testing for validation, and user-defined settings for flexibility. The prototype performs Fast Fourier Transform (FFT) on various signal types and visualizes the frequency spectrum, allowing users to configure signal types and scaling factors.

## Features

- **GPU Acceleration**: Leverages NVIDIA's CUDA platform for GPU-accelerated FFT computations.
- **Unit Testing**: Includes unit tests using Google Test to ensure the correctness and robustness of the implementation.
- **User-Defined Settings**: Allows users to configure signal types, scaling factors, and frequency ranges for analysis.
- **Interactive UI**: Provides an interactive command-line interface for user input and output.

## Requirements

- **Hardware**: NVIDIA GPU with CUDA compatibility.
- **Software**:
  - CUDA Toolkit 12.5 or higher
  - CMake 3.14 or higher
  - Google Test (version used: v1.15.2)

## Installation

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/Mattjesc/GPU-Accelerated-FAP.git
   cd GPU-Accelerated-FAP
   ```

2. **Install Dependencies**:
   - Ensure CUDA Toolkit is installed and properly configured.
   - Install CMake if not already installed.

3. **Build the Project**:
   ```sh
   mkdir build
   cd build
   cmake ..
   make
   ```

## Usage

1. **Run the Application**:
   ```sh
   ./fft_visualization
   ```

2. **Follow the Prompts**:
   - Enter the size of the FFT.
   - Choose the signal type (1: Sine wave, 2: Square wave, 3: Sawtooth wave, 4: Triangle wave).
   - Enter the magnitude scaling factor.
   - Specify the minimum and maximum frequencies to display.
   - Indicate whether to display the phase spectrum.

3. **Run Unit Tests**:
   ```sh
   ctest
   ```

## Project Structure

- `CMakeLists.txt`: CMake configuration file for building the project.
- `fft_visualization.cu`: CUDA source file containing FFT-related functions.
- `fft_visualization.h`: Header file declaring FFT-related functions.
- `main.cu`: Main entry point of the application.
- `test/fft_visualization_test.cpp`: Unit tests for FFT-related functions using Google Test.

## File Descriptions

- **CMakeLists.txt**: Configures the build system, including setting up the project, linking libraries, and defining build targets.
- **fft_visualization.cu**: Contains the implementation of FFT-related functions, including data generation, FFT computation, and result visualization.
- **fft_visualization.h**: Header file declaring the FFT-related functions for use in other parts of the project.
- **main.cu**: The main entry point of the application, which interacts with the user and calls FFT analysis functions.
- **test/fft_visualization_test.cpp**: Contains unit tests for the FFT-related functions using Google Test, ensuring the correctness and robustness of the implementation.

## Justifications

### Normalization
- **Normalization**: The magnitude spectrum is normalized to ensure that the values are within a consistent range, making it easier to interpret and compare different signals. Normalization also helps in visualizing the spectrum more effectively by scaling the values to a common scale factor provided by the user.

### Signal Choices
- **Signal Types**: The project offers four signal types (Sine wave, Square wave, Sawtooth wave, Triangle wave) to provide a diverse set of inputs for FFT analysis. These signal types are commonly used in signal processing and cover a range of periodic waveforms, allowing users to analyze different characteristics and behaviors under FFT transformation.

### Unit Testing
- **Unit Testing**: Unit tests are crucial for ensuring the correctness and reliability of the FFT-related functions. By using Google Test, we can automate the testing process and verify that each function behaves as expected, which is essential for maintaining the integrity of the codebase as it evolves.

### User-Defined Settings
- **User-Defined Settings**: Allowing users to configure signal types, scaling factors, and frequency ranges provides flexibility and customization. This enables users to tailor the analysis to their specific needs and explore different scenarios without modifying the underlying code.

## Note on Library Versions

This project was developed and tested with the following specific versions of libraries and tools:
- CUDA Toolkit 12.5
- CMake 3.14
- Google Test v1.15.2

Future releases of these tools and libraries may introduce changes that could affect the compatibility and functionality of this project.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to NVIDIA for the CUDA Toolkit and cuFFT library.
- Thanks to the Google Test team for the testing framework.
