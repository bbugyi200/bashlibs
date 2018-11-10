lib=$(DESTDIR)/usr/lib
files=gutils.sh secret.sh

.PHONY: install uninstall

install: $(lib) $(files)
	cp $(files) $(lib)

$(libdir):
	@mkdir -p $(lib)

uninstall:
	$(foreach f, $(files), rm $(lib)/$(f);)
