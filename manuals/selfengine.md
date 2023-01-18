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

### Кросс-платформенная обработка строк (UTF-8)

Чтобы избавиться от головной боли с кодировками, надо выбрать один вариант и придерживаться его во всех платформах. Самый очевидный кандидат - UTF-8. Существует даже манифест, призывающий его использовать повсеместно [UTF-8 Everywhere (utf8everywhere.org)](http://utf8everywhere.org/). Для Linux он и так по дефолту, осталась Win.

Основная проблема - на винде нет возможности нормально считать строку в UTF-8 из консоли. Вывести можно. Для решения надо делать такие хаки для ввода и вывода:

```cpp
#ifdef WIN32
#include <locale.h>
#include <vector>
#include <Windows.h>
std::string utf8_to_cp1251(std::string const& utf8)
{
    if (!utf8.empty())
    {
        int wchlen = MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), utf8.size(), NULL, 0);
        if (wchlen > 0 && wchlen != 0xFFFD)
        {
            std::vector<wchar_t> wbuf(wchlen);
            int result_u = MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), utf8.size(), &wbuf[0], wchlen);
            if (!result_u) {
                throw std::runtime_error("utf8_to_cp1251 cannot convert MultiByteToWideChar!");
            }
            std::vector<char> buf(wchlen);
            int result_c = WideCharToMultiByte(1251, 0, &wbuf[0], wchlen, &buf[0], wchlen, 0, 0);
            if (!result_c) {
                throw std::runtime_error("utf8_to_cp1251 cannot convert WideCharToMultiByte!");
            }

            return std::string(&buf[0], wchlen);
        }
    }
    return std::string();
}

std::string cp1251_to_utf8(const std::string& cp1251) {
    std::string res;
    int result_u, result_c;
    enum { CP1251 = 1251 };
    result_u = MultiByteToWideChar(CP1251, 0, cp1251.c_str(), -1, 0, 0);
    if (!result_u) {
        throw std::runtime_error("cp1251_to_utf8 cannot convert MultiByteToWideChar!");
    }
    wchar_t* ures = new wchar_t[result_u];
    if (!MultiByteToWideChar(CP1251, 0, cp1251.c_str(), -1, ures, result_u)) {
        delete[] ures;
        throw std::runtime_error("cp1251_to_utf8 cannot convert MultiByteToWideChar 2!");
    }
    result_c = WideCharToMultiByte(CP_UTF8, 0, ures, -1, 0, 0, 0, 0);
    if (!result_c) {
        delete[] ures;
        throw std::runtime_error("cp1251_to_utf8 cannot convert WideCharToMultiByte!");
    }
    char* cres = new char[result_c];
    if (!WideCharToMultiByte(CP_UTF8, 0, ures, -1, cres, result_c, 0, 0)) {
        delete[] cres;
        throw std::runtime_error("cp1251_to_utf8 cannot convert WideCharToMultiByte 2!");
    }
    delete[] ures;
    res.append(cres);
    delete[] cres;
    return res;
}

#endif

void printOutput(const std::string& data)
{
    std::string output = data;
#ifdef WIN32
    output = utf8_to_cp1251(output);
#endif
    std::cout << output;
    std::cout.flush();
}
std::string readInput()
{
    std::string input;
    std::getline(std::cin, input);
#ifdef WIN32
    input = cp1251_to_utf8(input);
#endif
    return input;
}

...
//в main
#ifdef WIN32
        setlocale(LC_ALL, "RUS");
        system("chcp 1251");
#endif
```

Также, в самом проекта на CMake надо сделать, чтобы кодировка символов по-умолчанию воспринималась корректно:

```cmake
#Для студии ставим флаг, что кодировка исходников UTF-8
if(MSVC)
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
endif()
```

Также, надо обратить внимание что длина строки будет рассчитываться некорректно! Можно использовать хак:

```cpp
int utf8_strlen(const string& str)
{
    int c,i,ix,q;
    for (q=0, i=0, ix=str.length(); i < ix; i++, q++)
    {
        c = (unsigned char) str[i];
        if      (c>=0   && c<=127) i+=0;
        else if ((c & 0xE0) == 0xC0) i+=1;
        else if ((c & 0xF0) == 0xE0) i+=2;
        else if ((c & 0xF8) == 0xF0) i+=3;
        //else if (($c & 0xFC) == 0xF8) i+=4; // 111110bb //byte 5, unnecessary in 4 byte UTF-8
        //else if (($c & 0xFE) == 0xFC) i+=5; // 1111110b //byte 6, unnecessary in 4 byte UTF-8
        else throw std::exception("invalid utf8");//TODO: add hex representation
    }
    return q;
}
```

Или более профессиональный вариант для WinApi: [C++ - Unicode Encoding Conversions with STL Strings and Win32 APIs | Microsoft Learn](https://learn.microsoft.com/en-us/archive/msdn-magazine/2016/september/c-unicode-encoding-conversions-with-stl-strings-and-win32-apis)
