ALL=pa_ulex.cma ulexing.cma
OCAMLBUILD=ocamlbuild -byte-plugin

all::
	$(OCAMLBUILD) $(ALL)
all.opt::
	$(OCAMLBUILD) $(ALL) $(ALL:.cma=.cmxa)

MODS=ulexing utf16 utf8

install: all
	cd _build && $(MAKE) -f ../Makefile realinstall

realinstall:
	ocamlfind install ulex ../META $(wildcard $(MODS:=.mli) $(MODS:=.cmi) $(MODS:=.cmx) pa_ulex.cma ulexing.a ulexing.cma ulexing.cmxa)

uninstall:
	ocamlfind remove ulex

clean:
	$(OCAMLBUILD) -clean
	rm -f *~ *.html *.css *.tar.gz

view_test: all
	camlp4o -printer ocaml ./_build/pa_ulex.cma test.ml

run_test:
	ocamlbuild test.byte
	./test.byte

custom_ulexing.byte:
	$(OCAMLBUILD) custom_ulexing.byte

doc:
	ocamldoc -html ulexing.mli

VERSION      := $$(opam query --version)
NAME_VERSION := $$(opam query --name-version)
ARCHIVE      := $$(opam query --archive)

release:
	git tag -a v$(VERSION) -m "Version $(VERSION)."
	git push origin v$(VERSION)
	opam publish prepare $(NAME_VERSION) $(ARCHIVE)
	cp -t $(NAME_VERSION) descr
	grep -Ev '^(name|version):' opam >$(NAME_VERSION)/opam
	opam publish submit $(NAME_VERSION)
	rm -rf $(NAME_VERSION)
