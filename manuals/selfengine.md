# Шаблоны для консольной текстовой игры

### Работа с консолью и игровой цикл

Текст шаблона:

```cpp
#include <string>
#include <iostream>

//Запись строки на стандартный вывод
void writeOutput(const std::string& output)
{
    std::cout << output;
}

//Чтение строки от пользователя
std::string readUserInput()
{
    std::string input;
    std::getline(std::cin, input);
    return input;
}

//Обработка шага игры. Если вернули false - конец игры
bool runGameStep(const std::string& userCmd, std::string& gameOutput)
{
    //TODO: здесь храниться логика игры
    //блок if/switch для парсинга userCmd
    //заполнение gameOutput
    //возврат признака - продолжаем или нет
}

int main(int argc, char* argv[])
{
    const std::string prompt(">"); //символ приглашения на ввод
    //TODO: текст приветствия для пользователя
    writeOutput(prompt); //выводим приглашение на ввод текста
    //Основной цикл обработки
    while (true) 
    {
        //читаем строку от пользователя
        std::string userCmd = readUserInput();
        //Обработка и вывод на консоль
        std::string gameOutput;
        bool allowNext = runGameStep(userCmd, gameOutput);
        writeOutput(gameOutput);
        if (!allowNext) break;
        //отмечаем следующий ход
        writeOutput(prompt);
    }
    return EXIT_SUCCESS;
}
```

Пример игры, где игрок сразу же заканчивает, если наберёт любой текст, кроме `NO`:

```cpp
#include <string>
#include <iostream>

void writeOutput(const std::string& output)
{
    std::cout << output;
}

std::string readUserInput()
{
    std::string input;
    std::getline(std::cin, input);
    return input;
}

bool runGameStep(const std::string& userCmd, std::string& gameOutput)
{
    if (userCmd == "NO")
    {
        gameOutput = "OK. May be next time.\n";
        return true;
    }
    
    gameOutput = "BYE-BYE!\n";
    return false;
}

int main(int argc, char* argv[])
{
    const std::string prompt(">");
    writeOutput("Stub game. Print text and exit! If NO, continue game.\n"); //TODO: текст приветствия для пользователя
    writeOutput(prompt);
    while (true) 
    {
        std::string userCmd = readUserInput();
        std::string gameOutput;
        bool allowNext = runGameStep(userCmd, gameOutput);
        writeOutput(gameOutput);
        if (!allowNext) break;
        writeOutput(prompt);
    }
    return EXIT_SUCCESS;
}
```

Пример игровой сессии:

```
Stub game. Print text and exit! If NO, continue game.
>NO
OK. May be next time.
>NO
OK. May be next time.
>ok
BYE-BYE!
```

Обоснование:

1. Функции ввода и вывода могут поменяться в зависимости от рабочей платформы, надо, чтобы логика игры была защищена от изменения способа ввода и вывода. Поэтому весь обмен текстом ограничивается `writeOutput`/`readUserInput`

2. В main содержится стандартный порядок шагов для текстовой игры, который определяет в какой момент мы выдаём или спрашиваем команду, а также логика выдачи приглашения и окончания игры.

3. Основная функция игры `runGameStep` не должна обращаться к консоли, а также возвращать значение true/false для определения следующего шага. Это позволит сделать логику обработки чистой, тестируемой и не зависящей от изменений окружения (main для разных платформ может видоизменяться)



### Работа со звуком

Для выдачи звука я рекомендую воспользоваться библиотекой [miniaudio](https://miniaud.io/). Можете скачать с [официального репозитория](https://raw.githubusercontent.com/mackron/miniaudio/master/miniaudio.h). Дополнительно, вам понадобиться `stb_vorbis.c`. Скачать можно также с [официального репозитория](https://raw.githubusercontent.com/mackron/miniaudio/master/extras/stb_vorbis.c). Структура проекта будет следующая:

```
\text-game-project
    CMakeList.txt
    main.cpp
    miniaudio.h
    stb_vorbis.c
```

Теперь об изменении основного шаблона:

```cpp
//сначала vorbis только дефайны
#define STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"    

//теперь весь миниаудио, подтягивает дефайны ворбиса
#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"

//vorbis реализацию
#undef STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"   

static ma_engine snd_engine;

bool initSound()
{
    ma_result result = ma_engine_init(NULL, &snd_engine);
    if (result != MA_SUCCESS) {
        std::cout<<"Failed init sound engine\n";
        return false;  // Failed to initialize the engine.
    }
    return true;
}

void playSound(std::string sound_file_name)
{
    ma_engine_play_sound(&snd_engine, sound_file_name.c_str(), NULL);
}

//TODO: функции консоли
//В функции игрового ццикла используем playSound

int main(int argc, char* argv[])
{
    //Попытка инициализации звука
    if (!initSound())
    {
         return EXIT_FAILURE;
    }
    //TODO: далее обработка консоли
}
```

В [reqdialas/manuals/audio(github.com)](https://github.com/antlas1/reqdialas/tree/main/manuals/audio) можно найти полный пример проекта, со звуками. Для запуска их надо скопировать в рабочий каталог приложения. 


