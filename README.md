# ТЗ для проектов Диалас

Правила оформления для одиночных игр: [reqdialas/selfengine.md at main · antlas1/reqdialas (github.com)](https://github.com/antlas1/reqdialas/blob/main/manuals/selfengine.md)

## Однопользовательские проекты

| Проект               | Краткое описание                                                                                            | Размер    | Сложность | Стартовое ТЗ                                                             | Состояние             | Дата начала | Дата окончания | Ссылка на релиз | Ссылка на исходник                                  |
| -------------------- | ----------------------------------------------------------------------------------------------------------- | --------- | --------- | ------------------------------------------------------------------------ | --------------------- | ----------- | -------------- | --------------- | --------------------------------------------------- |
| Новый разум. Прорыв. | Парсерный боевичок, где надо сражаться с монстрами в лабиринте. Используется прогрессивная боевая механика. | Большой   | Высокая   | [link](https://github.com/antlas1/reqdialas/tree/main/lone/newmind2)     | <u>ЗАМОРОЖЕН</u>      | 27.11.22    | -              | -               | -                                                   |
| Магнат               | Клон настольной монополии, с удобством для работы со скринридерами и упрощениями                            | Средний   | Средняя   | [link](https://github.com/antlas1/reqdialas/tree/main/lone/magnat)       | **ГОТОВО**            | 06.12.22    | 17.01.23       | -               | [link](https://github.com/GDP1977/Monopolist-v-1-3) |
| Кабанчик             | Звуковая игра, где надо угадывать сколько глотков сделал собутыльник по звуку.                              | Маленький | Низкая    | [link](https://github.com/antlas1/reqdialas/tree/main/lone/tavern)       | <mark>В РАБОТЕ</mark> | 17.01.23    |                |                 |                                                     |
| CYBER INFILTRATION   | Парсерный боевик по типу серии игр "зомби".                                                                 | Средний   | Средняя   | [link](https://github.com/antlas1/reqdialas/tree/main/lone/infiltration) | <mark>В РАБОТЕ</mark> | 27.11.22    |                |                 |                                                     |
| 4D-кроссворд         | Обычный кроссворд, с облегченными правилами для построения пересечений                                      | Средний   | Низкая    | [link](https://github.com/antlas1/reqdialas/tree/main/lone/cross4D)      | СВОБОДНО!             |             |                |                 |                                                     |

### Заметки

Построение диаграмм классов plantUml в Notepad++ (плагин nppExec):

```
cd C:\tools\
C:\tools\JavaPortable\bin\java -jar plantuml.jar -charset "utf-8" -graphvizdot "C:\tools\Graphviz-7.0.4\bin\dot.exe" "$(FULL_CURRENT_PATH)"
cd "$(CURRENT_DIRECTORY)"
explorer $(NAME_PART).png
```