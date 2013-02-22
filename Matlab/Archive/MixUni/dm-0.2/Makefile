CC	= gcc
CFLAGS	= -O3 -Wall
SRCS	= sdm.c learn.c newton.c likelihood.c \
	  feature.c dmatrix.c random.c gamma.c writer.c util.c 
OBJS	= $(SRCS:.c=.o)
HEADERS	= $(SRCS:.c=.h)
LIKSRCS	= dmlik.c likelihood.c feature.c loader.c dmatrix.c util.c gamma.c
LIKOBJS	= $(LIKSRCS:.c=.o)
LDFLAGS	= -lm
VERSION	= 0.2
PKGNAME	= dm-$(VERSION)
DISTDIR	= ../dist

all: depend sdm

sdm: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)
dmlik: $(LIKOBJS)
	$(CC) $(CFLAGS) -o $@ $(LIKOBJS) $(LDFLAGS)

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
rebuild: clean all

-include .depend
