################ Source files ##########################################

bvt/SRCS	:= $(wildcard bvt/*.cc)
bvt/BVTS	:= $(bvt/SRCS:.cc=)
bvt/OBJS	:= $(addprefix $O,$(bvt/SRCS:.cc=.o))
bvt/LIBS	:=
CXXFLAGS	+= -I.

################ Compilation ###########################################

.PHONY:	bvt/all bvt/run bvt/clean bvt/check

bvt/all:	${bvt/BVTS}

# The correct output of a bvt is stored in bvtXX.std
# When the bvt runs, its output is compared to .std
#
bvt/run:	${bvt/BVTS}
	@echo "Running build verification tests:"
	@for i in ${bvt/BVTS}; do \
	    echo "Running $$i"; \
	    ./$$i < $$i.cc &> $$i.out; \
	    diff $$i.std $$i.out && rm -f $$i.out; \
	done

${bvt/BVTS}: bvt/%: $Obvt/%.o ${ALLTGTS}
	@echo "Linking $@ ..."
	@${LD} ${LDFLAGS} -o $@ $< ${bvt/LIBS}

################ Maintenance ###########################################

bvt/clean:
	@rm -f ${bvt/BVTS} ${bvt/OBJS} $(bvt/OBJS:.o=.d)
	@rmdir $O/bvt &> /dev/null || true

bvt/check:	check

${bvt/OBJS}: bvt/Module.mk ${NAME}
