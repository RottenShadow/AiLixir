// Force the app to use the high-performance GPU on systems with multiple GPUs.
// Both NVIDIA (NvOptimusEnablement) and AMD (AmdPowerXpressRequestHighPerformance)
// symbols are recognized by their respective drivers at load time.

extern "C" {
  // NVIDIA Optimus: prefer discrete GPU over integrated
  __declspec(dllexport) unsigned long NvOptimusEnablement = 1;

  // AMD PowerXpress: prefer high-performance GPU
  __declspec(dllexport) int AmdPowerXpressRequestHighPerformance = 1;
}
