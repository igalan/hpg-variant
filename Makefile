CC = gcc
CFLAGS = -std=c99 -O3
CFLAGS_DEBUG = -std=c99 -g

# Source code folders
LIBS_ROOT = libs
CONTAINERS_DIR = $(LIBS_ROOT)/containers
COMMONS_DIR = $(LIBS_ROOT)/commons
BIOINFO_DATA_DIR = $(LIBS_ROOT)/bioformats
REGION_DIR = $(BIOINFO_DATA_DIR)/features/region

# Include and libs folders
INCLUDES = -I $(CONTAINERS_DIR) -I $(COMMONS_DIR) -I $(REGION_DIR) -I $(BIOINFO_DATA_DIR)/vcf/ -I . -I ./effect/
LIBS = -L/usr/lib/x86_64-linux-gnu -lcurl -Wl,-Bsymbolic-functions -lconfig -lcprops -fopenmp -lm

# Source files dependencies
VCF_FILES = $(BIOINFO_DATA_DIR)/vcf/vcf_file.c $(BIOINFO_DATA_DIR)/vcf/vcf_reader.c $(BIOINFO_DATA_DIR)/vcf/vcf_batch.c \
	$(BIOINFO_DATA_DIR)/vcf/vcf_read.c $(BIOINFO_DATA_DIR)/vcf/vcf_write.c \
	$(BIOINFO_DATA_DIR)/vcf/util.c $(BIOINFO_DATA_DIR)/vcf/vcf_filters.c
MISC_FILES = $(COMMONS_DIR)/file_utils.o $(COMMONS_DIR)/string_utils.o $(COMMONS_DIR)/http_utils.o $(CONTAINERS_DIR)/list.o $(REGION_DIR)/region.o $(CONTAINERS_DIR)/region_table.o

# Project source files
EFFECT_FILES = effect/main_effect.c effect/effect_options_parsing.c effect/effect_runner.c
HPG_VARIANT_FILES = main.c global_options.c $(EFFECT_FILES) $(VCF_FILES) $(MISC_FILES)


all: list.o file_utils.o http_utils.o string_utils.o region.o region_table.o hpg-variant

hpg-variant: $(HPG_VARIANT_FILES)
	$(CC) $(CFLAGS) -D_XOPEN_SOURCE=600 -o $@ $(HPG_VARIANT_FILES) $(INCLUDES) $(LIBS)
#	$(CC) $(CFLAGS_DEBUG) -D_XOPEN_SOURCE=600 -o $@ $(HPG_VARIANT_FILES) $(INCLUDES) $(LIBS)

file_utils.o:
	cd $(COMMONS_DIR) && make file_utils.o

http_utils.o:
	cd $(COMMONS_DIR) && make http_utils.o

string_utils.o:
	cd $(COMMONS_DIR) && make string_utils.o

list.o:
	cd $(CONTAINERS_DIR) && make list.o

region.o:
	cd $(REGION_DIR) && make region.o

region_table.o:
	cd $(CONTAINERS_DIR) && make region_table.o

clean:
	rm hpg-variant

