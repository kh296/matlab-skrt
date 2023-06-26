# Define directories.
BUILD = build
SRC = +mskrt
#
# Define commands.
MCC = mcc
RM = rm -rf

# Define target and additional sources.
TARGET = matlabreg
FILENAMES = getdispfield.m getnumerics.m isrightsize.m istext.m niftiload.m niftisave.m
SOURCES = $(patsubst %, $(SRC)/%, $(FILENAMES))

all:
	$(MAKE) clean
	$(MCC) -m $(SRC)/$(TARGET).m -a $(SOURCES) -d $(BUILD)
	mv $(BUILD)/*.app .

show:
	@echo SOURCES $(SOURCES)

clean:
	$(RM) *.app
	$(RM) $(BUILD)
