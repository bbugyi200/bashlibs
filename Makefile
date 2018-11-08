libdir=$(DESTDIR)/usr/lib
files=gutils.sh secret.sh

install: $(libdir) $(files)
	cp $(files) $(libdir)

$(libdir):
	[ -d $(libdir) ] || mkdir -p $(libdir)

uninstall:
	$(foreach f, $(files), rm $(libdir)/$(f);)
