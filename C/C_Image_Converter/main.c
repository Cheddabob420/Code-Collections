/* Includes */
#include <stddef.h>
#include <strings.h>
#include <webp/types.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <webp/encode.h>

/* Globals */
typedef enum {
  FORMAT_UNKNOWN = 0,
  FORMAT_PNG,
  FORMAT_BMP,
  FORMAT_JPEG,
  FORMAT_WEBP
} ImageFormat;

/* Prototypes */
int save_webp(const char *filename, unsigned char *data, int w, int h,
              int channels);
ImageFormat get_format_enum(const char *format_str);
void make_output_filename(char *output, size_t max_size, const char *input_path,
                          const char *new_ext);
/* Main Logic */
int main(int argc, char *argv[]) {
  if (argc < 3) {
    printf("Usage: %s <input_image_path> <target_format>\n", argv[0]);
    printf("Formats: jpeg, jpg, png, bmp, webp\n");
    return EXIT_FAILURE;
  }
  char *input_path = argv[1];
  char *target_fmt = argv[2];

  int width, height, channels = 0;
  unsigned char *img = stbi_load(input_path, &width, &height, &channels, 0);
  if (img == NULL) {
    printf("Error: Could not load image '%s'\n", input_path);
    return EXIT_FAILURE;
  }
  char output_path[512];
  make_output_filename(output_path, sizeof(output_path), input_path,
                       target_fmt);
  int success = 0;

  switch (get_format_enum(target_fmt)) {
  case FORMAT_PNG:
    success = stbi_write_png(output_path, width, height, channels, img,
                             width * channels);
    break;
  case FORMAT_BMP:
    success = stbi_write_bmp(output_path, width, height, channels, img);
    break;
  case FORMAT_JPEG:
    success = stbi_write_jpg(output_path, width, height, channels, img, 90);
    break;
  case FORMAT_WEBP:
    success = save_webp(output_path, img, width, height, channels);
    break;
  case FORMAT_UNKNOWN:
    fprintf(stderr, "Error getting image format!");
    break;
  default:
    printf("Error: Unsupported target format '%s'\n", target_fmt);
    stbi_image_free(img);
    return EXIT_FAILURE;
  }

  if (success) {
    printf("Success! Saved converted image to %s\n", output_path);
  } else {
    printf("Error: Failed to save image\n");
  }
  stbi_image_free(img);
  return EXIT_SUCCESS;
}

/* Functions */
int save_webp(const char *filename, unsigned char *data, int w, int h,
              int channels) {
  FILE *f = fopen(filename, "wb");
  if (!f)
    return 0;
  uint8_t *output;
  size_t bytes_saved = 0;
  if (channels == 3) {
    bytes_saved = WebPEncodeRGB(data, w, h, w * 3, 90.0f, &output);
  } else if (channels == 4) {
    bytes_saved = WebPEncodeRGB(data, w, h, w * 4, 90.0f, &output);
  }
  if (bytes_saved > 0) {
    fwrite(output, 1, bytes_saved, f);
    WebPFree(output);
  }
  fclose(f);
  return bytes_saved > 0;
}

ImageFormat get_format_enum(const char *format_str) {
  if (strcasecmp(format_str, "png") == 0)
    return FORMAT_PNG;
  if (strcasecmp(format_str, "bmp") == 0)
    return FORMAT_BMP;
  if (strcasecmp(format_str, "jpeg") == 0 ||
      strcasecmp(format_str, "jpg") == 0) {
    return FORMAT_JPEG;
  }
  if (strcasecmp(format_str, "webp") == 0)
    return FORMAT_WEBP;
  return FORMAT_UNKNOWN;
}

void make_output_filename(char *output, size_t max_size, const char *input_path,
                          const char *new_ext) {
  strncpy(output, input_path, max_size - 1);
  output[max_size - 1] = '\0';
  char *dot = strrchr(output, '.');
  char *slash = strrchr(output, '/');
  if (dot != NULL) {
    if (slash == NULL || dot > slash) {
      *dot = '\0';
    }
  }
  strncat(output, ".", max_size - strlen(output) - 1);
  strncat(output, new_ext, max_size - strlen(output) - 1);
}
