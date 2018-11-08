libdir=$(DESTDIR)/usr/lib
files=gutils.sh secret.sh

.PHONY: install uninstall

install: $(libdir) $(files)
	cp $(files) $(libdir)

$(libdir):
	@mkdir -p $(libdir)

uninstall:
	$(foreach f, $(files), rm $(libdir)/$(f);)
