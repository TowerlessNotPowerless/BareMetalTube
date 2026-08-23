#	=================================
#	makefile for CoPro Bat'n'Ball
#	=================================

COPY_FILE = copy
CREATE_DIRECTORY = mkdir
ASM = ca65
LINK = ld65 -o

CA_FLAGS = -v -l "$(TEMP_FOLDER)\$(COMPONENT_FILENAME).lst" -o "$(TEMP_FOLDER)\$(COMPONENT_FILENAME).o" --cpu 6502 ".\src\$(COMPONENT_FILENAME)\main.asm" > $(TEMP_FOLDER)\$(COMPONENT_FILENAME).ca65
LD_FLAGS = -C beeb.cfg "$(TEMP_FOLDER)\$(COMPONENT_FILENAME).o" -S 000000 --cfg-path "." > $(TEMP_FOLDER)\$(COMPONENT_FILENAME).ld65

TEMP_FOLDER = .\asm-temp
VDFS_DISC_FOLDER = .\vdfs
VDFS_INPUT_FOLDER = .\src\vdfsInput

BEEB_FILENAME_AUTO_BOOT = !Boot

# for code/data integrity we will include a build timestamp
# in many of the files
FILENAME_PREFIX_TIMESTAMP = timestamp

.PHONY: directories

all: \
	directories  \
	$(TEMP_FOLDER)\$(FILENAME_PREFIX_TIMESTAMP).dat \
	$(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT) \
	$(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT).inf \

directories: \
	$(TEMP_FOLDER) \
	$(VDFS_DISC_FOLDER) \

#========================================

$(TEMP_FOLDER):
	$(CREATE_DIRECTORY) "$(TEMP_FOLDER)"

#========================================

$(VDFS_DISC_FOLDER):
	$(CREATE_DIRECTORY) "$(VDFS_DISC_FOLDER)"

#========================================
#	Timestamp
#========================================

$(TEMP_FOLDER)\$(FILENAME_PREFIX_TIMESTAMP).dat: \
	$(wildcard ./*/*.*) \
	$(wildcard ./*/*/*.*) \
	$(wildcard ./*/*/*/*.*) \
	$(wildcard ./*/*/*/*/*.*) \

	$(eval COMPONENT_FILENAME := $(FILENAME_PREFIX_TIMESTAMP))
	$(ASM) $(CA_FLAGS)
	$(LINK) $(TEMP_FOLDER)\$(COMPONENT_FILENAME).dat $(LD_FLAGS)

#========================================
#	!Boot
#========================================

$(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT).inf: \
	$(VDFS_INPUT_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT).inf \

	$(COPY_FILE) $(VDFS_INPUT_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT).inf $(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT).inf

#========================================

$(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT): \
	$(VDFS_INPUT_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT) \
	$(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT).inf \
	
	$(COPY_FILE) $(VDFS_INPUT_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT) $(VDFS_DISC_FOLDER)\$(BEEB_FILENAME_AUTO_BOOT)

#========================================
