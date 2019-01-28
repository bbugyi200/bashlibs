PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin

bindir=$(DESTDIR)/$(BINDIR)
files=gutils.sh secret.sh

.PHONY: install uninstall

install: $(bindir) $(files)
	cp $(files) $(bindir)

$(bindir):
	@mkdir -p $(bindir)

uninstall:
	$(foreach f, $(files), rm $(bindir)/$(f);)
