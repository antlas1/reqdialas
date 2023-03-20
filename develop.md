### Заметки разработки

Построение диаграмм классов plantUml в Notepad++ (плагин nppExec):

```
cd C:\tools\
C:\tools\JavaPortable\bin\java -jar plantuml.jar -charset "utf-8" -graphvizdot "C:\tools\Graphviz-7.0.4\bin\dot.exe" "$(FULL_CURRENT_PATH)"
cd "$(CURRENT_DIRECTORY)"
explorer $(NAME_PART).png
```