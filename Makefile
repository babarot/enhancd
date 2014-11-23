MANPAGES   ?= enhancd.1
PREFIX     ?= /usr/local
MKPATH     ?= mkdir -p
INSTALL    ?= install
INSTALLMAN ?= ${INSTALL} -m 444 -v
RM         := rm -f

all: install

uninstall:
	$(RM) ${PREFIX}/share/man/man1/${MANPAGES}

install:
	${MKPATH} ${PREFIX}/share/man/man1
	${INSTALLMAN} ${MANPAGES} ${PREFIX}/share/man/man1/${MANPAGES}
	${INSTALLMAN} ${MANPAGES} ${PREFIX}/share/man/man1/cd.1
	@echo ""
	@echo "Put something like this in your ~/.bashrc or ~/.zshrc:"
	@echo "  source /path/to/enhancd.sh"

.PHONY: all install uninstall
