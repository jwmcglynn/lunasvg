#include <lunasvg.h>

#include <cstddef>
#include <cstdint>
#include <tuple> // for std::ignore

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  if (size == 0) {
    return 0;
  }

  auto doc = lunasvg::Document::loadFromData(
      reinterpret_cast<const char *>(data), size);
  if (doc) {
    // Render the document to exercise more codepaths.
    std::ignore = doc->renderToBitmap();
  }

  return 0;
}
