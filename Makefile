SAMDISK ?= samdisk
OS9 ?= os9
STREAMS := $(shell find . -type d -name \*-STREAM -and -not -path '*dist*')
DISKS = $(dir $(STREAMS))
RAWS = $(subst -STREAM,.raw,$(STREAMS))
INDEXES = $(DISKS:%=%INDEX)

all: $(INDEXES)

raw: $(RAWS)

index: $(INDEXES)

%.raw: %-STREAM/*.raw
	@samdisk copy $< $@

%.rawtmp: %.raw
	mv $^ $@

%/INDEX : RAW = $(subst -STREAM,.rawtmp,$(wildcard $*/*-STREAM))
%/INDEX: $(RAW)
	$(MAKE) $(RAW)
	cd $(dir $(RAW)) && $(OS9) dir -aer $(notdir $(RAW)) > $(notdir $@)

clean:
	rm -f $(RAWS)
