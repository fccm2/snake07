snake07f.js: snake07f.ml canvas.cmt
	bsc -I . $< | sed -e 's!.*require.*!!g' | sed -e 's!export.*!!g' > $@
canvas.cmt: canvas.res
	bsc $<
clean:
	$(RM) canvas.cm[ijt]
	$(RM) snake07f.cmt
	$(RM) snake07f.cmi
	$(RM) snake07f.cmj
clean2:
	$(RM) snake07f.js
