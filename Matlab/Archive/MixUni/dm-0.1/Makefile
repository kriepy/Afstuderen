CC	= gcc
CFLAGS	= -Wall -O3
SRCS	= dm.c learn.c loo.c writer.c likelihood.c feature.c gamma.c \
	  dmatrix.c util.c
OBJS	= $(SRCS:.c=.o)
HEADERS	= $(SRCS:.c=.h)
LDFLAGS	= -lm
VERSION	= 0.1
PKGNAME	= dm-$(VERSION)
DISTDIR	= ../dist

all: depend dm

dm: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)
.c.o:
	$(CC) -c $(CFLAGS) $<

pkg:
	@[ -d $(PKGNAME) ] || mkdir $(PKGNAME)
	@cp -p $(SRCS) $(HEADERS) Makefile $(PKGNAME)
	@tar cvfz $(DISTDIR)/$(PKGNAME).tar.gz $(PKGNAME)
	@rm -r $(PKGNAME)
	@ls -l $(DISTDIR)/$(PKGNAME).tar.gz
depend:
	@$(CC) -MM $(SRCS) > .depend
clean:
	@rm -f $(OBJS)

-include .depend
