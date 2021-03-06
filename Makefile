default:
	@echo "---------------"
	@echo "HLLR Makefile"
	@echo "---------------"
	@echo "  To compile hllr; use target 'hllr'"
	@echo "  To clean; use target 'clean'"
	@echo "  To bootstrap hllr (compile hllr parser from hllr) use target 'bootstrap'"
	@echo "  To tar hllr; use option 'tar'"
	@echo ""


hllr: pre_process hlex_process
	@echo "---------------"
	@echo "Compiling hllr!"
	@echo "---------------"
	mkdir -p bin
	haxe -cp src -neko bin/hllr.n -main Main
	nekotools boot bin/hllr.n

hlex_process:
	@echo "---------------"
	@echo "Building lexer for .hlr files"
	@echo "---------------"
	hlex scripts/hllr.hlx -haxe cx-src/HLex.cx -token Token
	
pre_process: hlex_process
	@echo "---------------"
	@echo "Preprocessing hllr source"
	@echo "---------------"
	rm -rvf src
	mkdir src
	caxe cx-src $(SCX) -o src -tc 2 --times

clean:
	@echo "---------------"
	@echo "Cleaning hllr build"
	@echo "---------------"
	rm -f cx-src/HLex.cx
	rm -f bin/hllr.n bin/hllr
	
bootstrap:
	@echo "---------------"
	@echo "Bootstrapping hllr!"
	@echo "---------------"
	hllr scripts/hllr.hlr cx-src/HLlr.cx -haxe -token Token -index TokenUtils.index -lalr1

tar:
	@echo "---------------"
	@echo "Tarring hllr"
	@echo "---------------"
	tar cvfz hllr.tar.gz cx-src scripts Makefile
