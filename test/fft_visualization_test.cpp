#include <gtest/gtest.h>
#include "../fft_visualization.h" // Adjust the path as necessary

// Test case for calculateMagnitude
TEST(FFTVisualizationTest, CalculateMagnitude) {
    std::vector<cufftComplex> data = {{1.0f, 0.0f}, {0.0f, 1.0f}, {1.0f, 1.0f}};
    std::vector<float> magnitude(data.size());
    calculateMagnitude(data, magnitude);

    EXPECT_NEAR(magnitude[0], 1.0f, 1e-5);
    EXPECT_NEAR(magnitude[1], 1.0f, 1e-5);
    EXPECT_NEAR(magnitude[2], sqrt(2.0f), 1e-5);
}

// Test case for calculatePhase
TEST(FFTVisualizationTest, CalculatePhase) {
    std::vector<cufftComplex> data = {{1.0f, 0.0f}, {0.0f, 1.0f}, {1.0f, 1.0f}};
    std::vector<float> phase(data.size());
    calculatePhase(data, phase);

    EXPECT_NEAR(phase[0], 0.0f, 1e-5);
    EXPECT_NEAR(phase[1], M_PI / 2, 1e-5);
    EXPECT_NEAR(phase[2], M_PI / 4, 1e-5);
}

// Test case for generateInputData
TEST(FFTVisualizationTest, GenerateInputData) {
    int N = 4;
    std::vector<cufftComplex> h_data;
    generateInputData(h_data, N, 1); // Sine wave

    ASSERT_EQ(h_data.size(), N);
    // Add more assertions to verify the generated data
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}